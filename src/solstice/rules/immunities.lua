--- Rules
-- @module rules

--- Immunities
-- @section immunities

local _IMM = {}

--- Get innate immunity.
-- @param imm IMMUNITY\_TYPE\_* constant.
-- @param cre Creature object.
local function GetInnateImmunity(imm, cre)
   local f = _IMM[imm]
   if not f then return 0 end
   return f(imm, cre)
end

--- Sets innate immunity override.
-- @param func Function taking a creature parameter and
-- returning a percent immunity.
-- @param ... List of IMMUNITY\_TYPE\_* constants.
local function SetInnateImmunityOverride(func, ...)
   local t = {...}
   assert(#t > 0, "At least one IMMUNITY_TYPE_* constnats must be specified!")
   for _, v in ipairs(t) do
      _IMM[v] = func
   end
end

local M = require 'solstice.rules.init'
M.GetInnateImmunity = GetInnateImmunity
M.SetInnateImmunityOverride = SetInnateImmunityOverride
