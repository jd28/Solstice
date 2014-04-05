--- solstice.ctypes defines the internal proxy ctypes used by
-- the Solstice library.  It never needs to be explicitly
-- required.
-- @module ctypes

local ffi = require 'ffi'
local C = ffi.C

local function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

require 'solstice.nwn.ctypes.foundation'
require 'solstice.nwn.ctypes.2da'
require 'solstice.nwn.ctypes.vector'
require 'solstice.nwn.ctypes.location'
require 'solstice.nwn.ctypes.effect'
require 'solstice.nwn.ctypes.itemprop'
require 'solstice.nwn.ctypes.object'
require 'solstice.nwn.ctypes.area'
require 'solstice.nwn.ctypes.aoe'
require 'solstice.nwn.ctypes.client'
require 'solstice.nwn.ctypes.combat'
require 'solstice.nwn.ctypes.creature'
require 'solstice.nwn.ctypes.door'
require 'solstice.nwn.ctypes.encounter'
require 'solstice.nwn.ctypes.feat'
require 'solstice.nwn.ctypes.item'
require 'solstice.nwn.ctypes.module'
require 'solstice.nwn.ctypes.nwnx'
require 'solstice.nwn.ctypes.skill'
require 'solstice.nwn.ctypes.placeable'
require 'solstice.nwn.ctypes.store'
require 'solstice.nwn.ctypes.trigger'
require 'solstice.nwn.ctypes.waypoint'

ffi.cdef(interp([[
typedef struct {
   int32_t      dice;
   int32_t      sides;
   int32_t     bonus;
} DiceRoll;

typedef struct {
    int32_t  type;
    DiceRoll roll;
    int32_t  mask;
} DamageRoll;

typedef struct {
    int32_t    damages[${DAMAGE_INDEX_NUM}];
    int32_t    damages_unblocked[${DAMAGE_INDEX_NUM}];
    int32_t    immunity_adjust[${DAMAGE_INDEX_NUM}];
    int32_t    resist_adjust[${DAMAGE_INDEX_NUM}];
    int32_t    mod_adjust[${DAMAGE_INDEX_NUM}];
    int32_t    soak_adjust;
} DamageResult;

typedef struct {
   int32_t      save;
   int32_t      savetype;
   CGameEffect* effect;
   int32_t      vfx;
   int32_t      type;
   double       duration;
} SpellDurationImpact;

typedef struct CombatMod {
    int32_t ab;
    int32_t ac;
    DamageRoll dmg;
    int32_t hp;
} CombatMod;

typedef struct {
    uint32_t                  id;

    int32_t                   iter;
    int32_t                   ab_ability;
    int32_t                   dmg_ability;
    int32_t                   ab_mod;
    int32_t                   transient_ab_mod;

    int32_t                   crit_range;
    int32_t                   crit_mult;
    int32_t                   power;

    uint32_t                  base_dmg_flags;
    DiceRoll                  base_dmg_roll;

    DamageRoll                damage[50];
    int32_t                   damage_len;
    bool                      has_dev_crit;

} CombatWeapon;

typedef struct {
    int32_t       ab_base;
    int32_t       ab_transient;
    int32_t       attacks_on;
    int32_t       attacks_off;
    int32_t       offhand_penalty_on;
    int32_t       offhand_penalty_off;
    int32_t       ranged_type;
    int32_t       weapon_type;
    DamageRoll    damage[20];
    int32_t       damage_len;
} Offense;

typedef struct {
    int32_t       concealment;
    int32_t       hp_eff;
    int32_t       hp_max;

    int32_t       soak;
    int32_t       soak_eff[${DAMAGE_POWER_NUM}];
    int32_t       soak_stack[${DAMAGE_POWER_NUM}];

    int32_t       immunity[${DAMAGE_INDEX_NUM}];
    int32_t       immunity_base[${DAMAGE_INDEX_NUM}];

    int32_t       immunity_misc[${IMMUNITY_TYPE_NUM}];

    int32_t       resist[${DAMAGE_INDEX_NUM}];
    int32_t       resist_eff[${DAMAGE_INDEX_NUM}];
    int32_t       resist_stack[${DAMAGE_INDEX_NUM}];

    /*Saves         saves;*/
} Defense;

typedef struct {
    Offense         offense;
    Defense         defense;
    CombatWeapon    equips[${EQUIP_TYPE_NUM}];
    CombatMod       mods[${COMBAT_MOD_NUM}];
    CombatMod       mod_situ[${SITUATION_NUM}];
    int32_t            effective_level;
    int32_t            first_custom_eff;
    uint32_t           fe_mask;
    uint32_t           training_vs_mask;
    int32_t            skill_eff[${SKILL_NUM}];
    int32_t            ability_eff[${ABILITY_NUM}];
    int32_t            update_flags;
} CombatInfo;

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
    CombatInfo        *ci;
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

typedef struct {
    CNWSCreature         *attacker_nwn;
    CNWSObject           *target_nwn;

    CombatInfo           *attacker_ci;
    CombatInfo           *target_ci;
    CNWSCombatAttackData *attack;
    int32_t               weapon;
    int32_t               target_state;
    int32_t               situational_flags;
    double                target_distance;
    bool                  is_offhand;
    bool                  is_sneak;
    bool                  is_death;
    bool                  is_killing;

    int32_t               damage_total;
    DamageResult          dmg_result;

    int32_t               effects_to_remove[${DAMAGE_INDEX_NUM} + 1];
    int32_t               effects_to_remove_len;
} Attack;

]], _CONSTS))

require 'solstice.nwn.funcs'

combat_info_t = ffi.typeof('CombatInfo')
combat_mod_t = ffi.typeof('CombatMod')
damage_result_t = ffi.typeof('DamageResult')
dice_roll_t = ffi.typeof('DiceRoll')
damage_roll_t = ffi.typeof('DamageRoll')
spell_duration_impact_t = ffi.typeof('SpellDurationImpact')
