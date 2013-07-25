--- Creature module
-- @module creature

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

local M = require 'solstice.creature.init'
M.const = require 'solstice.creature.constant'
setmetatable(M, { __index = M.const })

M.Creature  = inheritsFrom(Obj.Object, "solstice.creature.Creature" )

--- Internal ctype.
M.creature_t = ffi.metatype("Creature", { __index = M.Creature })

safe_require 'solstice.creature.ability'
safe_require 'solstice.creature.action'
safe_require 'solstice.creature.ai'
safe_require 'solstice.creature.alignment'
safe_require 'solstice.creature.armor_class'
safe_require 'solstice.creature.associate'
safe_require 'solstice.creature.attack_bonus'
safe_require 'solstice.creature.class'
safe_require 'solstice.creature.combat'
safe_require 'solstice.creature.conceal'
safe_require 'solstice.creature.cutscene'
safe_require 'solstice.creature.effects'
safe_require 'solstice.creature.faction'
safe_require 'solstice.creature.feats'
safe_require 'solstice.creature.hp'
safe_require 'solstice.creature.info'
safe_require 'solstice.creature.internal'
safe_require 'solstice.creature.inventory'
safe_require 'solstice.creature.level'
safe_require 'solstice.creature.logger'
safe_require 'solstice.creature.modes'
safe_require 'solstice.creature.pc'
safe_require 'solstice.creature.saves'
safe_require 'solstice.creature.skills'
safe_require 'solstice.creature.spells'
safe_require 'solstice.creature.state'
safe_require 'solstice.creature.talent'
safe_require 'solstice.creature.xp'

--- Functions
-- @section

--- Generates a random name
-- @param[opt=solstice.creature.NAME_FIRST_GENERIC_MALE] name_type solstice.creature.NAME_*
-- @return Random name.
function M.RandomName(name_type)
   name_type = name_type or M.NAME_FIRST_GENERIC_MALE

   NWE.StackPushInteger(name_type);
   NWE.ExecuteCommand(249, 1);
   return NWE.StackPopString();
end

--- Misc
-- @section misc

--- Briefly displays a string ref as ambient text above targets head.
-- @param strref String ref (therefore text is translated)
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function M.Creature:FloatingStrRef(strref, broadcast)
   NWE.StackPushInteger(broadcast)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(525, 3)
end

--- Briefly displays ambient text above targets head.
-- @param msg Text to display
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function M.Creature:FloatingText(msg, broadcast)
   NWE.StackPushBoolean(broadcast)
   NWE.StackPushObject(self)
   NWE.StackPushString(msg)
   NWE.ExecuteCommand(526, 3)
end

--- Fully restores a creature
-- Gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..) 
function M.Creature:ForceRest()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(775, 1)
end

--- Determines the door that is blocking a creature.
-- @return Last blocking door encountered by the caller and solstice.object.INVALID if none
function M.Creature:GetBlockingDoor()
   NWE.ExecuteCommand(336, 0)
   return NWE.StackPopObject()
end

--- Checks if a creature has triggered an OnEnter event
-- @param subarea Subarea to check 
function M.Creature:GetIsInSubArea(subarea)
   NWE.StackPushObject(subarea)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(768, 2)

   return NWE.StackPopBoolean()
end

return M