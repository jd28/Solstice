local TA = OPT.TA

local ffi = require 'ffi'
local C = ffi.C

local random = math.random
local floor  = math.floor
local min    = math.min

local bit    = require 'bit'
local bor    = bit.bor
local band   = bit.band
local lshift = bit.lshift

local Eff = require 'solstice.effect'

local Dice   = require 'solstice.dice'
local DoRoll = Dice.DoRoll
local RollValid = Dice.IsValid

local function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

ffi.cdef(interp([[
typedef struct {
    int32_t    damages[${DAMAGE_INDEX_NUM}];
    int32_t    damages_unblocked[${DAMAGE_INDEX_NUM}];
    int32_t    immunity[${DAMAGE_INDEX_NUM}];
    int32_t    resist[${DAMAGE_INDEX_NUM}];
    int32_t    resist_remaining[${DAMAGE_INDEX_NUM}];
    int32_t    reduction, reduction_remaining, parry;
} DamageResult;

typedef struct {
    CNWSCreature         *attacker_nwn;
    CNWSObject           *target_nwn;

    CombatInfo           *attacker_ci;
    CombatInfo           *target_ci;
    CNWSCombatAttackData *attack;
    int32_t               weapon;
    int32_t               ranged_type;
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

const char* ns_GetCombatDamageString(
    const char *attacker,
    const char *target,
    const DamageResult *dmg,
    bool simple);

Attack* Local_GetAttack();
]], _CONSTS))

--- Adds combat message to an attack.
local function AddCCMessage(info, type, objs, ints, str)
   C.nwn_AddCombatMessageData(info.attack, type or 0, #objs, objs[1] or 0, objs[2] or 0,
                              #ints, ints[1] or 0, ints[2] or 0, ints[3] or 0, ints[4] or 0,
                              str or "")
end

local function AddDamageToResult(info, dmg, mult)
   if mult > 1 and band(dmg.mask, 2) ~= 0 then
      mult = 1
   end

   local roll = DoRoll(dmg.roll, mult)

   -- penalty
   if band(dmg.mask, 1) ~= 0 then
      roll = -roll
   end

   if band(dmg.mask, 4) == 0 then
      info.dmg_result.damages[dmg.type] = info.dmg_result.damages[dmg.type] + roll
   else
      info.dmg_result.damages_unblocked[dmg.type] = info.dmg_result.damages_unblocked[dmg.type] + roll
   end
end

--- Adds an onhit effect to an attack.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param eff Effect ctype.
local function AddEffect(info, attacker, eff)
   eff.direct = true
   eff:SetCreator(attacker.id)
   C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
end

--- Adds an onhit visual effect to an attack.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param vfx VFX_*
local function AddVFX(info, attacker, vfx)
   AddEffect(info, attacker, Eff.VisualEffect(vfx))
end

--- Clear special attack.
-- @param info Attack ctype.
local function ClearSpecialAttack(info)
   info.attack.cad_special_attack = 0
end

--- Copy damage to NWN Attack Data.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Attack target.
local function CopyDamageToNWNAttackData(info, attacker, target)
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      if i < 13 then
         if info.dmg_result.damages[i] <= 0 then
            info.attack.cad_damage[i] = -1
         else
            info.attack.cad_damage[i] = info.dmg_result.damages[i]
         end
      else
         if info.dmg_result.damages[i] > 0 then
            local eff = Eff.Damage(i, info.dmg_result.damages[i])
            -- Set effect to direct so that Lua will not delete the
            -- effect.  It will be deleted by the combat engine.
            eff.direct = true
            -- Add the effect to the onhit effect list so that it can
            -- be applied when damage is signaled.
            AddEffect(info, attacker, eff)
         end
      end
   end
   if TA then
    local s = ffi.string(C.ns_GetCombatDamageString(
                            attacker:GetName(),
                            target:GetName(),
                            info.dmg_result,
                            false))

    AddCCMessage(info, 11, {}, { 0xCC }, s)
  end
end

--- Returns attack result.
-- @param info AttackInfo
local function GetResult(info)
   return info.attack.cad_attack_result
end

--- Determines if attack is ranged.
-- @param info AttackInfo
local function GetIsRangedAttack(info)
   return info.attack.cad_ranged_attack == 1
end

--- Determine if attack is a sneak attack.
-- @param info AttackInfo
local function GetIsSneakAttack(info)
   return info.attack.cad_sneak_attack == 1
end

--- Determines if attack is a special attack
-- @param info AttackInfo
local function GetIsSpecialAttack(info)
   return info.attack.cad_special_attack ~= 0
end

--- Returns special attack
-- @param info AttackInfo
local function GetSpecialAttack(info)
   return info.attack.cad_special_attack
end

local function SetSneakAttack(info, sneak, death)
   info.attack.cad_sneak_attack = sneak
   info.attack.cad_death_attack = death
end

--- Returns the attack type.  See ATTACK_TYPE_*
-- @param info AttackInfo
local function GetType(info)
   return info.attack.cad_attack_type
end

--- Gets the total attack roll.
-- @param info AttackInfo
local function GetAttackRoll(info)
   return info.attack.cad_attack_roll + info.attack.cad_attack_mod
end

--- Determine if attack is a coup de grace.
-- @param info AttackInfo
local function GetIsCoupDeGrace(info)
   return info.attack.cad_coupdegrace ~= 0
end

--- Determines if attack results in a critical hit
-- @param info AttackInfo
local function GetIsCriticalHit(info)
   return GetResult(info) == 3
end

--- Determine if attack is a death attack.
-- @param info AttackInfo
local function GetIsDeathAttack(info)
   return info.attack.cad_death_attack == 1
end

--- Determines if the attack results in a hit.
-- @param info AttackInfo
local function GetIsHit(info)
   local t = GetResult(info)
   return t == 1 or t == 3 or t == 5 or t == 6 or t == 7 or t == 10
end

--- Sets attack modifier
-- @param info AttackInfo.
-- @param ab Attack modifier
local function SetAttackMod(info, ab)
   info.attack.cad_attack_mod = ab
end

--- Sets attack roll
-- @param info AttackInfo.
-- @param roll The 1d20 attack roll.
local function SetAttackRoll(info, roll)
   info.attack.cad_attack_roll = roll
end

--- Set concealment.
-- @param info AttackInfo.
-- @param conceal Concealment result.
local function SetConcealment(info, conceal)
   info.attack.cad_concealment = conceal
end

--- Set Critical result.
-- @param info AttackInfo.
-- @param threat Set critical threat
-- @param result Set critical hit result.
local function SetCriticalResult(info, threat, result)
   info.attack.cad_threat_roll = threat
   info.attack.cad_critical_hit = result
end

--- Set missed by.
-- @param info AttackInfo.
-- @param roll How much creature missed by.
local function SetMissedBy(info, roll)
   info.attack.cad_missed = roll
end

--- Sets the attack result.
-- @param info AttackInfo.
-- @param result See...
local function SetResult(info, result)
   info.attack.cad_attack_result = result
end

local M = {}
M.AddCCMessage = AddCCMessage
M.AddDamageToResult = AddDamageToResult
M.AddEffect = AddEffect
M.AddVFX = AddVFX
M.ClearSpecialAttack = ClearSpecialAttack
M.CopyDamageToNWNAttackData = CopyDamageToNWNAttackData
M.GetAttackRoll = GetAttackRoll
M.GetIsCoupDeGrace = GetIsCoupDeGrace
M.GetIsCriticalHit = GetIsCriticalHit
M.GetIsDeathAttack = GetIsDeathAttack
M.GetIsHit = GetIsHit
M.GetIsRangedAttack = GetIsRangedAttack
M.GetIsSneakAttack = GetIsSneakAttack
M.GetIsSpecialAttack = GetIsSpecialAttack
M.GetResult = GetResult
M.GetSpecialAttack = GetSpecialAttack
M.GetType = GetType
M.SetAttackMod = SetAttackMod
M.SetAttackRoll = SetAttackRoll
M.SetConcealment = SetConcealment
M.SetCriticalResult = SetCriticalResult
M.SetMissedBy = SetMissedBy
M.SetResult = SetResult
M.SetSneakAttack = SetSneakAttack
return M
