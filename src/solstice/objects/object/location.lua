----
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Location
-- @section location

function Object:GetArea()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(24, 1)
   return NWE.StackPopObject()
end

function Object:GetDistanceToObject(obj)
   local loc1 = self:GetLocation()
   local loc2 = obj:GetLocation()

   return loc1:GetDistanceBetween(loc2)
end

function Object:GetFacing()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(28, 1)
   return NWE.StackPopFloat()
end

function Object:GetLocation()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(213, 1)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

function Object:GetPosition()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(27, 1)
   return NWE.StackPopVector()
end

function Object:LineOfSight(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(752, 2)
   return NWE.StackPopBoolean()
end

function Object:SetFacing(direction)
   NWE.StackPushFloat(direction)
   NWE.ExecuteCommand(10, 1)
end

function Object:SetFacingPoint(target)
   NWE.StackPushVector(target)
   NWE.ExecuteCommand(143, 1)
end
