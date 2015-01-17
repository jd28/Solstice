--- Object
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
