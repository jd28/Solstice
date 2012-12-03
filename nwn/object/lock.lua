--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Get if object is locked
function Object:GetLocked()
   local o = lock_get_obj(self)
   return o.lock_locked == 1
end

--- Get if object is lockabe
function Object:GetLockable()
   local o = lock_get_obj(self)
   return o.lock_lockable == 1
end

--- Get the objects lock
function Object:GetLock()
   return lock_t(self.type, self.id, self.obj)
end

--- Get is object open
function Object:GetIsOpen()
   nwn.engine.StackPushObject(obj);
   nwn.engine.ExecuteCommand(443, 1);

   return nwn.engine.StackPopBoolean()
end

--- Set object locked
-- @param locked If true object will be locked, if false unlocked.
function Object:SetLocked(locked)
   local o = lock_get_obj(self)
   o.lock_locked = locked
end