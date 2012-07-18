local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local color = require 'nwn.color'

local DAMAGE_RESULTS = {}
local DAMAGE_ID = 0

local s = string.gsub([[
typedef struct DamageResult {
   int32_t    damages[$NS_OPT_NUM_DAMAGES];
   int32_t    immunity_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    resist_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    soak_adjust;
} DamageResult;

typedef struct {
   DiceRoll rolls[$NS_OPT_NUM_DAMAGES][50];
   int32_t  idxs[$NS_OPT_NUM_DAMAGES];
} DamageRoll;
]], "%$([%w_]+)", { NS_OPT_NUM_DAMAGES = NS_OPT_NUM_DAMAGES })

ffi.cdef (s)

damage_roll_t = ffi.typeof('DamageRoll')
damage_result_t = ffi.typeof("DamageResult")

local function NSAddDamageToRoll(dmg, dmg_type, roll)
   local idx = nwn.GetDamageIndexFromFlag(dmg_type)
   local n = dmg.idxs[idx]

   --print("NSAddDamageToRoll", dmg, dmg_type, idx, n)

   dmg.rolls[idx][n] = roll
   dmg.idxs[idx] = n + 1
end

function NSAddDamageResultToAttack(attack_info, dmg_result)
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      if i < 13 then
	 if dmg_result.damages[i] <= 0 then
	    attack_info.attack.cad_damage[i] = 65535
	 else
	    attack_info.attack.cad_damage[i] = dmg_result.damages[i]
	 end
      else 
	 if dmg_result.damages[i] > 0 then
	    local flag = bit.lshift(1, i)
	    local eff = nwn.EffectDamage(flag, dmg_result.damages[i])
	    -- Set effect to direct so that Lua will not delete the
	    -- effect.  It will be deleted by the combat engine.
	    eff.direct = true
	    -- Add the effect to the onhit effect list so that it can
	    -- be applied when damage is signaled.
	    C.ns_AddOnHitEffect(attack_info.attack, attack_info.attacker, eff.eff)
	 end
      end
   end
end

--[[
function NSApplyDamageRollById(target, attacker, id)
   print("NSApplyDamageRollById")
   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)

   local dmg_result = DAMAGE_RESULTS[id]
   if dmg_result == nil then return end

   local eff = nwn.EffectDamage(1)
   eff.eff.eff_creator = attacker.id
   eff.eff.eff_integers[0] = 1
   eff.eff.eff_integers[1] = 1
   eff.eff.eff_integers[2] = 0
   eff.eff.eff_integers[3] = 1 --dmg_roll.damage_power
   eff.eff.eff_integers[4] = 1000

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      eff.eff.eff_integers[5 + i] = dmg_result.damages[i]
   end

   target:ApplyEffect(nwn.DURATION_TYPE_INSTANT, eff)

   NSBroadcastDamage(attacker, target, dmg_result)

   DAMAGE_RESULTS[id] = nil
end
--]]

function NSBroadcastDamage(attacker, target, dmg_result)
   --print("NSBroadcastDamage")
   local total = NSGetTotalDamage(dmg_result)
   local log

   if NS_OPT_NO_FLOAT_DAMAGE then
      log = NSFormatDamageRoll(attacker, target, dmg_result)
   elseif NS_OPT_NO_FLOAT_ZERO_DAMAGE and total <= 0 then
      log = NSFormatDamageRoll(attacker, target, dmg_result)
   else
      C.nwn_PrintDamage(attacker.id, target.id, total, dmg_result.damages)
      local extra = NSGetTotalDamage(dmg_result, 13)
      if extra > 0 then
         log = NSFormatDamageRoll(attacker, target, dmg_result, 13)
      end
   end

   local tloc = target:GetLocation()
   local ploc

   local imm
   if NSGetTotalImmunityAdjustment(dmg_result) > 0 then
      imm = NSFormatDamageRollImmunities(attacker, target, dmg_result)
   end

   local resist
   if NSGetTotalResistAdjustment(dmg_roll.result) > 0 then
      resist = NSFormatDamageRollResistance(attacker, target, dmg_result)
   end

   local dr 
   if dmg_result.soak_adjust > 0 then
      dr = NSFormatDamageRollReduction(attacker, target, dmg_result)
   end

   for pc in nwn.PCs() do
      ploc = pc:GetLocation()
      if tloc:GetDistanceBetween(ploc) <= 20 then
         if log then
            pc:SendMessage(log)
         end
         if dr then
            pc:SendMessage(dr)
         end
         if imm then
            pc:SendMessage(imm)
         end
         if resist then
            pc:SendMessage(resist)
         end
      end
   end
end

--- Adjusts damage done to targets damage immunity, resistance.
function NSDoDamageAdjustments(attacker, target, dmg_result, damage_power, attack_info)
   local dmg, resist, imm, imm_adj

   local weap = NSGetCurrentAttackWeapon(attacker, attack_info)
   local basetype, basemask = nwn.GetWeaponBaseDamageType(weap:GetBaseType())

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      -- When the index is the base weapon damage type, use the weapons base type
      -- to determine what immunity applies
      if i == 12 then
	 imm = target:GetDamageImmunity(nwn.GetDamageIndexFromFlag(basetype))
      else
	 imm = target:GetDamageImmunity(i)
      end

      dmg = dmg_result.damages[i]
      if dmg ~= 0 then
	 imm_adj = math.floor((imm * dmg) / 100)
	 -- Immunity
	 dmg_result.immunity_adjust[i] = imm_adj
	 dmg_result.damages[i] = dmg - imm_adj
      end
   end

   -- Resist
   target:DoDamageResistance(attacker, dmg_result, attack_info)
   
   -- Damage Reduction
   target:DoDamageReduction(attacker, dmg_result, damage_power)
end

---
function NSDoDamageRoll(bonus, penalty, mult)
   --print("NSDoDamageRoll", bonus, penalty, mult)
   local roll, prev, idx
   local res = damage_result_t()

   for i = 1, mult do
      for j = 0, NS_OPT_NUM_DAMAGES - 1 do
	 --print("bonus", j)
	 for k = 0, bonus.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] + nwn.DoDiceRoll(bonus.rolls[j][k])
	    --print(k, nwn.FormatDiceRoll(bonus.rolls[j][k]))
	 end

	 --print("penalty", j)
	 for k = 0, penalty.idxs[j] - 1 do
	    res.damages[j] = res.damages[j] - nwn.DoDiceRoll(penalty.rolls[j][k])
	    --print(k, nwn.FormatDiceRoll(bonus.rolls[j][k]))
	 end

	 if res.damages[j] < 0 then
	    res.damages[j] = 0
	 end
      end
   end
   
   return res
end

function NSCompactPhysicalDamageResult(dmg_result)
   dmg_result.damages[12] = dmg_result.damages[12] + dmg_result.damages[0] + 
      dmg_result.damages[1] + dmg_result.damages[2]

   dmg_result.damages[0], dmg_result.damages[1], dmg_result.damages[2] = 0, 0, 0
end

function NSGetDamageRoll(attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   --print("NSGetDamageRoll", attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   -- If attack_info is nil then we're coming from the hook.
   if not attack_info then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      attack_info = NSGetAttackInfo(attacker, target)
   end

   local base = 0
   local attack_type

   if offhand then 
      attack_type = nwn.ATTACK_TYPE_OFFHAND
   else
      attack_type = nwn.GetAttackTypeFromEquipNum(attack_info.weapon)
   end

   -- Determine Damage Bonuses/Penalties from effects/item properties.
   local bonus, penalty = attacker:GetEffectDamageBonus(target, attack_type)

   -- Add weapons base damage to damage roll.
   NSAddDamageToRoll(bonus, nwn.DAMAGE_TYPE_BASE_WEAPON, attacker.ci.equips[attack_info.weapon].base_dmg)

   -- Add any damage bonuses from combat modifiers. E,g. size, race, etc.
   NSGetDamageBonus(attacker, target, bonus)

   -- If this is a critical hit determine the multiplier.
   local mult = 1
   if crit then
      -- Add any addition damage from the weapons crit_dmg bonus.  E,g from Overwhelming Critical.
      NSAddDamageToRoll(bonus, nwn.DAMAGE_TYPE_BASE_WEAPON, attacker.ci.equips[attack_info.weapon].crit_dmg)
      mult = NSGetCriticalHitMultiplier(attacker, offhand, attack_info.weapon)
   end

   -- Roll all the damage.
   local dmg_result = NSDoDamageRoll(bonus, penalty, mult)
   NSCompactPhysicalDamageResult(dmg_result)

   local damage_power = 1 -- TODO: FIX THIS!!

   -- situational

   -- If the target is a creature modify the damage roll by their immunities, resistances,
   -- soaks.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSDoDamageAdjustments(attacker, target, dmg_result, damage_power, attack_info)
   end

   --print(NSCreateDamageResultDebugString(attacker, target, dmg_result))

   return dmg_result
end

--- Adds all the asorted damage bonuses.
function NSGetDamageBonus(attacker, target, dmg_roll)
   if attacker.ci.area.dmg.dice > 0 or attacker.ci.area.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.area.dmg_type, attacker.ci.area.dmg)
   end
   if attacker.ci.class.dmg.dice > 0 or attacker.ci.class.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.class.dmg_type, attacker.ci.class.dmg)
   end
   if attacker.ci.feat.dmg.dice > 0 or attacker.ci.feat.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.feat.dmg_type, attacker.ci.feat.dmg)
   end   
   if attacker.ci.mode.dmg.dice > 0 or attacker.ci.mode.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.mode.dmg_type, attacker.ci.mode.dmg)
   end
   if attacker.ci.race.dmg.dice > 0 or attacker.ci.race.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.race.dmg_type, attacker.ci.race.dmg)
   end
   if attacker.ci.size.dmg.dice > 0 or attacker.ci.size.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.size.dmg_type, attacker.ci.size.dmg)
   end
   if attacker.ci.skill.dmg.dice > 0 or attacker.ci.skill.dmg.bonus > 0 then
      NSAddDamageToRoll(dmg_roll, attacker.ci.skill.dmg_type, attacker.ci.skill.dmg)
   end

   -- Favored Enemies
   if attacker.ci.fe_mask ~= 0 
      and (attacker.ci.fe.dmg.dice > 0 or attacker.ci.fe.dmg.bonus > 0)
   then
      if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
         and bit.band(attacker.ci.fe_mask, bit.lshift(1, target:GetRacialType())) ~= 0
      then
         NSAddDamageToRoll(dmg_roll, attacker.ci.fe.dmg_type, attacker.ci.fe.dmg)
      end
   end
end

---
function NSGetTotalDamage(dmg_result)
   --print("NSGetTotalDamage", dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.damages[i]
   end
   return total
end

---
function NSGetTotalImmunityAdjustment(dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.immunity_adjust[i]
   end
   return total
end

---
function NSGetTotalResistAdjustment(dmg_result)
   local total = 0
   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      total = total + dmg_result.resist_adjust[i]
   end
   return total
end

---
function NSResolveDamage(attacker, target, from_hook, attack_info)
   --print("NSResolveDamage", attacker, target, from_hook, attack_info)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
      attack_info = NSGetAttackInfo(attacker, target)
   end

   local ki_strike = attack_info.attack.cad_special_attack == 882
   local crit = attack_info.attack.cad_attack_result == 3

   -- Following should be dealt with in special attacks.
   --if ki_strike then
   --   attack:DecrementRemainingFeatUses(882)
   --end

   local damage_result = NSGetDamageRoll(attacker, 
					 target, 
					 attack_info.is_offhand,
					 crit,
					 attack_info.attack.cad_sneak_attack == 1,
					 attack_info.attack.cad_death_attack == 1,
					 ki_strike,
					 attack_info)

   local total = NSGetTotalDamage(damage_result)

   --Defensive Roll
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(nwn.FEAT_DEFENSIVE_ROLL)
   then
      target:DecrementRemainingFeatUses(nwn.FEAT_DEFENSIVE_ROLL)
      
      if target:ReflexSave(total, nwn.SAVING_THROW_TYPE_DEATH, attacker) then
         -- TODO: Adjust individual damages.
         total = math.floor(total / 2)
      end
   end

   -- Death Attack

   -- Add the damage result info to the CNWSCombatAttackData and
   -- and EffectDamages for any custom damage
   NSAddDamageResultToAttack(attack_info, damage_result)
  
   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and total > 0
      and attack_info.attacker_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message
      
      attack_info.attack.cad_attack_result = 4
      attack_info.attacker_cr.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      end

      if total > 0 then
         C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, attack_info.is_offhand, crit)
      end

      C.nwn_ResolveItemCastSpell(attacker.obj, target.obj.obj)

      if total > 0 then
         NSResolveOnHitVisuals(attacker, target, attack_info.attack, damage_result)
      end
   end

   return damage_result
end

function NSResolveOnHitVisuals(attacker, target, attack, dmg_result)
   local flag
   local highest = 0
   local highest_vfx
   local vfx

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      flag = bit.lshift(1, i)
      vfx = nwn.GetDamageVFX(flag, attack.cad_ranged_attack == 1)
      if vfx and dmg_result.damages[i] > highest then
         highest_vfx = vfx
         highest = dmg_result.damages[i]
      end
   end

   if highest_vfx then
      C.ns_AddOnHitVisual(attack, attacker.id, highest_vfx)
   end
end
