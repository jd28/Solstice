----
-- @module object

local M = require 'solstice.object.init'
local Object = M.Object

--- Properties
-- @section properties

--- Get a property.
-- Simple wrapper around `Game.GetProperty`
-- @string prop Property name
function Object:GetProperty(prop)
   return Game.GetProperty(self, prop)
end

--- Set a PC property
-- Simple wrapper around `Game.GetProperty`
-- @string prop Property name.
-- @param value The value can be anything you choose number, string, location,
-- lua table, etc, etc.
function Object:SetProperty(prop, value)
      Game.GetProperty(self, prop, value)
end

--- Get all of an object's properties.
-- @return nil if object is invalid, else all properties as a mutable lua table.
function Object:GetAllProperties()
   return Game.GetAllProperties(self)
end

--- Delete all of an object's properties.
-- @param obj Object.
function Object:DeleteAllProperties()
   Game.DeleteAllProperties(self)
end
