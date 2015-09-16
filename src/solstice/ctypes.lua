---
-- This module defines some C structs for use by Solstice.  The constructors
-- all take parameters for their respective fields.  These are generated
-- dynamically by LuaJIT and so are dependent on some constants being
-- defined.
--
-- If you have any desire to change these... note which ones need to
-- be synced with nwnx_solstice.  Typically any additions will work fine,
-- any deletions will require a greater understanding of the entire
-- library.
--
-- Note about documentation.  If a field is an array is it will be
-- specified `field:` \[length\]
--
-- @module ctypes

local ffi = require 'ffi'
local C = ffi.C

local function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

require 'solstice.nwn.ctypes.foundation'
require 'solstice.nwn.ctypes.2da'
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
require 'solstice.nwn.ctypes.messages'
require 'solstice.nwn.ctypes.module'
require 'solstice.nwn.ctypes.nwnx'
require 'solstice.nwn.ctypes.skill'
require 'solstice.nwn.ctypes.placeable'
require 'solstice.nwn.ctypes.race'
require 'solstice.nwn.ctypes.store'
require 'solstice.nwn.ctypes.sound'
require 'solstice.nwn.ctypes.trigger'
require 'solstice.nwn.ctypes.waypoint'

--- Unsynced structs.
-- @section types

--- Constructor: dice_roll_t
-- @table DiceRoll
-- @field dice Number of dice.
-- @field sides Number of sides.
-- @field bonus Bonus

--- Constructor: damage_roll_t
--
-- The mask is defined:
--
-- * 0x1 = Damage roll is a penalty
-- * 0x2 = Damage roll is applicable only to criticals.
-- * 0x4 = Damage roll is unblockable by resistances.
-- @table DamageRoll
-- @field type DAMAGE_INDEX_*
-- @field roll DiceRoll
-- @field mask Critical/Unblockable bitmask.

--- Constructor combat_mod_t
-- @table CombatMod
-- @field ab Attack bonus/penalty.
-- @field ac AC bonus/penalty.
-- @field dmd DamageRoll bonus/penalty.
-- @field hp Hitpoint bonus/penalty.

--- Caches some offensive information.
-- @table Offense
-- @field ab_base BAB
-- @field ab_transient Attack bonus effects applied directly to player.
-- @field attacks_on Number of onhand attacks.
-- @field attacks_off Number of offhand attacks.
-- @field offhand_penalty_on Dualwield AB penalty for offhand attack.
-- @field offhand_penalty_off Dualwield AB penalty for offhand attack.
-- @field ranged_type Ranged type. See rangedwpns.2da
-- @field weapon_type Weapon type. See 'Type' column in wpnprops.2da
-- @field damage [20] DamageRoll.  Damage bonus/penalties applied
-- directly to player.
-- @field damage_len Number of DamageRolls in the damage array.

--- Caches some defensive information.
-- @table Defense
-- @field concealment Concealment
-- @field hp_eff Hitpoints from effects.
-- @field hp_max Maximum hitpoints.
-- @field soak Innate soak.
-- @field soak_stack [DAMAGE_POWER_NUM] Stacking soak effects.
-- @field immunity [DAMAGE_INDEX_NUM] Damage immunity.
-- @field immunity_base [DAMAGE_INDEX_NUM] Innate immunity. E,g RDD.
-- @field immunity_misc [IMMUNITY_TYPE_NUM] % Immunity to IMMMUNITY_TYPE_*
-- @field resist [DAMAGE_INDEX_NUM] Innate resistance.
-- @field resist_stack [DAMAGE_INDEX_NUM] Stacking damage resistance.

--- Weapon properties.
-- @table CombatWeapon
-- @field id Item's object id.
-- @field iter Iteration penalty.
-- @field ab_ability AB from ability scores.
-- @field dmg_ability Damage from ability scores.
-- @field ab_mod AB modifier. Eg. from WM.
-- @field transient_ab_mod AB modifer from AttackBonus effects.
-- @field crit_range Critical hit range.  More technically, the threat.
-- @field crit_mult Critical hit multiplier
-- @field power Damage power
-- @field base_dmg_flags Base weapon damage flags.
-- @field base_dmg_roll Base weapon damage roll.
-- @field damage [50] From effects, weapons, etc. [TODO] Reconsider the size.
-- @field damage_len Number of damages used in the above array.
-- @field has_dev_crit

--- Caches combat related information.
-- @table CombatInfo
-- @field offense Offense ctype.
-- @field defense Deffense type
-- @field equips [EQUIP_TYPE_NUM] CombatWeapon ctypes.
-- @field mods [COMBAT_MOD_NUM] CombatMod ctypes.
-- @field mod_situ[SITUATION_NUM] CombatMod ctypes.
-- @field mod_mode CombatMod for mode effects.
-- @field effective_level OBSOLETE
-- @field first_custom_eff OBSOLETE
-- @field fe_mask Favored enemy bitmask.
-- @field training_vs_mask Training Vs bitmask.
-- @field skill_eff [SKILL_NUM] Skill bonuses from effects.
-- @field ability_eff [ABILITY_NUM] Ability bonuses from effects.
-- @field update_flags OBSOLETE

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
    float         crit_chance_modifier;
    float         crit_dmg_modifier;
    float         damge_bonus_modifier;
} Offense;

typedef struct {
    int32_t       concealment;
    int32_t       hp_eff;
    int32_t       hp_max;

    int32_t       soak;
    int32_t       soak_stack[${DAMAGE_POWER_NUM}];

    int32_t       immunity[${DAMAGE_INDEX_NUM}];
    int32_t       immunity_base[${DAMAGE_INDEX_NUM}];

    int32_t       immunity_misc[${IMMUNITY_TYPE_NUM}];

    int32_t       resist[${DAMAGE_INDEX_NUM}];
    int32_t       resist_stack[${DAMAGE_INDEX_NUM}];

    /*Saves         saves;*/
} Defense;

typedef struct {
    Offense         offense;
    Defense         defense;
    CombatWeapon    equips[${EQUIP_TYPE_NUM}];
    CombatMod       mods[${COMBAT_MOD_NUM}];
    CombatMod       mod_situ[${SITUATION_NUM}];
    CombatMod       mod_mode;
    int32_t            effective_level;
    int32_t            first_custom_eff;
    uint32_t           fe_mask;
    uint32_t           training_vs_mask;
    int32_t            skill_eff[${SKILL_NUM}];
    int32_t            ability_eff[${ABILITY_NUM}];
    int32_t            update_flags;
} CombatInfo;

typedef struct Effect {
    CGameEffect     *eff;
    bool            direct;
} Effect;

typedef struct Itemprop {
    CGameEffect     *eff;
    bool            direct;
} Itemprop;

typedef struct {
    CNWSObject *obj;
    CGameEffect *eff;
    bool is_remove;
} EffectData;


]], _CONSTS))

require 'solstice.nwn.funcs'

combat_info_t = ffi.typeof('CombatInfo')
combat_mod_t = ffi.typeof('CombatMod')
dice_roll_t = ffi.typeof('DiceRoll')
damage_roll_t = ffi.typeof('DamageRoll')
spell_duration_impact_t = ffi.typeof('SpellDurationImpact')
