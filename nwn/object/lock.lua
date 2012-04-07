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

---
function Object:GetLocked()
   local o = lock_get_obj(self)
   return o.lock_locked == 1
end

---
function Object:GetLockable()
   local o = lock_get_obj(self)
   return o.lock_lockable == 1
end

---
function Object:GetLock()
   return lock_t(self.type, self.id, self.obj)
end

---
function Object:GetIsOpen()
   nwn.engine.StackPushObject(obj);
   nwn.engine.ExecuteCommand(443, 1);

   return nwn.engine.StackPopBoolean()
end

---
function Object:SetLocked(locked)
   local o = lock_get_obj(self)
   o.lock_locked = locked
end