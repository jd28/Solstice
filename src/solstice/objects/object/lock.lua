----
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Lock
-- @section lock

--- Get if object is locked
function Object:GetLocked()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_locked == 1
end

--- Get if object is lockabe
function Object:GetLockable()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_lockable == 1
end

--- Get is object open
function Object:GetIsOpen()
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(443, 1);
   return NWE.StackPopBoolean()
end

--- Set object locked
-- @param locked If true object will be locked, if false unlocked.
function Object:SetLocked(locked)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   locked = locked and 1 or 0
   self.obj.lock_locked = locked
end


--- Determine if a key is required.
function Object:GetKeyRequired()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_key_required == 1
end

--- Feedback for when missing key.
function Object:GetKeyRequiredFeedback()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return "" end
   return ffi.string(self.obj.lock_key_required_msg.text)
end

--- Get lock's key tag.
function Object:GetLockKeyTag()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return "" end
   return ffi.string(self.obj.lock_key_name.text)
end

--- Get lock unlock DC
function Object:GetUnlockDC()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return 0 end
   return self.obj.lock_open_dc
end

--- Get lock's lock DC
function Object:GetLockDC()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return 0 end
   return self.obj.lock_lock_dc
end

--- Set an lock locked or unlocked
-- @param locked If true lock will be locked, open if false.
function Object:SetLocked(locked)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   locked = locked and 1 or 0
   self.obj.lock_locked = locked
end

--- Set lock requires key
-- @bool key_required If true key is required, if false not.
function Object:SetKeyRequired(key_required)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   key_required = key_required and 1 or 0
   self.obj.lock_key_required = key_required
end

--- Set feedback message
-- @string message Message sent when creature does not have the key
function Object:SetKeyRequiredFeedback(message)
   NWE.StackPushString(message)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(820, 2)
end

--- Set lock's key tag
-- @string tag New key tag.
function Object:SetKeyTag(tag)
   NWE.StackPushString(tag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(799, 2)
end

--- Set lock to be lockable
-- @bool lockable if true lock can be locked, if false it can't
function Object:SetLockLockable(lockable)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   lockable = lockable and 1 or 0
   self.obj.lock_lockable = lockable
end

--- Set lock's unlock DC
-- @param dc New DC.
function Object:SetUnlockDC(dc)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   self.obj.lock_open_dc = dc
end

--- Set lock's lock DC
-- @param dc New DC.
function Object:SetLockDC(dc)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   self.obj.lock_lock_dc = dc
end
