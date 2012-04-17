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
--------------------------------------------------------------------------------

require 'nwn.creature.weapons'
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local ne = nwn.engine

local function zero_combat_mod(mod)
   mod.ab = 0
   mod.ac = 0
   mod.dmg_dice = 0
   mod.dmg_dice = 0
   mod.dmg_bonus = 0
end

---
function Creature:GetAC(for_future)
   ne.StackPushInteger(for_future or 0)
   ne.StackPushObject(self)
   ne.ExecuteCommand(116, 2)
   return ne.StackPopInteger()
end

---
function Creature:GetArcaneSpellFailure()
   ne.StackPushObject(self)
   ne.ExecuteCommand(737, 1)
   return ne.StackPopInteger()
end

---
function Creature:GetAttackTarget()
   ne.StackPushObject(self)
   ne.ExecuteCommand(316, 1)
   return ne.StackPopObject()
end

---
function Creature:GetAttemptedAttackTarget()
   ne.ExecuteCommand(361, 0)
   return ne.StackPopObject()
end

---
function Creature:GetAttemptedSpellTarget()
   ne.ExecuteCommand(375, 0)
   return ne.StackPopObject()
end

---
function Creature:GetBaseAttackBonus()
   ne.StackPushObject(self)
   ne.ExecuteCommand(699, 1)
   return ne.StackPopInteger()
end

function Creature:GetCombatMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_mode_combat
end

function Creature:GetEffectAttackBonus(target, attack_type)
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

   for i = self.stats.cs_first_ab_effect, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type > nwn.EFFECT_TRUETYPE_ATTACK_DECREASE then
         break
      end

      amount   = self.obj.obj.obj_effects[i].eff_integers[0]
      atk_type = self.obj.obj.obj_effects[i].eff_integers[1]
      race     = self.obj.obj.obj_effects[i].eff_integers[2]
      lawchaos = self.obj.obj.obj_effects[i].eff_integers[3]
      goodevil = self.obj.obj.obj_effects[i].eff_integers[4]
      subrace  = self.obj.obj.obj_effects[i].eff_integers[5]
      deity    = self.obj.obj.obj_effects[i].eff_integers[6]
      valid    = false

      if atk_type == nwn.ATTACK_BONUS_MISC or atk_type == attack_type then
         valid = true
      elseif attack_type == 6 and (atk_type == nwn.ATTACK_BONUS_ONHAND or nwn.ATTACK_BONUS_CWEAPON1) then
         valid = true
      elseif attack_type == 8 and atk_type == nwn.ATTACK_BONUS_UNARMED then
         valid = true
      end

      if valid then
         -- TODO this is wrong...
         if (race == nwn.RACIAL_TYPE_INVALID and lawchaos == 0 and  goodevil == 0 and  subrace == 0 and deity == 0)
            or race == trace
            or lawchaos == tlawchaos
            or goodevil == tgoodevil
            or subrace == tsubrace_id
            or deity == tdeity_id
         then
            if eff_type == nwn.EFFECT_TRUETYPE_ATTACK_DECREASE then
               total = total - amount
            elseif eff_type == nwn.EFFECT_TRUETYPE_ATTACK_INCREASE then
               total = total + amount
            end 
         end
      end
   end
   return total
end

function Creature:GetEffectArmorClassBonus(attacker, touch)
   local eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge = 0, 0, 0, 0, 0

   return eff_nat, eff_armor, eff_shield, eff_deflect, eff_dodge
end

---
function Creature:GetEffectCritMultBonus(target)
   local amount, percent, race, lawchaos, goodevil, subrace, deity
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id

   local total = 0

   if target and target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      trace = target:GetRacialType()
      tgoodevil = target:GetGoodEvilValue()
      tlawchaos = target:GetLawChaosValue()
      tdeity_id = target:GetDeityId()
      tsubrace_id = target:GetSubraceId()
   end

   for i = self.ci.first_cm_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_MODIFYNUMATTACKS or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE)
      then
         break
      end

      amount      = self.obj.obj.obj_effects[i].eff_integers[1]
      percent     = self.obj.obj.obj_effects[i].eff_integers[2]
      race        = self.obj.obj.obj_effects[i].eff_integers[3]
      lawchaos    = self.obj.obj.obj_effects[i].eff_integers[4]
      goodevil    = self.obj.obj.obj_effects[i].eff_integers[5]
      subrace     = self.obj.obj.obj_effects[i].eff_integers[6]
      deity       = self.obj.obj.obj_effects[i].eff_integers[7]

      if (race == RACE_INVALID_RACE and lawchaos == 0 and  goodevil == 0 and  subrace == 0 and deity == 0)
         or race == trace
         or lawchaos == tlawchaos
         or goodevil == tgoodevil
         or subrace == tsubrace_id
         or deity == tdeity_id
      then
         if eff_type == nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE then
            if math.random(100) <= percent then
               total = total - amount
            end
         else
             if math.random(100) <= percent then
               total = total - amount
            end
         end 
      end
   end
   return total
end

---
function Creature:GetEffectCritRangeBonus(target)
   local amount, percent, race, lawchaos, goodevil, subrace, deity
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id

   local total = 0

   if target and target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      trace = target:GetRacialType()
      tgoodevil = target:GetGoodEvilValue()
      tlawchaos = target:GetLawChaosValue()
      tdeity_id = target:GetDeityId()
      tsubrace_id = target:GetSubraceId()
   end

   for i = self.ci.first_cr_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_MODIFYNUMATTACKS or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_DESCREASE)
      then
         break
      end

      amount      = self.obj.obj.obj_effects[i].eff_integers[1]
      percent     = self.obj.obj.obj_effects[i].eff_integers[2]
      race        = self.obj.obj.obj_effects[i].eff_integers[3]
      lawchaos    = self.obj.obj.obj_effects[i].eff_integers[4]
      goodevil    = self.obj.obj.obj_effects[i].eff_integers[5]
      subrace     = self.obj.obj.obj_effects[i].eff_integers[6]
      deity       = self.obj.obj.obj_effects[i].eff_integers[7]

      if (race == RACE_INVALID_RACE and lawchaos == 0 and  goodevil == 0 and  subrace == 0 and deity == 0)
         or race == trace
         or lawchaos == tlawchaos
         or goodevil == tgoodevil
         or subrace == tsubrace_id
         or deity == tdeity_id
      then
         if eff_type == nwn.EFFECT_CUSTOM_CRIT_RANGE_DESCREASE then
            if math.random(100) <= percent then
               total = total - amount
            end
         else
            if math.random(100) <= percent then
               total = total + amount
            end
         end 
      end
   end
   return total
end

---
function Creature:GetEnemyStateAttackBonus(is_ranged)
   local ab = 0
   local mask = self.ci.target_state_mask

   -- Target State
   if is_ranged == 1 then
      -- -2 when target is moving.
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_MOVING) ~= 0 then
         ab = ab - 2
      end

      -- -4 When target is prone and attacker ranged. 
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_PRONE) ~= 0 then
         ab = ab - 4
      end
   else
      -- +4 When target is prone and attacker melee. 
      if bit.band(mask, nwn.COMBAT_TARGET_STATE_PRONE) ~= 0 then
         ab = ab + 4
      end
   end

   -- +2 when attacker is invisible
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_ATTACKER_INVIS) ~= 0 then
      ab = ab + 2
   end 

   -- +2 if target blind
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_BLIND) ~= 0 then
      ab = ab + 2
   end 

   -- +2 When target is stunned. 
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_STUNNED) ~= 0 then
      ab = ab + 2
   end

   -- -4 When attack can't see target. 
   if bit.band(mask, nwn.COMBAT_TARGET_STATE_UNSEEN) ~= 0 then
      ab = ab -4
   end

   return ab
end

---Determines the creature that is going to attack another creature in the current combat round.
-- @return Returns the creature that is going to attack and nil if there is no attacker or self is not valid.
function Creature:GetGoingToBeAttackedBy()
   ne.StackPushObject(self)
   ne.ExecuteCommand(211, 1);
   return ne.StackPopObject();
end

---
function Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_cr
end

---
function Creature:GetIsInCombat()
   ne.StackPushObject(self)
   ne.ExecuteCommand(320, 1)
   return ne.StackPopBoolean()
end

---
function Creature:GetIsVisibile(target)
   return C.nwn_GetIsVisible(self.obj, target.id)
end

---
function Creature:GetLastAttackType()
   ne.StackPushObject(self.id)
   ne.ExecuteCommand(317, 1)
   return ne.StackPopInteger()
end

---
function Creature:GetLastAttackMode()
   ne.StackPushObject(self)
   ne.ExecuteCommand(318, 1)
   return ne.StackPopInteger()
end

---
function Creature:GetLastWeaponUsed()
   ne.StackPushObject(self)
   ne.ExecuteCommand(328, 1)
   return ne.StackPopObject()
end

---
function Creature:GetLastTrapDetected()
   ne.StackPushObject(self)
   ne.ExecuteCommand(486, 1)
   return ne.StackPopObject()
end

---
function Creature:GetMaxAttackRange(target)
   return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

function Creature:GetMaxDodgeAC(target)
   return 20
end

---
function Creature:GetOffhandAttackPenalty()
   local on = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local off = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local ab_on, ab_off = 0, 0
   local off_is_weap
   local on_bi, off_bi
   

   if not on:GetIsValid() or not off:GetIsValid() then
      return ab_on, ab_off
   end

   if on:GetIsValid() then
      on_bi = C.nwn_GetBaseItem(on:GetBaseType())
      -- Not sure about this.  Double sided weapons don't have offhand penalties?
      -- I saw this in MaxRock's windows plugin, 
      --if on_bi == nil or on_bi.bi_weapon_wield == 8 then
      --   return ab
      --end
   else
      -- If either item is invalid we can't be dual wielding.
      return ab_on, ab_off
   end

   if off:GetIsValid() then
      off_bi = C.nwn_GetBaseItem(off:GetBaseType())
      -- Check if this is a weapon
      if off_bi.bi_damage_type == 0 then
         return ab_on, ab_off
      end
   else
      -- If either item is invalid we can't be dual wielding.
      return ab_on, ab_off
   end

   if self:GetRelativeWeaponSize(off) <= -1 or on_bi.bi_weapon_wield == 8 then
      ab_on  = -4
      ab_off = -8
   else
      ab_on  = -6
      ab_off = -10
   end

   if self:GetHasFeat(374) then
      ab_on  = ab_on + 2
      ab_off = ab_off + 6
   else
      if self:GetHasFeat(nwn.FEAT_TWO_WEAPON_FIGHTING) then
         ab_on  = ab_on + 2
         ab_off = ab_off + 2
      end
      
      if self:GetHasFeat(nwn.FEAT_AMBIDEXTERITY) then
         ab_off = ab_off + 4
      end
   end
      
   return ab_on, ab_off
end

---
-- @param damage
-- @param dc
-- @param savetype
-- @param versus
function Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   ne.StackPushObject(versus)
   ne.StackPushInteger(savetype)
   ne.StackPushInteger(dc)
   ne.StackPushObject(self)
   ne.StackPushInteger(damage)
   ne.ExecuteCommand(299, 5)
   return ne.StackPopInteger()
end

function Creature:GetSituationalAttackBonus()
   local situ_mask = self.ci.situational_flags
   local ab = 0
   local idx = 1
   for i = 0, 2 do
      if bit.band(situ_mask, idx) then
         ab = ab + self.ci.situational[i].ab      
      end
      idx = bit.lshift(idx, 1)
   end
   return ab
end

---
function Creature:GetTurnResistanceHD()
   ne.StackPushObject(self)
   ne.ExecuteCommand(478, 1)
   ne.StackPopInteger()
end

---
function Creature:RestoreBaseAttackBonus()
   ne.StackPushObject(self)
   ne.ExecuteCommand(756, 1)
end

---
-- @param amount
function Creature:SetBaseAttackBonus(amount)
   ne.StackPushObject(self)
   ne.StackPushInteger(amount)
   ne.ExecuteCommand(755, 2)
end

---
function Creature:SurrenderToEnemies()
   ne.ExecuteCommand(476, 0);
end

---
function Creature:PrintCombatInformation()
   local info = {}
   table.insert(info, string.format("Current Attacker: %x", self.ci.attacker))
   table.insert(info, string.format("Current Target: %x", self.ci.target))
   table.insert(info, string.format("Wield Type: %d", self.ci.wield_type))
   table.insert(info, string.format("BAB: %d", self.ci.bab))
   --table.insert(info, string.format("AB Size Modifier: %d", self.ci.ab_size))
   --table.insert(info, string.format("AB Mode Modifier: %d", self.ci.ab_mode))
   --table.insert(info, string.format("AB Offhand Penalty: %d", self.ci.ab_offhand_penalty))
   --table.insert(info, string.format("AB Area Modifier: %d", self.ci.ab_area))
   --table.insert(info, string.format("AB Area Modifier: %d", self.ci.ab_feat))
   table.concat(info, ",\n")

end

---
function Creature:PrintWeaponInfo()
   local fmt = "Id: %X, AB: %d, AB Ability: %d, "
      .. "Dmg Ability: %d, Base Damage: %dd%d + %d, "
      .. "Crit Range: %d, Crit Multiplier: %d, Crit Damage: %dd%d\n\n"
   
   for i = 0, 5 do
      print(string.format(fmt,
                          self.ci.equips[i].id,
                          self.ci.equips[i].ab_mod,
                          self.ci.equips[i].ab_ability,
                          self.ci.equips[i].dmg_ability,
                          self.ci.equips[i].dmg_dice,
                          self.ci.equips[i].dmg_sides,
                          self.ci.equips[i].dmg_mod,
                          self.ci.equips[i].crit_range,
                          self.ci.equips[i].crit_mult,
                          self.ci.equips[i].crit_dice,
                          self.ci.equips[i].crit_sides))
   end
end

---
function Creature:GetRangedAttackMod(target)
   local ab = 0

   -- Point Blank Shot
   if self.ci.target_distance <= 25
      and self:GetHasFeat(nwn.FEAT_POINT_BLANK_SHOT)
   then
      ab = ab + 1
   end

   if target.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      -- Ranged Attack in Melee Target Range
      local max = target:GetMaxAttackRange(self)
      local weap = target:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
      if self.ci.target_distance <= max * max
         and weap:GetIsValid()
         and not weap:GetIsRangedWeapon()
      then
         ab = ab - 4
      end
   end

   return ab
end

---
function Creature:UpdateCombatEquips()
   self.ci.equips[0].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND).id
   self.ci.equips[1].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND).id
   self.ci.equips[2].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS).id
   self.ci.equips[3].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_L).id
   self.ci.equips[4].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_R).id
   self.ci.equips[5].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_B).id

end

---
function Creature:UpdateCombatInfo(update_flags)
   update_flags = nwn.COMBAT_UPDATE_ALL

   --self.num_attacks_on = self:GetNumberOfAttacks()
   --self.num_attacks_off = self:GetNumberOfAttacks(true)
   
   if bit.band(nwn.COMBAT_UPDATE_EQUIP, update_flags) then
      self:UpdateCombatEquips()
      self:UpdateCombatWeaponInfo()
      self.ci.offhand_penalty_on,
      self.ci.offhand_penalty_off = self:GetOffhandAttackPenalty()
   end

   if bit.band(nwn.COMBAT_UPDATE_AREA, update_flags) then
      self:UpdateCombatModifierArea()
   end

   if bit.band(nwn.COMBAT_UPDATE_LEVELUP, update_flags) then
      self.ci.bab = self:GetBaseAttackBonus()
      self:UpdateCombatModifierClass()
      self:UpdateCombatModifierFeat()
   end

   if bit.band(nwn.COMBAT_UPDATE_MODE, update_flags) then
      self:UpdateCombatModifierMode()
   end

   if bit.band(nwn.COMBAT_UPDATE_SHIFT, update_flags) then
      self:UpdateCombatModifierRace()
      self:UpdateCombatModifierSize()
   end
   self:UpdateCombatModifierSkill()
end

---
function Creature:UpdateCombatModifierArea()
   local mod = self.ci.area
   zero_combat_mod(mod)
   local area = self:GetArea()
   local area_type = area.obj.area_type
   local ab = 0

   if bit.band(area_type, 4) and
      not bit.band(area_type, 2) and
      not bit.band(area_type, 1) and
      self:GetHasFeat(nwn.FEAT_NATURE_SENSE)
   then
      ab = 2
   end
   
   mod.ab = ab
end

---
function Creature:UpdateCombatModifierClass()
   zero_combat_mod(self.ci.class)
   local ac = 0

   local monk = self:GetLevelByClass(nwn.CLASS_TYPE_MONK)
   if monk > 0 and
      self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
   then
      ac = ac + self:GetAbilityModifier(nwn.ABILITY_WISDOM)
      ac = ac + (monk / 5)
   end

   self.ci.class.ac = ac
end

---
function Creature:UpdateCombatModifierFeat()
   local mod = self.ci.feat
   zero_combat_mod(mod)
   local ab, ac = 0, 0

   if self:GetHasFeat(nwn.FEAT_EPIC_PROWESS) then
      ab = ab + 2
   end

   if self:GetHasFeat(nwn.FEAT_EPIC_ARMOR_SKIN) then
      ac = ac + 2
   end

   mod.ab = ab
   mod.ac = ac
end

---
function Creature:UpdateCombatModifierMode()
   zero_combat_mod(self.ci.mode)
   local mode = self:GetCombatMode()
   local ab, ac = 0, 0

   if mode == nwn.COMBAT_MODE_INVALID then
      return
   end

   if mode == nwn.COMBAT_MODE_PARRY then
      ac = 0
   elseif mode == nwn.COMBAT_MODE_POWER_ATTACK then
      ab = -5
      self.ci.dmg_bonus = 10
   elseif mode == nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK then
      ab = -10
      self.ci.dmg_bonus = 10
   elseif mode == nwn.COMBAT_MODE_FLURRY_OF_BLOWS then
      ab = -2
   elseif mode == nwn.COMBAT_MODE_RAPID_SHOT then
      ac = 0
   elseif mode == nwn.COMBAT_MODE_EXPERTISE then
      ab = -5
      ac = 5
   elseif mode == nwn.COMBAT_MODE_IMPROVED_EXPERTISE then
      ab = -10
      ac = 10
   elseif mode == nwn.COMBAT_MODE_DEFENSIVE_CASTING then
      ac = 0
   elseif mode == nwn.COMBAT_MODE_DIRTY_FIGHTING then
      ac = 0
   elseif mode == nwn.COMBAT_MODE_DEFENSIVE_STANCE then
      ac = 0
   end

   self.ci.mode.ab = ab
   self.ci.mode.ac = ac
end

---
function Creature:UpdateCombatModifierRace()
   local mod = self.ci.race
   zero_combat_mod(mod)
end

---
function Creature:UpdateCombatModifierSize()
   local mod = self.ci.size
   zero_combat_mod(mod)
   local size = self:GetSize()
   local ac, ab = 0, 0

   if size == nwn.CREATURE_SIZE_TINY then
      ac, ab = 2, 2
   elseif size == nwn.CREATURE_SIZE_SMALL then
      ac, ab = 1, 1
   elseif size == nwn.CREATURE_SIZE_LARGE then
      ac, ab = -1, -1
   elseif size == nwn.CREATURE_SIZE_HUGE then
      ac, ab = -2, -2
   end
   
   mod.ab = ab
   mod.ac = ac
end

---
--
function Creature:UpdateCombatModifierSkill()
   zero_combat_mod(self.ci.skill)

   local ac = 0
   print(self:GetSkillRank(nwn.SKILL_TUMBLE, true),
         math.floor(self:GetSkillRank(nwn.SKILL_TUMBLE, true) / 5))

   ac = ac + self:GetSkillRank(nwn.SKILL_TUMBLE, true) / 5

   self.ci.skill.ac = ac
end


---
function Creature:UpdateCombatWeaponInfo()
   local weap
   for i = 0, 5 do
      weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)
      if weap:GetIsValid() then
         self.ci.equips[i].ab_mod = self:GetWeaponAttackBonus(weap)
         self.ci.equips[i].ab_ability = self:GetWeaponAttackAbility(weap)
         self.ci.equips[i].dmg_ability = self:GetWeaponDamageAbility(weap)

         self.ci.equips[i].iter = self:GetWeaponIteration(weap)

         self.ci.equips[i].dmg_dice,
         self.ci.equips[i].dmg_sides = self:GetWeaponBaseDamage(weap)
         self.ci.equips[i].dmg_mod = self:GetWeaponDamageBonus(weap)

         self.ci.equips[i].crit_range = self:GetWeaponCritRange(weap)
         self.ci.equips[i].crit_mult = self:GetWeaponCritMultiplier(weap)
         self.ci.equips[i].crit_dice,
         self.ci.equips[i].crit_sides = self:GetWeaponCritDamage(weap)
      else
         self.ci.equips[i].ab_mod = 0
         self.ci.equips[i].ab_ability = 0
         self.ci.equips[i].dmg_ability = 0
         self.ci.equips[i].dmg_dice = 0
         self.ci.equips[i].dmg_sides = 0
         self.ci.equips[i].dmg_mod = 0
         self.ci.equips[i].crit_range = 0
         self.ci.equips[i].crit_mult = 0
         self.ci.equips[i].crit_dice = 0
         self.ci.equips[i].crit_sides = 0
      end
   end
end