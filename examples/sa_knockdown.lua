require 'nwn.constants'
require 'nwn.specattack'

-- This file contains example Knockdown special attack.

local function resolve_kd(attacker, target, attack)
   local success = false
   local eff
   local asize = attacker:GetSize()
   local tsize = target:GetSize()

   -- A creature can only knockdown another that is within one creature
   -- size of its own.
   local size_diff = math.abs(asize - tsize)
   if size_diff > 1 then 
      return false
   end

   -- target gets +4 for every size larger than the attacker and -4
   -- for every size smaller.  Since the difference can only be 1, 0, -1
   -- we can just check which is greater and less than.
   local dc_mod = 0
   if tsize > asize then
      dc_mod = 4
   elseif tsize < asize then
      dc_mod = -4
   end

   -- Determine attack roll from attack ctype
   local ab = attack.cad_attack_roll + attack.cad_attack_mod
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab, attacker,
				      true, 0, 0, 0, dc_mod)
   then
      local eff = nwn.EffectKnockdown()
      eff:SetDurationType(nwn.DURATION_TYPE_TEMPORARY)
      eff:SetDuration(6.0)
      return true, eff
   end

   return false
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_KNOCKDOWN,
   -- See local function above for (Improved) Knocdown for resolving knockdown
   resolve_kd,
   -- Attack Bonus modifier.
   function(attacker, target)
      -- -4 AB when using Knockdown
      return -4
   end,
   function(attacker, target)
      local dice, sides, bonus = 0, 0, 0
      local type = nwn.DAMAGE_TYPE_BASE_WEAPON
      -- No damage bonus modification on Improved Knockdown
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return dice, sides, bonus, type
   end)

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_KNOCKDOWN_IMPROVED,
   -- See local function above for (Improved) Knocdown for resolving knockdown
   resolve_kd,
   -- Attack Bonus modifier.
   function(attacker, target, attack)
      -- No attack bonus modification on Improved Knockdown
      -- This function need not be passed to nwn.RegisterMeleeSpecialAttack
      -- It is here for illustrative purposes only.
      return 0
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
