--- Rules.
-- @module rules

local TDA = require 'solstice.2da'

local M = require 'solstice.rules.init'

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

return M
