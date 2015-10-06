----
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Lock
-- @section lock

function Object:GetLocked()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_locked == 1
end

function Object:GetLockable()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_lockable == 1
end

function Object:GetIsOpen()
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(443, 1);
   return NWE.StackPopBoolean()
end

function Object:SetLocked(locked)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   locked = locked and 1 or 0
   self.obj.lock_locked = locked
end


function Object:GetKeyRequired()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return false end
   return self.obj.lock_key_required == 1
end

function Object:GetKeyRequiredFeedback()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return "" end
   return ffi.string(self.obj.lock_key_required_msg.text)
end

function Object:GetLockKeyTag()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return "" end
   return ffi.string(self.obj.lock_key_name.text)
end

function Object:GetUnlockDC()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return 0 end
   return self.obj.lock_open_dc
end

function Object:GetLockDC()
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return 0 end
   return self.obj.lock_lock_dc
end

function Object:SetKeyRequired(key_required)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   key_required = key_required and 1 or 0
   self.obj.lock_key_required = key_required
end

function Object:SetKeyRequiredFeedback(message)
   NWE.StackPushString(message)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(820, 2)
end

function Object:SetKeyTag(tag)
   NWE.StackPushString(tag)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(799, 2)
end

function Object:SetLockLockable(lockable)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   lockable = lockable and 1 or 0
   self.obj.lock_lockable = lockable
end

function Object:SetUnlockDC(dc)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   self.obj.lock_open_dc = dc
end

function Object:SetLockDC(dc)
   if not self:CheckType(OBJECT_TYPE_DOOR, OBJECT_TYPE_PLACEABLE) then return end
   self.obj.lock_lock_dc = dc
end
