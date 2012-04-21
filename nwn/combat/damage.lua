--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local color = require 'nwn.color'

ffi.cdef[[
typedef struct DamageRoll {
   uint32_t    damage_power;

   DiceRoll    bonus[100];
   uint32_t    bonus_type[100];
   uint32_t    bonus_count;

   DiceRoll    penalty[100];
   uint32_t    penalty_type[100];
   uint32_t    penalty_count;

   uint32_t    damages[13];
   uint32_t    immunity_adjust[13];
   uint32_t    resist_adjust[13];
   uint32_t    soak_adjust;
} DamageRoll;
]]

local damage_roll_t = ffi.typeof("DamageRoll")

local function NSAddDamageBonus(dmg_roll, dmg_type, roll)
   local idx = dmg_roll.bonus_count
   if idx >= 100 then
      error "Only 25 damage bonuses can be applicable at one time..."
      return
   end

   dmg_roll.bonus[idx] = roll
   dmg_roll.bonus_type[idx] = nwn.GetDamageIndexFromFlag(dmg_type)

   dmg_roll.bonus_count = idx + 1
end

local function NSAddDamagePenalty(dmg_roll, dmg_type, roll)
   local idx = dmg_roll.penalty_count
   if idx >= 100 then
      error "Only 25 damage penalties can be applicable at one time..."
      return
   end

   dmg_roll.penalty[idx] = roll
   dmg_roll.penalty_type[idx] = dmg_type

   dmg_roll.penalty_count = idx + 1
end

---
--
function NSDoDamageAdjustments(attacker, target, dmg_roll)
   local dmg, resist, imm, imm_adj

   for i = 0, 12 do
      dmg = dmg_roll.damages[i]
      imm = target:GetDamageImmunity(i)
      imm_adj = math.floor((imm * dmg) / 100)

      -- Immunity
      dmg_roll.immunity_adjust[i] = imm_adj
      dmg_roll.damages[i] = dmg - imm_adj
      
      -- Resist
      resist = target:GetDamageResistance(i)
      dmg_roll.resist_adjust[i] = resist
      dmg_roll.damages[i] = dmg - resist
   end

   local highest_soak = 0
   if dmg_roll.damage_power < 20 and dmg_roll.damage_power >= 0 then
      for i = dmg_roll.damage_power + 1, 20 do
         if target.ci.soak[i] > highest_soak then
            highest_soak = target:GetDamageReduction(i)
         end
      end
   end

   dmg_roll.soak_adjust = highest_soak
   dmg_roll.damages[12] = dmg_roll.damages[12] - highest_soak
end

function NSDoCritDamageRoll(dmg_roll, mult, attacker, weap_num)
   local roll, prev, idx

   for i = 1, mult do
      roll = nwn.DoDiceRoll(attacker.ci.equips[weap_num].crit_dmg)
      
      prev = dmg_roll.damages[12]
      dmg_roll.damages[12] = prev + roll
   end
end

---
-- TODO: Ki Strike
function NSDoDamageRoll(dmg_roll, mult)
   local roll, prev, idx
   for j = 1, mult do
      for i = 0, dmg_roll.bonus_count do
         idx = dmg_roll.bonus_type[i]
         roll = nwn.DoDiceRoll(dmg_roll.bonus[i])
         
         prev = dmg_roll.damages[idx]
         dmg_roll.damages[idx] = prev + roll
      end
   end
end

function NSGetDamageRoll(attacker, target, offhand, crit, sneak, death, ki_damage, weapon, weap_num)
   -- If weap is nil then we're coming from the hook.
   local cr, attack_num, attack, attack_type, mult
   local from_hook = false

   if not weapon then
      from_hook = true

      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      cr = attacker.obj.cre_combat_round
      attack_num = cr.cr_current_attack
      attack = C.nwn_GetAttack(cr, attack_num)
      attack_type = attack.cad_attack_type

      weapon, weap_num = NSGetCurrentAttackWeapon(cr, attack_type, attacker)
   end

   local base = 0
   local dmg_roll = damage_roll_t()


   NSAddDamageBonus(dmg_roll, nwn.DAMAGE_TYPE_BASE_WEAPON, attacker.ci.equips[weap_num].base_dmg)
   NSGetDamageBonus(attacker, target, 0, dmg_roll)

   -- Effects
   NSGetEffectDamageBonus(attacker, target, offhand, dmg_roll)

   -- situational
   -- NSAddDamageBonus(dmg_roll, attacker.ci.fe.dmg_type, attacker.ci.fe.dmg)

   if crit then
      mult = NSGetCriticalHitMultiplier(attacker, offhand, weapon, weap_num)
   else
      mult = 1
   end

   NSDoDamageRoll(dmg_roll, mult)

   if crit then
      NSDoCritDamageRoll(dmg_roll, mult, attacker, weap_num)
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      NSDoDamageAdjustments(attacker, target, dmg_roll)
   end

   NSFormatDamageRoll(attacker, target, dmg_roll)
   NSFormatDamageRollImmunities(attacker, target, dmg_roll)

   return dmg_roll
end

function NSGetDamageBonus(attacker, target, int, dmg_roll)

   NSAddDamageBonus(dmg_roll, attacker.ci.area.dmg_type, attacker.ci.area.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.class.dmg_type, attacker.ci.class.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.feat.dmg_type, attacker.ci.feat.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.mode.dmg_type, attacker.ci.mode.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.race.dmg_type, attacker.ci.race.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.size.dmg_type, attacker.ci.size.dmg)
   NSAddDamageBonus(dmg_roll, attacker.ci.skill.dmg_type, attacker.ci.skill.dmg)

   -- TODO: Favored enememy
   NSAddDamageBonus(dmg_roll, attacker.ci.fe.dmg_type, attacker.ci.fe.dmg)
end

function NSGetEffectDamageBonus(attacker, target, offhand, dmg_roll)
   local atk_type, race, lawchaos, goodevil, subrace, deity, amount
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id

   local total = 0
   local eff_type

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      trace = target:GetRacialType()
      tgoodevil = target:GetGoodEvilValue()
      tlawchaos = target:GetLawChaosValue()
      tdeity_id = target:GetDeityId()
      tsubrace_id = target:GetSubraceId()
   end

   local valid = false

   for i = attacker.stats.cs_first_dmg_eff, attacker.obj.obj.obj_effects_len - 1 do
      eff_type = attacker.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE 
         or eff_type < nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE 
      then
         break
      end

      amount   = attacker.obj.obj.obj_effects[i].eff_integers[0]
      dmg_flag = attacker.obj.obj.obj_effects[i].eff_integers[1]
      race     = attacker.obj.obj.obj_effects[i].eff_integers[2]
      lawchaos = attacker.obj.obj.obj_effects[i].eff_integers[3]
      goodevil = attacker.obj.obj.obj_effects[i].eff_integers[4]
      atk_type = attacker.obj.obj.obj_effects[i].eff_integers[5]
      subrace  = attacker.obj.obj.obj_effects[i].eff_integers[6]
      deity    = attacker.obj.obj.obj_effects[i].eff_integers[7]
      valid    = false

      if atk_type == nwn.ATTACK_BONUS_MISC or atk_type == attack_type then
         valid = true
      elseif attack_type == 6 and (atk_type == nwn.ATTACK_BONUS_ONHAND or nwn.ATTACK_BONUS_CWEAPON1) then
         -- TODO: This is double counting damage bonuses if both onhand and cweapon1 are equipped.
         valid = true
      elseif attack_type == 8 and atk_type == nwn.ATTACK_BONUS_UNARMED then
         valid = true
      end

      if race == nwn.RACIAL_TYPE_INVALID 
         and lawchaos == 0
         and goodevil == 0
         and subrace == 0
         and deity == 0
      then
         valid = true
      end
      
      if valid
         and (race == nwn.RACIAL_TYPE_INVALID or race == trace)
         and (lawchaos == 0 or lawchaos == tlawchaos)
         and (goodevil == 0 or goodevil == tgoodevil)
         and (subrace == 0 or subrace == tsubrace_id)
         and (deity == 0 or deity == tdeity_id)
      then
         if eff_type == nwn.EFFECT_TRUETYPE_DAMAGE_DECREASE then
            NSAddDamagePenalty(dmg_roll, dmg_flag, nwn.GetDamageRollFromConstant(amount))
         elseif eff_type == nwn.EFFECT_TRUETYPE_DAMAGE_INCREASE then
            NSAddDamageBonus(dmg_roll, dmg_flag, nwn.GetDamageRollFromConstant(amount))
         end 
      end
   end
end

function NSGetTotalDamage(dmg_roll)
   local total = 0
   for i = 0, 12 do
      total = total + dmg_roll.damages[i]
   end
   return total
end

function NSGetTotalImmunityAdjustment(dmg_roll)
   local total = 0
   for i = 0, 12 do
      total = total + dmg_roll.immunity_adjust[i]
   end
   return total
end

function NSGetTotalResistAdjustment(dmg_roll)
   local total = 0
   for i = 0, 12 do
      total = total + dmg_roll.resist_adjust[i]
   end
   return total
end

function NSResolveDamage(attacker, target, from_hook, cr, attack, attack_type, weap, weap_num, is_offhand)
   local cr, attack_num, attack, attack_type, mult

   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   cr = attacker.obj.cre_combat_round
   attack_num = cr.cr_current_attack
   attack = C.nwn_GetAttack(cr, attack_num)
   attack_type = attack.cad_attack_type

   local is_offhand = NSGetOffhandAttack(cr)
   local weapon, weap_num = NSGetCurrentAttackWeapon(cr, attack_type, attacker)
   local ki_strike = attack.cad_special_attack == 882
   local crit = attack.cad_attack_result == 3

   if ki_strike then
      attack:DecrementRemainingFeatUses(882)
   end

   local damage_roll = NSGetDamageRoll(attacker, target, is_offhand,
                                       crit,
                                       attack.cad_sneak_attack == 1,
                                       attack.cad_death_attack == 1,
                                       ki_strike,
                                       weapon,
                                       weap_num)

   local total = NSGetTotalDamage(damage_roll)

   --Defensive Roll
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(nwn.FEAT_DEFENSIVE_ROLL)
   then
      target:DecrementRemainingFeatUses(nwn.FEAT_DEFENSIVE_ROLL)
      
      if target:ReflexSave(total, nwn.SAVING_THROW_TYPE_DEATH, attacker) then
         total = math.floor(total / 2)
      end
   end

   -- Death Attack

   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and total > 0
      and cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- Send Epic Dodge Message
      
      attack.cad_attack_result = 4
      cr.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      end

      if total > 0 then
         C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, is_offhand, crit)
      end

      C.nwn_ResolveItemCastSpell(attacker.obj, target.obj.obj)

      if total >= 0 then
         NSResolveOnHitVisuals(attacker, target, attack, damage_roll)
      end
   end
   
   print("Resolve Damage: ", total)

   return total, damage_roll
end

function NSResolveOnHitVisuals(attacker, target, attack, dmg_roll)
   local flag
   local highest = 0
   local highest_vfx
   local vfx

   for i = 0, 12 do
      flag = bit.lshift(1, i)
      vfx = nwn.GetDamageVFX(flag, attack.cad_ranged_attack == 1)
      if vfx and dmg_roll.damages[i] > highest then
         highest_vfx = vfx
         highest = dmg_roll.damages[i]
      end
   end

   if highest_vfx then
      C.ns_AddOnHitVisual(attack, attacker.id, highest_vfx)
   end
end

function NSSignalMeleeDamage(attacker, target, attack_count)
   local current_attack = attacker.obj.cre_combat_round.cr_current_attack
   local attack_offset

   print(current_attack, attack_count)

   local attack = C.nwn_GetAttack(attacker.obj.cre_combat_round, current_attack - attack_count)
   local attack_anim = bit.rshift(attack.cad_anim_length, 1) --v35
   local target_anim = 0 --v36

   print(current_attack, attack_offset)

   for i = attack_count, 1, -1 do
      attack_offset = current_attack - i
      attack = C.nwn_GetAttack(attacker.obj.cre_combat_round, attack_offset)

      C.ns_SignalAttack(attacker.obj, target.obj.obj, attack, target_anim)
      C.ns_SignalAOO(attacker.obj, target.obj.obj, attack, target_anim)

      if NSGetAttackResult(attack) then
         -- Do damage effect.
         print(attack.cad_onhit_effs_len)
         C.ns_SignalOnHitEffects(attacker.obj, target.obj.obj, attack, attack_anim)
      else
         C.ns_SignalMiss(attacker.obj, target.obj.obj, attack, attack_anim)
      end

      attack_anim = attack_anim + bit.rshift(attack.cad_react_anim_len, 1)
      target_anim = target_anim + target_anim + bit.rshift(attack.cad_react_anim_len, 1)
   end
end

function NSSignalRangedDamage(attacker, target, attack_count)

end

