local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local fmt = string.format
local sm = string.strip_margin

local Attack = safe_require 'solstice.attack'

---
function GetAttackTypeFromEquipNum(num)
   if num == 0 then
      return ATTACK_TYPE_ONHAND
   elseif num == 1 then
      return ATTACK_TYPE_OFFHAND
   elseif num == 2 then
      return ATTACK_TYPE_UNARMED
   elseif num == 3 then
      return ATTACK_TYPE_CWEAPON1
   elseif num == 4 then
      return ATTACK_TYPE_CWEAPON2
   elseif num == 5 then
      return ATTACK_TYPE_CWEAPON3
   else
      print(debug.traceback())
      error "Invalid Equip Number"
   end
end

--- Bridge functions.

function NSGetCriticalHitMultiplier(attacker, is_offhand)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return attacker:GetCriticalHitMultiplier(is_offhand == 1)
end

function NSGetCriticalHitRange(attacker, is_offhand)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return attacker:GetCriticalHitRange(is_offhand == 1)
end

function NSGetCriticalHitRoll(attacker, is_offhand)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   return 21 - attacker:GetCriticalHitRange(is_offhand == 1)
end

function NSInitializeNumberOfAttacks(cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return end
   cre:InitializeNumberOfAttacks()
end

function NWNXSolstice_ResolveMeleeAttack(attacker, target, attack_count, anim)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   target = _SOL_GET_CACHED_OBJECT(target)
   attacker:UpdateCombatInfo()
   Attack.ResolveAttack(attacker, target, attack_count, anim, false)
end

function NWNXSolstice_ResolveRangedAttack(attacker, target, attack_count, anim)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   target = _SOL_GET_CACHED_OBJECT(target)
   attacker:UpdateCombatInfo()
   Attack.ResolveAttack(attacker, target, attack_count, anim, true)
end

-- This function is called by others get worst faction AC...
function NSGetArmorClassVersus(target, attacker, touch)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   target = _SOL_GET_CACHED_OBJECT(target)
   return target:GetACVersus(attacker, touch)
end

-- this function is called by a few others, EquipMostDamaging...
function NSGetAttackModifierVersus(attacker, target, attack_info, attack_type)
   return 0
   --   attacker = _NL_GET_CACHED_OBJECT(attacker)
   --   target = _NL_GET_CACHED_OBJECT(target)
   --   return attacker:GetABVersus(target)
end

function NSSavingThrowRoll(cre, save_type, dc, immunity_type, vs, send_feedback, feat, from_combat)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   vs = _SOL_GET_CACHED_OBJECT(vs)

   return cre:SavingThrowRoll(cre, save_type, dc, immunity_type, vs, send_feedback, feat, from_combat)
end
