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
require 'nwn.funcs'

ffi.cdef[[
typedef struct Object {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Object;
]]

local object_mt = { __index = Object }
object_t = ffi.metatype("Object", object_mt)

-- Create invalid object so don't have to test nullity and validity.
nwn.OBJECT_INVALID = object_t(-1, 0x7F000000, nil)

require "nwn.object.action"
require "nwn.object.combat"
require "nwn.object.commands"
require "nwn.object.effects"
require "nwn.object.info"
require "nwn.object.inventory"
require "nwn.object.listen"
require "nwn.object.location"
require "nwn.object.lock"
require "nwn.object.nearest"
require "nwn.object.saves"
require "nwn.object.spells"
require "nwn.object.state"
require "nwn.object.vars"

---
-- @param 
-- @return
function Object:Copy(location, owner, tag)
   tag   = tag or ""

   nwn.engine.StackPushString(tag)
   nwn.engine.StackPushObject(owner)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, location)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(600, 4)

   return nwn.engine.StackPopObject()
end

---
-- @param 
-- @return
function Object:BeginConversation(target, conversation)
   conversation = conversation or ""
   
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushString(conversation)
   nwn.engine.ExecuteCommand(255, 2)
   nwn.engine.StackPopInteger()
end

--- Destroy an object.
-- @param delay Delay (in seconds) before object is destroyed. (Default: 0.0f) 
function Object:Destroy(delay)
   delay = delay or 0.0

   nwn.engine.StackPushFloat(delay)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(241, 2)
end

--- Returns the Resref of an object.
-- @return The Resref, empty string on error. 
function Object:GetResref()
   return ffi.string(ffi.C.nl_Object_GetTag(ffi.cast("Object*", self)))
end

--- Determine the tag associated with an object.
-- @return Tag of the object, empty string on error.
function Object:GetTag()
   if self.type == GAME_OBJECT_TYPE_AREA then
      return ffi.string(self.obj.area_tag.text)
   end
   local o = ffi.cast("Object*", self)
   return ffi.string(o.obj.tag)
end

--- Determine if named timer is still active.
-- @return true if the timer is active
function Object:GetIsTimerActive(var_name)
   return self:GetLocalBool(var_name)
end

---
-- NWScript: NONE
-- @param 
-- @return
function Object:GetTrap()
   if self.type == GAME_OBJECT_TYPE_DOOR or
      self.type == GAME_OBJECT_TYPE_PLACEABLE or
      self.type == GAME_OBJECT_TYPE_TRIGGER then
      return trap_t(self.id, self.type, ffi.cast("CGameObject*", self.obj))
   end

   return nwn.OBJECT_INVALID
end

--- Check whether an object is trapped.
-- @return true if self is trapped, otherwise false.
function Object:GetIsTrapped()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(551, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Object:GetIsValid()
   if self.id == 0x7F000000 then
      return false
   end

   return _OBJECTS[self.id] and true or false
end

---
-- @param 
-- @return
function Object:PlaySound(sound)
   nwn.engine.StackPushString(sound)
   nwn.engine.ExecuteCommand(46, 1)
end

---
function Object:PlaySoundByStrRef(strref, as_action)
   nwn.engine.StackPushInteger(as_action)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(720, 2)
end

---
-- @param 
-- @return
function Object:ResistSpell(oVersus)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(oVersus)
   nwn.engine.ExecuteCommand(169, 2)
   return nwn.engine.StackPopBoolean()
end

---
function Object:__tostring()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(272, 1)
   return nwn.engine.StackPopString()
end

---
function Object:SetTag(tag)
   ffi.C.nl_Object_SetTag(ffi.cast("Object*", self), tag)
end

---
function Object:Trap(nType, nFaction, sOnDisarm, sOnTriggered)
   nwn.engine.StackPushString(sOnTriggered)
   nwn.engine.StackPushString(sOnDisarm)
   nwn.engine.StackPushInteger(nFaction)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nType)
   nwn.engine.ExecuteCommand(810, 5)
end

---
function Object:GetTransitionTarget()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(198, 1)
   return nwn.engine.StackPopObject()
end

---
function Object:GetLastOpenedBy()
   nwn.engine.ExecuteCommand(376, 0)
   return nwn.engine.StackPopObject()
end

---
function Object:SetTimer(var_name, duration, on_expire)
   self:SetLocalBool(var_name, true)
   self:DelayCommand(duration,
                     function ()
                        self:DeleteLocalBool(var_name)
                        if on_expire then
                           on_expire(self, var_name)
                        end
                     end)
end