--- solstice.ctypes defines the internal proxy ctypes used by
-- the Solstice library.  It never needs to be explicitly
-- required.
-- @module ctypes

local ffi = require 'ffi'
local C = ffi.C

require 'solstice.nwn.ctypes.aoe'
require 'solstice.nwn.ctypes.area'
require 'solstice.nwn.ctypes.combat'
require 'solstice.nwn.ctypes.creature'
require 'solstice.nwn.ctypes.door'
require 'solstice.nwn.ctypes.effect'
require 'solstice.nwn.ctypes.itemprop'
require 'solstice.nwn.ctypes.encounter'
require 'solstice.nwn.ctypes.item'
require 'solstice.nwn.ctypes.location'
require 'solstice.nwn.ctypes.module'
require 'solstice.nwn.ctypes.placeable'
require 'solstice.nwn.ctypes.store'
require 'solstice.nwn.ctypes.vector'
require 'solstice.nwn.ctypes.waypoint'

ffi.cdef [[
typedef struct {
   uint8_t      dice;
   uint8_t      sides;
   uint16_t     bonus;
} DiceRoll;

typedef struct {
    int32_t  type;
    DiceRoll roll;
    bool     penalty;
} DamageRoll;

typedef struct {
   float        duration;
   int32_t      save;
   int32_t      savetype;
   CGameEffect* effect;
   int32_t      vfx;
   int32_t      type;
} SpellDurationImpact;
]]

dice_roll_t = ffi.typeof('DiceRoll')
damage_roll_t = ffi.typeof('DamageRoll')
spell_duration_impact_t = ffi.typeof('SpellDurationImpact')

ffi.cdef[[
typedef struct {
    uint32_t          type;
    uint32_t          id;
    CNWSAreaOfEffectObject *obj;
} AoE;

typedef struct Area {
    uint32_t        type;
    uint32_t        id;
    CNWSArea       *obj;
} Area;

typedef struct Creature {
    uint32_t           type;
    uint32_t           id;
    CNWSCreature      *obj;
    CNWSCreatureStats *stats;
    uint32_t           effective_level;
    uint32_t           first_custom_eff;
} Creature;

typedef struct Encounter {
    uint32_t        type;
    uint32_t        id;
    CNWSEncounter  *obj;
} Encounter;

typedef struct Door {
    uint32_t        type;
    uint32_t        id;
    CNWSDoor       *obj;
} Door;

typedef struct Effect {
    CGameEffect     *eff;
    bool            direct;
} Effect;

typedef struct Item {
    uint32_t        type;
    uint32_t        id;
    CNWSItem       *obj; 
} Item;

typedef struct Itemprop {
    CGameEffect     *eff;
    bool            direct;
} Itemprop;

typedef struct Lock {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Lock;

typedef struct Module {
    uint32_t        type;
    uint32_t        id;
    CNWSModule     *obj;
} Module;

typedef struct Object {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Object;

typedef struct Placeable {
    uint32_t        type;
    uint32_t        id;
    CNWSPlaceable   *obj;
} Placeable;

typedef struct Store {
    uint32_t        type;
    uint32_t        id;
    CNWSStore      *obj;
} Store;

typedef struct Trap {
    uint32_t        type;
    uint32_t        id;
    CGameObject     *obj;
} Trap;

typedef struct Trigger {
    uint32_t        type;
    uint32_t        id;
    CNWSTrigger    *obj;
} Trigger;

typedef struct Waypoint {
    uint32_t        type;
    uint32_t        id;
    CNWSWaypoint   *obj;
} Waypoint;
]]

