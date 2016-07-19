--- Rules
-- @module rules

--- Abilities
-- @section ability

local ffi = require 'ffi'

local function GetAbilityName(ability)
   return Game.GetTlkString(Game.Get2daInt("abilities", "Name", ability))
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
local ABILITY_EFF = ffi.cast('int32_t*', ffi.C.malloc(4 * ABILITY_NUM))
local function GetAbilityEffectModifier(cre, ability)
  for i=0, ABILITY_NUM -1 do
     ABILITY_EFF[i] = 0
  end

  if cre.obj.obj.obj_effects_len <= 0 then return 0 end
  if cre.obj.cre_stats.cs_first_ability_eff > 0 then
    for i = cre.obj.cre_stats.cs_first_ability_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ABILITY_INCREASE
        and cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_ABILITY_DECREASE
      then
        break
      end

      local abtype = cre.obj.obj.obj_effects[i].eff_integers[0]
      local amt = cre.obj.obj.obj_effects[i].eff_integers[1]

      if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ABILITY_INCREASE then
        ABILITY_EFF[abtype] = ABILITY_EFF[abtype] + amt
      else
        ABILITY_EFF[abtype] = ABILITY_EFF[abtype] - amt
      end
    end
  end

  if ability then
    return ABILITY_EFF[ability]
  else
    return ABILITY_EFF
  end
end


local function DebugAbilities(cre)
  local ABIL_FMT = "  %s: Total: %d (%d), Modifier: %d (%d), Effect: %d, Limits: %d-%d"
  local t = { "Abilities: "}
  for i=0, ABILITY_NUM - 1 do
    local low, high = GetAbilityEffectLimits(cre, i)
    table.insert(t,
      string.format(ABIL_FMT,
        GetAbilityName(i),
        cre:GetAbilityScore(i),
        cre:GetAbilityScore(i, true),
        cre:GetAbilityModifier(i),
        cre:GetAbilityModifier(i, true),
        GetAbilityEffectModifier(cre, i),
        low,
        high))
  end
  return table.concat(t, '\n')
end

local M = require 'solstice.rules.init'
M.GetAbilityEffectLimits = GetAbilityEffectLimits
M.GetAbilityEffectModifier = GetAbilityEffectModifier
M.GetAbilityName = GetAbilityName
M.DebugAbilities = DebugAbilities