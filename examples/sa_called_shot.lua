require 'nwn.constants'
require 'nwn.specattack'

-- Called Shot Arm
local function csarm_resolve(attacker, target, attack)
   -- Determine attack roll from attack ctype
   local ab = attack.cad_attack_roll + attack.cad_attack_mod
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab, attacker) then
      local eff = nwn.EffectAttackBonus(-2)
      target:ApplyEffect(eff, nwn.RoundToSeconds(4))
   end
end

-- Register the melee version
nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_ARM,
   csarm_resolve,
   -- Attack Bonus modifier.
   function(attacker, target, attack)
      -- Called shots are made at a -4 attack penalty
      return -4
   end,
   -- Damage bonus modifier
   function(attacker, target, attack)
      local dice, sides, bonus = 0, 0, 0
      local type = nwn.DAMAGE_TYPE_BASE_WEAPON
      -- No damage bonus modification
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return dice, sides, bonus, type
   end)

-- Register the range version, which happens to be identical
nwn.RegisterRangedSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_ARM,
   csarm_resolve,
   -- Attack Bonus modifier.
   function(attacker, target, attack)
      -- Called shots are made at a -4 attack penalty
      return -4
   end,
   -- Damage bonus modifier
   function(attacker, target, attack)
      local dice, sides, bonus = 0, 0, 0
      local type = nwn.DAMAGE_TYPE_BASE_WEAPON
      -- No damage bonus modification on Improved Knockdown
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return dice, sides, bonus, type
   end)

----------------------------------------------------------------------------------------
-- Called Shot Leg
local function csleg_resolve(attacker, target, attack)
   -- Determine attack roll from attack ctype
   local ab = attack.cad_attack_roll + attack.cad_attack_mod
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab, attacker) then
      local eff = nwn.EffectMovementSpeed(-20)
      eff = nwn.EffectLinkEffects(eff, nwn.EffectAbility(nwn.ABILITY_DEXTERITY, -2))
      target:ApplyEffect(eff, nwn.RoundToSeconds(4))
   end
end

-- Register the melee version
nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_LEG,
   csleg_resolve,
   -- Attack Bonus modifier.
   function(attacker, target, attack)
      -- Called shots are made at a -4 attack penalty
      return -4
   end,
   -- Damage bonus modifier
   function(attacker, target, attack)
      local dice, sides, bonus = 0, 0, 0
      local type = nwn.DAMAGE_TYPE_BASE_WEAPON
      -- No damage bonus modification on Improved Knockdown
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return dice, sides, bonus, type
   end)

-- Register the range version, which happens to be identical
nwn.RegisterRangedSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_CALLED_SHOT_LEG,
   csleg_resolve,
   -- Attack Bonus modifier.
   function(attacker, target, attack)
      -- Called shots are made at a -4 attack penalty
      return -4
   end,
   -- Damage bonus modifier
   function(attacker, target, attack)
      local dice, sides, bonus = 0, 0, 0
      local type = nwn.DAMAGE_TYPE_BASE_WEAPON
      -- No damage bonus modification
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return dice, sides, bonus, type
   end)
