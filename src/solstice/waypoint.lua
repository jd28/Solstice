--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module waypoint

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

local M = {}

M.Waypoint  = inheritsFrom(Obj.Object, "solstice.waypoint.Waypoint")

--- Internal ctype.
M.waypoint_t = ffi.metatype("Waypoint", { __index = M.Waypoint })

--- Set's a map pin's status
-- @param[opt=false] enabled Enable/Disable map pin.
function M.Waypoint:SetMapPinEnabled(enabled)
   NWE.StackPushInteger(enabled)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(386, 2)
end

--- Finds a waypiont by tag
-- @param tag Tag of waypoint.
-- @return solstice.waypoint.Waypoint instance or OBJECT_INVALID
function M.GetByTag(tag)
   NWE.StackPushString(tag)
   return NWE.StackPopObject()
end

return M
