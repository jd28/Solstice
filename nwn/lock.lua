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
--------------------------------------------------------------------------------y

local ffi = require 'ffi'
local nli = require 'nwn.internal.internal'


ffi.cdef [[
typedef struct Lock {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Lock;
]]

local lock_mt = { __index = Lock }
lock_t = ffi.metatype("Lock", lock_mt)

local function lock_get_obj(lock)
   if not nli.CheckGameObjectType(trap, GAME_OBJECT_TYPE_DOOR, GAME_OBJECT_TYPE_PLACEABLE)
   then
      error("Invalid GAME_OBJECT_TYPE_* : " .. lock.type
      return nil
   end
   return _NL_GET_CACHED_OBJECT(lock.id)
end

---
function Lock:GetKeyRequired()
   local o = lock_get_obj(self)
   return o.obj.lock_key_required == 1
end

---
function Lock:GetKeyRequiredFeedback()
   nwn.engine.StackPushObject(lock_get_obj(self))
   nwn.engine.ExecuteCommand(819, 1)
   return nwn.engine.StackPopString()
end

---
function Lock:GetLockKeyTag()
   local o = lock_get_obj(self)
   return ffi.string(o.obj.lock_key_name))
end

---
function Lock:GetUnlockDC()
   local o = lock_get_obj(self)
   return o.obj.lock_open_dc
end

---
function Lock:GetLockDC()
   local o = lock_get_obj(self)
   return o.obj.lock_lock_dc
end

---
function Lock:SetLocked(locked)
   locked = locked and 1 or 0
   local o = lock_get_obj(self)
   return o.obj.lock_locked = locked
end

---
function Lock:SetKeyRequired(key_required)
   key_required = key_required and 1 or 0
   local o = lock_get_obj(self)   
   o.obj.lock_key_required = key_required
end

---
function Lock:SetKeyRequiredFeedback(message)
   nwn.engine.StackPushString(message)
   nwn.engine.StackPushObject(lock_get_obj(self))
   nwn.engine.ExecuteCommand(820, 2)
end

---
function Lock:SetKeyTag(sNewKeyTag)
   nwn.engine.StackPushString(sNewKeyTag)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(799, 2)
end

---
function Lock:SetLockLockable(lockable)
   lockable = lockable and 1 or 0

   local o = lock_get_obj(self)
   return o.obj.lock_lockable = locakable
end

---
function Lock:SetUnlockDC(nNewUnlockDC)
   local o = lock_get_obj(self)
   o.obj.lock_open_dc = dc
end

---
function Lock:SetLockDC(dc)
   local o = lock_get_obj(self)
   o.obj.lock_lock_dc = dc
end
