--- Rules module
-- @module rules

local _DMG_IMM = {}
local _DMG_RED = {}

--- Get base damage immunity.
-- @param cre Creature object.
-- @param dmgidx DAMAGE\_INDEX\_*
local function GetBaseDamageImmunity(cre, dmgidx)
   local f = _DMG_IMM[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage immunity override function.
-- @param dmgidx DAMAGE\_INDEX\_*
-- @func func (creature) -> int
local function SetBaseDamageImmunityOverride(dmgidx, func)
   _DMG_IMM[dmgidx] = func
end

--- Get base damage reduction.
-- @param cre Creature object.
local function GetBaseDamageReduction(cre)
   return 0
end

--- Sets a damage resistance override function.
-- @func func (creature) -> int
local function SetBaseDamageReductionOverride(func)
   GetBaseDamageReductionOverride = func
end

--- Get base damage reduction.
-- @param cre Creature object.
-- @param dmgidx DAMAGE\_INDEX\_*
local function GetBaseDamageResistance(cre, dmgidx)
   local f = _DMG_RED[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage resistance override function.
-- @param dmgidx DAMAGE\_INDEX\_*
-- @func func (creature) -> int
local function SetBaseDamageResistanceOverride(dmgidx, func)
   _DMG_RED[dmgidx] = func
end

local M = require 'solstice.rules.init'
M.GetBaseDamageImmunity           = GetBaseDamageImmunity
M.SetBaseDamageImmunityOverride   = SetBaseDamageImmunityOverride
M.GetBaseDamageReduction          = GetBaseDamageReduction
M.GetBaseDamageResistance         = GetBaseDamageResistance
M.SetBaseDamageResistanceOverride = SetBaseDamageResistanceOverride
