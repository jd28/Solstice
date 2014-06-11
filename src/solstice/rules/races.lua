--- Rules
-- @module rules

local ffi = require 'ffi'
local C = ffi.C

--- Races
-- @section rules.races.

--- Determine race's ability bonus.
-- @param race RACIAL\_TYPE\_*
-- @param ability ABILITY\_*
local function GetRaceAbilityBonus(race, ability)
   local r = C.nwn_GetRace(race)
   if r == nil then return 0 end

   if ability == ABILITY_STRENGTH then
      return r.ra_str_adjust
   elseif ability == ABILITY_DEXTERITY then
      return r.ra_dex_adjust
   elseif ability == ABILITY_CONSTITUTION then
      return r.ra_con_adjust
   elseif ability == ABILITY_INTELLIGENCE then
      return r.ra_int_adjust
   elseif ability == ABILITY_WISDOM then
      return r.ra_wis_adjust
   elseif ability == ABILITY_CHARISMA then
      return r.ra_cha_adjust
   end
   return 0
end

local M = require 'solstice.rules.init'
M.GetRaceAbilityBonus = GetRaceAbilityBonus
