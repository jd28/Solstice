--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module placeable

local ffi = require 'ffi'
local Obj = require 'solstice.object'
local NWE = require 'solstice.nwn.engine'

local M = {}

M.Placeable = inheritsFrom({}, Obj.Object)

--- Internal ctype.
M.placeable_t = ffi.metatype("Placeable", { __index = M.Placeable })

--- Make placeable do an action
-- @param action Action to do.
function M.Placeable:DoAction(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(547, 2)
end

--- Get if an action is possible
-- @param action Action type
function M.Placeable:GetIsActionPossible(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(546, 2)
   return NWE.StackPopBoolean()
end

--- Get if a placeable is static.
function M.Placeable:GetIsStatic()
   if not self:GetIsValid() then return false end

   return self.obj.plc_static == 1
end

--- Get placeable illumination
function M.Placeable:GetIllumination()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(545, 1)
   return NWE.StackPopInteger()
end

--- Get if a creature is sitting on placeable.
function M.Placeable:GetSittingCreature()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(210, 1)
   return NWE.StackPopObject()
end

--- Get if placeable is useable
function M.Placeable:GetUseable()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(587, 1)
   return NWE.StackPopBoolean()
end

--- Set placeable appearance.
-- @param value See placeables.2da
function M.Placeable:SetAppearance(value)
   if not self:GetIsValid() or value < 0 then return end

   self.obj.plc_appearance = value
   return self.obj.plc_appearance
end

--- Set placeable illumination
-- @param illuminate If true turn on placeables illumination
function M.Placeable:SetIllumination(illuminate)
   NWE.StackPushBoolean(illuminate)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(544, 2)
end

--- Set placeable useable
-- @param useable If true placeable is useable
function M.Placeable:SetUseable(useable)
   NWE.StackPushBoolean(useable)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(835, 2)
end

return M
