--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

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