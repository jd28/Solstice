----
-- Module containing the `Creature` class.
-- @module creature

local ffi = require 'ffi'
local C   = ffi.C
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Creature = inheritsFrom({}, M.Object)

M.Creature  = Creature

local Signal = require 'solstice.external.signal'
Creature.signals = {
  OnConversation = Signal.signal(),
  OnBlocked = Signal.signal(),
  OnDisturbed = Signal.signal(),
  OnPerception = Signal.signal(),
  OnSpellCastAt = Signal.signal(),
  OnCombatRoundEnd = Signal.signal(),
  OnDamaged = Signal.signal(),
  OnPhysicalAttacked = Signal.signal(),
  OnDeath = Signal.signal(),
  OnHeartbeat = Signal.signal(),
  OnRested = Signal.signal(),
  OnSpawn = Signal.signal(),
  OnUserDefined = Signal.signal(),
}

function Creature.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_CREATURE
      },
      { __index = Creature })
end

safe_require 'solstice.objects.creature.ability'
safe_require 'solstice.objects.creature.action'
safe_require 'solstice.objects.creature.ai'
safe_require 'solstice.objects.creature.alignment'
safe_require 'solstice.objects.creature.armor_class'
safe_require 'solstice.objects.creature.associate'
safe_require 'solstice.objects.creature.class'
safe_require 'solstice.objects.creature.combat'
safe_require 'solstice.objects.creature.cutscene'
safe_require 'solstice.objects.creature.effects'
safe_require 'solstice.objects.creature.faction'
safe_require 'solstice.objects.creature.feats'
safe_require 'solstice.objects.creature.hp'
safe_require 'solstice.objects.creature.info'
safe_require 'solstice.objects.creature.internal'
safe_require 'solstice.objects.creature.inventory'
safe_require 'solstice.objects.creature.level'
safe_require 'solstice.objects.creature.modes'
safe_require 'solstice.objects.creature.pc'
safe_require 'solstice.objects.creature.perception'
safe_require 'solstice.objects.creature.saves'
safe_require 'solstice.objects.creature.skills'
safe_require 'solstice.objects.creature.spells'
safe_require 'solstice.objects.creature.state'
safe_require 'solstice.objects.creature.talent'
safe_require 'solstice.objects.creature.xp'

--- Functions
-- @section

--- Generates a random name
-- @param[opt=NAME_FIRST_GENERIC_MALE] name_type NAME_*
-- @return Random name.
function M.RandomName(name_type)
   name_type = name_type or NAME_FIRST_GENERIC_MALE

   NWE.StackPushInteger(name_type);
   NWE.ExecuteCommand(249, 1);
   return NWE.StackPopString();
end

--- Misc
-- @section misc

function Creature:JumpToLimbo()
   if not self:GetIsValid() then return end
   C.nwn_JumpToLimbo(self.obj)
end

--- Briefly displays a string ref as ambient text above targets head.
-- @param strref String ref (therefore text is translated)
-- @param[opt=false] broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters).
function Creature:FloatingStrRef(strref, broadcast)
   NWE.StackPushInteger(broadcast)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(525, 3)
end

--- Briefly displays ambient text above targets head.
-- @param msg Text to display
-- @param[opt=false] broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters).
function Creature:FloatingText(msg, broadcast)
   NWE.StackPushBoolean(broadcast)
   NWE.StackPushObject(self)
   NWE.StackPushString(msg)
   NWE.ExecuteCommand(526, 3)
end

--- Fully restores a creature
-- Gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..)
function Creature:ForceRest()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(775, 1)
end

--- Determines the door that is blocking a creature.
-- @return Last blocking door encountered by the caller and solstice.object.INVALID if none
function Creature:GetBlockingDoor()
   NWE.ExecuteCommand(336, 0)
   return NWE.StackPopObject()
end

--- Checks if a creature has triggered an OnEnter event
-- @param subarea Subarea to check
function Creature:GetIsInSubArea(subarea)
   NWE.StackPushObject(subarea)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(768, 2)

   return NWE.StackPopBoolean()
end
