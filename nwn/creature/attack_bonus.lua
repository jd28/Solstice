require 'nwn.creature.effects'
require 'nwn.effects'

local ffi = require 'ffi'

-- Effect accumulator locals
local bonus = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local penalty = ffi.new("uint32_t[?]", NS_OPT_MAX_EFFECT_MODS)
local ab_amount = nwn.CreateEffectAmountFunc(0)
local ab_range = nwn.CreateEffectRangeFunc(nwn.EFFECT_TRUETYPE_ATTACK_DECREASE,
					   nwn.EFFECT_TRUETYPE_ATTACK_INCREASE)

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

--- Determine creature's BAB.
function Creature:GetBaseAttackBonus()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(699, 1)
   return nwn.engine.StackPopInteger()
end

--- Get creatures attack bonus from effects/weapons.
-- @param vs Creatures target
-- @param attack_type Current attack type.  See nwn.ATTACK_TYPE_*
function Creature:GetEffectAttackBonus(vs, attack_type)
   local function valid(eff, vs_info)
      local type = eff:GetInt(1)
      if not (type == nwn.ATTACK_TYPE_MISC or attack_type == type) then
	 return false
      end

      -- If using versus info is globably disabled return true.
      if not NS_OPT_USE_VERSUS_INFO then return true end

      local race      = eff:GetInt(2)
      local lawchaos  = eff:GetInt(3)
      local goodevil  = eff:GetInt(4)
      local subrace   = eff:GetInt(5)
      local deity     = eff:GetInt(6)
      local vs        = eff:GetInt(7)

      if (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (vs == 0 or vs == vs_info.target)
      then
         return true
      end
      return false
   end

   local vs_info
   if NS_OPT_USE_VERSUS_INFO then
      vs_info = nwn.GetVersusInfo(vs)
   end
   local bon_idx, pen_idx = self:GetEffectArrays(bonus,
						 penalty,
						 vs_info,
						 AB_EFF_INFO,
						 ab_range,
						 valid,
						 ab_amount,
						 math.max,
						 self.stats.cs_first_ab_eff)

   local bon_total, pen_total = 0, 0
   
   for i = 0, bon_idx - 1 do
      if AB_EFF_INFO.stack then
	 bon_total = bon_total + bonus[i]
      else
	 bon_total = math.max(bon_total, bonus[i])
      end
   end

   for i = 0, pen_idx - 1 do
      if AB_EFF_INFO.stack then
	 pen_total = pen_total + penalty[i]
      else
	 pen_total = math.max(pen_total, penalty[i])
      end
   end

   return math.clamp(bon_total - pen_total, self:GetMinAttackBonusMod(), self:GetMaxAttackBonusMod())
end

--- Determines maximum attack bonus modifier.
function Creature:GetMaxAttackBonusMod()
   return 20
end

--- Determines minimum attack bonus modifier.
function Creature:GetMinAttackBonusMod()
   return -20
end