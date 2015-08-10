--- Object
-- @module waypoint

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Waypoint  = inheritsFrom({}, M.Object)
M.Waypoint = Waypoint

function Waypoint.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_WAYPOINT
      },
      { __index = Waypoint })
end

--- Set's a map pin's status
-- @param[opt=false] enabled Enable/Disable map pin.
function Waypoint:SetMapPinEnabled(enabled)
   NWE.StackPushInteger(enabled)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(386, 2)
end
