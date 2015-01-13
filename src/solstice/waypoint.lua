--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module waypoint

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

local M = {}
local Waypoint  = inheritsFrom({}, Obj.Object)
M.Waypoint = Waypoint

-- Internal ctype.
M.waypoint_t = ffi.metatype("Waypoint", { __index = M.Waypoint })

--- Set's a map pin's status
-- @param[opt=false] enabled Enable/Disable map pin.
function Waypoint:SetMapPinEnabled(enabled)
   NWE.StackPushInteger(enabled)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(386, 2)
end

return M
