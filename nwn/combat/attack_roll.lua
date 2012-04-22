-----------------------------------------------------------------------------
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

function NSGetAttackResult(attack_info)
   local t = attack_info.attack.cad_attack_result

   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
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

   return ac + nat + armor + shield + deflect + dodge
end

--- GetAttackModifierVersus
function NSGetAttackModifierVersus(attacker, target, attack_info, attack_type, weap, weap_num)
   
   local bab

   if attack_type == 2 then
      bab = attacker.ci.bab - (5 * attack_info.attacker_cr.cr_offhand_taken)
      attack_info.attacker_cr.cr_offhand_taken = attack_info.attacker_cr.cr_offhand_taken + 1
   elseif attack_type == 6 or attack_type == 8 then
      bab = attacker.ci.bab
      if attack_info.attack.cad_special_attack ~= 867 
         or attack_info.attack.cad_special_attack ~= 868
         or attack_info.attack.cad_special_attack ~= 391
      then
         bab = bab - (5 * attack_info.attacker_cr.cr_extra_taken)
      end
      attack_info.attacker_cr.cr_extra_taken = attack_info.attacker_cr.cr_extra_taken + 1
   else
      if attack_info.attack.cad_special_attack == 65002 
         or attack_info.attack.cad_special_attack == 6
         or attack_info.attack.cad_special_attack == 391
      then
         bab = attacker.ci.bab
      else
         bab = attacker.ci.bab - (attack_info.current_attack * attacker.ci.equips[weap_num].iter)
      end
   end

   local ab_abil = attacker:GetAbilityModifier(attacker.ci.equips[weap_num].ab_ability)

   -- Base Attack Bonus
   local ab = bab

   -- Offhand Attack Penalty
   if attack_info.is_offhand then
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
   ab = ab + NSResolveSpecialAttackAttackBonus(attacker, target, attack_info.attack)

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
   local state = attacker:GetEnemyStateAttackBonus(attack_info.attack.cad_ranged_attack)
   ab = ab + state

   -- Ranged Attacker Modifications
   if attack_info.attack.cad_ranged_attack == 1 then
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

function NSResolveAttackRoll(attacker, target, from_hook, attack_info)
   if from_hook then
      attacker = _NL_GET_CACHED_OBJECT(attacker)
      target = _NL_GET_CACHED_OBJECT(target)
   end

   local attack_type = attack_info.attack.cad_attack_type
   local weap, weap_num = NSGetCurrentAttackWeapon(attack_info.attacker_cr, attack_type, attacker)

   local ab = 0
   local ac = 0

   if target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      target = nwn.OBJECT_INVALID
   end

   -- Modifier Vs
   ab = ab + NSGetAttackModifierVersus(attacker, target, attack_info, attack_type, weap, weap_num)
   attack_info.attack.cad_attack_mod = ab

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      ac = ac + NSGetArmorClassVersus(target, attacker, false, false, attack_info.attack)
   end

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in 
   -- NSResolvePostMelee/RangedDamage
   if attack_info.attack.cad_coupdegrace == 1 then
      attack_info.attack.cad_attack_result = 7
      attack_info.attack.cad_attack_roll = 20
      return
   end

   local roll = math.random(20)
   attack_info.attack.cad_attack_roll = roll 

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1

   if NSResolveMissChance(attacker, target, hit, attack_info)
      or NSResolveDeflectArrow(attacker, target, hit, attack_info)
      or NSResolveParry(attacker, target, hit, attack_info)
   then
      return
   end

   if not hit then
      attack_info.attack.cad_attack_result = 4
      if roll == 1 then
         attack_info.attack.cad_missed = 1
      else
         attack_info.attack.cad_missed = ac - ab + roll
      end
      return
   else
      attack_info.attack.cad_attack_result = 1
   end

--[[
   if roll < NSGetCriticalHitRoll(attacker, is_offhand, weap, weap_num) then
      attack_info.attack.cad_threat_roll = math.random(20)
      attack_info.attack.cad_critical_hit = 1

      -- TODO Difficulty Settings
      -- TODO immunity
      if attack_info.attack.cad_threat_roll + ab >= ac then
         -- Is critical hit
         attack_info.attack.cad_attack_result = 3
      end
   end
   --]]
end