----
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Nearest Objects
-- @section nearest

--- Gets nearest creature by criteria types and values
function Object:GetNearestCreature(type1, value1, nth, ...)
   nth = nth or 1
   local type2, value2, type3, value3 = ...
   type2  = type2  or -1
   value2 = value2 or -1
   type3  = type3  or -1
   value3 = value3 or -1

   NWE.StackPushInteger(value3)
   NWE.StackPushInteger(type3)
   NWE.StackPushInteger(value2)
   NWE.StackPushInteger(type2)
   NWE.StackPushInteger(nth)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(value1)
   NWE.StackPushInteger(type1)
   NWE.ExecuteCommand(38, 8)
   NWE.StackPopObject()
end

--- Get nearest object
-- @param[opt=OBJECT_TYPE_ALL] obj_type OBJECT_TYPE_*
-- @param[opt=1] nth Which object to return.
function Object:GetNearestObject(obj_type, nth)
   obj_type = obj_type or OBJECT_TYPE_ALL
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(obj_type)
   NWE.ExecuteCommand(227, 3)
   return NWE.StackPopObject()
end

--- Get nearest object by tag.
-- @param tag Tag of object
-- @param[opt=1] nth Which object to return
function Object:GetNearestObjectByTag(tag, nth)
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushObject(self)
   NWE.StackPushString(tag)
   NWE.ExecuteCommand(229, 3)
   return NWE.StackPopObject()
end

--- Get nearest trap.
-- @param[opt=false] is_detected If true return only detected traps.
function Object:GetNearestTrap(is_detected)
   NWE.StackPushBoolean(is_detected)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(488, 2)
   return NWE.StackPopObject()
end
