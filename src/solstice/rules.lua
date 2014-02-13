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

local LOOKUP = {}

_CONSTS = {}

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

--- Loads all registered consant loaders.
--
-- NOTE: This function should be called only from the module
-- load event.
function M.LoadConstants()
   for _, t in ipairs(LOOKUP) do
      load(_G, t)
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
   table.insert(LOOKUP, { tda = tda,
                          column_label = column_label,
                          extract = extract,
                          value_type = value_type,
                          value_label = value_label })
end

--- Register constant.
function M.RegisterConstant(name, value)
   assert(type(name) == "string")
   _G[name] = value
end

-- Global function to simplify loading constants from a NWNX
-- request.
-- NOTE: This function should be called only from the module
-- load event.
function NWNXSolstice_LoadConstants()
   M.LoadConstants()
   setmetatable(_G, { __index = _CONSTS })
end

return M
