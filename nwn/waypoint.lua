require 'nwn.ctypes.waypoint'

local ffi = require 'ffi'

ffi.cdef [[
typedef struct Waypoint {
    uint32_t        type;
    uint32_t        id;
    CNWSWaypoint   *obj;
} Waypoint;
]]

local waypoint_mt = { __index = Waypoint }
waypoint_t = ffi.metatype("Waypoint", waypoint_mt)

--- Set's a map pin's status
-- @param enabled (Default: false)
function Waypoint:SetMapPinEnabled(enabled)
   nwn.engine.StackPushInteger(enabled)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(386, 2)
end