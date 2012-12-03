local ffi = require 'ffi'
local C = ffi.C

ffi.cdef[[
typedef struct AttackInfo {
   CNWSCombatRound  *attacker_cr;
   CNWSCombatRound  *target_cr;
   CNWSCombatAttackData *attack;
   uint32_t current_attack;
   uint32_t attack_id;
   uint32_t target_state;
   uint32_t situational_flags;
   int32_t  weapon;
   bool is_offhand;
   nwn_objid_t attacker;
   nwn_objid_t target;
} AttackInfo;
]]

attack_info_t = ffi.typeof("AttackInfo")

local s = string.gsub([[
typedef struct DamageResult {
   int32_t    damages[$NS_OPT_NUM_DAMAGES];
   int32_t    immunity_adjust[$NS_OPT_NUM_DAMAGES];
   int32_t    resist_adjust[$NS_OPT_NUM_DAMAGES];
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