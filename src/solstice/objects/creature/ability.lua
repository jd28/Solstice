----
-- @module creature

--- Abilites
-- @section abilities

local ffi = require "ffi"
local C = ffi.C

local M = require 'solstice.objects.init'
local Creature = M.Creature
local floor = math.floor

require 'solstice.effect'

--- Gets ability score that was raised at a particular level.
-- @return ABILITY_* or -1 on error.
function Creature:GetAbilityIncreaseByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = C.nwn_GetLevelStats(self.obj.cre_stats, level)
   if ls == nil then return -1 end

   return ls.ls_ability
end

--- Get the ability score of a specific type for a creature.
-- NWScript: GetAbilityModifier
-- @param ability ABILITY_*.
-- @param[opt=false] base If true will return the base ability score
-- without bonuses (e.g. ability bonuses granted from equipped
-- items). If nothing entered, defaults to false.
-- @return Returns the ability score of type `ability`
-- (otherwise -1).
function Creature:GetAbilityModifier(ability, base)
    local result = -1

    if base then
       result = floor((self:GetAbilityScore(ability, base) - 10) / 2)
    else
       if ability == ABILITY_STRENGTH then
          result = self.obj.cre_stats.cs_str_mod
       elseif ability == ABILITY_DEXTERITY then
          -- Dex may need to change.
          result = self:GetDexMod()
       elseif ability == ABILITY_CONSTITUTION then
          result = self.obj.cre_stats.cs_con_mod
       elseif ability == ABILITY_INTELLIGENCE then
          result = self.obj.cre_stats.cs_int_mod
       elseif ability == ABILITY_WISDOM then
          result = self.obj.cre_stats.cs_wis_mod
       elseif ability == ABILITY_CHARISMA then
          result = self.obj.cre_stats.cs_cha_mod
       end
    end

    return result
end

--- Get the ability score of a specific type for a creature.
-- NWScript: GetAbilityScore
-- @param ability ABILITY_*.
-- @param[opt=false] base If `true` will return the base ability score
-- without bonuses (e.g. ability bonuses granted from equipped
-- items). If nothing entered, defaults to false.
-- @return Returns the ability score of type ability for self
-- (otherwise -1).
function Creature:GetAbilityScore(ability, base)
   local result = -1

   if ability == ABILITY_STRENGTH then
      result = self.obj.cre_stats.cs_str
   elseif ability == ABILITY_DEXTERITY then
      result = self.obj.cre_stats.cs_dex
   elseif ability == ABILITY_CONSTITUTION then
      result = self.obj.cre_stats.cs_con
   elseif ability == ABILITY_INTELLIGENCE then
      result = self.obj.cre_stats.cs_int
   elseif ability == ABILITY_WISDOM then
      result = self.obj.cre_stats.cs_wis
   elseif ability == ABILITY_CHARISMA then
      result = self.obj.cre_stats.cs_cha
   end
   result = result + Rules.GetRaceAbilityBonus(self:GetRacialType(), ability)

   if not base then
      local min, max = Rules.GetAbilityEffectLimits(self, ability)
      local eff = Rules.GetAbilityEffectModifier(self, ability)
      result = result + math.clamp(eff, min, max)
   end
   return result
end

--- Gets a creatures dexterity modifier.
-- @param[opt=false] armor_check If true uses armor check penalty.
function Creature:GetDexMod(armor_check)
   return C.nwn_GetDexMod(self.obj.cre_stats, armor_check and 1 or 0)
end

--- Modifies the ability score of a specific type for a creature.
-- NWScript: nwnx_funcs by Acaos.
-- @param ability ABILITY_*.
-- @param value Amount to modify ability score
-- @return Returns the ability score of type ability for self
-- (otherwise -1).
function Creature:ModifyAbilityScore(ability, value)
    local abil = self:GetAbilityScore(ability, true) + value

    return self:SetAbilityScore(ability, abil)
end

--- Recalculates a creatures dexterity modifier.
function Creature:RecalculateDexModifier()
   if not self:GetIsValid() then return -1 end

   return C.nwn_RecalculateDexModifier(self.obj.cre_stats)
end

--- Sets the ability score of a specific type for a creature.
-- NWScript: nwnx_funcs by Acaos.
-- @param ability ABILITY_*.
-- @param value Amount to modify ability score
-- @return Returns the ability score of type ability for self
-- (otherwise -1).
function Creature:SetAbilityScore(ability, value)
   if not self:GetIsValid() then return -1 end
   value = math.clamp(value - Rules.GetRaceAbilityBonus(self:GetRacialType(), ability), 3, 255)
   return C.nwn_SetAbilityScore(self.obj.cre_stats, ability, value)
end

local fmt = string.format
local tinsert = table.insert

--- Create Ability debug string.
function Creature:DebugAbilities()
   local t = {}
   tinsert(t, "Abilities: ")
   for i = 0, ABILITY_NUM - 1 do
      local min, max = Rules.GetAbilityEffectLimits(self, i)
      local eff = Rules.GetAbilityEffectModifier(self, i)
      tinsert(t, fmt("  %s: Base: %d, Effects: %d, Clamp: (%d, %d, %d), Total: %d",
                     Rules.GetAbilityName(i),
                     self:GetAbilityScore(i, true),
                     math.clamp(eff, min, max),
                     eff,
                     min,
                     max,
                     self:GetAbilityScore(i, false)))

      tinsert(t, fmt("    Modifer: %d, Base: %d",
                     self:GetAbilityModifier(i, false),
                     self:GetAbilityModifier(i, true)))

   end
   return table.concat(t, "\n")
end
