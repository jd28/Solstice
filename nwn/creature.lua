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

require 'nwn.ctypes.combat'
require 'nwn.ctypes.creature'

local ffi = require 'ffi'

ffi.cdef[[
typedef struct CombatWeapon {
   uint32_t id;
   uint32_t base_type;

   uint8_t ab_ability;
   uint8_t dmg_ability;

   uint8_t ab_mod;
   uint8_t crit_range;
   uint8_t crit_mult;
   uint16_t slot;
   uint16_t dmg_dice;
   uint16_t dmg_sides;
   uint16_t dmg_mod;
   uint16_t crit_dice;
   uint16_t crit_sides;

} CombatWeapon;

typedef struct CombatInformation {
   uint32_t attacker;
   uint32_t target;

   uint32_t wield_type;

   int32_t bab;
   int32_t ab_mode;
   int32_t ab_size;
   int32_t ab_offhand_penalty;
   int32_t ab_area;
   int32_t ab_feat;


   uint8_t *resist;
   int16_t *immunity;

   uint16_t soak[20];

   int8_t save_mods[3];

   CombatWeapon equips[6];
} CombatInformation;

typedef struct Creature {
    uint32_t           type;
    uint32_t           id;
    CNWSCreature      *obj;
    CNWSCreatureStats *stats;
    CombatInformation  ci;
} Creature;
]]

local creature_mt = { __index = Creature }
creature_t = ffi.metatype("Creature", creature_mt)

require 'nwn.creature.ability'
require 'nwn.creature.action'
require 'nwn.creature.ai'
require 'nwn.creature.alignment'
require 'nwn.creature.associate'
require 'nwn.creature.class'
require 'nwn.creature.combat'
require 'nwn.creature.cutscene'
require 'nwn.creature.effects'
require 'nwn.creature.faction'
require 'nwn.creature.feats'
require 'nwn.creature.info'
require 'nwn.creature.internal'
require 'nwn.creature.inventory'
require 'nwn.creature.logger'
require 'nwn.creature.pc'
require 'nwn.creature.skills'
require 'nwn.creature.spells'
require 'nwn.creature.state'
require 'nwn.creature.talent'
require 'nwn.creature.xp'
require 'nwn.creature.hp'
require 'nwn.creature.saves'

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
