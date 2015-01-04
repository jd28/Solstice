----
-- @module game

--- Properties
-- @section properties

local _PROPERTIES = {}

--- Delete all of an object's properties.
-- @param obj Object.
local function DeleteAllProperties(obj)
   if not obj:GetIsValid() then return end
   _PROPERTIES[obj.id] = nil
end

--- Get all of an object's properties.
-- @param obj Object.
-- @return nil if object is invalid, else all properties as a mutable lua table.
local function GetAllProperties(obj)
   if not obj:GetIsValid() then return end
   return _PROPERTIES[obj.id]
end

--- Get an object's properties.
-- @param obj Object.
local function GetProperty(obj, prop)
   assert(type(prop) == 'string', 'Property name must be a string!')
   if not obj:GetIsValid() then return end
   return _PROPERTIES[obj.id][prop]
end

--- Set a property on an object.
-- @string prop Property name.
-- @param value The value can be anything you choose number, string, location,
-- lua table, etc, etc.
local function SetProperty(obj, prop, value)
   assert(type(prop) == 'string', 'Property name must be a string!')
   if not obj:GetIsValid() then return end
   _PROPERTIES[obj.id] = _PROPERTIES[obj.id] or {}
   _PROPERTIES[obj.id][prop] = value
end

--- Get the global properties table.
local function GetGlobalProperties()
   return _PROPERTIES
end

local M = require 'solstice.game.init'
M.SetProperty = SetProperty
M.DeleteAllProperties = DeleteAllProperties
M.GetAllProperties = GetAllProperties
M.GetProperty = GetProperty
M.GetGlobalProperties = GetGlobalProperties
