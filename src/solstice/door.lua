--- Door
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module door

local ffi = require 'ffi'
local Obj = require 'solstice.object'
local NWE = require 'solstice.nwn.engine'

local M = {
   ACTION_OPEN            = 0,
   ACTION_UNLOCK          = 1,
   ACTION_BASH            = 2,
   ACTION_IGNORE          = 3,
   ACTION_KNOCK           = 4,

   -- Door animation constants
   ANIMATION_CLOSE        = 204,
   ANIMATION_OPEN1        = 205,
   ANIMATION_OPEN2        = 206,
   ANIMATION_DESTROY      = 207,
}

M.Door = inheritsFrom(Obj.Object, "solstice.door.Door")

--- Internal ctype
M.door_t = ffi.metatype("Door", { __index = M.Door })

--- Class Door
-- @section

--- Determines whether an action can be used on a door.
-- @param action solstice.door.ACTION_*
function M.Door:GetIsActionPossible(action)
   NWE.StackPushInteger(action)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(337, 2)
   return NWE.StackPopBoolean()
end

--- Does specific action to target door.
-- @param action solstice.door.ACTION_*
function M.Door:DoAction(action)
   NWE.StackPushInteger(action);
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(338, 2);
end

return M