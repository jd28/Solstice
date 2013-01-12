local ffi = require 'ffi'
local C = ffi.C

ffi.cdef[[
typedef struct AttackInfo {
   uint32_t current_attack;
   uint32_t attack_id;
   uint32_t target_state;
   uint32_t situational_flags;
   int32_t  weapon;
   bool     is_offhand;
   bool     is_sneak;
   bool     is_death;

   CNWSCombatRound  *attacker_cr;
   CNWSCombatRound  *target_cr;
   CNWSCombatAttackData *attack;
} AttackInfo;
]]

attack_info_t = ffi.typeof("AttackInfo")

local s = string.gsub([[
typedef struct DamageResult {
   int32_t    damages[$NS_OPT_NUM_DAMAGES];
   int32_t    immunity_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    resist_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    mod_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    soak_adjust;
} CDamageResult;

typedef struct {
   DiceRoll rolls[$NS_OPT_NUM_DAMAGES][50];
   int32_t  idxs[$NS_OPT_NUM_DAMAGES];
} CDamageRoll;
]], "%$([%w_]+)", { NS_OPT_NUM_DAMAGES = NS_OPT_NUM_DAMAGES })

ffi.cdef (s)

damage_roll_t = ffi.typeof('CDamageRoll')
damage_result_t = ffi.typeof("CDamageResult")


ffi.cdef[[
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
   uint16_t base_type;
   uint16_t base_mask;
   DiceRoll base_dmg;
   DiceRoll crit_dmg;
} CombatWeapon;

typedef struct CombatMod {
   int32_t ab;
   int32_t ac;
   DiceRoll dmg;
   uint32_t dmg_type;
   int32_t hp;
} CombatMod;
]]

local s = string.gsub([[
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

   uint32_t ranged_type;

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
]], "%$([%w_]+)", { NS_OPT_NUM_DAMAGES = NS_OPT_NUM_DAMAGES,
                    NS_OPT_NUM_SITUATIONS = NS_OPT_NUM_SITUATIONS } )

ffi.cdef (s)