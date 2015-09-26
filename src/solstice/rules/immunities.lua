--- Rules
-- @module rules

--- Immunities
-- @section immunities

local _IMM = {}

--- Get innate immunity.
-- @param imm IMMUNITY_TYPE_* constant.
-- @param cre Creature object.
local function GetInnateImmunity(cre, imm)
   local f = _IMM[imm]
   if not f then return 0 end
   return f(cre, imm)
end

--- Sets innate immunity override.
-- @param func Function taking a creature parameter and
-- returning a percent immunity.
-- @param ... List of IMMUNITY_TYPE_* constants.
local function SetInnateImmunityOverride(func, ...)
   local t = table.pack(...)
   for i=1, t.n do
      if not t[i] then
         local Log = System.GetLogger()
         Log:error('Null immunity constant has been passed.  Stacktrace: %s', debug.traceback())
      else
         _IMM[t[i]] = func
      end
   end
end

local function GetEffectImmunityModifier(cre, imm, vs)
   local res = 0
   if cre.obj.obj.obj_effects_len <= 0 then return 0 end
   for i = cre.obj.cre_stats.cs_first_imm_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_IMMUNITY then
         break
      end
      local immtype = cre.obj.obj.obj_effects[i].eff_integers[0]
      if immtype >= 0
         and immtype < IMMUNITY_TYPE_NUM
         and immtype == imm
      then
         local amt = cre.obj.obj.obj_effects[i].eff_integers[4]
         amt = amt == 0 and 100 or amt
         res = res + amt
      end
   end
   for i = cre.obj.obj.obj_effects_len - 1, 0, -1 do
      if cre.obj.obj.obj_effects[i].eff_type < SOL_EFFECT_TYPE_IMMUNITY_DECREASE then
         break
      end
      if cre.obj.obj.obj_effects[i].eff_type == SOL_EFFECT_TYPE_IMMUNITY_DECREASE then
      local immtype = cre.obj.obj.obj_effects[i].eff_integers[0]
         if immtype >= 0
            and immtype < IMMUNITY_TYPE_NUM
            and immtype == imm
         then
            local amt = cre.obj.obj.obj_effects[i].eff_integers[1]
            res = res - amt
         end
      end
   end
   return res
end

local function GetEffectImmunityLimits(cre)
  return 0, 100
end

local function crits(cre, imm)
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

local function sneaks(cre, imm)
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
local function GetEffectImmunity(cre, imm, vs)
   if imm == nil then
      error(debug.traceback())
   end
   if not cre:GetIsValid() or
      imm < 0 or imm >= IMMUNITY_TYPE_NUM
   then
      return 0
   end

   if OPT.USE_VERSUS then
      error "Net yet implimented"
   end

   local innate = GetInnateImmunity(cre, imm)
   local effect = GetEffectImmunityModifier(cre, imm)
   return math.max(effect + innate, innate)
end

SetInnateImmunityOverride(crits, IMMUNITY_TYPE_CRITICAL_HIT)
SetInnateImmunityOverride(sneaks, IMMUNITY_TYPE_SNEAK_ATTACK)

local function DebugEffectImmunities(cre)
   local t = {"Immunities:"}
   for i=0, IMMUNITY_TYPE_NUM - 1 do
      local innate = GetInnateImmunity(cre, i)
      local effect = GetEffectImmunityModifier(cre, i)
      table.insert(t, string.format("  %d: Innate: %d, Effect: %d", i, innate, effect))
   end
   return table.concat(t, '\n')
end

local M = require 'solstice.rules.init'
M.DebugEffectImmunities = DebugEffectImmunities
M.GetEffectImmunity = GetEffectImmunity
M.GetEffectImmunityLimits = GetEffectImmunityLimits
M.GetEffectImmunityModifier = GetEffectImmunityModifier
M.GetInnateImmunity = GetInnateImmunity
M.SetInnateImmunityOverride = SetInnateImmunityOverride