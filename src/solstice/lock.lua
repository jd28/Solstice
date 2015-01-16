--- Lock
-- This module is broken...
-- @module lock
-- @alias M

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = {}
M.Lock = {}

--- Internal ctype.
M.lock_t = ffi.metatype("Lock", { __index = M.Lock })

local function lock_get_obj(lock)
   local obj = _SOL_GET_CACHED_OBJECT(lock.id)
   if not anyinstance(obj, Door, Placeable) then
      error "Invalid type"
   end
   return obj
end

--- Determine if a key is required.
function M.Lock:GetKeyRequired()
   local o = lock_get_obj(self)
   return o.obj.lock_key_required == 1
end

--- Feedback for when missing key.
function M.Lock:GetKeyRequiredFeedback()
   NWE.StackPushObject(lock_get_obj(self))
   NWE.ExecuteCommand(819, 1)
   return NWE.StackPopString()
end

--- Get lock's key tag
function M.Lock:GetLockKeyTag()
   local o = lock_get_obj(self)
   return ffi.string(o.obj.lock_key_name)
end

--- Get lock unlock DC
function M.Lock:GetUnlockDC()
   local o = lock_get_obj(self)
   return o.obj.lock_open_dc
end

--- Get lock's lock DC
function M.Lock:GetLockDC()
   local o = lock_get_obj(self)
   return o.obj.lock_lock_dc
end

--- Set an lock locked or unlocked
-- @param locked If true lock will be locked, open if false.
function M.Lock:SetLocked(locked)
   locked = locked and 1 or 0
   local o = lock_get_obj(self)
   o.obj.lock_locked = locked
end

--- Set lock requires key
-- @param key_required If true key is required, if false not.
function M.Lock:SetKeyRequired(key_required)
   key_required = key_required and 1 or 0
   local o = lock_get_obj(self)
   o.obj.lock_key_required = key_required
end

--- Set feedback message
-- @param message Message sent when creature does not have the key
function M.Lock:SetKeyRequiredFeedback(message)
   NWE.StackPushString(message)
   NWE.StackPushObject(lock_get_obj(self))
   NWE.ExecuteCommand(820, 2)
end

--- Set lock's key tag
function M.Lock:SetKeyTag(sNewKeyTag)
   NWE.StackPushString(sNewKeyTag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(799, 2)
end

--- Set lock to be lockable
-- @param lockable if true lock can be locked, if false it can't
function M.Lock:SetLockLockable(lockable)
   lockable = lockable and 1 or 0

   local o = lock_get_obj(self)
   o.obj.lock_lockable = locakable
end

--- Set lock's unlock DC
function M.Lock:SetUnlockDC(dc)
   local o = lock_get_obj(self)
   o.obj.lock_open_dc = dc
end

--- Set lock's lock DC
function M.Lock:SetLockDC(dc)
   local o = lock_get_obj(self)
   o.obj.lock_lock_dc = dc
end

return M
