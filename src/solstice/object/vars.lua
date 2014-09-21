--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'

--- Class Object: Variables
-- @section vars

local function get_var_table(obj)
   if obj.type == OBJECT_TRUETYPE_MODULE then
      return obj.obj.mod_vartable
   elseif obj.type == OBJECT_TRUETYPE_AREA then
      return obj.obj.area_vartable
   else
      return obj.obj.obj.obj_vartable
   end
end

local function get_var_value(var)
   if var.var_type == VARIABLE_TYPE_OBJECT then
      return var.var_value.val_object
   elseif var.var_type == VARIABLE_TYPE_FLOAT then
      return var.var_value.val_float
   elseif var.var_type == VARIABLE_TYPE_INT then
      return var.var_value.val_int
   elseif var.var_type == VARIABLE_TYPE_STRING then
      return ffi.string(var.var_value.val_string.text)
   elseif var.var_type == VARIABLE_TYPE_LOCATION then
      error "Unsupported"
   end

end

--- Get local variable count.
function M.Object:GetLocalVarCount()
   local vt = get_var_table(self)
   return vt.vt_len
end

--- Get local variable by index.
-- @param index Postive integer.
function M.Object:GetLocalVarByIndex(index)
   local vt = get_var_table(self)
   if index >= vt.vt_len then return end
   return vt.vt_list[index]
end

--- Get all variables.
-- @param[opt] match A string pattern for testing variable names.  See string.find
-- @param[opt] type Get variables of a particular type.
function M.Object:GetAllVars(match, type)
   local res = {}
   for i = 0, self:GetLocalVarCount() - 1 do
      local var = self:GetLocalVarByIndex(i)
      local name = ffi.string(var.var_name.text)
      if (not type or var.var_type == type) and
         (not match or string.find(name, match))
      then
         res[name] = get_var_value(var)
      end
   end
   return res
end

--- Decrements local integer variable
-- @param name Variable name
-- @param[opt=1] val Amount to decrement.
-- @return New local variable value.
function M.Object:DecrementLocalInt(name, val)
   if not self:GetIsValid() then return end
   val = val or 1

   local newval = self:GetLocalInt(name) - val
   self:SetLocalInt(name, newval)
   return newval
end

--- Boolean wrapper around DeleteLocalInt
-- Int/Bool values are stored under the same name
-- @param name Variable name.
function M.Object:DeleteLocalBool(name)
   self:DeleteLocalInt(name)
end

--- Delete a local int variable
-- @param name Variable name.
function M.Object:DeleteLocalInt(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(265, 2)
end

--- Delete a local float variable
-- @param name Variable to delete
function M.Object:DeleteLocalFloat(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(266, 2)
end

--- Delete a local string variable
-- @param name Variable to delete
function M.Object:DeleteLocalString(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(267, 2)
end

--- Delete a local object variable
-- @param name Variable to delete
function M.Object:DeleteLocalObject(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(268, 2)
end

--- Delete a local location variable
-- @param name Variable to delete
function M.Object:DeleteLocalLocation(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(269, 2)
end

--- Boolean wrapper around GetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same name
-- @param name Variable name
function M.Object:GetLocalBool(name)
   return self:GetLocalInt(name) ~= 0
end

--- Get a local int variable
-- @param name Variable name
function M.Object:GetLocalInt(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(51, 2)
   return NWE.StackPopInteger()
end

--- Get local float variable
-- @param name Variable name
function M.Object:GetLocalFloat(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(52, 2)
   return NWE.StackPopFloat()
end

--- Get local location variable
-- @param name Variable name
function M.Object:GetLocalLocation(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(153, 2)
   return NWE.StackPopLocation()
end

--- Get local object variable
-- @param name Variable name
function M.Object:GetLocalObject(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(54, 2)
   return NWE.StackPopObject()
end

--- Get local string
-- @param name Variable name.
function M.Object:GetLocalString(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(53, 2)
   local s = NWE.StackPopString()
   return s
end

--- Increment local integer variable
-- @param name Variable name
-- @param[opt=1] val Amount to increment.
-- @return New local variable value.
function M.Object:IncrementLocalInt(name, val)
   val = val or 1

   local newval = self:GetLocalInt(name) + val
   self:SetLocalInt(name, newval)
   return newval
end

--- Boolean wrapper around SetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same name.
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalBool(name, val)
   self:SetLocalInt(name, val and 1 or 0)
end

--- Set local float variable
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalFloat(name, val)
   NWE.StackPushFloat(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(56, 3)
end

--- Set local int variable
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalInt(name, val)
   NWE.StackPushInteger(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(55, 3)
end

--- Set local location variable
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalLocation(name, val)
   NWE.StackPushLocation(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(152, 3)
end

--- Set local string variable
-- NOTE: SetLocalObject must use the NWN stack in order
--    for NWNX hook to work.
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalString(name, val)
   NWE.StackPushString(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(57, 3)
end

--- Set local object variable
-- NOTE: SetLocalObject must use the NWN stack in order
--    for NWNX hook to work.
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalObject(name, val)
   NWE.StackPushObject(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(58, 3)
end
