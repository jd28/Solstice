----
-- @module object

local M = require 'solstice.object.init'
local Object = M.Object
local NWE = require 'solstice.nwn.engine'

--- Class Object: Information
-- @section info

---
function Object:GetColor(channel)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(843, 2)
   return NWE.StackPopInteger()
end

--- Get object's description
-- @param[opt=false] original If true get original description.
-- @param[opt=true] identified If true get identified description.
function Object:GetDescription(original, identified)
   if identified == nil then identified = true end

   NWE.StackPushBoolean(identified)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(836, 3)
   return NWE.StackPopString()
end

--- Get object's gold.
function Object:GetGold()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(418, 1)
   return NWE.StackPopInteger()
end

--- Get object's name
-- @bool original If true returns object's original name,
-- if false returns overriden name
function Object:GetName(original)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(253, 2)
   return NWE.StackPopString()
end

--- Get object's type
-- @return OBJECT_TYPE_* or OBJECT_TYPE_NONE
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

--- Checks object type.
-- @param ... Any number of OBJECT_TYPE_* constants
function Object:CheckType(...)
   local t = self:GetType()
   for _, v in ipairs({...}) do
      if t == v then
         return true
      end
   end
   return false
end

--- Get plot flag
function Object:GetPlotFlag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(455, 1)
   return NWE.StackPopBoolean()
end

--- Get portrait ID
function Object:GetPortraitId()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(831, 1)
   return NWE.StackPopInteger()
end

--- Get portrait resref
function Object:GetPortraitResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(833, 1)
   return NWE.StackPopString()
end

--- Returns the Resref of an object.
-- @return The Resref, empty string on error.
function Object:GetResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(582, 1)
   return NWE.StackPopString()
end

--- Determine the tag associated with an object.
-- @return Tag of the object, empty string on error.
function Object:GetTag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(168, 1)
   return NWE.StackPopString()
end

---
function Object:SetColor(channel, value)
   NWE.StackPushInteger(value)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(844, 3)
end

---
-- @string description New description.
-- @param[opt=true] identified If true sets identified description.
function Object:SetDescription(description, identified)
   description = description or ""
   if identified == nil then identified = true end

   NWE.StackPushBoolean(identified)
   NWE.StackPushString(description)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(837, 3)
end

---
-- @param[opt=false] destroyable
-- @param[opt=false] raiseable
-- @param[opt=true] selectable
function Object:SetIsDestroyable(destroyable, raiseable, selectable)
   if selectable == nil then selectable = true end

   NWE.StackPushBoolean(selectable)
   NWE.StackPushBoolean(raiseable)
   NWE.StackPushBoolean(destroyable)
   NWE.ExecuteCommand(323, 3)
end

--- Set object's name
-- @param[opt=""] name New name
function Object:SetName(name)
   name = name or ""

   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(830, 2)
end

--- Set object's plot flag
-- @param[opt=false] flag If true object is plot.
function Object:SetPlotFlag(flag)
   NWE.StackPushBoolean(flag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(456, 2)
end

--- Set portrait ID
-- @param id Portrait ID
function Object:SetPortraitId(id)
   NWE.StackPushInteger(id)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(832, 2)
end

--- Set Portrait resref
-- @param resref Portrait resref
function Object:SetPortraitResRef(resref)
   NWE.StackPushString(resref)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(834, 2)
end
