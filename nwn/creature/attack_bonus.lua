require 'nwn.creature.effects'
require 'nwn.effects'

local ffi = require 'ffi'

-- TODO: Replace get ab functions with NWNXCombt functions...
--[[
--- Determines creature's attack bonus.
-- @param is_offhand If true attack is using offhand weapon.
-- @param log Optional: Log table for debugging.
function Creature:GetAB(is_offhand, log)
   return self:GetABVersus(nwn.OBJECT_INVALID, is_offhand, nil, log)
end

--- Determines creature's attack bonus vs object.
-- @param tar Attack target
-- @param is_offhand If true attack is using offhand weapon.
-- @param attack Optional: Attack class instance.  This should only ever be passed from
--    Solstice combat engine.
-- @param log Optional: Log table for debugging.
function Creature:GetABVersus(tar, is_offhand, attack, log)
   local att = self
   local ab = self.ci.bab
   local wp_num = attack and attack.info.weapon or self:GetEquipNumFromEquips(is_offhand)
   local att_type = nwn.GetAttackTypeFromEquipNum(wp_num)
   local ab_abil = self:GetAbilityModifier(self.ci.equips[wp_num].ab_ability)

   ab = ab + ab_abil
   -- Size Modifier
   ab = ab + self.ci.size.ab
   -- Area Modifier
   ab = ab + self.ci.area.ab
   -- Feat Modifier
   ab = ab + self.ci.feat.ab
   -- Mode Modifier
   ab = ab + self.ci.mode.ab
   -- Race Modifier
   ab = ab + self.ci.race.ab

   -- Weapon AB Mod.  i.e, WF, SWF, EWF, etc
   ab = ab + self.ci.equips[wp_num].ab_mod

   -- Offhand Attack Penalty
   if is_offhand then
      ab = ab + self.ci.offhand_penalty_off
   else
      ab = ab + self.ci.offhand_penalty_on
   end

   nwn.LogTableAdd(log, "Ability Modifier: %d", ab_abil)
   nwn.LogTableAdd(log, "Area: %d", self.ci.area.ab)
   nwn.LogTableAdd(log, "Base Attack Bonus: %d", self.ci.bab)
   nwn.LogTableAdd(log, "Dual Wield Off Penalty: %d", self.ci.offhand_penalty_off)
   nwn.LogTableAdd(log, "Dual Wield On Penalty: %d", self.ci.offhand_penalty_on)
   nwn.LogTableAdd(log, "Feat: %d", self.ci.feat.ab)
   nwn.LogTableAdd(log, "Mode: %d", self.ci.mode.ab)
   nwn.LogTableAdd(log, "Race: %d", self.ci.race.ab)
   nwn.LogTableAdd(log, "Size: %d", self.ci.size.ab)
   nwn.LogTableAdd(log, "Weapon Feat: %d", self.ci.equips[wp_num].ab_mod)

   -- Favored Enemies
   if att:GetIsFavoredEnemy(tar) then
      ab = ab + att.ci.fe.ab
   end

   local eff_ab = att:GetEffectAttackBonus(tar, att_type)

   -- +1 Offensive Training Vs.
   if att:GetHasOffensiveTrainingVs(tar) then
      ab = ab + 1
   end

   -- This is as far as we can go if this is not called from the combat engine.
   if not attack then
      nwn.LogTableAdd(log, "Effect Bonus: %d", eff_ab)
      nwn.LogTableAdd(log, "    Total: %d", ab + eff_ab)
      return ab + eff_ab 
   end

   -- Debugging info for the results calculated above.  NOTE: Offensive traing is currently hardcoded
   nwn.LogTableAdd(log, "Favored Enemy: %d", att.ci.fe.ab)
   nwn.LogTableAdd(log, "Offensive Training Vs: %d", 1)
   nwn.LogTableAdd(log, "Effect Bonus: %d", eff_ab)

   -- Special Attack Modifier
   if attack:GetIsSpecialAttack() then
      local val = NSSpecialAttack(nwn.SPECIAL_ATTACK_EVENT_AB, att, tar, attack)
      nwn.LogTableAdd(log, "Special Attack (%d), %d", attack:GetIsSpecialAttack(), val)
      ab = ab + val
   end

   local is_ranged = attack:GetIsRangedAttack()
   
   -- Target State
   local state = att:GetEnemyStateAttackBonus(is_ranged)
   nwn.LogTableAdd(log, "Enemy State: %d", state)
   ab = ab + state

   -- Ranged Attacker Modifications
   if is_ranged then
      local r = att:GetRangedAttackMod(tar)
      ab = ab + r
   end

   local sit_ab = att:GetSituationalAttackBonus()
   nwn.LogTableAdd(log, "Situation Bonus: %d", sit_ab)

   ab = ab + eff_ab + sit_ab
   nwn.LogTableAdd(log, "    Total: %d", ab)
   return ab
end
   --]]
--- Determine creature's BAB.
function Creature:GetBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(699, 1)
   return nwn.engine.StackPopInteger()
end
