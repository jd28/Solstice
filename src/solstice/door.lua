--- Door
-- @module door

local ffi = require 'ffi'
local Obj = require 'solstice.object'
local NWE = require 'solstice.nwn.engine'

local M = {}
local Door = inheritsFrom({}, Obj.Object)
M.Door = Door

-- Internal ctype
M.door_t = ffi.metatype("Door", { __index = M.Door })

--- Class Door
-- @section

--- Determines whether an action can be used on a door.
-- @param action DOOR_ACTION_*
function M.Door:GetIsActionPossible(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(337, 2)
   return NWE.StackPopBoolean()
end

--- Does specific action to target door.
-- @param action DOOR_ACTION_*
function M.Door:DoAction(action)
   NWE.StackPushInteger(action);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(338, 2);
end

return M
