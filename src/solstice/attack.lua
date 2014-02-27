--- Attack module
--

local ffi = require 'ffi'
local C = ffi.C
local random = math.random

local bit  = require 'bit'
local bor  = bit.bor
local band = bit.band

local Eff = require 'solstice.effect'

local Dice   = require 'solstice.dice'
local DoRoll = Dice.DoRoll
local RollValid = Dice.IsValid
local GetIsRangedWeapon = Rules.GetIsRangedWeapon

--- Adds combat message to an attack.
local function AddCCMessage(info, type, objs, ints)
   C.nwn_AddCombatMessageData(info.attack, type or 0, #objs, objs[1] or 0, objs[2] or 0,
                              #ints, ints[1] or 0, ints[2] or 0, ints[3] or 0, ints[4] or 0)
end

--- Adds an onhit effect to an attack.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param eff Effect ctype.
local function AddEffect(info, attacker, eff)
   C.ns_AddOnHitEffect(info.attack, attacker.id, eff.eff)
end

--- Adds an onhit visual effect to an attack.
-- @param info AttackInfo ctype.
-- @param vfx VFX\_*
local function AddVFX(info, vfx)
   C.ns_AddOnHitVisual(info.attack, info.attacker.id, vfx)
end

--- Clear special attack.
-- @param info AttackInfo ctype.
local function ClearSpecialAttack(info)
   info.attack.cad_special_attack = 0
end

--- Copy damage to NWN Attack Data.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
local function CopyDamageToNWNAttackData(info, attacker)
   for i = 0, 12 do
      if i < 13 then
         if info.dmg_result.damages[i] <= 0 then
            info.attack.cad_damage[i] = -1
         else
            info.attack.cad_damage[i] = info.dmg_result.damages[i]
         end
      else
         if info.dmg_result.damages[i] > 0 then
            local flag = bit.lshift(1, i)
            local eff = nwn.EffectDamage(flag, info.dmg_result.damages[i])
            -- Set effect to direct so that Lua will not delete the
            -- effect.  It will be deleted by the combat engine.
            eff.direct = true
            -- Add the effect to the onhit effect list so that it can
            -- be applied when damage is signaled.
            AddEffect(info, attacker, eff)
         end
      end
   end
end

--- Create Attack Info holder.
-- @param attacker Attacking creature.
-- @param target Attack target.
local function CreateAttackInfo(attacker, target)
   local attack_info = ffi.new("AttackInfo")
   local cr = attacker.obj.cre_combat_round
   attack_info.attacker_cr = cr
   attack_info.current_attack = cr.cr_current_attack
   attack_info.attack = C.nwn_GetAttack(attacker.obj)
   attack_info.attack.cad_attack_group = attack_info.attack.cad_attack_group
   attack_info.attack.cad_target = target.id
   attack_info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   attack_info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(attacker.obj)
   attack_info.is_offhand = cr.cr_current_attack + 1 > cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(attacker.obj, attack_info.attack.cad_attack_type)
   attack_info.weapon = EQUIP_TYPE_UNARMED
   if weapon ~= nil then
      for i = 0, EQUIP_TYPE_NUM - 1 do
         if attacker.ci.equips[i].id == weapon.obj.obj_id then
            attack_info.weapon = i
            break
         end
      end
   end

   if target.type == OBJECT_TRUETYPE_CREATURE then
      attack_info.target_cr = target.obj.cre_combat_round
   end

   return attack_info
end

--- Returns attack result.
-- @param info AttackInfo
local function GetResult(info)
   return info.attack.cad_attack_result
end

--- Returns the attack type.  See ATTACK_TYPE_*
-- @param info AttackInfo
local function GetType(info)
   return info.attack.cad_attack_type
end


--- Forces people to equip ammunition.
-- NWN just doesn't seem to like letting Throwaxes, shurikens, darts... so we're forcing them
-- to auto-equip them (if they have none they will default to normal behavior, unarmed attacks)
-- @param attacker Attacking creature.
-- @param attack_count Number of attacks in attack group.
local function ForceEquipAmmunition(attacker, attack_count)
   C.ns_ForceEquipAmmunition(attacker.obj, attack_count, attacker.ci.ranged_type)
end

--- Determines if creature has ammunition available.
-- @param attacker Attacking creature.
-- @param attack_count Number of attacks in attack group.
local function GetAmmunitionAvailable(attacker, attack_count)
   return C.ns_GetAmmunitionAvailable(attacker.obj, attack_count,
                                      attacker.ci.ranged_type)
end


--- Gets the total attack roll.
-- @param info AttackInfo
local function GetAttackRoll(info)
   return info.attack.cad_attack_roll + info.attack.cad_attack_mod
end

--- Get critical hit roll
-- @param info AttackInfo.
-- @param attacker Attacking creature.
local function GetCriticalHitRoll(info, attacker)
   return 21 - attacker:GetCriticalHitRange(info.is_offhand, info.weapon)
end

--- Get current weapon.
-- @param info AttackInfo
-- @param attacker Attacking object.
local function GetCurrentWeapon(info, attacker)
   local n = info.weapon
   if n >= 0 and n <= 5 then
      local id = attacker.ci.equips[n].id
      return _SOL_GET_CACHED_OBJECT(id)
   end
   return OBJECT_INVALID
end

--- Determine if attack is a coup de grace.
-- @param info AttackInfo
local function GetIsCoupDeGrace(info)
   return info.attack.cad_coupdegrace ~= 0
end

--- Determines if attack results in a critical hit
-- @param info AttackInfo
local function GetIsCriticalHit(info)
   return GetResult(info) == 3
end

--- Determine if attack is a death attack.
-- @param info AttackInfo
local function GetIsDeathAttack(info)
   return info.attack.cad_death_attack == 1
end

--- Determines if the attack results in a hit.
-- @param info AttackInfo
local function GetIsHit(info)
   local t = GetResult(info)
   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

--- Determine if current attack is an offhand attack.
-- @param info AttackInfo
local function GetIsOffhandAttack(info)
   local cr = info.attacker_cr
   return info.attacker_cr.cr_current_attack + 1 >
      info.attacker_cr.cr_effect_atks
      + info.attacker_cr.cr_additional_atks
      + info.attacker_cr.cr_onhand_atks
end

--- Determines if attack is ranged.
-- @param info AttackInfo
local function GetIsRangedAttack(info)
   return info.attack.cad_ranged_attack == 1
end

--- Determine if attack is a sneak attack.
-- @param info AttackInfo
local function GetIsSneakAttack(info)
   return info.attack.cad_sneak_attack == 1
end

local function SetSneakAttack(info, sneak, death)
   info.attack.cad_sneak_attack = sneak
   info.attack.cad_death_attack = death
end


--- Determines if attack is a special attack
-- @param info AttackInfo
local function GetIsSpecialAttack(info)
   return info.attack.cad_special_attack ~= 0
end

--- Returns special attack
-- @param info AttackInfo
local function GetSpecialAttack(info)
   return info.attack.cad_special_attack
end

local function GetTotalAttacks(info)
  local res = info.attacker_cr.cr_effect_atks
     + info.attacker_cr.cr_additional_atks
     + info.attacker_cr.cr_onhand_atks
     + info.attacker_cr.cr_offhand_atks;

  return res < 1 and 1 or res
end

--- Determines the attack penalty based on attack count.
-- @param info AttackInfo.
-- @param attacker Attacking creature.
local function GetIterationPenalty(info, attacker)
   local iter_pen = 0
   local spec_att = GetSpecialAttack(info)

   -- Deterimine the iteration penalty for an attack.  Not all attack types are
   -- have it.
   if att_type == ATTACK_TYPE_OFFHAND then
      iter_pen = 5 * info.attacker_cr.cr_offhand_taken
      info.attacker_cr.cr_offhand_taken = info.attacker_cr.cr_offhand_taken + 1
   elseif info.attacker_cr.current_attack > info.attacker_cr.cr_onhand_atks then
      -- Normally this would have checked for ATTACK_TYPE_EXTRA1 or
      -- ATTACK_TYPE_EXTRA1, but those seemed superfluous.

      if spec_att ~= 867 or
         spec_att ~= 868 or
         spec_att ~= 391
      then
         iter_pen = 5 * info.attacker_cr.cr_extra_taken
      end
      info.attacker_cr.cr_extra_taken = info.attacker_cr.cr_extra_taken + 1
   elseif spec_att ~= 65002 and spec_att ~= 6 and spec_att ~= 391 then
      iter_pen = info.current_attack * attacker.ci.equips[info.weapon].iter
   end

   return iter_pen
end

--- Determine total damage.
-- @param info AttackInfo.
local function GetDamageTotal(info)
   local sum = 0
   for i = 0, 12 do
      sum = sum + info.dmg_result.damages[i]
   end
   return sum
end

--- Sets attack modifier
-- @param info AttackInfo.
-- @param ab Attack modifier
local function SetAttackMod(info, ab)
   info.attack.cad_attack_mod = ab
end

--- Sets attack roll
-- @param info AttackInfo.
-- @param roll The 1d20 attack roll.
local function SetAttackRoll(info, roll)
   info.attack.cad_attack_roll = roll
end

--- Set concealment.
-- @param info AttackInfo.
-- @param conceal Concealment result.
local function SetConcealment(info, conceal)
   info.attack.cad_concealment = conceal
end

--- Set Critical result.
-- @param info AttackInfo.
-- @param threat Set critical threat
-- @param result Set critical hit result.
local function SetCriticalResult(info, threat, result)
   info.attack.cad_threat_roll = threat
   info.attack.cad_critical_hit = result
end

--- Set missed by.
-- @param info AttackInfo.
-- @param roll How much creature missed by.
local function SetMissedBy(info, roll)
   info.attack.cad_missed = roll
end

--- Sets the attack result.
-- @param info AttackInfo.
-- @param result See...
local function SetResult(info, result)
   info.attack.cad_attack_result = result
end


local function ResolveCachedSpecialAttacks(attacker)
   C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
end

--- Resolve pre-roll.
-- @param info AttackInfo.
-- @param attacker Attacker
-- @param target Target
local function ResolvePreRoll(info, attacker, target)
   if not GetIsCoupDeGrace(info) then
      ResolveCachedSpecialAttacks(attacker)
   end

   -- Special Attack
   -- Determine if able to use special attack (if one has been used).
   if GetIsSpecialAttack(info) then
      local sa = GetSpecialAttack(info)
      if sa < 1115 and attacker:GetRemainingFeatUses(sa) == 0 then
         ClearSpecialAttack(info)
      end
   end
end

--- Resolves Armor Class Roll
--  A large part of the AC is calculated in Creature:GetAC, only those parts
--  that are potentially determined by the target are calculated below.
-- @param info AttackInfo.
-- @param attacker Attacker
-- @param target Target
local function ResolveArmorClass(info, attacker, target)
   return target:GetACVersus(attacker, false, info, GetIsRangedAttack(info))
end

--- Resolves that attack bonus of the creature.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
function ResolveAttackModifier(info, attacker, target)
   return attacker:GetAttackBonusVs(target, info.weapon)
end

--- Determine miss chance / concealment.

-- @param hit Is hit.
-- @param use_cached
-- @return Returns true if the attacker failed to over come miss chance
-- or concealment.
local function ResolveMissChance(info, attacker, target, hit, use_cached)
   -- Miss Chance
   local miss_chance = 0
   -- Conceal
   local conceal = target:GetConcealment(attacker, info.attack)

   -- If concealment and mis-chance are less than or equal to zero
   -- there is no chance of them affecting the outcome of an attack.
   if conceal <= 0 and miss_chance <= 0 then return false end

   local chance, attack_result

   -- Deterimine which of miss chance and concealment is higher.
   -- attack_result is a magic number for the NWN combat engine that
   -- determines which combat messages are sent to the player.
   if miss_chance < conceal then
      chance = conceal
      attack_result = 8
   else
      chance = miss_chance
      attack_result = 9
   end

   -- The attacker has two possible chances to over come miss chance / concealment
   -- if they posses the blind fight feat.  If not they only have one chance to do so.
   if random(100) >= chance
      or (attacker:GetHasFeat(FEAT_BLIND_FIGHT) and random(100) >= chance)
   then
      return false
   else
      SetResult(info, attack_result)
      -- Show the modified conceal/miss chance in the combat log.
      SetConcealment(math.floor(info, (chance ^ 2) / 100))
      SetMissedBy(info, 1)
      return true
   end
end

--- Resolves deflect arrow.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param hit Is hit.
local function ResolveDeflectArrow(info, attacker, target, hit)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then
      return false
   end
   -- Deflect Arrow
   if hit
      and info.attacker_cr.cr_deflect_arrow == 1
      and info.attack.cad_ranged_attack ~= 0
      and bit.band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(FEAT_DEFLECT_ARROWS)
   then
      local on = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      local off = target:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)

      if not on:GetIsValid()
         or (target:GetRelativeWeaponSize(on) <= 0
         and not GetIsRangedWeapon(on)
         and not off:GetIsValid())
      then
         on = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
         on = on:GetBaseType()
         local bow
         if on ~= BASE_ITEM_DART
            and on ~= BASE_ITEM_THROWINGAXE
            and on ~= BASE_ITEM_SHURIKEN
         then
            bow = 0
         else
            bow = 1
         end
         local v = vector_t(target.obj.obj.obj_position.x,
                            target.obj.obj.obj_position.y,
                            target.obj.obj.obj_position.z)

         C.nwn_CalculateProjectileTimeToTarget(attacker.obj, v, bow)
         info.attacker_cr.cr_deflect_arrow = 0
         SetResult(info, 2)
         info.attack.cad_attack_deflected = 1
         return true
      end
   end
   return false
end

--- Resolve parry
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param hit is hit.
local function ResolveParry(info, attacker, target, hit)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return false end

   if info.attack.cad_attack_roll == 20
      or attacker.obj.cre_mode_combat ~= COMBAT_MODE_PARRY
      or info.attacker_cr.cr_parry_actions == 0
      or info.attacker_cr.cr_round_paused ~= 0
      or info.attack.cad_ranged_attack ~= 0
   then
      return false
   end

   -- Can not Parry when using a Ranged Weapon.
   local on = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if on:GetIsValid() and GetIsRangedWeapon(on) then
      return false
   end

   local roll = random(20) + target:GetSkillRank(SKILL_PARRY)
   info.target_cr.cr_parry_actions = info.target_cr.cr_parry_actions - 1

   if roll >= info.attack.cad_attack_roll + info.attack.cad_attack_mod then
      if roll - 10 >= info.attack.cad_attack_roll + info.attack.cad_attack_mod then
         target:AddParryAttack(attacker)
      end
      SetAttackResult(info, 2)
      return true
   end

   C.nwn_AddParryIndex(info.target_cr)
   return false
end

--- Resolve attack roll.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveAttackRoll(info, attacker, target)
   local attack_type = info.attack.cad_attack_type

   -- Determine attack modifier
   local ab = ResolveAttackModifier(info, attacker, target)
      - GetIterationPenalty(info, attacker)
   SetAttackMod(info, ab)

   -- Determine AC
   local ac = ResolveArmorClass(info, attacker, target)

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in
   -- NSResolvePostMelee/RangedDamage
   if GetIsCoupDeGrace(info) then
      SetResult(info, 7)
      SetAttackRoll(info, 20)
      return
   end

   local roll = random(20)
   SetAttackRoll(info, roll)

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1

   if ResolveMissChance(info, attacker, target, hit)
      or ResolveDeflectArrow(info, attacker, target, hit)
      or ResolveParry(info, attacker, target, hit)
   then
      return
   end

   if not hit then
      SetResult(info, 4)
      if roll == 1 then
         SetMissedBy(info, 1)
      else
         SetMissedBy(info, ac - ab + roll)
      end
      return
   else
      SetResult(info, 1)
   end

   -- Determine if this is a critical hit.
   if roll > GetCriticalHitRoll(info, attacker) then
      local threat = random(20)
      SetCriticalResult(info, threat, 1)

      if threat + ab >= ac then
         if not target:GetIsImmuneToCriticalHits(attacker) then
            -- Is critical hit
            SetResult(info, 3)
         else
            -- Send target immune to crits.
            AddCCMessage(info, nil, { target.id }, { 126 })
         end
      end
   end
end

local function AddDamageToResult(info, dmg, mult)
   if dmg.mask == 0 or (mult > 1 and band(dmg.mask, 2) ~= 0) then
      -- penalty
      if band(dmg.mask, 1) ~= 0 then
         info.dmg_result.damages[dmg.type] = info.dmg_result.damages[dmg.type]
            - DoRoll(dmg.roll)
      else
         info.dmg_result.damages[dmg.type] = info.dmg_result.damages[dmg.type]
            + DoRoll(dmg.roll)
      end
   end
end

--- Resolve damage result.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param mult crit multiplier
-- @param ki_strike Is WM Ki Strike.
local function ResolveDamageResult(info, attacker, mult, ki_strike)
   for i = 0, attacker.ci.equips[info.weapon].damage_len - 1 do
      AddDamageToResult(info, attacker.ci.equips[info.weapon].damage[i], mult)
   end

   for i = 0, attacker.ci.offense.damage_len - 1 do
      AddDamageToResult(info, attacker.ci.offense.damage[i], mult)
   end

   info.dmg_result.damages[12] = info.dmg_result.damages[12]
      + DoRoll(attacker.ci.equips[info.weapon].base_dmg_roll)

   info.dmg_result.damages[12] = info.dmg_result.damages[12]
      + (attacker.ci.equips[info.weapon].dmg_ability * mult)
end

--- Resolve item cast spell.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveItemCastSpell(info, attacker, target)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return end

   local weapon = GetCurrentWeapon(info, attacker)
   if weapon:GetIsValid() then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          weapon.obj, false)
   end

   local shield = target:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
   local chest = target:GetItemInSlot(INVENTORY_SLOT_CHEST)

   if chest:GetIsValid() then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          chest.obj, true)
   end
   if shield:GetIsValid() and
      (shield.obj.it_baseitem == BASE_ITEM_SMALLSHIELD or
       shield.obj.it_baseitem == BASE_ITEM_LARGESHIELD or
       shield.obj.it_baseitem == BASE_ITEM_TOWERSHIELD)
   then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          shield.obj, true)
   end
end

--- Resolve on hit effects...
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveOnHitEffect(info, attacker, target)
   -- TODO: FIX
   --C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, info.is_offhand,
   --                         GetIsCriticalHit(info))
end

--- Resolve on hit visual effects.
-- TODO: FIX
-- This is not default behavior.
-- @param info AttackInfo ctype.
function ResolveOnHitVFX(info)
   return
--[[
   local flag, highest_vfx, vfx
   local highest = 0

   for i = 0, 12 do
      flag = bit.lshift(1, i)
      vfx = nwn.GetDamageVFX(flag, info:GetIsRangedAttack())
      if vfx and info.dmg_result.damages[i] > highest then
         highest_vfx = vfx
         highest = info.dmg_result.damages[i]
      end
   end

   if highest_vfx then
      AddVFX(info, highest_vfx)
   end
   --]]
end

--- Resolves that damage of the creature.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- NOTE: This function is only ever called by the combat engine.
local function ResolveDamage(info, attacker, target)
   local ki_strike = GetSpecialAttack(info) == 882
   -- If this is a critical hit determine the multiplier.
   local mult = 1
   if GetIsCriticalHit(info) then
      mult = attacker:GetCriticalHitMultiplier(info.is_offhand, info.weapon)
   end

   ResolveDamageResult(info, attacker, mult, ki_strike)
   local total = GetDamageTotal(info)

   -- Defensive Roll
   if target.type == OBJECT_TRUETYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(FEAT_DEFENSIVE_ROLL)
   then
      target:DecrementRemainingFeatUses(FEAT_DEFENSIVE_ROLL)

      if target:ReflexSave(total, SAVING_THROW_TYPE_DEATH, attacker) then
         --dmg_roll:MapResult(function (amt) return math.floor(amt / 2) end)
      end
   end

   local total = GetDamageTotal(info)

   -- Add the damage result info to the CNWSCombatAttackData
   CopyDamageToNWNAttackData(info)

   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == OBJECT_TRUETYPE_CREATURE
      and total > 0
      and info.target_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message

      SetResult(info, 4)
      info.target_cr.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      else
         -- Item onhit cast spells are done regardless of whether weapon damage is
         -- greater than zero.
         ResolveItemCastSpell(info, attacker, target)
      end

      if total > 0 then
         ResolveOnHitEffect(info, attacker, target)
         ResolveOnHitVFX(info, dmg_roll)
      end
   end
end

function ResolveCoupDeGrace(info, attacker, target)
   if bit.band(info.target_state, COMBAT_TARGET_STATE_ASLEEP) == 0             or
      (target.type == OBJECT_TRUETYPE_CREATURE and target.obj.cre_is_immortal) or
      target.obj.obj.obj_is_invulnerable == 1
   then
      return
   end

   AddEffect(info, attacker, Eff.Death(false, true))
   info.is_killing = true
end

function ResolveDevCrit(info, attacker, target)
   if not GetIsCriticalHit(info)
   -- TODO: FIX
   --or NS_OPT_DEVCRIT_DISABLE_ALL
   --or (NS_OPT_DEVCRIT_DISABLE_PC and attacker:GetIsPC())
   then
      return
   end

   local dc = 10 + math.floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(ABILITY_STRENGTH)

   if target:FortitudeSave(dc, SAVING_THROW_VS_DEATH, attacker) == 0 then
      local eff = Eff.EffectDeath(true, true)
      eff:SetSubType(SUBTYPE_SUPERNATURAL)
      target:ApplyEffect(DURATION_TYPE_INSTANT, eff)

      info:SetResult(10)
   end
end

--- Resolve Epic Dodge.
-- probably broken.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveEpicDodge(info, attacker, target)
   if info.target.type ~= OBJECT_TRUETYPE_CREATURE then return false end

   -- Epic Dodge : Don't want to use it unless we take damage.
   if attacker_cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(FEAT_EPIC_DODGE)
   then
      -- TODO: Send Epic Dodge Message
      SetResult(info, 4)
      attacker_cr.cr_epic_dodge_used = 1
      return true
   end

   return false
end

--- Resolve melee animations
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param i
-- @param attack_count
-- @param anim
local function ResolveMeleeAnimations(attacker, target, i, attack_count, anim)
   C.nwn_ResolveMeleeAnimations(attacker.obj, i, attack_count, target.obj.obj, anim)
end

--- Resolve out of ammo.
-- @param attacker Attacking creature.
local function ResolveOutOfAmmo(attacker)
   C.nwn_SetRoundPaused(attacker.obj.cre_combat_round, 0, 0x7F000000)
   C.nwn_SetPauseTimer(attacker.obj.cre_combat_round, 0, 0)
   C.nwn_SetAnimation(attacker.obj, 1)
end

local function ResolveCripplingStrike(info, attacker, target)
   if band(info.situational_flags, SITUATION_FLAG_SNEAK_ATTACK) == 0 or
      not attacker:GetHasFeat(FEAT_CRIPPLING_STRIKE)
   then
      return
   end

   local e = Eff.Ability(ABILITY_STRENGTH, -2)
   e:SetDurationType(DURATION_TYPE_PERMANENT)
   AddEffect(info, attacker, e)
end

local function ResolveDeathAttack(info, attacker, target)
   if band(info.situational_flags, SITUATION_FLAG_DEATH_ATTACK) == 0 then
      return
   end
   local dc = attacker:GetLevelByClass(CLASS_TYPE_ASSASSIN)
      + 10 + attacker:GetAbilityModifier(ABILITY_INTELLIGENCE)

   if target:FortitudeSave(dc, SAVING_THROW_VS_DEATH, attacker) == 0 then
      C.ApplyOnHitDeathAttack(attacker.obj, target.obj.obj, random(6) + attacker:GetHitDice())
   end
end

local function ResolveQuiveringPalm(info, attacker, target)
   if GetSpecialAttack(info) ~= SPECIAL_ATTACK_QUIVERING_PALM or
      target:GetHitDice() >= attacker:GetHitDice()            or
      GetDamageTotal(info) <= 0                               or
      target:IsImmune(IMMUNITY_TYPE_CRITICAL_HITS)            or
      target:FortitudeSave(10 + (attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(ABILITY_WISDOM),
                           0, attacker) == 0
   then
      return
   end
   local e = Eff.Death(true, true)
   e:SetDurationType(DURATION_TYPE_INSTANT)
   AddEffect(info, attacker, e)
end

local function ResolveCircleKick(info, attacker, target)
   if OPT.DISABLE_CIRCLE_KICK           or
      GetIsSpecialAttack(info)          or
      GetTotalAttacks(info) >= 49       or
      info.weapon ~= EQUIP_TYPE_UNARMED or
      not Attacker:GetHasFeat(FEAT_CIRCLE_KICK)
   then
      return
   end

   local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
   local nearest = C.nwn_GetNearestEnemy(attacker.obj, max_range, target.obj.obj.obj_id)
   if nearest == OBJECT_INVALID.id then return end

   info.attacker_cr.cr_new_target = nearest
   C.nwn_AddCircleKickAttack(attacker.obj, nearest)
   attacker.obj.cre_passive_attack_beh = 1
   info.attacker_cr.cr_num_circle_kicks = info.attacker_cr.cr_num_circle_kicks - 1
end

local function ResolveCleave(info, attacker, target)
   if GetSpecialAttack(info) == FEAT_WHIRLWIND_ATTACK   or
      GetSpecialAttack(info) == FEAT_IMPROVED_WHIRLWIND or
      GetTotalAttacks(info) >= 49
   then
      return
   end

   if attacker:GetHasFeat(FEAT_GREAT_CLEAVE) then
      local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
      local nearest = C.nwn_GetNearestEnemy(attacker.obj, max_range, target.obj.obj.obj_id)
      if nearest == OBJECT_INVALID.id then return end

      info.attacker_cr.cr_new_target = nearest
      C.nwn_AddCleaveAttack(attacker.obj, nearest)
      attacker.obj.cre_passive_attack_beh = 1

   elseif attacker:GetHasFeat(FEAT_CLEAVE) then
      local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
      local nearest = C.nwn_GetNearestEnemy(attacker.obj, max_range, target.obj.obj.obj_id)
      if nearest == OBJECT_INVALID.id then return end

      info.attacker_cr.cr_new_target = nearest
      C.nwn_AddCleaveAttack(attacker.obj, nearest)
      attacker.obj.cre_passive_attack_beh = 1
      info.attacker_cr.cr_num_cleaves = info.attacker_cr.cr_num_cleaves - 1
   end
end

--- Resolve post damage stuff.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param is_ranged
local function ResolvePostDamage(info, attacker, target, is_ranged)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return end

   ResolveCoupDeGrace(info, attacker, target)
   ResolveDevCrit(info, attacker, target)

   -- No more posts apply to ranged.
   if is_ranged then return end

   if not info.is_killing then
      ResolveCripplingStrike(info, attacker, target)
      ResolveDeathAttack(info, attacker, target)
      ResolveQuiveringPalm(info, attacker, target)
      ResolveCircleKick(info, attacker, target)
   else
      ResolveCleave(info, attacker, target)
   end
end

--- Resolve ranged attack animations.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param anim Animation.
local function ResolveRangedAnimations(attacker, target, anim)
   C.nwn_ResolveRangedAnimations(attacker.obj, target.obj.obj, anim)
end

--- Resolve ranged attack miss.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveRangedMiss(attacker, target)
   C.nwn_ResolveRangedMiss(attacker.obj, target.obj.obj)
end

--- Resolve situations.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveSituations(info, attacker, target)
   local flags = 0
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return flags end

   local x = attacker.obj.obj.obj_position.x - target.obj.obj.obj_position.x;
   local y = attacker.obj.obj.obj_position.y - target.obj.obj.obj_position.y;
   local z = attacker.obj.obj.obj_position.z - target.obj.obj.obj_position.z;

   -- Save some time by not sqrt'ing to get magnitude
   info.target_distance = x * x + y * y + z * z;

   if info.target_distance <= 100 then
      -- Coup De Grace
      if band(info.target_state, COMBAT_TARGET_STATE_ASLEEP) ~= 0 and
         target:GetHitDice() <= 10
      then
         flags = bor(flags, SITUATION_FLAG_COUPDEGRACE)
         info.attack.cad_coupdegrace = 1
      end
   end

   -- In order for a sneak attack situation to be possiblle the attacker must
   -- be able to do some amount of sneak damage.
   local death = RollValid(attacker.ci.mod_situ[SITUATION_DEATH_ATTACK].dmg.roll)
   local sneak = RollValid(attacker.ci.mod_situ[SITUATION_SNEAK_ATTACK].dmg.roll)

   -- Sneak Attack & Death Attack
   if sneak or death and
      (band(info.target_state, COMBAT_TARGET_STATE_ATTACKER_UNSEEN) ~= 0 or
       band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) ~= 0 or
       band(info.target_state, COMBAT_TARGET_STATE_FLANKED) ~= 0)
   then
      if not target:GetIsImmune(IMMUNITY_TYPE_SNEAK_ATTACK) then
         -- Death Attack.  If it's a Death Attack it's also a sneak attack.
         if death then
            flags = bor(flags, SITUATION_FLAG_DEATH_ATTACK)
            flags = bor(flags, SITUATION_FLAG_SNEAK_ATTACK)
            SetSneakAttack(info, true, true)
         elseif sneak then
            flags = bor(flags, SITUATION_FLAG_SNEAK_ATTACK)
            SetSneakAttack(info, true, false)
         end
      else
         --TODO: Immune to sneaks message.
         --CNWCCMessageData *msg = CNWCCMessageData_create();
         --CExoArrayList_int32_add(&msg->integers, 134);
         --CExoArrayList_uint32_add(&msg->objects, target_nwn->obj_id);
         --attack_data_.addCCMessage(msg);
      end
   end
   return flags
end

--- Signal Damage
local function SignalDamage(attacker, target, attack_count, is_ranged)
   if is_ranged then
      C.nwn_SignalRangedDamage(attacker.obj, target.obj.obj, attack_count)
   else
      C.nwn_SignalMeleeDamage(attacker.obj, target.obj.obj, attack_count)
   end
end

--- Update attack info.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function UpdateInfo(info, attacker, target)
   local cr = info.attacker_cr

   cr.cr_current_attack = cr.cr_current_attack + 1
   info.current_attack = cr.cr_current_attack
   info.attack = C.nwn_GetAttack(attacker.obj)
   info.attack.cad_attack_group = info.attack.cad_attack_group
   info.attack.cad_target = target.id
   info.attack.cad_attack_mode = attacker.obj.cre_mode_combat
   info.attack.cad_attack_type = C.nwn_GetWeaponAttackType(attacker.obj)
   info.is_offhand = cr.cr_current_attack + 1 > cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks

   -- Get equip number
   local weapon = C.nwn_GetCurrentAttackWeapon(attacker.obj, info.attack.cad_attack_type)
   info.weapon = EQUIP_TYPE_UNARMED
   if weapon ~= nil then
      for i = 0, EQUIP_TYPE_NUM - 1 do
         if attacker.ci.equips[i].id == weapon.obj.obj_id then
            info.weapon = i
            break
         end
      end
   end
end

--- Do melee attack.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param i The current attack in the flurry.
-- @param attack_count Number of attacks in flurry.
-- @param anim
local function do_melee_attack(info, attacker, target, i, attack_count, anim)
   ResolvePreRoll(info, attacker, target)
   ResolveAttackRoll(info, attacker, target)

   if GetIsHit(info) then
      ResolveDamage(info, attacker, target)
      ResolvePostDamage(info, attacker, target, false)
   end
   ResolveMeleeAnimations(attacker, target, i, attack_count, anim)

   -- Attempt to resolve a special attack one was
   -- a) Used
   -- b) The attack is a hit.
   if GetIsSpecialAttack(info) and GetIsHit(info) then
      -- Special attacks only apply when the target is a creature
      -- and damage is greater than zero.
      if target.type == OBJECT_TRUETYPE_CREATURE and GetDamageTotal(info) > 0 then
         attacker:DecrementRemainingFeatUses(GetSpecialAttack(info))

         -- The resolution of Special Attacks will return an effect to be applied
         -- or nil.
         local success, eff = false --TODO: NSSpecialAttack(SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, info)
         if success then
            -- Check to makes sure an effect was returned.
            if eff then
               -- Set effect to direct so that Lua will not delete the
               -- effect.  It will be deleted by the combat engine.
               eff.direct = true
               -- Add the effect to the onhit effect list so that it can
               -- be applied when damage is signaled.
               AddEffect(info, attacker, eff)
            end
         else
            -- If the special attack failed because it wasn't
            -- applicable or the targets skill check (for example)
            -- was success full set the attack result to 5.
            SetResult(info, 5)
         end
      else
         -- If the target is not a creature or no damage was dealt set attack result to 6.
         SetResult(info, 6)
      end
   end

   UpdateInfo(info, attacker, target)
end

--- Do ranged attack.
-- @param info AttackInfo ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param i The current attack in the flurry.
-- @param anim
local function do_ranged_attack(info, attacker, target, i, anim)
   ResolvePreRoll(info, attacker, target)

   ResolveAttackRoll(info, attacker, target)

   if GetIsHit(info) then
      ResolveDamage(info, attacker, target)
      ResolvePostDamage(info, attacker, target, true)
   else
      ResolveRangedMiss(attacker, target)
   end
   ResolveRangedAnimations(attacker, target, anim)

   -- Attempt to resolve a special attack one was
   -- a) Used
   -- b) The attack is a hit.
   if GetIsSpecialAttack(info) and GetIsHit(info) then
      -- Special attacks only apply when the target is a creature
      -- and damage is greater than zero.
      if target.type == OBJECT_TRUETYPE_CREATURE
         and GetDamageTotal(info) > 0
      then
         attacker:DecrementRemainingFeatUses(GetSpecialAttack(info))

         -- The resolution of Special Attacks will return an effect to be applied
         -- or nil.
         local success, eff = false --TODO: NSSpecialAttack(SPECIAL_ATTACK_EVENT_RESOLVE, attacker, target, info)
         if success then
            -- Check to makes sure an effect was returned.
            if eff then
               -- Set effect to direct so that Lua will not delete the
               -- effect.  It will be deleted by the combat engine.
               eff.direct = true
               -- Add the effect to the onhit effect list so that it can
               -- be applied when damage is signaled.
               AddEffect(info, attacker, eff)
            end
         else
            -- If the special attack failed because it wasn't
            -- applicable or the targets skill check (for example)
            -- was success full set the attack result to 5.
            SetAttackResult(info, 5)
         end
      else
         -- If the target is not a creature or no damage was dealt set attack result to 6.
         SetAttackResult(info, 6)
      end
   end
   UpdateInfo(info, attacker, target)
end

--- Resolve attack.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param attack_count Number of attacks in flurry.
-- @param anim
-- @param is_ranged Is ranged attack.
local function ResolveAttack(attacker, target, attack_count, anim, is_ranged)
   if not target:GetIsValid() then return end

   local info = CreateAttackInfo(attacker, target)
   local use_cached = false

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == OBJECT_TRUETYPE_CREATURE then
      info.target_state = attacker:GetTargetState(target)
      info.situational_flags = ResolveSituations(info, attacker, target)
   end

   for i=0, attack_count - 1 do
      if is_ranged then
         -- Attack count can be modified if, say, a creature only has less arrows left than attacks
         -- or none at all.
         attack_count = GetAmmunitionAvailable(info, attack_count)
         if attack_count == 0 then
            ResolveOutOfAmmo(info)
            return
         end

         do_ranged_attack(info, attacker, target, i, anim)
         ForceEquipAmmunition(attack, attack_count)
      else
         do_melee_attack(info, attacker, target, i, attack_count, anim)
      end
   end

   SignalDamage(attacker, target, attack_count, is_ranged)
end

local M = {
   ResolveAttack = ResolveAttack
}

return M
