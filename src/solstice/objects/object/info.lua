----
-- @module object

local M = require 'solstice.objects.init'
local Object = M.Object
local NWE = require 'solstice.nwn.engine'

--- Class Object: Information
-- @section info

---
function Object:GetColor(channel)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(843, 2)
   return NWE.StackPopInteger()
end

function Object:GetDescription(original, identified)
   if identified == nil then identified = true end

   NWE.StackPushBoolean(identified)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(836, 3)
   return NWE.StackPopString()
end

function Object:GetGold()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(418, 1)
   return NWE.StackPopInteger()
end

function Object:GetName(original)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(253, 2)
   return NWE.StackPopString()
end

function Object:GetType()
   local ret = OBJECT_TYPE_NONE
   if self.type == OBJECT_TRUETYPE_CREATURE then
      ret = OBJECT_TYPE_CREATURE
   elseif self.type == OBJECT_TRUETYPE_ITEM then
      ret = OBJECT_TYPE_ITEM
   elseif self.type == OBJECT_TRUETYPE_TRIGGER then
      ret = OBJECT_TYPE_TRIGGER
   elseif self.type == OBJECT_TRUETYPE_PLACEABLE then
      ret = OBJECT_TYPE_PLACEABLE
   elseif self.type == OBJECT_TRUETYPE_DOOR then
      ret = OBJECT_TYPE_DOOR
   elseif self.type == OBJECT_TRUETYPE_AREA_OF_EFFECT then
      ret = OBJECT_TYPE_AREA_OF_EFFECT
   elseif self.type == OBJECT_TRUETYPE_WAYPOINT then
      ret = OBJECT_TYPE_WAYPOINT
   elseif self.type == OBJECT_TRUETYPE_ENCOUNTER then
      ret = OBJECT_TYPE_ENCOUNTER
   elseif self.type == OBJECT_TRUETYPE_STORE then
      ret = OBJECT_TYPE_STORE
   end
   return ret
end

function Object:CheckType(...)
   local t = self:GetType()
   local tp = table.pack(...)
   for i=1, t.n do
      if t == tp[i] then
         return true
      end
   end
   return false
end

function Object:GetPlotFlag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(455, 1)
   return NWE.StackPopBoolean()
end

function Object:GetPortraitId()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(831, 1)
   return NWE.StackPopInteger()
end

function Object:GetPortraitResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(833, 1)
   return NWE.StackPopString()
end

function Object:GetResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(582, 1)
   return NWE.StackPopString()
end

function Object:GetTag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(168, 1)
   return NWE.StackPopString()
end

---
function Object:SetColor(channel, value)
   NWE.StackPushInteger(value)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(844, 3)
end

function Object:SetDescription(description, identified)
   description = description or ""
   if identified == nil then identified = true end

   NWE.StackPushBoolean(identified)
   NWE.StackPushString(description)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(837, 3)
end

function Object:SetIsDestroyable(destroyable, raiseable, selectable)
   if selectable == nil then selectable = true end

   NWE.StackPushBoolean(selectable)
   NWE.StackPushBoolean(raiseable)
   NWE.StackPushBoolean(destroyable)
   NWE.ExecuteCommandUnsafe(323, 3)
end

function Object:SetName(name)
   name = name or ""

   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(830, 2)
end

function Object:SetPlotFlag(flag)
   NWE.StackPushBoolean(flag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(456, 2)
end

function Object:SetPortraitId(id)
   NWE.StackPushInteger(id)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(832, 2)
end

function Object:SetPortraitResRef(resref)
   NWE.StackPushString(resref)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(834, 2)
end
