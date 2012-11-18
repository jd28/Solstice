require 'nwn.constants'
require 'nwn.specattack'

-- This file contains example Knockdown special attack.

local function resolve_kd(attacker, target, attack_info)
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
   local ab = NSGetAttackRoll(attack_info)
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab, attacker,
				      false, 0, 0, 0, dc_mod)
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
   function()
      -- -4 AB when using Knockdown
      return -4
   end)

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_KNOCKDOWN_IMPROVED,
   -- See local function above for (Improved) Knocdown for resolving knockdown
   resolve_kd)
