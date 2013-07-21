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
   if isinstance(obj, Module) then
      return obj.obj.mod_vartable
   elseif isinstance(obj, Area) then
      return obj.obj.area_vartable
   else
      return obj.obj.obj.obj_vartable
   end
end

--- Decrements local integer variable
-- @param name Variable name
-- @param[opt=1] val Amount to decrement.
-- @return New local variable value.
function M.Object:DecrementLocalInt(name, val)
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
    return C.nwn_DeleteLocalInt(get_var_table(self), name) 
end

--- Delete a local float variable
-- @param name Variable to delete
function M.Object:DeleteLocalFloat(name)
    return C.nwn_DeleteLocalFloat(get_var_table(self), name) 
end

--- Delete a local string variable
-- @param name Variable to delete
function M.Object:DeleteLocalString(name)
   return C.nwn_DeleteLocalString(get_var_table(self), name) 
end

--- Delete a local object variable
-- @param name Variable to delete
function M.Object:DeleteLocalObject(name)
    return C.nwn_DeleteLocalObject(get_var_table(self), name) 
end

--- Delete a local location variable
-- @param name Variable to delete
function M.Object:DeleteLocalLocation(name)
    return C.nwn_DeleteLocalLocation(get_var_table(self), name) 
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
    return C.nwn_GetLocalInt(get_var_table(self), name) 
end

--- Get local float variable
-- @param name Variable name
function M.Object:GetLocalFloat(name)
   return C.nwn_GetLocalFloat(get_var_table(self), name)
end

--- Get local location variable
-- @param name Variable name
function M.Object:GetLocalLocation(name)
   return C.nwn_GetLocalLocation(get_var_table(self), name)
end

--- Get local object variable
-- @param name Variable name
function M.Object:GetLocalObject(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(54, 2)
   return NWE.StackPopObject()
end

--- Get local string
-- @param name Variable name.
function M.Object:GetLocalString(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(53, 2)
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
   C.nwn_SetLocalFloat(get_var_table(self), name, val)
end

--- Set local int variable
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalInt(name, val) 
    C.nwn_SetLocalInt(get_var_table(self), name, val) 
end

--- Set local location variable
-- @param name Variable name
-- @param val Value
function M.Object:SetLocalLocation(name, val)
    C.nwn_SetLocalLocation(get_var_table(self), name, val) 
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

