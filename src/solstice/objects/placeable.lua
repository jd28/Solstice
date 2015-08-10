----
-- Defines Placeable object and related functions.
-- @module placeable

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Placeable = inheritsFrom({}, M.Object)
M.Placeable = Placeable

function Placeable.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_PLACEABLE
      },
      { __index = Placeable })
end

--- Make placeable do an action
-- @param action Action to do.
function Placeable:DoAction(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(547, 2)
end

--- Get if an action is possible
-- @param action Action type
function Placeable:GetIsActionPossible(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(546, 2)
   return NWE.StackPopBoolean()
end

--- Get if a placeable is static.
function Placeable:GetIsStatic()
   if not self:GetIsValid() then return false end

   return self.obj.plc_static == 1
end

--- Get placeable illumination
function Placeable:GetIllumination()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(545, 1)
   return NWE.StackPopInteger()
end

--- Get if a creature is sitting on placeable.
function Placeable:GetSittingCreature()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(210, 1)
   return NWE.StackPopObject()
end

--- Get if placeable is useable
function Placeable:GetUseable()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(587, 1)
   return NWE.StackPopBoolean()
end

--- Set placeable appearance.
-- @param value See placeables.2da
function Placeable:SetAppearance(value)
   if not self:GetIsValid() or value < 0 then return end

   self.obj.plc_appearance = value
   return self.obj.plc_appearance
end

--- Set placeable illumination
-- @param illuminate If true turn on placeables illumination
function Placeable:SetIllumination(illuminate)
   NWE.StackPushBoolean(illuminate)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(544, 2)
end

--- Set placeable useable
-- @param useable If true placeable is useable
function Placeable:SetUseable(useable)
   NWE.StackPushBoolean(useable)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(835, 2)
end
