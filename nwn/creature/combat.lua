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

function nwn.ZeroCombatMod(mod)
   mod.ab = 0
   mod.ac = 0
   mod.dmg.dice = 0
   mod.dmg.dice = 0
   mod.dmg.bonus = 0
   mod.dmg_type = nwn.DAMAGE_TYPE_BASE_WEAPON
end

--- Adds parry attack.
-- @param attacker Attacker to do parry attack against.
function Creature:AddParryAttack(attacker)
   C.nwn_AddParryAttack(self.obj.cre_combat_round, attacker.id)
end

---
function Creature:DoDamageImmunity(attacker, dmg_result)
   for i = 0, NS_SETTINGS.NS_OPT_NUM_DAMAGES - 1 do
      dmg = dmg_result.damages[i]
      imm = self:GetDamageImmunity(i)
      imm_adj = math.floor((imm * dmg) / 100)
      -- Immunity
      dmg_result.immunity_adjust[i] = imm_adj
      dmg_result.damages[i] = dmg - imm_adj
   end
end

---
function Creature:DoDamageResistance(attacker, dmg_result)
   local eff_type, amount, dmg_flg, idx
   local limit, use_eff, resist
   for i = 0, NS_SETTINGS.NS_OPT_NUM_DAMAGES - 1 do
      -- Innate / Feat resistance.  In the case of damage reduction these stack
      -- with damage resistance effects.
      if self.ci.resist[i] > 0 then
         resist = math.min(dmg_result.damages[i], self.ci.resist[i])
         dmg_result.resist_adjust[i] = resist
         dmg_result.damages[i] = dmg_result.damages[i] - resist
      end
      -- If there is any damage left to be resisted by effects.
      if dmg_result.damages[i] > 0 then
         local eff = self.ci.eff_resist[i]

         -- If there is a resist effect for this damage, use it.
         if eff >= 0 then
            use_eff = self.obj.obj.obj_effects[eff]
         end
      end

      -- If using a resist effect determine if the effect has a limit and adjust it if so.
      if use_eff then
         resist = math.min(use_eff.eff_integers[1], dmg_result.damages[i])
         local eff_limit = use_eff.eff_integers[2]
         if eff_limit > 0 then
            if eff_limit <= resist then
               resist = eff_limit
               self:RemoveEffectById(eff.eff_id)
            else
               use_eff.eff_integers[2] = eff_limit - resist
            end
         end

         -- Resist adjustment must be incremented by effect resistance in case any
         -- innate resistance has already been applied.
         dmg_result.resist_adjust[i] = dmg_result.resist_adjust[i] + resist
         dmg_result.damages[i] = dmg_result.damages[i] - resist
      end
   end
end

--- Modifies damage roll by highest applicable soak, if any.
function Creature:DoDamageReduction(attacker, dmg_result, damage_power)
   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = self.ci.soak

   -- In the NWN Engine base damage is stored in damage index 12.
   local base_damage = dmg_result.damages[12]
   local use_eff

   -- If damage power is greater then 20 or less than zero something is most
   -- likely wrong so don't bother with effects
   if damage_power < 20 and damage_power >= 0 then
      -- Loop through the soak effects and find a soak that is a) higher than innate soak
      -- and b) is greater than the damage power.
      for i = damage_power + 1, 20 do
         local eff = self.ci.eff_soak[i]
         if eff >= 0 then
            local eff_amount = self.obj.obj.obj_effects[eff].eff_integers[0]
            -- If the soak amount is greater than the higest soak, save the effect for later use.
            -- If it has a limit it will need to be adjusted or removed.  Update the new highest
            -- soak amount.  The limit here is itself not relevent.
            if eff_amount >= highest_soak then
               highest_soak = eff_amount
               use_eff = self.obj.obj.obj_effects[eff]
            end
         end
      end
   end

   -- Now that the highest soak amount has been found, determine the minimum of it and
   -- the base damage.  I.e. you can't soak more than your damamge.
   highest_soak = math.min(base_damage, highest_soak)

   -- If using a soak effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      local eff_limit = use_eff.eff_integers[2]
      if eff_limit > 0 then
         -- If the effect damage limit is less than the highest soak amount then
         -- the effect needs to be remove and the highest soak amount adjusted. I.e.
         -- You can't soak more than the remaing limit on soak damage.  Effect removal
         -- will trigger Creature:UpdateDamageReduction to determine the new best soak
         -- effects.
         -- Else the current limit must be adjusted by the highest soak amount.
         if eff_limit <= highest_soak then
            highest_soak = eff_limit
            self:RemoveEffectById(eff.eff_id)
         else
            use_eff.eff_integers[2] = eff_limit - highest_soak
         end
      end      
   end

   -- Set the soak amount and adjust the base damage result
   dmg_result.soak_adjust = highest_soak
   dmg_result.damages[12] = base_damage - highest_soak
end

--- Get creature's AC.
-- @param for_future (Default: false)
function Creature:GetAC(for_future)
   ne.StackPushBoolean(for_future)
   ne.StackPushObject(self)
   ne.ExecuteCommand(116, 2)
   return ne.StackPopInteger()
end

--- Get creature's arcane spell failure.
function Creature:GetArcaneSpellFailure()
   ne.StackPushObject(self)
   ne.ExecuteCommand(737, 1)
   return ne.StackPopInteger()
end

--- Get creature's attack target
function Creature:GetAttackTarget()
   ne.StackPushObject(self)
   ne.ExecuteCommand(316, 1)
   return ne.StackPopObject()
end

--- Get creature's attempted attack target
function Creature:GetAttemptedAttackTarget()
   ne.ExecuteCommand(361, 0)
   return ne.StackPopObject()
end

--- Get creature's attempted spell target
function Creature:GetAttemptedSpellTarget()
   ne.ExecuteCommand(375, 0)
   return ne.StackPopObject()
end

--- Get creature's base attack bonus.
function Creature:GetBaseAttackBonus()
   ne.StackPushObject(self)
   ne.ExecuteCommand(699, 1)
   return ne.StackPopInteger()
end

--- Get creature's challenge rating
function Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_cr
end

--- Get creature's combat mode
function Creature:GetCombatMode()
   if not self:GetIsValid() then return 0 end
   return self.obj.cre_mode_combat
end

--- Get creature's damage flags.
function Creature:GetDamageFlags()
   return C.nwn_GetDamageFlags(self.obj)
end

--- Determines attack bonus based on target's state.
-- See nwn.COMBAT_TARGET_STATE_*
-- @param is_ranged true if current attack is a ranged attack.
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

--- Determines if creature is immune to critical hits.
-- @param attacker Attacker
function Creature:GetIsImmuneToCriticalHits(attacker)
end

--- Determines if creature is in combat.
function Creature:GetIsInCombat()
   ne.StackPushObject(self)
   ne.ExecuteCommand(320, 1)
   return ne.StackPopBoolean()
end

--- Determines if creature is visible to another creature.
-- @param target Target to test.
function Creature:GetIsVisibile(target)
   return C.nwn_GetIsVisible(self.obj, target.id)
end

--- Get's last attack type used by creature.
function Creature:GetLastAttackType()
   ne.StackPushObject(self.id)
   ne.ExecuteCommand(317, 1)
   return ne.StackPopInteger()
end

--- Get's last attack mode used by creature.
function Creature:GetLastAttackMode()
   ne.StackPushObject(self)
   ne.ExecuteCommand(318, 1)
   return ne.StackPopInteger()
end

--- Get's last weapon used by creature.
function Creature:GetLastWeaponUsed()
   ne.StackPushObject(self)
   ne.ExecuteCommand(328, 1)
   return ne.StackPopObject()
end

--- Get's last trap detected by creature.
function Creature:GetLastTrapDetected()
   ne.StackPushObject(self)
   ne.ExecuteCommand(486, 1)
   return ne.StackPopObject()
end

--- Determines creature's maximum attack bonus from gear/effects.
function Creature:GetMaxAttackBonus()
   return 20
end

--- Determines creatures maximum attack range.
-- @param target Target to attack
function Creature:GetMaxAttackRange(target)
   return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

--- Determines creature's maximum dodge AC from gear/effects.
function Creature:GetMaxDodgeAC()
   return 20
end

--- Determines creatures offhand attack penalty.
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

--- Determines reflex saved damage adjustment.
-- @param damage Total damage.
-- @param dc Difficulty class
-- @param savetype nwn.SAVING_THROW_TYPE_*
-- @param versus Creature to roll against.
function Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   ne.StackPushObject(versus)
   ne.StackPushInteger(savetype)
   ne.StackPushInteger(dc)
   ne.StackPushObject(self)
   ne.StackPushInteger(damage)
   ne.ExecuteCommand(299, 5)
   return ne.StackPopInteger()
end

--- Determines attack bonus from situational factors.
-- See nwn.SITUATION_*
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

--- Determines turn resistance hit dice.
function Creature:GetTurnResistanceHD()
   ne.StackPushObject(self)
   ne.ExecuteCommand(478, 1)
   ne.StackPopInteger()
end

--- Restores a creature's base number of attacks.
function Creature:RestoreBaseAttackBonus()
   ne.StackPushObject(self)
   ne.ExecuteCommand(756, 1)
end

--- Sets a creature's base number of attacks.
-- @param amount Amount of attacks.
function Creature:SetBaseAttackBonus(amount)
   ne.StackPushObject(self)
   ne.StackPushInteger(amount)
   ne.ExecuteCommand(755, 2)
end

--- Causes all creatures in a 10 meter (1 tile) radius to stop actions.
-- Improves the creature's reputation with nearby enemies for 3 minutes. Only works for NPCs.
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

--- Get ranged attack bonus/penalty vs a target.
-- @param target Creature's target.
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

--- Updates equipped weapon object IDs.
function Creature:UpdateCombatEquips()
   self.ci.equips[0].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND).id
   self.ci.equips[1].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND).id
   self.ci.equips[2].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS).id
   self.ci.equips[3].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_L).id
   self.ci.equips[4].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_R).id
   self.ci.equips[5].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_B).id

end

--- Updates a creature's combat modifiers.
-- See ConbatMod ctype.
-- @param update_flags
function Creature:UpdateCombatInfo(update_flags)
   update_flags = nwn.COMBAT_UPDATE_ALL

   self:UpdateDamageResistance()
   self:UpdateDamageReduction()

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

   if bit.band(nwn.COMBAT_UPDATE_SHIFT, update_flags) then
      self:UpdateCombatModifierRace()
      self:UpdateCombatModifierSize()
   end
   self:UpdateCombatModifierSkill()
end

--- Determines creature's area combat modifiers.
function Creature:UpdateCombatModifierArea()
   local mod = self.ci.area
   nwn.ZeroCombatMod(mod)
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

--- Determines creature's class combat modifiers.
function Creature:UpdateCombatModifierClass()
   nwn.ZeroCombatMod(self.ci.class)
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

--- Determines creature's feat combat modifiers.
function Creature:UpdateCombatModifierFeat()
   local mod = self.ci.feat
   nwn.ZeroCombatMod(mod)
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

--- Determines creature's race combat modifiers.
function Creature:UpdateCombatModifierRace()
   local mod = self.ci.race
   nwn.ZeroCombatMod(mod)
end

--- Determines creature's size combat modifiers.
function Creature:UpdateCombatModifierSize()
   local mod = self.ci.size
   nwn.ZeroCombatMod(mod)
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

--- Determines creature's skill combat modifiers.
function Creature:UpdateCombatModifierSkill()
   nwn.ZeroCombatMod(self.ci.skill)

   local ac = 0
   ac = ac + self:GetSkillRank(nwn.SKILL_TUMBLE, true) / 5
   self.ci.skill.ac = ac
end


--- Determines creature's weapon combat info.
function Creature:UpdateCombatWeaponInfo()
   local weap
   for i = 0, 5 do
      weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)
      if weap:GetIsValid() then
         self.ci.equips[i].ab_mod = self:GetWeaponAttackBonus(weap)
         self.ci.equips[i].ab_ability = self:GetWeaponAttackAbility(weap)
         self.ci.equips[i].dmg_ability = self:GetWeaponDamageAbility(weap)

         self.ci.equips[i].iter = self:GetWeaponIteration(weap)

         self.ci.equips[i].base_dmg.dice,
         self.ci.equips[i].base_dmg.sides = self:GetWeaponBaseDamage(weap)
         self.ci.equips[i].base_dmg.bonus = self:GetWeaponDamageBonus(weap)

         self.ci.equips[i].crit_range = self:GetWeaponCritRange(weap)
         self.ci.equips[i].crit_mult = self:GetWeaponCritMultiplier(weap)
         self.ci.equips[i].crit_dmg.dice,
         self.ci.equips[i].crit_dmg.sides = self:GetWeaponCritDamage(weap)
      else
         self.ci.equips[i].ab_mod = 0
         self.ci.equips[i].ab_ability = 0
         self.ci.equips[i].dmg_ability = 0
         self.ci.equips[i].base_dmg.dice = 0
         self.ci.equips[i].base_dmg.sides = 0
         self.ci.equips[i].base_dmg.bonus = 0
         self.ci.equips[i].crit_range = 0
         self.ci.equips[i].crit_mult = 0
         self.ci.equips[i].crit_dmg.dice = 0
         self.ci.equips[i].crit_dmg.sides = 0
         self.ci.equips[i].crit_dmg.bonus = 0
      end
   end
end