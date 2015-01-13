--- Rules module
-- @module rules

local _DMG_IMM = {}
local _DMG_RED = {}

--- Damage Modifiers
-- @section

--- Get base damage immunity.
-- @param cre Creature object.
-- @param dmgidx DAMAGE_INDEX_*
local function GetBaseDamageImmunity(cre, dmgidx)
   local f = _DMG_IMM[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage immunity override function.
-- @func func (creature) -> int
-- @param ... DAMAGE_INDEX_*
local function SetBaseDamageImmunityOverride(func, ...)
   local t = {...}
   assert(#t > 0, "At least one DAMAGE_INDEX_* constant must be specified!")

   for _, v in ipairs({...}) do
      _DMG_IMM[v] = func
   end
end

local function rdd(cre)
   local res = 0
   if cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 10 then
      res = 100
   end
   return res
end

SetBaseDamageImmunityOverride(rdd, DAMAGE_INDEX_FIRE)


--- Get base damage reduction.
-- @param cre Creature object.
local function GetBaseDamageReduction(cre)
   local res = 0
   if cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9) then
      res = res + 9
   elseif cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6) then
      res = res + 6
   elseif cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3) then
      res = res + 3
   end

   local barb = cre:GetLevelByClass(CLASS_TYPE_BARBARIAN)
   if barb > 10 then
      res = res + math.ceil((barb - 10) / 3)
   end

   local dd =  cre:GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER)
   if dd > 5 then
      res = res + 3 + (math.floor((dd - 6) / 4) * 3)
   end
   return res
end

--- Get base damage reduction.
-- @param cre Creature object.
-- @param dmgidx DAMAGE_INDEX_*
local function GetBaseDamageResistance(cre, dmgidx)
   local f = _DMG_RED[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage resistance override function.
-- @func func (creature) -> int
-- @param ... DAMAGE_INDEX_*
local function SetBaseDamageResistanceOverride(func, ...)
  local t = {...}
  for _, dmg in ipairs(t) do
    _DMG_RED[dmg] = func
  end
end

local M = require 'solstice.rules.init'
M.GetBaseDamageImmunity           = GetBaseDamageImmunity
M.SetBaseDamageImmunityOverride   = SetBaseDamageImmunityOverride
M.GetBaseDamageReduction          = GetBaseDamageReduction
M.GetBaseDamageResistance         = GetBaseDamageResistance
M.SetBaseDamageResistanceOverride = SetBaseDamageResistanceOverride
