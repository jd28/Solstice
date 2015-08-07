--- Rules.
-- @module rules

local M = require 'solstice.rules.init'

_CONSTS = {}

local global_mt = getmetatable(_G) or {}
global_mt.__index = _CONSTS
setmetatable(_G, global_mt)

-- Helper function for loading the 2da values.
local function load(into, lookup)
   if not lookup.tda or not lookup.column_label then
      error "sol.consant.Load: invalid tda or column label!"
   end

   local twoda = Game.GetCached2da(lookup.tda)
   local size = Game.Get2daRowCount(twoda) - 1
   for i = 0, size do
      local const = Game.Get2daString(twoda, lookup.column_label, i)
      if #const > 0 and const ~= "****" then
         if lookup.extract then
            const = string.match(const, lookup.extract)
         end
         if const then
            if lookup.value_label then
               local val
               if lookup.value_type == "string" then
                  val = Game.Get2daString(twoda, lookup.value_label, i)
               elseif lookup.value_type == "float" then
                  val = Game.Get2daFloat(twoda, lookup.value_label, i)
               elseif lookup.value_type == "int" then
                  val = Game.Get2daInt(twoda, lookup.value_label, i)
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

--- Constants
-- @section

--- Register constant loader.
-- @param tda 2da name (without .2da)
-- @param column_label Label of the 2da column that contains constant
-- names.
-- @param[opt] extract A lua string.match pattern for extracting a
-- constant name.  E,g: `"FEAT_([%w_]+)"` to strip off 'FEAT_'
-- @param[opt] value_label Label of the 2da column that contains
-- the constants value.  If not passed constant value will be the
-- 2da row number.
-- @param[opt="int"] value_type Constant type.  Only used when
-- value_label is passed. Legal values: "int", "string", "float"
function M.RegisterConstants(tda, column_label, extract,
                             value_label, value_type)
   load(_CONSTS, { tda = tda,
                   column_label = column_label,
                   extract = extract,
                   value_type = value_type or "int",
                   value_label = value_label })
end

--- Register constant.
function M.RegisterConstant(name, value)
   assert(type(name) == "string")
   _CONSTS[name] = value
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
