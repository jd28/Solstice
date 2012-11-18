require 'nwn.constants'
require 'nwn.specattack'

local function resolve_sap(attacker, target, attack_info)
   -- Determine attack roll from attack ctype
   local ab = NSGetAttackRoll(attack_info)
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:GetIsSkillSuccessful(nwn.SKILL_DISCIPLINE, ab, attacker, true) then
      local eff = nwn.EffectDazed()
      eff:SetDurationType(nwn.DURATION_TYPE_TEMPORARY)
      eff:SetDuration(12.0)
      return true, eff
   end
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_SAP,
   resolve_sap,
   function () return -4 end)