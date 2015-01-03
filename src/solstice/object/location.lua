----
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Location
-- @section location

--- Get area object is in.
function Object:GetArea()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(24, 1)
   return NWE.StackPopObject()
end

-- Get distance between two objects
function Object:GetDistanceToObject(obj)
   local loc1 = self:GetLocation()
   local loc2 = obj:GetLocation()

   return loc1:GetDistanceBetween(loc2)
end

--- Get direction object is facing
function Object:GetFacing()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(28, 1)
   return NWE.StackPopFloat()
end

--- Get object's location
function Object:GetLocation()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(213, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

--- Get object's position
function Object:GetPosition()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(27, 1)
   return NWE.StackPopVector()
end

--- Get is target in line of sight
-- @param target Target to check.
function Object:LineOfSight(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(752, 2)
   return NWE.StackPopBoolean()
end

--- Set direction object is facing in.
function Object:SetFacing(direction)
   NWE.StackPushFloat(direction)
   NWE.ExecuteCommand(10, 1)
end

--- Set the poin the object is facing.
-- @param target Vector position.
function Object:SetFacingPoint(target)
   NWE.StackPushVector(target)
   NWE.ExecuteCommand(143, 1)
end
