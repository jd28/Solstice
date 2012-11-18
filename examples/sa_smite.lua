require 'nwn.constants'
require 'nwn.specattack'

local function smite_ab_good(attacker, target)
   if target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_GOOD then
      return attacker:GetAbilityModifier(nwn.ABILITY_CHARISMA)
   end
   return 0
end

local function smite_good(attacker, target, attack_info)
   -- Attacker didn't hit or the target isn't valid, no damage.
   if not NSGetAttackResult(attack_info) 
      or target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_GOOD
   then
      return false
   end
   -- Add smite good message
   NSAddAttackFeedback(attack_info, 239)

   return true
end

local function smite_dmg_good(attacker, target, attack_info)
   -- Attacker didn't hit or the target isn't valid, no damage.
   if not NSGetAttackResult(attack) 
   then
      return
   end

   if target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_GOOD then
      return
   end

   local level = attacker:GetLevelByClass(nwn.CLASS_TYPE_BLACKGUARD)
   local dmg = level
   local great = attacker:GetHighestFeatInRange(nwn.FEAT_EPIC_GREAT_SMITING_1,
						nwn.FEAT_EPIC_GREAT_SMITING_10)
   if great ~= -1 then
      dmg = dmg + (level * (great - nwn.FEAT_EPIC_GREAT_SMITING_1 + 1))
   end

   return nwn.DAMAGE_TYPE_NEGATIVE, dice_roll_t(0, 0, dmg) 
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_SMITE_GOOD,
   smite_good,
   smite_ab_good,
   smite_dmg_good)

--------------------------------------------------------------------------------
--nwn.SPECIAL_ATTACK_TRUE_SMITE_EVIL

local function smite_ab_evil(attacker, target)
   if target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_EVIL then
      return attacker:GetAbilityModifier(nwn.ABILITY_CHARISMA)
   end
   return 0
end

local function smite_evil(attacker, target, attack_info)
   -- Attacker didn't hit or the target isn't valid, no damage.
   if not NSGetAttackResult(attack_info) 
      or target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_EVIL
   then
      return false
   end
   -- Add smite message
   NSAddAttackFeedback(attack_info, 239)
   return true
end

local function smite_dmg_evil(attacker, target, attack_info)
   -- Attacker didn't hit or the target isn't valid, no damage.
   if not NSGetAttackResult(attack) 
   then
      return
   end

   if target:GetAlignmentGoodEvil() ~= nwn.ALIGNMENT_EVIL then
      return
   end

   local level = attacker:GetLevelByClass(nwn.CLASS_TYPE_DIVINE_CHAMPION)
      + attacker:GetLevelByClass(nwn.CLASS_TYPE_PALADIN)
   local dmg = level
   local great = attacker:GetHighestFeatInRange(nwn.FEAT_EPIC_GREAT_SMITING_1,
						nwn.FEAT_EPIC_GREAT_SMITING_10)
   if great ~= -1 then
      dmg = dmg + (level * (great - nwn.FEAT_EPIC_GREAT_SMITING_1 + 1))
   end

   return nwn.DAMAGE_TYPE_DIVINE, dice_roll_t(0, 0, dmg) 
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_SMITE_EVIL,
   smite_evil,
   smite_ab_evil,
   smite_dmg_evil)
