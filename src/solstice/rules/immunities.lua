--- Rules
-- @module rules

--- Immunities
-- @section immunities

local _IMM = {}

--- Get innate immunity.
-- @param imm IMMUNITY_TYPE_* constant.
-- @param cre Creature object.
local function GetInnateImmunity(imm, cre)
   local f = _IMM[imm]
   if not f then return 0 end
   return f(imm, cre)
end

--- Sets innate immunity override.
-- @param func Function taking a creature parameter and
-- returning a percent immunity.
-- @param ... List of IMMUNITY_TYPE_* constants.
local function SetInnateImmunityOverride(func, ...)
   local t = {...}
   assert(#t > 0, "At least one IMMUNITY_TYPE_* constnats must be specified!")
   for _, v in ipairs(t) do
      _IMM[v] = func
   end
end

local function crits(imm, cre)
   if cre:GetRacialType() == RACIAL_TYPE_UNDEAD
      or cre:GetRacialType() == RACIAL_TYPE_CONSTRUCT
   then
      return 100
   end
   if cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER) >= 10 then
      return 100
   end

   local mod = 0
   if OPT.TA then
      if cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 40 then
         return 100
      end
      if cre:GetIsPC() then
         mod = cre:GetAbilityScore(ABILITY_STRENGTH, true) * 2
         if cre:GetAbilityScore(ABILITY_DEXTERITY, true) >= 30 then
            mod = mod + cre:GetAbilityScore(ABILITY_DEXTERITY, true)
         end
      end
   end
   return mod
end

local function sneaks(imm, cre)
   if cre:GetRacialType() == RACIAL_TYPE_UNDEAD
      or cre:GetRacialType() == RACIAL_TYPE_CONSTRUCT
   then
      return 100
   end

   if cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER) >= 10 then
      return 100
   end

   local mod = 0
   if OPT.TA then
      if cre:GetIsPC() and cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 30 then
         return 100
      end
   end
   return mod
end

--- Determine if creature has an immunity.
-- @param cre Creature
-- @param imm_type IMMUNITY_TYPE_*
-- @param[opt] vs Creature's attacker.
local function GetEffectImmunity(cre, imm_type, vs)
   if imm_type == nil then
      error(debug.traceback())
   end
   if not cre:GetIsValid() or
      imm_type < 0 or imm_type >= IMMUNITY_TYPE_NUM
   then
      return 0
   end

   if OPT.USE_VERSUS then
      error "Net yet implimented"
   end

   local innate = GetInnateImmunity(imm_type, cre)
   return math.max(cre['SOL_IMMUNITY_MISC']:get(imm_type) + innate, innate)
end

SetInnateImmunityOverride(crits, IMMUNITY_TYPE_CRITICAL_HIT)
SetInnateImmunityOverride(sneaks, IMMUNITY_TYPE_SNEAK_ATTACK)

local M = require 'solstice.rules.init'
M.GetInnateImmunity = GetInnateImmunity
M.SetInnateImmunityOverride = SetInnateImmunityOverride
M.GetEffectImmunity = GetEffectImmunity
