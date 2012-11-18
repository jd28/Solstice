require 'nwn.constants'
require 'nwn.specattack'

local function called_shot_ab() return -4 end

----------------------------------------------------------------------------------------
-- Called Shot Arm
-- Skill Check: Attack Roll vs Discipline.
-- Event:
--    Resolve: -2 AB to target for 4 rounds.
--    Resolve AB: -4 to attack roll.
--    Resolve Damage: NONE

local function csarm_resolve(attacker, target, attack_info)
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, NSGetAttackRoll(attack_info), attacker) then
      local eff = nwn.EffectAttackBonus(-2)
      eff:SetDuration(nwn.RoundToSeconds(4))
      return true, eff
   end
end

-- Register the melee version
nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_ARM,
   csarm_resolve,
   -- Attack Bonus modifier.
   called_shot_ab)

-- Register the range version, which happens to be identical
nwn.RegisterRangedSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_ARM,
   csarm_resolve,
   -- Attack Bonus modifier.
   called_shot_ab)

----------------------------------------------------------------------------------------
-- Called Shot Leg
-- Skill Check: Attack Roll vs Discipline.
-- Event:
--    Resolve: -20% Movement Rate, -2 Dexterity to target for 4 rounds.
--    Resolve AB: -4 to attack roll.
--    Resolve Damage: NONE
local function csleg_resolve(attacker, target, attack)
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, NSGetAttackRoll(attack_info), attacker) then
      local eff = nwn.EffectMovementSpeed(-20)
      eff = nwn.EffectLinkEffects(eff, nwn.EffectAbility(nwn.ABILITY_DEXTERITY, -2))
      eff:SetDuration(nwn.RoundToSeconds(4))
      return true, eff
   end
end

-- Register the melee version
nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_LEG,
   csleg_resolve,
   -- Attack Bonus modifier.
   called_shot_ab)

-- Register the range version, which happens to be identical
nwn.RegisterRangedSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_LEG,
   csleg_resolve,
   -- Attack Bonus modifier.
   called_shot_ab)
