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

local ffi = require 'ffi'
local C = ffi.C

function Creature:GetABSizeModifier()
   local size = self:GetSize()
   local mod = 0

   if size == 1 then
      mod = 2
   elseif size == 2 then
      mod = 1
   elseif size == 4 then
      mod = -1
   elseif size == 5 then
      mod = -2
   end
   
   return mod
end

---
function Creature:GetAC(for_future)
   nwn.engine.StackPushInteger(for_future or 0)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(116, 2)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetArcaneSpellFailure()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(737, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetAttackTarget()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(316, 1)
   return nwn.engine.StackPopObject()
end

---
function Creature:GetAttemptedAttackTarget()
   nwn.engine.ExecuteCommand(361, 0)
   return nwn.engine.StackPopObject()
end

---
function Creature:GetAttemptedSpellTarget()
   nwn.engine.ExecuteCommand(375, 0)
   return nwn.engine.StackPopObject()
end

---
function Creature:GetBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(699, 1)
   return nwn.engine.StackPopInteger()
end

---
-- @param offhand
function Creature:GetCriticalHitMultiplier(offhand)
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetCriticalHitMultiplier(self.stats, offhand)
end

---
-- @param offhand
function Creature:GetCriticalHitMultiplier(offhand)
   if not self:GetIsValid() then return 0 end
   return C.nwn_GetCriticalHitRange(self.stats, offhand)
end

---Determines the creature that is going to attack another creature in the current combat round.
-- @return Returns the creature that is going to attack and nil if there is no attacker or self is not valid.
function Creature:GetGoingToBeAttackedBy()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(211, 1);
   return nwn.engine.StackPopObject();
end

---
function Creature:GetChallengeRating()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_cr
end

---
function Creature:GetIsInCombat()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(320, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetLastAttackType()
   nwn.engine.StackPushObject(self.id)
   nwn.engine.ExecuteCommand(317, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetLastAttackMode()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(318, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetLastWeaponUsed()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(328, 1)
   return nwn.engine.StackPopObject()
end

---
function Creature:GetLastTrapDetected()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(486, 1)
   return nwn.engine.StackPopObject()
end

---
-- @param damage
-- @param dc
-- @param savetype
-- @param versus
function Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
   nwn.engine.StackPushObject(versus)
   nwn.engine.StackPushInteger(savetype)
   nwn.engine.StackPushInteger(dc)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(damage)
   nwn.engine.ExecuteCommand(299, 5)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetTurnResistanceHD()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(478, 1)
   nwn.engine.StackPopInteger()
end

---
function Creature:RestoreBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(756, 1)
end

---
-- @param amount
function Creature:SetBaseAttackBonus(amount)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.ExecuteCommand(755, 2)
end

---
function Creature:SurrenderToEnemies()
   nwn.engine.ExecuteCommand(476, 0);
end

function Creature:UpdatedCombatInfo()
   self.bab = self:GetBaseAttackBonus()
   self.ab_ability = self:GetAttackBonusAbility()
   self.dmg_ability = self:GetDamageBonusAbility()

   self.num_attacks_on = self:GetNumberOfAttacks()
   self.num_attacks_off = self:GetNumberOfAttacks(true)

   self:UpdateCombatBonus()
   self:CalculateWeaponBonus()
end

---
function Creature:UpdateCombatBonus()
   -- need to update this for ranged weapons.
   local ab_abil = self:GetAbilityModifier(nwn.ABILITY_STRENGTH)
   local dmg_abil = self:GetAbilityModifier(nwn.ABILITY_STRENGTH)

   local ab  = 0
   local dmg = 0

   local cb = nwn.COMBAT_BONUS_CLASS 
   for _, class in self:Classes() do
      self:AddCombatBonus(cb, class)
   end

   cb = nwn.COMBAT_BONUS_ABILITY
   for i = 0, 5 do
      self:AddCombatBonus(cb, i)
   end   

   --- subrace
   --- deity
end

function Creature:GetAttackBonusAdjustment()

end

local function eff_ab(i, attacker, target, trace, tgoodevil, tdeity_id, tsubrace_id)
   local valid = false
   local attack_type = effs[i].eff_integers[1]
   local race = effs[i].eff_integers[2]
   local lawchaos = effs[i].eff_integers[3]
   local goodevil = effs[i].eff_integers[4]
   local subrace = effs[i].eff_integers[5]
   local deity = effs[i].eff_integers[6]

   if eff_type == ATACK_BONUS_MISC or attack_type == 0 then
      valid = true
   elseif attack_type == 6 and
      (eff_type == ATTACK_BONUS_ONHAND or
       eff_type == ATTACK_BONUS_CWEAPON1)
   then
      valid = true
   elseif attack_type == 8 and eff_type == ATTACK_BONUS_UNARMED then
      valid = true
   end
   
   if race ~= RACE_INVALID_RACE then
      valid = race == trace
   end

   if lawchaos ~= 0 then
      valid = lawchaos == tlawchaos
   end 

   if goodevil ~= 0 then
      valid = goodevil == tgoodevil
   end 

   if subrace ~= 0 then
      valid = subrace == tsubrace_id
   end       

   if deity ~= 0 then
      valid = deity == tdeity_id
   end 

   if valid then
      if eff_type == EFFECT_TRUETYPE_ATTACK_DECREASE then
         total = total - effs[i].eff_integers[0]
      else
         total = total + effs[i].eff_integers[0]
      end
   end
end

function Creature:UpdateCombatBonusVs(target)
   -- If the target is the same we can reuse the same results.
   if target == self.target then
      return
   end
   self.target = target 

   local trace = target:GetRacialType()
   local tgoodevil = target:GetGoodEvilValue()
   local tlawchaos = target:GetLawChaosValue()
   local tdeity_id = target:GetDeityId()
   local tsubrace_id = target:GetSubraceId()

   local effs = self.obj.obj.obj_effects
   local eff_type
   local total = 0
   for i = 0, self.obj.obj.obj_effects_len - 1 do
      eff_ab(i, attacker, target, trace, tgoodevil, tdeity_id, tsubrace_id)
   end
   
end
function Creature:UpdateWeaponCombatBonus()
   local weap
   for i = 0, 4 do
      if self.ci.equips[i] ~= nil then
         weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)

         self.ci.equips[i].ab_mod = self:GetWeaponAttackBonus(weap)
         self.ci.equips[i].ab_ability = self:GetWeaponAttackAbility(weap)
         self.ci.equips[i].dmg_ability = self:GetWeaponDamageAbility(weap)
         self.ci.equips[i].crit_range = self:GetWeaponCritRange(weap)
         self.ci.equips[i].crit_mult = self:GetWeaponCritMultiplier(weap)
         self.ci.equips[i].crit_dice,
         self.ci.equips[i].crit_sides = self:GetWeaponCritDamage(weap)
      end
   end
end

function Creature:PrintCombatInformation()
   local info = {}
   table.insert(info, string.format("Current Attacker: %x", self.ci.attacker))
   table.insert(info, string.format("Current Attacker: %x", self.ci.target))
   table.insert(info, string.format("Wield Type: %d", self.ci.wield_type))
   table.insert(info, string.format("BAB: %d", self.ci.bab))
   table.insert(info, string.format("AB Size Modifier: %d", self.ci.ab_size))
   table.insert(info, string.format("AB Mode Modifier: %d", self.ci.ab_mode))
   table.insert(info, string.format("AB Offhand Penalty: %d", self.ci.ab_offhand_penalty))
   table.insert(info, string.format("AB Area Modifier: %d", self.ci.ab_area))
   table.insert(info, string.format("AB Area Modifier: %d", self.ci.ab_feat))
   table.concat(info, ",\n")

end

function Creature:UpdateCombatInformation(event)
   self.ci.bab = self:GetBaseAttackBonus()
   self.ci.ab_size = self:GetABSizeModifier()

   -- Area Enter
   self.ci.ab_area = self:GetABAreaModifier()

   -- Equip
   self:UpdateWeaponCombatBonus()

   -- Levelup
   self.ci.ab_class = self:GetClassAttackBonus()
   
   end

function Creature:GetWeaponAttackBonus(weap)
   
end

function Creature:GetWeaponAttackAbility(weap)
   local abil = nwn.ABILITY_STRENGTH
   local mod = self:GetAbilityModifier(abil)
   
   for i = 1, 5 do
      local t = nwn.GetWeaponAttackAbilityModifier(self, weap, i)
      if t > mod then
         abil = i
         mod = t
      end
   end
   return abil
end

function Creature:GetWeaponDamageAbility(weap)
   local abil = nwn.ABILITY_STRENGTH
   local mod = self:GetAbilityModifier(abil)

   nwn.GetWeaponDamageAbilityModifier(self, weap, ability)

   for i = 1, 5 do
      local t = nwn.GetWeaponDamageAbilityModifier(self, weap, i)
      if t > mod then
         abil = i
         mod = t
      end
   end
   return abil
end

function Creature:GetWeaponCritRange(weap)
   
end

function Creature:GetWeaponCritMultiplier(weap)
   
end

function Creature:GetWeaponCritDamage(weap)
   local dice, sides = 0, 0

   return dice, sides
end

--[[
   uint8_t *resist;
   int16_t *immunity;

   uint16_t soak[20];

   int8_t save_mods[3]

   CombatWeapon equips[6];
   --]]