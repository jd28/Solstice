--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'

local NWE = require 'solstice.nwn.engine'

--- Class Object: Information
-- @section info

---
function M.Object:GetColor(channel)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(843, 2)
   return NWE.StackPopInteger()
end

--- Get object's description
-- @param[opt=false] original If true get original description.
-- @param[opt=true] identified If true get identified description.
function M.Object:GetDescription(original, identified)
   if identified == nil then identified = true end
   
   NWE.StackPushBoolean(identified)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(836, 3)
   return NWE.StackPopString()
end

--- Get object's gold.
function M.Object:GetGold()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(418, 1)
   return NWE.StackPopInteger()
end

--- Get object's name
-- @param original
function M.Object:GetName(original)
   NWE.StackPushBoolean(original)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(253, 2)
   return NWE.StackPopString()
end

--- Get object's type
function M.Object:GetType()
   return self.type
end

--- Get plot flag
function M.Object:GetPlotFlag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(455, 1)
   return NWE.StackPopBoolean()
end

--- Get portrait ID
function M.Object:GetPortraitId()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(831, 1)
   return NWE.StackPopInteger()
end

--- Get portrait resref
function M.Object:GetPortraitResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(833, 1)
   return NWE.StackPopString()
end

--- Returns the Resref of an object.
-- @return The Resref, empty string on error. 
function M.Object:GetResRef()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(582, 1)
   return NWE.StackPopString()
end

--- Determine the tag associated with an object.
-- @return Tag of the object, empty string on error.
function M.Object:GetTag()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(168, 1)
   return NWE.StackPopString()
end

---
function M.Object:SetColor(channel, value)
   NWE.StackPushInteger(value)
   NWE.StackPushInteger(channel)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(844, 3)
end

---
-- @string description New description.
-- @param[opt=true] identified If true sets identified description.
function M.Object:SetDescription(description, identified)
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
function M.Object:SetIsDestroyable(destroyable, raiseable, selectable)
   if selectable == nil then selectable = true end
   
   NWE.StackPushBoolean(selectable)
   NWE.StackPushBoolean(raiseable)
   NWE.StackPushBoolean(destroyable)
   NWE.ExecuteCommand(323, 3)
end

--- Set object's name
-- @param[opt=""] name New name
function M.Object:SetName(name)
   name = name or ""
   
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(830, 2)
end

--- Set object's plot flag
-- @param[opt=false] flag If true object is plot.
function M.Object:SetPlotFlag(flag)
   NWE.StackPushBoolean(flag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(456, 2)
end

--- Set portrait ID
-- @param id Portrait ID
function M.Object:SetPortraitId(id)
   NWE.StackPushInteger(id)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(832, 2)
end

--- Set Portrait resref
-- @param resref Portrait resref
function M.Object:SetPortraitResRef(resref)
   NWE.StackPushString(resref)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(834, 2)
end

