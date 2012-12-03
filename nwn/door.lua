--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.ctypes.door'
local ffi = require 'ffi'

ffi.cdef[[
typedef struct Door {
    uint32_t        type;
    uint32_t        id;
    CNWSDoor       *obj;
} Door;
]]

local door_mt = { __index = Door }
door_t = ffi.metatype("Door", door_mt)

--- Determines whether an action can be used on a door.
-- @param action DOOR_ACTION_*
function Door:GetIsActionPossible(action)
   nwn.engine.StackPushInteger(action)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(337, 2)
   return nwn.engine.StackPopBoolean()
end

--- Does specific action to target door.
-- @param action DOOR_ACTION_*
function Door:DoAction(action)
   nwn.engine.StackPushInteger(action);
   nwn.engine.StackPushObject(self);
   nwn.engine.ExecuteCommand(338, 2);
end
