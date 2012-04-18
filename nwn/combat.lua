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

function NSGetAttackResult(attack_data)
   local t = attack_data.cad_attack_result

   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

-- @param weap Attack weapon, if nil then the call is coming from the plugin.
function NSGetCriticalHitMultiplier(attacker, offhand, weap, weap_num)
   local result
   if weap then
      result = attacker.ci.equips[weap_num].crit_mult
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      local cr = attacker.obj.cre_combat_round
      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritMultiplier(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritMultBonus()

   return result
end

-- @param weap Attack weapon, if nil then the call is coming from the plugin.
function NSGetCriticalHitRoll(attacker, offhand, weap, weap_num)
   local result
   if weap then
      result = attacker.ci.equips[weap_num].crit_range
   else
      local weapon --= C.nwn_GetCurrentAttackWeapon(cr, 0)
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      local cr = attacker.obj.cre_combat_round
      if offhand then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
         if not weapon:GetIsValid() then
            weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         end
      else
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      end

      if not weapon:GetIsValid() then
         weapon = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS)
      end

      if not weapon:GetIsValid() then
         weapon = C.nwn_GetCurrentAttackWeapon(cr, 0)
         if weapon == nil then
            weapon = nwn.OBJECT_INVALID
         else
            weapon = _NL_GET_CACHED_OBJECT(weapon.obj.obj_id)
         end
      end

      if not weapon:GetIsValid() then
         result = 1
      else 
         result = attacker:GetWeaponCritRange(weapon)
      end
   end
   
   -- Effects...
   result = result + attacker:GetEffectCritRangeBonus()

   return 21 - result
end

function NSGetCurrentAttackWeapon(combat_round, attack_type, attacker)
   local weapon = C.nwn_GetCurrentAttackWeapon(combat_round, attack_type)
   local ci_weap_number = -1

   if attacker then
      for i = 0, 5 do
         if attacker.ci.equips[i].id == weapon.obj.obj_id then
            ci_weap_number = i
            break
         end
      end
   end
   return _NL_GET_CACHED_OBJECT(weapon.obj.obj_id), ci_weap_number
end

---
-- Note: it's already been established that target is a creature
function NSGetArmorClassVersus(target, attacker, touch, from_hook, attack)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      target:UpdateCombatInfo()
   else
      target:UpdateCombatInfo()
   end

   -- 10 base AC
   local ac = 10
   local nat, armor, shield, deflect, dodge = 0, 0, 0, 0, 0

   -- Size Modifier
   ac = ac + target.ci.size.ac

   -- Armor AC
   ac = ac + target.stats.cs_ac_armour_base
   armor = target.stats.cs_ac_armour_bonus
   armorpen = target.stats.cs_ac_armour_penalty

   -- Deflect AC
   deflect = target.stats.cs_ac_deflection_bonus - target.stats.cs_ac_deflection_penalty

   -- Natural AC
   ac = ac + target.stats.cs_ac_natural_base
   nat = target.stats.cs_ac_natural_bonus - target.stats.cs_ac_natural_penalty


   -- Shield AC
   ac = ac + target.stats.cs_ac_shield_base
   shield = target.stats.cs_ac_shield_bonus - target.stats.cs_ac_shield_penalty

   -- Class: Monk, RDD, PM, ...
   ac = ac + target.ci.class.ac

   -- Attack Mode Modifier
   ac = ac + attacker.ci.mode.ac

   -- Feat: Armor Skin, etc
   ac = ac + target.ci.feat.ac

   -- Dex Modifier
   local dex_mod = target:GetDexMod(true)
   local dexed = false

   -- Attacker is invis and target doesn't have blindfight or target is Flatfooted
   -- then target gets no Dex mod.
   if bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS) == 0
      and bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED) == 0
   then
      -- Attacker is seen or target has Blindfight and it's not a ranged attack then target
      -- gets dex_mod and dodge AC
      if bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN) == 0
         or (target:GetHasFeat(nwn.FEAT_BLIND_FIGHT) and attack.cad_ranged_attack == 0)
      then
         if dex_mod > 0 then
            dexed = true
         end
         -- Dodge AC
         dodge = target.stats.cs_ac_dodge_bonus - target.stats.cs_ac_dodge_penalty

         -- Skill: Tumble...
        -- print("Tumble", target.ci.skill.ac)
         ac = ac + target.ci.skill.ac
         
         -- If this is an attack of opportunity and target has mobility
         -- there is a +4 ac bonus.
         if attack.cad_special_attack == -534 
            and target:GetHasFeat(nwn.FEAT_MOBILITY)
         then
            ac = ac + 4
         end
         
         if target:GetHasFeat(nwn.FEAT_DODGE) then
            if target.obj.cre_combat_round.cr_dodge_target == nwn.OBJECT_INVALID.id then
               target.obj.cre_combat_round.cr_dodge_target = attacker.id
            end
            if target.obj.cre_combat_round.cr_dodge_target == attacker.id
               and not target:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
            then
               ac = ac + 1
            end
         end
      end
   -- If dex_mod is negative we add it in.
   elseif dex_mod < 0 then
      dexed = true
   end

   -- If target has Uncanny Dodge 1 or Defensive Awareness 1, target gets
   -- dex modifier.
   if not dexed
      and dex_mod > 0
      and (target:GetHasFeat(nwn.FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1)
           or target:GetHasFeat(nwn.FEAT_UNCANNY_DODGE_1))
   then
      dexed = true
   end

   if dexed then
--    print("Dex Mod", dex_mod)
      ac = ac + dex_mod
   end

   -- +4 Defensive Training Vs.
   if target.ci.training_vs_mask ~= 0 
      and attacker.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(target.ci.training_vs_mask, bit.lshift(1, attacker:GetRacialType())) ~= 0
   then
      ac = ac + 4
   end

   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge =
      target:GetEffectArmorClassBonus(attacker, touch)

   dodge = dodge + eff_dodge
   local max_dodge_ac = target:GetMaxDodgeAC()
   if dodge > max_dodge_ac then
      dodge = max_dodge_ac
   end

   if touch then
      return ac + dodge
   end

   if eff_nat > nat then nat = eff_nat end
   if eff_armor > armor then armor = eff_armor end
   if eff_shield > shield then shield = eff_shield end
   if eff_deflect > deflect then deflect = eff_deflect end


-- print("AC:", nat, armor, shield, deflect, dodge)
-- print("AC:", ac + nat + armor + shield + deflect + dodge)

   return ac + nat + armor + shield + deflect + dodge
end

--- GetAttackModifierVersus
function NSGetAttackModifierVersus(attacker, target, from_hook, cr, attack, attack_type, weap, weap_num, is_offhand)
   local attack_num
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)

      cr = attacker.obj.cre_combat_round
      attack_num = cr.cr_current_attack
      attack = C.nwn_GetAttack(cr, attack_num)
      attack_type = attack.cad_attack_type
      weap, weap_num = NSGetCurrentAttackWeapon(cr, attack_type, attacker)
      is_offhand = NSGetOffhandAttack(cr)

      -- Temporary
      NSResolveTargetState(attacker, target)
   else
      attack_num = cr.cr_current_attack

      -- Temporary
      NSResolveTargetState(attacker, target)
   end

   local bab

   if attack_type == 2 then
      bab = attacker.ci.bab - (5 * cr.cr_offhand_taken)
      cr.cr_offhand_taken = cr.cr_offhand_taken + 1
   elseif attack_type == 6 or attack_type == 8 then
      bab = attacker.ci.bab
      if attack.cad_special_attack ~= 867 
         or attack.cad_special_attack ~= 868
         or attack.cad_special_attack ~= 391
      then
         bab = bab - (5 * cr.cr_extra_taken)
      end
      cr.cr_extra_taken = cr.cr_extra_taken + 1
   else
      if attack.cad_special_attack == 65002 
         or attack.cad_special_attack == 6
         or attack.cad_special_attack == 391
      then
         bab = attacker.ci.bab
      else
         bab = attacker.ci.bab - (attack_num * attacker.ci.equips[weap_num].iter)
      end
   end

   local ab_abil = attacker:GetAbilityModifier(attacker.ci.equips[weap_num].ab_ability)

   -- Base Attack Bonus
   local ab = bab

   -- Offhand Attack Penalty
   if is_offhand then
      ab = ab + attacker.ci.offhand_penalty_off
   else
      ab = ab + attacker.ci.offhand_penalty_on      
   end

   -- Size Modifier
   ab = ab + attacker.ci.size.ab

   -- Area Modifier
   ab = ab + attacker.ci.area.ab

   -- Feat Modifier
   ab = ab + attacker.ci.feat.ab

   -- Attack Mode Modifier
   ab = ab + attacker.ci.mode.ab

   -- Special Attack Modifier
   ab = ab + NSResolveSpecialAttackAttackBonus(attacker, target, attack)

   -- Favored Enemies
   if attacker.ci.fe_mask ~= 0 
      and target.type == nwn.nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(attacker.ci.fe_mask, bit.lshift(1, target:GetRacialType())) ~= 0
   then
      ab = ab + attacker.ci.fe.ab
   end

   -- +1 Offensive Training Vs.
   if attacker.ci.training_vs_mask ~= 0 
      and target.type == nwn.GAME_OBJECT_TYPE_CREATURE
      and bit.band(attacker.ci.training_vs_mask, bit.lshift(1, target:GetRacialType())) ~= 0
   then
      ab = ab + 1
   end

   -- Race Modifier
   ab = ab + attacker.ci.race.ab

   -- Weapon AB Mod.  i.e, WF, SWF, EWF, etc
   ab = ab + attacker.ci.equips[weap_num].ab_mod

   -- Target State
   local state = attacker:GetEnemyStateAttackBonus(attack.cad_ranged_attack)
   ab = ab + state

   -- Ranged Attacker Modifications
   if attack.cad_ranged_attack == 1 then
      local r = attacker:GetRangedAttackMod(target)
      ab = ab + r
   end
   
   local eff_ab = attacker:GetEffectAttackBonus(target, attack_type)
   if eff_ab > 20 then
      eff_ab = 20
   end

   local sit_ab = attacker:GetSituationalAttackBonus()

   return ab + ab_abil + eff_ab + sit_ab
end

function NSGetOffhandAttack(cr)
   return cr.cr_current_attack + 1 > 
      cr.cr_effect_atks + cr.cr_additional_atks + cr.cr_onhand_atks
end

function NSInitializeNumberOfAttacks (cre, combat_round)
   cre = _NL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return end
   combat_round = cre.obj.cre_combat_round

   cre:UpdateCombatInfo()

   local rh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local rh_valid = rh:GetIsValid()
   local lh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local age = cre.stats.cs_age
   local style = (age / 100) % 10
   local extra_onhand = (age / 10000) % 10
   local extra_offhand = (age / 1000) % 10
   local attacks = 0
   local offhand_attacks = 0

   combat_round.cr_extra_taken = 0
   combat_round.cr_offhand_taken = 0

   if rh_valid and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_HEAVYCROSSBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_LIGHTCROSSBOW)
      and not cre:GetHasFeat(nwn.FEAT_RAPID_RELOAD)
   then
      attacks = 1
   elseif cre.stats.cs_override_atks > 0 then
      -- appearently some kind of attack override
      attacks = cre.stats.cs_override_atks
   else
      attacks = C.nwn_GetAttacksPerRound(cre.stats)
   end

   -- STYLE
   if style == 7 and not rh:GetIsValid() then
      -- sunfist
      extra_onhand = extra_onhand + 1
   elseif style == 3 and lh:GetIsValid() and -- spartan
      (lh.obj.it_baseitem == nwn.BASE_ITEM_SMALLSHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_LARGESHIELD or
       lh.obj.it_baseitem == nwn.BASE_ITEM_TOWERSHIELD)
   then
      extra_onhand = extra_onhand + 1;
   elseif cre:GetLevelByClass(nwn.CLASS_TYPE_RANGER) >= 40 and
      cre:GetLevelByClass(nwn.CLASS_TYPE_MONK) == 0
   then
      extra_offhand = extra_offhand + 1; 
   end

   -- FEAT
   if not rh:GetIsValid() and cre:GetKnowsFeat(nwn.FEAT_CIRCLE_KICK) then
      extra_onhand = extra_onhand + 1
   end

   offhand_attacks = C.nwn_CalculateOffHandAttacks(combat_round)

   if cre.obj.cre_slowed ~= 0 and attacks > 1 then
      attacks = attacks - 1
   end

   if cre.obj.cre_mode_combat == 10 then -- Dirty Fighting
      cre:SetCombatMode(0)
      combat_round.cr_onhand_atks = 1
      combat_round.cr_offhand_atks = 0
      return
   elseif cre.obj.cre_mode_combat == 6 and -- Rapid Shot
      rh:GetIsValid() and
      (rh.obj.it_baseitem == nwn.BASE_ITEM_LONGBOW or
       rh.obj.it_baseitem == nwn.BASE_ITEM_SHORTBOW) 
   then
      combat_round.cr_additional_atks = 1
   elseif cre.obj.cre_mode_combat == 5 and -- flurry
      (not rh:GetIsValid() or
       rh.obj.it_baseitem == 40 or
       rh:GetIsFlurryable())
   then
      combat_round.cr_additional_atks = 1
   end

   if cre.obj.cre_hasted then
      combat_round.cr_additional_atks = combat_round.cr_additional_atks + 1
   end

   -- Only give extra offhand attacks if we have one to begin with.
   if offhand_attacks > 0 then
      offhand_attacks = offhand_attacks + extra_offhand
   end

   combat_round.cr_onhand_atks = attacks + extra_onhand
   combat_round.cr_offhand_atks = offhand_attacks

end

function NSResolveAttackRoll(attacker, target, from_hook)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   local cr = attacker.obj.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_type = attack.cad_attack_type
   local is_offhand = NSGetOffhandAttack(cr)
   local weap, weap_num = NSGetCurrentAttackWeapon(cr, attack_type, attacker)

   local ab = 0
   local ac = 0

   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      target = nwn.OBJECT_INVALID
   end

   -- Modifier Vs
   ab = ab + NSGetAttackModifierVersus(attacker, target, false, cr, attack, attack_type, weap, weap_num, is_offhand)
   attack.cad_attack_mod = ab

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      ac = ac + NSGetArmorClassVersus(target, attacker, false, false, attack)
   end

   print(ab, ac)

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in 
   -- NSResolvePostMelee/RangedDamage
   if attack.cad_coupdegrace == 1 then
      attack.cad_attack_result = 7
      attack.cad_attack_roll = 20
      return
   end

   local roll = math.random(20)
   attack.cad_attack_roll = roll 

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1
   if NSResolveMissChance(attacker, target, hit, cr, attack)
      or NSResolveDeflectArrow(attacker, target, hit, cr, attack)
      or NSResolveParry(attacker, target, hit, cr, attack)
   then
      return
   end

   if not hit then
      attack.cad_attack_result = 4
      if roll == 1 then
         attack.cad_missed = 1
      else
         attack.cad_missed = ac - ab + roll
      end
      return
   else
      attack.cad_attack_result = 1
   end


   if roll < NSGetCriticalHitRoll(attacker, is_offhand, weap, weap_num) then
      attack.cad_threat_roll = math.random(20)
      attack.cad_critical_hit = 1

      -- TODO Difficulty Settings
      -- TODO immunity
      if attack.cad_threat_roll + ab >= ac then
         -- Is critical hit
         attack.cad_attack_result = 3
      end
   end
end

function NSResolveDamage(attacker, target)

end

function NSGetDamageRoll(attacker, target, offhand, unknown, sneak, death, ki_damage)

end

function NSGetDamageBonus(attacker, target, int)
end

function NSResolveSpecialAttackAttackBonus(attacker, target, attack)
   return NSMeleeSpecialAttack(attack.cad_special_attack, 1, attacker, target, attack) or 0
end

function NSResolveSpecialAttackDamageBonus(attacker, target)
   local dice, sides, bonus = 
      NSMeleeSpecialAttack(attack.cad_special_attack, 2, attacker, target, attack)
end

function NSResolveMeleeSpecialAttack(attacker, attack_in_grp, attack_count, target, a)
   if not target:GetIsValid() then return end
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   local sa = attack.cad_special_attack

   if attack.cad_special_attack < 1115 and
      attacker:GetFeatRemaintingUses(attack.cad_special_attack) == 0
   then
      attack.cad_special_attack = 0
   end

   ResolveAttackRoll(attacker, target, attack)
   if NSGetAttackResult(attack) then
      NSResolveDamage(attacker, target)
      NSResolvePostMeleeDamage(attacker, target)
   end
   C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, a)

   if not nwn.GetAttackResult(attack) then return end
   
   attacker:DecrementFeatRemaintingUses(attack.cad_special_attack)
   NSMeleeSpecialAttack(attack.cad_special_attack, 0, attacker, target, attack)
end

function NSResolveRangedSpecialAttack(attacker, attack_in_grp, attack_count, target, a)
   if not target:GetIsValid() then return end
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   local sa = attack.cad_special_attack

   if attack.cad_special_attack < 1115 and
      attacker:GetFeatRemaintingUses(attack.cad_special_attack) == 0
   then
      attack.cad_special_attack = 0
   end

   ResolveAttackRoll(attacker, target, attack)
   if NSGetAttackResult(attack) then
      NSResolveDamage(attacker, target)
      NSResolvePostRangedDamage(attacker, target)
   end
   C.nwn_ResolveRangedAnimations(attacker.obj, target.obj.obj, a)

   if not nwn.GetAttackResult(attack) then return end
   
   attacker:DecrementFeatRemaintingUses(attack.cad_special_attack)
   NSRangedSpecialAttack(attack.cad_special_attack, 0, attacker, target, attack)
end

function NSResolveMeleeAttack(attacker, target, attack_count, a)
   if target == nwn.OBJECT_INVALID.id then return end

   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)
   
   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group
   
   NSResolveTargetState(attacker, target)
   NSResolveSituationalModifiers(attack, target)

   for i = 0, attack_count - 1 do
      attack.cad_attack_group = attack_group
      attack.cad_target = target.obj_id
      attack.cad_attack_mode = attacker.cre_mode_combat
      attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)

      if attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker)
      end

      if attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         NSResolveMeleeSpecialAttack(attacker, i, attack_count, target, a)
      else
         ResolveAttackRoll(attacker, target, attack)
         if NSGetAttackResult(attack) then
            NSResolveDamage(attacker, target)
            NSResolvePostMeleeDamage(attacker, target)
         end
         C.nwn_ResolveMeleeAnimations(attacker, i, attack_count, target, a)
      end
      current_attack = current_attack + 1
      cr.cr_current_attack = current_attack
      attack = C.nwn_GetAttack(cr, current_attack)
   end
   C.nwn_SignalMeleeDamage(attacker, target, attack_count)
end

function NSResolveRangedAttack(attacker, target, attack_count, a)
   if target == nwn.OBJECT_INVALID.id then return end

   attacker = _NL_GET_CACHED_OBJECT(attacker)
   target = _NL_GET_CACHED_OBJECT(target)

   if not target:GetIsValid() or
      not attacker:GetAmmunitionAvailable(attack_count)
   then 
      --CNWSCombatRound__SetRoundPaused(*(_DWORD *)(a1 + 0xACC), 0, 0x7F000000u);
      --CNWSCombatRound__SetPauseTimer(*(_DWORD *)(a1 + 0xACC), 0, 0);
      --return (*(int (__cdecl **)(int, signed int))(*(_DWORD *)(a1 + 0xC) + 0x88))(a1, 1);
   end

   local cr = attacker.cre_combat_round
   local current_attack = cr.cr_current_attack
   local attack = C.nwn_GetAttack(cr, current_attack)
   local attack_group = attack.cad_attack_group

   NSResolveTargetState(attacker, target)
   NSResolveSituationalModifiers(attacker, target)

   for i = 0, attack_count - 1 do
      attack.cad_attack_group = attack_group
      attack.cad_target = target.obj_id
      attack.cad_attack_mode = attacker.cre_mode_combat
      attack.cad_attack_type = C.nwn_GetWeaponAttackType(cr)

      if attack.cad_coupdegrace == 0 then
         C.nwn_ResolveCachedSpecialAttacks(attacker)
      end

      if attack.cad_special_attack ~= 0 then
         -- Special Attacks... 
         NSResolveRangedSpecialAttack(attacker, i, attack_count, target, a)
      else
         NSResolveAttackRoll(attacker, target, attack)
         if NSGetAttackResult(attack) then
            NSResolveDamage(attacker, target)
            NSResolvePostRangedDamage(attacker, target)
         else
            C.nwn_ResolveRangedMiss(attacker.obj, target.obj.obj)
         end
         C.nwn_ResolveMeleeAnimations(attacker.obj, target.obj.obj, a)
      end
      current_attack = current_attack + 1
      cr.cr_current_attack = current_attack
      attack = C.nwn_GetAttack(cr, current_attack)
   end
   C.nwn_SignalRangendDamage(attacker.obj, target.obj.obj, attack_count)
end

function NSResolveDeflectArrow(attacker, target, hit, cr, attack)
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end
   -- Deflect Arrow
   if hit 
      and cr.cr_deflect_arrow == 1
      and attack.cad_ranged_attack ~= 0
      and bit.band(attacker.ci.target_state, nwn.COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(nwn.FEAT_DEFLECT_ARROWS)
   then
      local on = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      local off = target:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)

      if not on:GetIsValid()
         or (target:GetRelativeWeaponSize(on) <= 0
             and not on:GetIsRangedWeapon()
             and not off:GetIsValid())
      then
         on = attacker:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
         on = on:GetBaseType()
         local bow
         if on ~= nwn.BASE_ITEM_DART 
            and on ~= nwn.BASE_ITEM_THROWINGAXE 
            and on ~= nwn.BASE_ITEM_SHURIKEN
         then
            bow = 0
         else
            bow = 1
         end
         local v = vector_t(target.obj.obj.obj_position.x,
                            target.obj.obj.obj_position.y,
                            target.obj.obj.obj_position.z)

         C.nwn_CalculateProjectileTimeToTarget(attacker.obj, v, bow)
         cr.cr_deflect_arrow = 0
         attack.cad_attack_result = 2
         attack.cad_attack_deflected = 1
         return true
      end
   end
   return false
end

function NSResolveMissChance(attacker, target, hit, cr, attack)
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return false
   end

   -- Miss Chance
   local miss_chance = attacker:GetMissChance(attack)
   -- Conceal
   local conceal = target:GetConcealment(attacker, attack)

   if conceal > 0 or miss_chance > 0 then
      if miss_chance < conceal then
         if math.random(1, 100) >= conceal
            or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
                and math.random(1, 100) >= conceal)
         then
            attack.cad_attack_result = 8
            attack.cad_concealment = math.floor((conceal ^ 2) / 100)
            attack.cad_missed = 1
            return true
         end
      else
         if math.random(1, 100) >= miss_chance
            or (attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
                and math.random(1, 100) >= miss_chance)
         then
            attack.cad_attack_result = 9
            attack.cad_concealment = math.floor((miss_chance ^ 2) / 100)
            attack.cad_missed = 1
            return true
         end
      end
   end
   return false
end

function NSSignalMeleeDamage(attacker, target, attack_count)

end

function NSResolveParry(attacker, target, hit, cr, attack)
   if attack.cad_attack_roll == 20
      or attacker.obj.cre_mode_combat ~= nwn.COMBAT_MODE_PARRY
      or cr.cr_parry_actions == 0
      or cr.cr_round_paused ~= 0
      or attack.cad_ranged_attack ~= 0
   then
      return false
   end
   
   -- Can not Parry when using a Ranged Weapon.
   local on = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   if on:GetIsValid() and on:GetIsRangedWeapon() then
      return false
   end

   local roll = math.random(20) + target:GetSkillRank(nwn.SKILL_PARRY)

   target.obj.cre_combat_round.cr_parry_actions = 
      target.obj.cre_combat_round.cr_parry_actions - 1

   if roll >= attack.cad_attack_roll + attack.cad_attack_mod then
      if roll - 10 >= attack.cad_attack_roll + attack.cad_attack_mod then
         target:AddParryAttack(attacker)
      end
      attack.cad_attack_result = 2
      return true
   end

   C.nwn_AddParryIndex(target.obj.cre_combat_round)
   return false
end

function NSSignalRangedDamage(attacker, target, attack_count)

end

function NSResolveDamage ()
   -- Epic Dodge : Don't want to use it unless we take damage.
   if hit
      and cr.cr_epic_dodge_used == 0
      and target:GetHasFeat(nwn.FEAT_EPIC_DODGE)
   then
      -- Send Epic Dodge Message
      cr.cr_epic_dodge_used = 1
   end

end

function NSResolvePostMeleeDamage(attacker, target, attack_data)
   if not target:GetIsValid() then return end

   local cr = attacker.cre_combat_round
end

function NSResolvePostRangedDamage(attacker, target, attack_data)
   if not target:GetIsValid() then return end

   local cr = attacker.cre_combat_round
end

function NSResolveSituationalModifiers(attacker, target)
   local flags = 0
   local x = attacker.obj.obj.obj_position.x - target.obj.obj.obj_position.x
   local y = attacker.obj.obj.obj_position.y - target.obj.obj.obj_position.y
   local z = attacker.obj.obj.obj_position.z - target.obj.obj.obj_position.z

   attacker.ci.target_distance = x ^ 2 + y ^ 2 + z ^ 2

   -- Save some time by not sqrt'ing to get magnitude
   if attacker.ci.target_distance <= 100 then
      -- Coup De Grace
      if bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ASLEEP)
         and target:GetHitDice() < 5
      then
         flags = bit.bor(flags, nwn.SITUATION_COUPDEGRACE)
      end

      local death = attacker.ci.situational[nwn.SITUATION_FLAG_DEATH_ATTACK].dmg_dice > 0
         or attacker.ci.situational[nwn.SITUATION_FLAG_DEATH_ATTACK].dmg_bonus > 0
      
      local sneak = attacker.ci.situational[nwn.SITUATION_FLAG_SNEAK_ATTACK].dmg_dice > 0
         or attacker.ci.situational[nwn.SITUATION_FLAG_SNEAK_ATTACK].dmg_bonus > 0

      -- Sneak Attack & Death Attack
      if (sneak or death) and
         (bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN) ~= 0
          or bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED) ~= 0
          or bit.band(attacker.ci.target_state_mask, nwn.COMBAT_TARGET_STATE_FLANKED)) ~= 0
      then
         -- Death Attack.  If it's a Death Attack it's also a sneak attack.
         if death then
            flags = bit.bor(flags, nwn.SITUATION_FLAG_DEATH_ATTACK)
            flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
         end

         -- Sneak Attack
         if sneak then
            flags = bit.bor(flags, nwn.SITUATION_FLAG_SNEAK_ATTACK)
         end
      end 
   end
   attacker.ci.situational_flags = flags
end
 
--- TODO: finish, test nwn funcs
function NSResolveTargetState(attacker, target)
   attacker.ci.target_state_mask = 0
   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return
   end

   local mask = 0

   if target:GetIsBlind()
      and not target:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
   then
      print("Blind")
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_BLIND)
   end

   if attacker:GetIsInvisible(target)
      and not target:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS)
   end

   if target:GetIsInvisible(attacker)
      and not attacker:GetHasFeat(nwn.FEAT_BLIND_FIGHT)
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_INVIS)
   end

   if not target:GetIsVisibile(attacker) then
      print("COMBAT_TARGET_STATE_ATTACKER_UNSEEN")
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
   end

   if not attacker:GetIsVisibile(target) then
      print("COMBAT_TARGET_STATE_UNSEEN")
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_UNSEEN)
   end

   if target.obj.obj.obj_anim == 4
      or target.obj.obj.obj_anim == 87
      or target.obj.obj.obj_anim == 86
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_MOVING)
   end

   if target.obj.obj.obj_anim == 36       
      or target.obj.obj.obj_anim == 33
      or target.obj.obj.obj_anim == 32
      or target.obj.obj.obj_anim == 7
      or target.obj.obj.obj_anim == 5
   then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_PRONE)
   end

   if target.obj.cre_state == 6 then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_STUNNED)
   end

   if target:GetIsFlanked(attacker) then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_FLANKED)
   end

   if target:GetIsFlatfooted() then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_FLATFOOTED)
   end

   if target.obj.cre_state == 9 or target.obj.cre_state == 8 then
      mask = bit.bor(mask, nwn.COMBAT_TARGET_STATE_ASLEEP)
   end

   attacker.ci.target_state_mask = mask
end
