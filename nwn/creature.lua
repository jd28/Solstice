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

ffi.cdef (string.gsub([[
typedef struct CombatWeapon {
   uint32_t id;
   uint32_t base_type;
   uint8_t iter;
   uint8_t ab_ability;
   uint8_t dmg_ability;
   uint8_t ab_mod;
   uint8_t crit_range;
   uint8_t crit_mult;
   uint16_t slot;

   DiceRoll base_dmg;
   DiceRoll crit_dmg;
} CombatWeapon;

typedef struct CombatMod {
   int32_t ab;
   int32_t ac;
   DiceRoll dmg;
   uint32_t dmg_type;
} CombatMod;

typedef struct CombatInformation {
   uint32_t attacker;
   uint32_t target;

   double target_distance;

   uint32_t wield_type;
   int32_t bab;
   int32_t offhand_penalty_on;
   int32_t offhand_penalty_off;

   CombatMod area;
   CombatMod class;
   CombatMod feat;
   CombatMod mode;
   CombatMod race;
   CombatMod size;
   CombatMod skill;
   CombatMod fe; // Favored Enemy
   CombatMod situational[$NS_OPT_NUM_SITUATIONS];

   uint32_t fe_mask; // favored enemy mask
   uint32_t training_vs_mask; // Training vs race
   uint32_t target_state_mask;
   uint32_t situational_flags;

   int32_t immunity[$NS_OPT_NUM_DAMAGES];

   int32_t eff_resist[$NS_OPT_NUM_DAMAGES];
   int32_t resist[$NS_OPT_NUM_DAMAGES];

   int32_t eff_soak[21];
   uint32_t soak;
   int32_t save_mods[3];
   CombatWeapon equips[6];

   uint32_t first_cr_effect;
   uint32_t first_cm_effect;
} CombatInformation;

typedef struct Creature {
    uint32_t           type;
    uint32_t           id;
    CNWSCreature      *obj;
    CNWSCreatureStats *stats;
    CombatInformation  ci;
} Creature;
]], "%$([%w_]+)", NS_SETTINGS))

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
