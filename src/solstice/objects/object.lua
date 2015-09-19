----
-- @module object

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local C = ffi.C

local Object = {}
M.Object = Object

function Object.new(id)
   return setmetatable({
         id = id,
         type = -1
      },
      { __index = Object })
end

--- Constants
-- @section class_object

--- Invalid Object.
-- Create invalid object so don't have to test nullity and validity.
M.INVALID = Object.new(0x7F000000)

safe_require "solstice.objects.object.action"
safe_require "solstice.objects.object.combat"
safe_require "solstice.objects.object.commands"
safe_require "solstice.objects.object.effects"
safe_require "solstice.objects.object.hp"
safe_require "solstice.objects.object.info"
safe_require "solstice.objects.object.inventory"
safe_require "solstice.objects.object.preception"
safe_require "solstice.objects.object.location"
safe_require "solstice.objects.object.lock"
safe_require "solstice.objects.object.nearest"
safe_require "solstice.objects.object.saves"
safe_require "solstice.objects.object.spells"
safe_require "solstice.objects.object.trap"
safe_require "solstice.objects.object.vars"

--- Class Object
-- @section class_object

--- Copies an object
-- @param location Location to copy the object to.
-- @param owner Owner of the object
-- @param[opt=""] tag Tag of new object.
function Object:Copy(location, owner, tag)
   tag = tag or ""

   NWE.StackPushString(tag)
   NWE.StackPushObject(owner)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(600, 4)

   return NWE.StackPopObject()
end

--- Begin conversation
-- @param target Object to converse with
-- @param[opt=""] conversation Dialog resref
function Object:BeginConversation(target, conversation)
   conversation = conversation or ""

   NWE.StackPushObject(target)
   NWE.StackPushString(conversation)
   NWE.ExecuteCommand(255, 2)
   NWE.StackPopInteger()
end

--- Destroy an object.
-- @param[opt=0.0] delay Delay (in seconds) before object is destroyed.
function Object:Destroy(delay)
   delay = delay or 0.0

   NWE.StackPushFloat(delay)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(241, 2)
end

--- Determine if dead
function Object:GetIsDead()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(140, 1);
   return NWE.StackPopBoolean();
end


--- Determine if named timer is still active.
-- @param name Timer name.
-- @return true if the timer is active
function Object:GetIsTimerActive(name)
   return self:GetLocalBool(name)
end

function Object:GetTrap()
   if self.type == GAME_OBJECT_TYPE_DOOR or
      self.type == GAME_OBJECT_TYPE_PLACEABLE or
      self.type == GAME_OBJECT_TYPE_TRIGGER then
      return trap_t(self.id, self.type, ffi.cast("CGameObject*", self.obj))
   end
-- TODO: Implement
   return M.INVALID
end

--- Check whether an object is trapped.
-- @return true if self is trapped, otherwise false.
function Object:GetIsTrapped()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(551, 1)
   return NWE.StackPopBoolean()
end

--- Determines if an object is valid
function Object:GetIsValid()
   if self.id == 0x7F000000 then return false end
   return C.nwn_GetObjectByID(self.id) ~= nil
end

--- Causes object to play a sound
-- @param sound Sound to play
function Object:PlaySound(sound)
   NWE.StackPushString(sound)
   NWE.ExecuteCommand(46, 1)
end

--- Causes object to play a sound
-- @param strref Sound to play
-- @param[opt=true] as_action Determines if this is an action that
-- can be stacked on the action queue.
function Object:PlaySoundByStrRef(strref, as_action)
   if as_action == nil then as_action = true end
   NWE.StackPushInteger(as_action)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(720, 2)
end

--- Attemp to resist a spell
-- @param vs Attacking caster
function Object:ResistSpell(vs)
   NWE.StackPushObject(self)
   NWE.StackPushObject(vs)
   NWE.ExecuteCommand(169, 2)
   return NWE.StackPopBoolean()
end

--- Changes an objects tag.
-- @param tag New tag.
function Object:SetTag(tag)
   error "TODO"
   -- TODO: Implement
end

--- Traps an objeect
-- @param type TRAP\_BASE\_TYPE_*
-- @param faction STANDARD\_FACTION\_*
-- @param[opt=""] on_disarm OnDisarmed script.
-- @param[opt=""] on_trigger OnTriggered script.
function Object:Trap(type, faction, on_disarm, on_trigger)
   NWE.StackPushString(on_trigger or "")
   NWE.StackPushString(on_disarm or "")
   NWE.StackPushInteger(faction)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(type)
   NWE.ExecuteCommand(810, 5)
end

--- Gets transition target
function Object:GetTransitionTarget()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(198, 1)
   return NWE.StackPopObject()
end

--- Get an object's type.
-- @return OBJECT\_TYPE\_* or OBJECT_TYPE_NONE on error.
function Object:GetType()
   if not self:GetIsValid() then return OBJECT_TYPE_NONE end
   if self.type == OBJECT_TRUETYPE_CREATURE then
      return OBJECT_TYPE_CREATURE
   elseif self.type == OBJECT_TRUETYPE_ITEM then
      return OBJECT_TYPE_ITEM
   elseif self.type == OBJECT_TRUETYPE_TRIGGER then
      return OBJECT_TYPE_TRIGGER
   elseif self.type == OBJECT_TRUETYPE_DOOR then
      return OBJECT_TYPE_DOOR
   elseif self.type == OBJECT_TRUETYPE_AREA_OF_EFFECT then
      return OBJECT_TYPE_AREA_OF_EFFECT
   elseif self.type == OBJECT_TRUETYPE_WAYPOINT then
      return OBJECT_TYPE_WAYPOINT
   elseif self.type == OBJECT_TRUETYPE_ENCOUNTER then
      return OBJECT_TYPE_ENCOUNTER
   elseif self.type == OBJECT_TRUETYPE_STORE then
      return OBJECT_TYPE_STORE
   elseif self.type == OBJECT_TRUETYPE_PLACEABLE then
      return OBJECT_TYPE_PLACEABLE
   end

   return OBJECT_TYPE_NONE
end

--- Gets the last object to open an object
function Object:GetLastOpenedBy()
   NWE.ExecuteCommand(376, 0)
   return NWE.StackPopObject()
end

--- Sets a timer on an object
-- @param var_name Variable name to hold the timer
-- @param duration Duration in seconds before timer expires.
-- @param on_expire Function which takes to arguments then object the
-- timer was set on and the variable.
function Object:SetTimer(var_name, duration, on_expire)
   self:SetLocalBool(var_name, true)
   self:DelayCommand(duration,
                     function (self)
                        if not self:GetIsValid() then return end
                        self:DeleteLocalBool(var_name)
                        if on_expire then
                           on_expire(self, var_name)
                        end
                     end)
end
