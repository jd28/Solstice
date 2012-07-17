local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

function NSResolveDevCrit(attacker, target, attack_info)
   if NS_OPT_DEVCRIT_DISABLE_ALL then
      return
   end

   if NS_OPT_DEVCRIT_DISABLE_PC and attacker:GetIsPC() then
      return
   end

   local dc = 10 + math.floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(nwn.ABILITY_STRENGTH)
   --print("NSResolveDevCrit", dc)
   if target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_DEATH, attacker) == 0 then
      local eff = nwn.EffectDeath(true, true)
      eff:SetSubType(nwn.SUBTYPE_SUPERNATURAL)
      target:ApplyEffect(nwn.DURATION_TYPE_INSTANT, eff)

      attack_info.attack.cad_attack_result = 10
   end
end

function NSResolvePostMeleeDamage(attacker, target, attack_info)
   if not target:GetIsValid() 
      or target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE 
   then 
      return 
   end

   NSResolveDevCrit(attacker, target, attack_info)
end

function NSResolvePostRangedDamage(attacker, target, attack_data)
   if not target:GetIsValid() 
      or target.type ~= nwn.GAME_OBJECT_TYPE_CREATURE
   then 
      return
   end

   local cr = attacker.obj.cre_combat_round
end
