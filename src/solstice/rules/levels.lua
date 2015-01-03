local C = require('ffi').C
local TDA = require 'solstice.2da'

--- Determine XP requirements for level.
-- @param level Character level
local function GetXPLevelRequirement(level)
   return TDA.Get2daInt('exptable', 'XP', level - 1)
end

--- Determine if an ability score is gained on level up.
-- @param level Character level
local function GetGainsStatOnLevelUp(level)
   if level <= 40 then return (level % 4) == 0 end
   return (level % 2) == 0
end

--- Determine if a feat is gained on level up.
-- @param level Character level
local function GainsFeatAtLevel(level)
   return level % 3 == 0
end

local M = require 'solstice.rules.init'
M.GetXPLevelRequirement = GetXPLevelRequirement
M.GetGainsStatOnLevelUp = GetGainsStatOnLevelUp
M.GainsFeatAtLevel      = GainsFeatAtLevel
