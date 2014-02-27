--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'

--- Class Object: Lock
-- @section lock

--- Get if object is locked
function M.Object:GetLocked()
   local o = lock_get_obj(self)
   return o.lock_locked == 1
end

--- Get if object is lockabe
function M.Object:GetLockable()
   local o = lock_get_obj(self)
   return o.lock_lockable == 1
end

--- Get the objects lock
function M.Object:GetLock()
   return lock_t(self.type, self.id, self.obj)
end

--- Get is object open
function M.Object:GetIsOpen()
   NWE.StackPushObject(obj);
   NWE.ExecuteCommand(443, 1);

   return NWE.StackPopBoolean()
end

--- Set object locked
-- @param locked If true object will be locked, if false unlocked.
function M.Object:SetLocked(locked)
   local o = lock_get_obj(self)
   o.lock_locked = locked
end