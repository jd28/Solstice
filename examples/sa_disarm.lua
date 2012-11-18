----------------------------------------------------------------------------------------
-- (Improved) Disarm
local function resolve_disarm(attacker, target, attack_info)
   local asize = attacker:GetSize()
   local tsize = target:GetSize()

   -- target gets +4 for every size larger than the attacker and -4
   -- for every size smaller.  Since the difference can only be 1, 0, -1
   -- we can just check which is greater and less than.
   local dc_mod = 0
   if tsize > asize then
      bonus = 4
   elseif tsize < asize then
      dc_mod = 4
   end

   -- Determine attack roll from attack ctype
   local ab = NSGetAttackRoll(attack_info)
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab + dc_mod, attacker,
				      true, 0, 0, bonus)
   then
      local eff = nwn.EffectDisarm()
      eff:SetDurationType(nwn.DURATION_TYPE_INSTANT)
      return true, eff
   end
   return false
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_DISARM,
   -- See local function above for (Improved) Disarm for resolving knockdown
   resolve_disarm,
   -- Attack Bonus modifier.
   function()
      -- -6 AB when using Disarm
      return -6
   end)

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_DISARM_IMPROVED,
   -- See local function above for (Improved) Disarm for resolving knockdown
   resolve_disarm,
   -- Attack Bonus modifier.
   function()
      -- -4 AB when using Improved Disarm
      return -4
   end)