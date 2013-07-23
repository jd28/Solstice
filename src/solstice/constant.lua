--- Constants.
-- @module constant

local TDA = require 'solstice.2da'

local M = {}
local LOOKUP = {}

-- Helper function for loading the 2da values.
local function load(t)
   if not t.tda or not t.column_label then
      error "sol.consant.Load: invalid tda or column label!"
   end
   local t = {}
   local twoda = TDA.GetCached2da(tda)
   local size = Get2daRowCount(twoda) - 1
   for i = 0, size do
      local const = TDA.Get2daString(twoda, column_label, i)
      if #const > 0 and const ~= "****" then
         if t.value_label then
            local val
            if t.value_type == "string" then
               val = TDA.Get2daString(twoda, value_label, i)
            elseif t.value_type == "float" then
               val = TDA.Get2daFloat(twoda, value_label, i)
            elseif t.value_type == "int" then
               val = TDA.Get2daInt(twoda, value_label, i)
            else
               error "solstice.constant.Load: Invalid value type!"
            end
            t[const] = val
         else
            t[const] = i
         end
      end
   end
   return t
end

--- Loads all registered consant loaders.
--
-- NOTE: This function should be called only from the module
-- load event.
function M.Load()
   for name, t in pairs(LOOKUP) do
      local temp = require(name)
      temp.const = load(t)
   end
end

--- Register constant loader.
-- @param module_name Name of the module to load constants into.
-- @param tda 2da name (without .2da)
-- @param column_label Label of the 2da column that contains constant
-- names.
-- @param[opt] value_label Label of the 2da column that contains
-- the constants value.  If not passed constant value will be the
-- 2da row number.
-- @param[opt="int"] const_type Constant type.  Only used when
-- value_label is passed. Legal values: "int", "string", "float"
function M.Register(module_name, tda, column_label, value_label,
                    value_type)
   LOOKUP[module_name] = { tda = tda, 
                           column_label = column_label, 
                           value_type = value_type,
                           value_label = value_label }
end

-- Global function to simplify loading constants from a NWNX
-- request.
-- NOTE: This function should be called only from the module
-- load event.
function NWNXSolstice_LoadConstants()
   M.Load()
end

return M