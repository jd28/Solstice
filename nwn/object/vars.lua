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

local ffi = require("ffi")
local C = ffi.C

-- TODO fix local variable functions...

---
function Object:DecrementLocalInt(name, val)
    val = val or 1

    local newval = self:GetLocalInt(name) - val
    self:SetLocalInt(name, newval)
    return newval
end

--- Boolean wrapper around DeleteLocalInt
-- Int/Bool values are stored under the same var_name
function Object:DeleteLocalBool(var_name)
   self:DeleteLocalInt(var_name)
end

---
function Object:DeleteLocalInt(var_name)
    return C.nwn_DeleteLocalInt(ffi.cast("Object*", self), var_name) 
end

---
function Object:DeleteLocalFloat(var_name)
    return C.nwn_DeleteLocalFloat(ffi.cast("Object*", self), var_name) 
end

---
function Object:DeleteLocalString(var_name)
    return C.nwn_DeleteLocalString(ffi.cast("Object*", self), var_name) 
end

---
function Object:DeleteLocalObject(var_name)
    return C.nwn_DeleteLocalObject(ffi.cast("Object*", self), var_name) 
end

---
function Object:DeleteLocalLocation(var_name)
    return C.nwn_DeleteLocalLocation(ffi.cast("Object*", self), var_name) 
end

--- Boolean wrapper around GetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same var_name
function Object:GetLocalBool(var_name)
   return self:GetLocalInt(var_name) ~= 0
end

---
function Object:GetLocalInt(var_name)
    return C.nwn_GetLocalInt(ffi.cast("Object*", self), var_name) 
end

---
function Object:GetLocalFloat(var_name)
   return C.nwn_GetLocalFloat(ffi.cast("Object*", self), var_name)
end

---
function Object:GetLocalLocation(var_name)
   return C.nwn_GetLocalLocation(ffi.cast("Object*", self), var_name)
end

---
function Object:GetLocalObject(var_name)
   return _NL_GET_CACHED_OBJECT(C.nwn_GetLocalObject(ffi.cast("Object*", self), var_name))
end

---
function Object:GetLocalString(var_name)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(53, 2)
   local s = nwn.engine.StackPopString()
   return s
end

---
function Object:IncrementLocalInt(var_name, val)
    val = val or 1

    local newval = self:GetLocalInt(var_name) + val
    self:SetLocalInt(var_name, newval)
    return newval
end

--- Boolean wrapper around SetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same var_name.
-- 
function Object:SetLocalBool(var_name, val)
   self:SetLocalInt(var_name, val and 1 or 0)
end

---
function Object:SetLocalFloat(var_name, val)
   C.nwn_SetLocalFloat(ffi.cast("Object*", self), var_name, val)
end

---
function Object:SetLocalInt(var_name, val) 
    C.nwn_SetLocalInt(ffi.cast("Object*", self), var_name, val) 
end

---
function Object:SetLocalLocation(var_name, val)
    C.nwn_SetLocalLocation(ffi.cast("Object*", self), var_name, val) 
end

---
function Object:SetLocalString(var_name, val)
    C.nwn_SetLocalString(ffi.cast("Object*", self), var_name, val) 
end

---
function Object:SetLocalObject(var_name, val)
    C.nwn_SetLocalObject(ffi.cast("Object*", self), var_name, val.id) 
end

