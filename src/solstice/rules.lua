local ffi = require 'ffi'
local bit = require 'bit'
local C = ffi.C
local TLK = require 'solstice.tlk'
local TDA = require 'solstice.2da'

local M = {}

--- Get skill's associated ability.
-- @return solstice.ability type constant
function M.GetSkillAbility(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return -1 end

   return sk.sk_ability
end

--- Check if skill has armor check penalty.
function M.SkillHasArmorCheckPenalty(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return false end

   return sk.sk_armor_check ~= 0
end

--- Get Skill name.
function M.GetSkillName(skill)
   sk = C.nwn_GetSkill(skill)
   if sk == nil then return "" end

   return TLK.GetString(sk.sk_name_strref)
end

local FEAT_USES = {}

---
-- @param feat
-- @param[opt] cre Creature instance.
function M.GetMaximumFeatUses(feat, cre)
   local f = FEAT_USES[feat]
   if not f then
      local tda = TDA.Get2daString("feat", "USESPERDAY", feat)
      return tonumber(tda) or 100
   end

   return f(feat, cre)
end

--- Register a function to determine maximum feat uses.
-- @param func A function taking two argument, a Creature instance and
-- and a solstice.feat constant
-- @param ... Vararg list of any number of solstice.feat constant.
function M.RegisterFeatUses(func, ...)
   for _, feat in ipairs({...}) do
      FEAT_USES[feat] = func
   end
end

function NWNXSolstice_GetMaximumFeatUses(feat, cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   return M.GetMaximumFeatUses(feat, cre)
end

_CONSTS = {}
setmetatable(_G, { __index = _CONSTS })

-- Helper function for loading the 2da values.
local function load(into, lookup)
   if not lookup.tda or not lookup.column_label then
      error "sol.consant.Load: invalid tda or column label!"
   end

   local twoda = TDA.GetCached2da(lookup.tda)
   local size = TDA.Get2daRowCount(twoda) - 1
   for i = 0, size do
      local const = TDA.Get2daString(twoda, lookup.column_label, i)
      if #const > 0 and const ~= "****" then
         if lookup.extract then
            const = string.match(const, lookup.extract)
         end
         if const then
            if lookup.value_label then
               local val
               if lookup.value_type == "string" then
                  val = TDA.Get2daString(twoda, lookup.value_label, i)
               elseif lookup.value_type == "float" then
                  val = TDA.Get2daFloat(twoda, lookup.value_label, i)
               elseif lookup.value_type == "int" then
                  val = TDA.Get2daInt(twoda, lookup.value_label, i)
               else
                  error(string.format("solstice.constant.Load: Invalid value type %s!",
                                      lookup.value_type))
               end
               into[const] = val
            else
               into[const] = i
            end
         end
      end
   end
end

--- Register constant loader.
-- @param module_name Name of the module to load constants into.
-- @param tda 2da name (without .2da)
-- @param column_label Label of the 2da column that contains constant
-- names.
-- @param[opt] extract A lua string.match pattern for extracting a
-- constant name.  E,g: `"FEAT_([%w_]+)"` to strip off 'FEAT_'
-- @param[opt] value_label Label of the 2da column that contains
-- the constants value.  If not passed constant value will be the
-- 2da row number.
-- @param[opt="int"] const_type Constant type.  Only used when
-- value_label is passed. Legal values: "int", "string", "float"
function M.RegisterConstants(tda, column_label, extract,
                             value_label, value_type)
   load(_CONSTS, { tda = tda,
                   column_label = column_label,
                   extract = extract,
                   value_type = value_type,
                   value_label = value_label })
end

--- Register constant.
function M.RegisterConstant(name, value)
   assert(type(name) == "string")
   _CONSTS[name] = value
end

--- Convert damage type constant to item property damage constant.
function M.ConvertDamageToItempropConstant(const)
   if const == DAMAGE_TYPE_BLUDGEONING then
      return IP_CONST_DAMAGE_BLUDGEONING
   elseif const == DAMAGE_TYPE_PIERCING then
      return IP_CONST_DAMAGE_PIERCING
   elseif const == DAMAGE_TYPE_SLASHING then
      return IP_CONST_DAMAGE_SLASHING
   elseif const == DAMAGE_TYPE_MAGICAL then
      return IP_CONST_DAMAGE_MAGICAL
   elseif const == DAMAGE_TYPE_ACID then
      return IP_CONST_DAMAGE_ACID
   elseif const == DAMAGE_TYPE_COLD then
      return IP_CONST_DAMAGE_COLD
   elseif const == DAMAGE_TYPE_DIVINE then
      return IP_CONST_DAMAGE_DIVINE
   elseif const == DAMAGE_TYPE_ELECTRICAL then
      return IP_CONST_DAMAGE_ELECTRICAL
   elseif const == DAMAGE_TYPE_FIRE then
      return IP_CONST_DAMAGE_FIRE
   elseif const == DAMAGE_TYPE_NEGATIVE then
      return IP_CONST_DAMAGE_NEGATIVE
   elseif const == DAMAGE_TYPE_POSITIVE then
      return IP_CONST_DAMAGE_POSITIVE
   elseif const == DAMAGE_TYPE_SONIC then
      return IP_CONST_DAMAGE_SONIC
   else
      error "Unable to convert damage contant to damage IP constant."
   end
end

function M.ConvertSaveToItempropConstant(const)
   if const == SAVING_THROW_FORT then
      return IP_CONST_SAVEBASETYPE_FORTITUDE
   elseif const == SAVING_THROW_REFLEX then
      return IP_CONST_SAVEBASETYPE_REFLEX
   elseif const == SAVING_THROW_WILL then
      return IP_CONST_SAVEBASETYPE_WILL
   else
      error "Unable to convert save contant to IP constant."
   end
end

function M.ConvertSaveVsToItempropConstant(const)
   if const == SAVING_THROW_VS_ALL then
      return IP_CONST_SAVEVS_UNIVERSAL
   elseif const == SAVING_THROW_VS_ACID then
      return IP_CONST_SAVEVS_ACID
   elseif const == SAVING_THROW_VS_COLD then
      return IP_CONST_SAVEVS_COLD
   elseif const == SAVING_THROW_VS_DEATH then
      return IP_CONST_SAVEVS_DEATH
   elseif const == SAVING_THROW_VS_DISEASE then
      return IP_CONST_SAVEVS_DISEASE
   elseif const == SAVING_THROW_VS_DIVINE then
      return IP_CONST_SAVEVS_DIVINE
   elseif const == SAVING_THROW_VS_ELECTRICITY then
      return IP_CONST_SAVEVS_ELECTRICAL
   elseif const == SAVING_THROW_VS_FEAR then
      return IP_CONST_SAVEVS_FEAR
   elseif const == SAVING_THROW_VS_FIRE then
      return IP_CONST_SAVEVS_FIRE
   elseif const == SAVING_THROW_VS_MIND_SPELLS then
      return IP_CONST_SAVEVS_MINDAFFECTING
   elseif const == SAVING_THROW_VS_NEGATIVE then
      return IP_CONST_SAVEVS_NEGATIVE
   elseif const == SAVING_THROW_VS_POISON then
      return IP_CONST_SAVEVS_POISON
   elseif const == SAVING_THROW_VS_POSITIVE then
      return IP_CONST_SAVEVS_POSITIVE
   elseif const == SAVING_THROW_VS_SONIC then
      return IP_CONST_SAVEVS_SONIC
   else
      error "Unable to convert save contant to IP constant."
   end
end

function M.ConvertImmunityToIPConstant(const)
   if const == IMMUNITY_TYPE_SNEAK_ATTACK then
      return IP_CONST_IMMUNITYMISC_BACKSTAB
   elseif const == IMMUNITY_TYPE_ABILITY_DECREASE then
      return IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN
   elseif const == IMMUNITY_TYPE_NEGATIVE_LEVEL then
      return IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN
   elseif const == IMMUNITY_TYPE_MIND_SPELLS then
      return IP_CONST_IMMUNITYMISC_MINDSPELLS
   elseif const == IMMUNITY_TYPE_POISON then
      return IP_CONST_IMMUNITYMISC_POISON
   elseif const == IMMUNITY_TYPE_DISEASE then
      return IP_CONST_IMMUNITYMISC_DISEASE
   elseif const == IMMUNITY_TYPE_FEAR then
      return IP_CONST_IMMUNITYMISC_FEAR
   elseif const == IMMUNITY_TYPE_KNOCKDOWN then
      return IP_CONST_IMMUNITYMISC_KNOCKDOWN
   elseif const == IMMUNITY_TYPE_PARALYSIS then
      return IP_CONST_IMMUNITYMISC_PARALYSIS
   elseif const == IMMUNITY_TYPE_CRITICAL_HIT then
      return IP_CONST_IMMUNITYMISC_CRITICAL_HITS
   elseif const == IMMUNITY_TYPE_DEATH then
      return IP_CONST_IMMUNITYMISC_DEATH_MAGIC
   else
      error "Unable to convert immunity contant to IP constant."
   end
end


return M
