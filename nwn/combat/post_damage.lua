local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveDevCrit(attacker, target, attack_info)
   if not NSGetIsCriticalHit(attack_info) 
      or NS_OPT_DEVCRIT_DISABLE_ALL 
      or (NS_OPT_DEVCRIT_DISABLE_PC and attacker:GetIsPC())
   then
      return
   end

   local dc = 10 + math.floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(nwn.ABILITY_STRENGTH)

   if target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_DEATH, attacker) == 0 then
      local eff = nwn.EffectDeath(true, true)
      eff:SetSubType(nwn.SUBTYPE_SUPERNATURAL)
      target:ApplyEffect(nwn.DURATION_TYPE_INSTANT, eff)

      NSSetAttackResult(attack_info, 10)
   end
end
