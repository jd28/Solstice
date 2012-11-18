require 'nwn.constants'
require 'nwn.specattack'

local function resolve_quiver(attacker, target, attack_info)
   if target:GetIsImmuneToCriticalHits()
      or target:GetRacialType() == nwn.RACIAL_TYPE_CONSTRUCT
   then
      return false
   end

   local dc = 10 + (attacker:GetLevelByClass(nwn.CLASS_TYPE_MONK) / 2) +
      attacker:GetAbilityModifier(nwn.ABILITY_WISDOM)
   
   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_DEATH, attacker) then
      local eff = nwn.EffectDeath()
      eff:SetDurationType(nwn.DURATION_TYPE_INSTANT)
      return true, eff
   end

   return false
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_QUIVERING_PALM,
   resolve_quiver)

local function resolve_stunning(attacker, target, attack_info)
   if target:GetIsImmuneToCriticalHits()
      or target:GetRacialType() == nwn.RACIAL_TYPE_CONSTRUCT
   then
      return false
   end

   local dc = 10 + (attacker:GetLevelByClass(nwn.CLASS_TYPE_MONK) / 2) +
      attacker:GetAbilityModifier(nwn.ABILITY_WISDOM)
   
   -- TODO Improved Stunning Fists...
   local improv = attacker:GetHighestFeatInRange(nwn.FEAT_EPIC_IMPROVED_STUNNING_FIST_1,
						 nwn.FEAT_EPIC_IMPROVED_STUNNING_FIST_10)
   if improv ~= -1 then
      dc = dc + (2 * (improv - nwn.FEAT_EPIC_IMPROVED_STUNNING_FIST_1 + 1))
   end

   -- If target fails a skill check versus attacker apply knockdown for 1 round.
   if not target:FortitudeSave(dc, nwn.SAVING_THROW_TYPE_MIND_SPELLS, attacker) then
      local eff = nwn.EffectStunned()
      eff:SetDurationType(nwn.DURATION_TYPE_TEMPORARY)
      eff:SetDuration(nwn.RoundsToSeconds(3))
      return true, eff
   end

   return false
end

nwn.RegisterMeleeSpecialAttack(
   nwn.SPECIAL_ATTACK_TRUE_STUNNING_FIST,
   resolve_stunning,
   function () return -4 end)