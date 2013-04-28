nwn.SITUATIONAL_FLAG_COUP_DE_GRACE = 1
nwn.SITUATIONAL_FLAG_SNEAK_ATTACK = 2
nwn.SITUATIONAL_FLAG_DEATH_ATTACK = 4

nwn.SITUATIONAL_COUP_DE_GRACE = 0
nwn.SITUATIONAL_SNEAK_ATTACK = 1
nwn.SITUATIONAL_DEATH_ATTACK = 2
nwn.SITUATIONAL_NUM = 3

require 'nwn.ctypes.combat'
require 'nwn.ctypes.creature'
require 'nwn.dice'

local ffi = require 'ffi'


ffi.cdef[[
typedef struct Creature {
    uint32_t           type;
    uint32_t           id;
    CNWSCreature      *obj;
    CNWSCreatureStats *stats;
    uint32_t           effective_level;
    uint32_t           first_custom_eff;
} Creature;
]]

local creature_mt = { __index = Creature }
creature_t = ffi.metatype("Creature", creature_mt)

safe_require 'nwn.creature.ability'
safe_require 'nwn.creature.action'
safe_require 'nwn.creature.ai'
safe_require 'nwn.creature.alignment'
safe_require 'nwn.creature.armor_class'
safe_require 'nwn.creature.associate'
safe_require 'nwn.creature.attack_bonus'
safe_require 'nwn.creature.class'
safe_require 'nwn.creature.combat'
safe_require 'nwn.creature.conceal'
safe_require 'nwn.creature.cutscene'
safe_require 'nwn.creature.effects'
safe_require 'nwn.creature.faction'
safe_require 'nwn.creature.feats'
safe_require 'nwn.creature.hp'
safe_require 'nwn.creature.info'
safe_require 'nwn.creature.internal'
safe_require 'nwn.creature.inventory'
safe_require 'nwn.creature.level'
safe_require 'nwn.creature.logger'
safe_require 'nwn.creature.modes'
safe_require 'nwn.creature.pc'
safe_require 'nwn.creature.saves'
safe_require 'nwn.creature.skills'
safe_require 'nwn.creature.spells'
safe_require 'nwn.creature.state'
safe_require 'nwn.creature.talent'
safe_require 'nwn.creature.xp'


--- Briefly displays a string ref as ambient text above targets head.
-- @param strref String ref (therefore text is translated)
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function Creature:FloatingStrRef(strref, broadcast)
   nwn.engine.StackPushInteger(broadcast)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(525, 3)
end

--- Briefly displays ambient text above targets head.
-- @param msg Text to display
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function Creature:FloatingText(msg, broadcast)
   nwn.engine.StackPushBoolean(broadcast)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushString(msg)
   nwn.engine.ExecuteCommand(526, 3)
end

--- Fully restores a creature
-- Gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..) 
function Creature:ForceRest()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(775, 1)
end

--- Determines the door that is blocking a creature.
-- @return Last blocking door encountered by the caller and nwn.OBJECT_INVALID if none
function Creature:GetBlockingDoor()
   nwn.engine.ExecuteCommand(336, 0)
   return nwn.engine.StackPopObject()
end

--- Checks if a creature has triggered an OnEnter event
-- @param subarea Subarea to check 
function Creature:GetIsInSubArea(subarea)
   nwn.engine.StackPushObject(subarea)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(768, 2)

   return nwn.engine.StackPopBoolean()
end
