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
require "nwn.object.hp"
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

--- Copies an object
-- @param location Location to copy the object to.
-- @param owner Owner of the object
-- @param tag Tag of new object (Default: "")
function Object:Copy(location, owner, tag)
   tag = tag or ""

   nwn.engine.StackPushString(tag)
   nwn.engine.StackPushObject(owner)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, location)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(600, 4)

   return nwn.engine.StackPopObject()
end

--- Begin conversation
-- @param target Object to converse with
-- @param conversation Dialog resref
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

--- Determine if named timer is still active.
-- @return true if the timer is active
function Object:GetIsTimerActive(var_name)
   return self:GetLocalBool(var_name)
end

---
-- @param 
-- @return
function Object:GetTrap()
   if self.type == GAME_OBJECT_TYPE_DOOR or
      self.type == GAME_OBJECT_TYPE_PLACEABLE or
      self.type == GAME_OBJECT_TYPE_TRIGGER then
      return trap_t(self.id, self.type, ffi.cast("CGameObject*", self.obj))
   end
-- TODO: Implement
   return nwn.OBJECT_INVALID
end

--- Check whether an object is trapped.
-- @return true if self is trapped, otherwise false.
function Object:GetIsTrapped()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(551, 1)
   return nwn.engine.StackPopBoolean()
end

--- Determines if an object is valid
function Object:GetIsValid()
   if self.id == 0x7F000000 then
      return false
   end

   return _OBJECTS[self.id] and true or false
end

--- Causes object to play a sound
-- @param sound Sound to play
function Object:PlaySound(sound)
   nwn.engine.StackPushString(sound)
   nwn.engine.ExecuteCommand(46, 1)
end

--- Causes object to play a sound
-- @param strref Sound to play
-- @param as_action Determines if this is an action that can be stacked on the action queue. 
--    (Default: true)
function Object:PlaySoundByStrRef(strref, as_action)
   if as_action == nil then as_action = true end
   nwn.engine.StackPushInteger(as_action)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(720, 2)
end

--- Attemp to resist a spell
-- @param vs Attacking caster
function Object:ResistSpell(vs)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(vs)
   nwn.engine.ExecuteCommand(169, 2)
   return nwn.engine.StackPopBoolean()
end

--- Changes an objects tag.
-- @param tag New tag.
function Object:SetTag(tag)
   -- TODO: Implement
end

--- Traps an objeect
-- @param type nwn.TRAP_BASE_TYPE_*
-- @param faction nwn.STANDARD_FACTION_*
-- @param on_disarm OnDisarmed script (Default: "")
-- @param on_trigger OnTriggered script (Default: "")
function Object:Trap(type, faction, on_disarm, on_trigger)
   nwn.engine.StackPushString(on_trigger or "")
   nwn.engine.StackPushString(on_disarm or "")
   nwn.engine.StackPushInteger(faction)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(type)
   nwn.engine.ExecuteCommand(810, 5)
end

--- Gets transition target
function Object:GetTransitionTarget()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(198, 1)
   return nwn.engine.StackPopObject()
end

--- Gets the last object to open an object
function Object:GetLastOpenedBy()
   nwn.engine.ExecuteCommand(376, 0)
   return nwn.engine.StackPopObject()
end

--- Sets a timer on an object
-- @param var_name Variable name to hold the timer
-- @param duration Duration in seconds before timer expires.
-- @param on_expire Function which takes to arguments then object the
--    timer was set on and the variable.
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