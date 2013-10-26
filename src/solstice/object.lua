-------------------------------------------------
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = safe_require 'solstice.object.init'
M.const = safe_require 'solstice.object.constant'
setmetatable(M, { __index = M.const })

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

M.Object = inheritsFrom(nil)

--- Internal Object ctype.
-- See sol/ctypes.lua for definition.
M.object_t = ffi.metatype("Object", { __index = M.Object })

--- Invalid Object.
-- Create invalid object so don't have to test nullity and validity.
M.INVALID = M.object_t(-1, 0x7F000000, nil)


safe_require "solstice.object.action"
safe_require "solstice.object.combat"
safe_require "solstice.object.commands"
safe_require "solstice.object.effects"
safe_require "solstice.object.hp"
safe_require "solstice.object.info"
safe_require "solstice.object.inventory"
safe_require "solstice.object.preception"
safe_require "solstice.object.location"
safe_require "solstice.object.lock"
safe_require "solstice.object.nearest"
safe_require "solstice.object.saves"
safe_require "solstice.object.spells"
safe_require "solstice.object.vars"

--- Functions
-- @section

--- Create an object of a specified type at a given location 
-- NWScript: CreateObject
-- @param object_type solstice.object.ITEM, solstice.object.CREATURE,
-- solstice.object.PLACEABLE, solstice.object.STORE, solstice.object.WAYPOINT.
-- @param template The resref of the object to create from the pallet.
-- @param loc The location to create the object at.
-- @param[opt=false] appear If `true`, the object will play its spawn in animation.
-- @param[opt=""] newtag If this string is not empty, it will replace the default tag from the template.
-- @return New object or solstice.object.INVALID
function M.Create(object_type, template, loc, appear, newtag)
   if appear == nil then appear = false end
   newtag = newtag or ""
   print (object_type, template, loc, appear, newtag)
   NWE.StackPushString(newtag)
   NWE.StackPushBoolean(appear)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.StackPushString(template)
   NWE.StackPushInteger(object_type)
   NWE.ExecuteCommand(243, 5)

   return NWE.StackPopObject()
end

--- Gets an object by tag
-- @param tag Tag of object
-- @param[opt=1] nth Nth object.
function M.GetByTag(tag, nth)
   nth = nth or 1
   
   NWE.StackPushInteger(nth)
   NWE.StackPushString(tag)
   NWE.ExecuteCommand(200, 2)
   return NWE.StackPopObject()
end


--- Class Object
-- @section class_object

--- Copies an object
-- @param location Location to copy the object to.
-- @param owner Owner of the object
-- @param[opt=""] tag Tag of new object.
function M.Object:Copy(location, owner, tag)
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
function M.Object:BeginConversation(target, conversation)
   conversation = conversation or ""
   
   NWE.StackPushObject(target)
   NWE.StackPushString(conversation)
   NWE.ExecuteCommand(255, 2)
   NWE.StackPopInteger()
end

--- Destroy an object.
-- @param[opt=0.0] delay Delay (in seconds) before object is destroyed.
function M.Object:Destroy(delay)
   delay = delay or 0.0

   NWE.StackPushFloat(delay)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(241, 2)
end

--- Determine if dead
function M.Object:GetIsDead()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(140, 1);
   return NWE.StackPopBoolean();
end


--- Determine if named timer is still active.
-- @param name Timer name.
-- @return true if the timer is active
function M.Object:GetIsTimerActive(name)
   return self:GetLocalBool(name)
end

function M.Object:GetTrap()
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
function M.Object:GetIsTrapped()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(551, 1)
   return NWE.StackPopBoolean()
end

--- Determines if an object is valid
function M.Object:GetIsValid()
   if self.id == 0x7F000000 then
      return false
   end

   local ob = _SOL_GET_CACHED_OBJECT(self.id)
   return ob.id ~= 0x7F000000
end

--- Causes object to play a sound
-- @param sound Sound to play
function M.Object:PlaySound(sound)
   NWE.StackPushString(sound)
   NWE.ExecuteCommand(46, 1)
end

--- Causes object to play a sound
-- @param strref Sound to play
-- @param[opt=true] as_action Determines if this is an action that can be stacked on the action queue.
function M.Object:PlaySoundByStrRef(strref, as_action)
   if as_action == nil then as_action = true end
   NWE.StackPushInteger(as_action)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(720, 2)
end

--- Attemp to resist a spell
-- @param vs Attacking caster
function M.Object:ResistSpell(vs)
   NWE.StackPushObject(self)
   NWE.StackPushObject(vs)
   NWE.ExecuteCommand(169, 2)
   return NWE.StackPopBoolean()
end

--- Changes an objects tag.
-- @param tag New tag.
function M.Object:SetTag(tag)
   error "TODO"
   -- TODO: Implement
end

--- Traps an objeect
-- @param type solstice.nwn.TRAP\_BASE\_TYPE_*
-- @param faction solstice.nwn.STANDARD\_FACTION\_*
-- @param[opt=""] on_disarm OnDisarmed script.
-- @param[opt=""] on_trigger OnTriggered script.
function M.Object:Trap(type, faction, on_disarm, on_trigger)
   NWE.StackPushString(on_trigger or "")
   NWE.StackPushString(on_disarm or "")
   NWE.StackPushInteger(faction)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(type)
   NWE.ExecuteCommand(810, 5)
end

--- Gets transition target
function M.Object:GetTransitionTarget()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(198, 1)
   return NWE.StackPopObject()
end

--- Gets the last object to open an object
function M.Object:GetLastOpenedBy()
   NWE.ExecuteCommand(376, 0)
   return NWE.StackPopObject()
end

--- Sets a timer on an object
-- @param var_name Variable name to hold the timer
-- @param duration Duration in seconds before timer expires.
-- @param on_expire Function which takes to arguments then object the
-- timer was set on and the variable.
function M.Object:SetTimer(var_name, duration, on_expire)
   self:SetLocalBool(var_name, true)
   self:DelayCommand(duration,
                     function ()
                        self:DeleteLocalBool(var_name)
                        if on_expire then
                           on_expire(self, var_name)
                        end
                     end)
end

return M