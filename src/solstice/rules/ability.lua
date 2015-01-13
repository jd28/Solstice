--- Rules
-- @module rules

local TLK = require 'solstice.tlk'
local TDA = require 'solstice.2da'

--- Abilities
-- @section ability

local function GetAbilityName(ability)
   return TLK.GetString(TDA.Get2daInt("abilities", "Name", ability))
end

--- Get the limits of ability effects
-- @param cre Creature object.
-- @param ability ABILITY_*
-- @return Minimum Default: -12
-- @return Maximum Default: 12
local function GetAbilityEffectLimits(cre, ability)
   return -12, 12
end

--- Get ability modification from effects.
-- @param cre Creature object.
-- @param ability ABILITY_*
-- @return Total amount, uncapped
local function GetAbilityEffectModifier(cre, ability)
   local eff = 0
   if cre.obj.cre_stats.cs_first_ability_eff > 0 then
      for i = cre.obj.cre_stats.cs_first_ability_eff, cre.obj.obj.obj_effects_len - 1 do
         if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ABILITY_INCREASE
            and cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ABILITY_DECREASE
         then
            break
         end
         if cre.obj.obj.obj_effects[i].eff_integers[0] == ability then
            if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ABILITY_INCREASE then
               eff = eff + cre.obj.obj.obj_effects[i].eff_integers[1]
            else
               eff = eff - cre.obj.obj.obj_effects[i].eff_integers[1]
            end
         end
      end
   end
   return eff
end

local M = require 'solstice.rules.init'
M.GetAbilityEffectLimits = GetAbilityEffectLimits
M.GetAbilityEffectModifier = GetAbilityEffectModifier
M.GetAbilityName = GetAbilityName
