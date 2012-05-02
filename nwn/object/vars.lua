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

local function get_var_table(obj)
   if obj.type == nwn.GAME_OBJECT_TYPE_MODULE then
      return obj.obj.mod_vartable
   elseif obj.type == nwn.GAME_OBJECT_TYPE_AREA then
      return obj.obj.area_vartable
   else
      return obj.obj.obj.obj_vartable
   end
end

--- Decrements local integer variable
-- @param name Variable name
-- @param val Amount to decrement by (Default: 1)
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

--- Delete a local int variable
-- @param var_name Variable to delete
function Object:DeleteLocalInt(var_name)
    return C.nwn_DeleteLocalInt(get_var_table(self), var_name) 
end

--- Delete a local float variable
-- @param var_name Variable to delete
function Object:DeleteLocalFloat(var_name)
    return C.nwn_DeleteLocalFloat(get_var_table(self), var_name) 
end

--- Delete a local string variable
-- @param var_name Variable to delete
function Object:DeleteLocalString(var_name)
   return C.nwn_DeleteLocalString(get_var_table(self), var_name) 
end

--- Delete a local object variable
-- @param var_name Variable to delete
function Object:DeleteLocalObject(var_name)
    return C.nwn_DeleteLocalObject(get_var_table(self), var_name) 
end

--- Delete a local location variable
-- @param var_name Variable to delete
function Object:DeleteLocalLocation(var_name)
    return C.nwn_DeleteLocalLocation(get_var_table(self), var_name) 
end

--- Boolean wrapper around GetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same var_name
function Object:GetLocalBool(var_name)
   return self:GetLocalInt(var_name) ~= 0
end

--- Get a local int variable
-- @param var_name Variable name
function Object:GetLocalInt(var_name)
    return C.nwn_GetLocalInt(get_var_table(self), var_name) 
end

--- Get local float variable
-- @param var_name Variable name
function Object:GetLocalFloat(var_name)
   return C.nwn_GetLocalFloat(get_var_table(self), var_name)
end

--- Get local location variable
-- @param var_name Variable name
function Object:GetLocalLocation(var_name)
   return C.nwn_GetLocalLocation(get_var_table(self), var_name)
end

--- Get local object variable
-- @param var_name Variable name
function Object:GetLocalObject(var_name)
   return _NL_GET_CACHED_OBJECT(C.nwn_GetLocalObject(get_var_table(self), var_name))
end

---
function Object:GetLocalString(var_name)
   nwn.engine.StackPushString(var_name)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(53, 2)
   local s = nwn.engine.StackPopString()
   return s
end

--- Increment local integer variable
-- @param var_name Variable name
-- @param val Amount to increment. (Default: 1)
function Object:IncrementLocalInt(var_name, val)
    val = val or 1

    local newval = self:GetLocalInt(var_name) + val
    self:SetLocalInt(var_name, newval)
    return newval
end

--- Boolean wrapper around SetLocalInt
-- A wrapper around GetLocalInt returning false if the result is 0, true otherwise.
-- Int/Bool values are stored under the same var_name.
-- @param var_name Variable name
-- @param val Value
function Object:SetLocalBool(var_name, val)
   self:SetLocalInt(var_name, val and 1 or 0)
end

--- Set local float variable
-- @param var_name Variable name
-- @param val Value
function Object:SetLocalFloat(var_name, val)
   C.nwn_SetLocalFloat(get_var_table(self), var_name, val)
end

--- Set local int variable
-- @param var_name Variable name
-- @param val Value
function Object:SetLocalInt(var_name, val) 
    C.nwn_SetLocalInt(get_var_table(self), var_name, val) 
end

--- Set local location variable
-- @param var_name Variable name
-- @param val Value
function Object:SetLocalLocation(var_name, val)
    C.nwn_SetLocalLocation(get_var_table(self), var_name, val) 
end

--- Set local float variable
-- @param var_name Variable name
-- @param val Value
-- TODO: Redo this or NWNX won't be able to hook it.
function Object:SetLocalString(var_name, val)
    C.nwn_SetLocalString(get_var_table(self), var_name, val) 
end

--- Set local object variable
-- @param var_name Variable name
-- @param val Value
function Object:SetLocalObject(var_name, val)
    C.nwn_SetLocalObject(get_var_table(self), var_name, val.id) 
end

