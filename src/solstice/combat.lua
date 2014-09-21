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

function NWNXSolstice_GetCriticalHitMultiplier(attacker, is_offhand)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   local equip = is_offhand and EQUIP_TYPE_OFFHAND or EQUIP_TYPE_ONHAND
   if equip == EQUIP_TYPE_ONHAND and attacker.ci.equips[equip].id == OBJECT_INVALID.id then
      equip = EQUIP_TYPE_UNARMED
   end

   return attacker:GetCriticalHitMultiplier(equip)
end

function NWNXSolstice_GetCriticalHitRoll(attacker, is_offhand)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   if not attacker:GetIsValid() then return 0 end
   local equip = is_offhand and EQUIP_TYPE_OFFHAND or EQUIP_TYPE_ONHAND
   if equip == EQUIP_TYPE_ONHAND and attacker.ci.equips[equip].id == OBJECT_INVALID.id then
      equip = EQUIP_TYPE_UNARMED
   end

   return 21 - attacker:GetCriticalHitRange(equip)
end

function NWNXSolstice_InitializeNumberOfAttacks(cre)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   if not cre:GetIsValid() then return end
   Rules.InitializeNumberOfAttacks(cre)
end

function NWNXSolstice_UpdateCombatInfo(attacker)
   attacker = _SOL_GET_CACHED_OBJECT(attacker)
   attacker:UpdateCombatInfo(true)
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

function NWNXSolstice_GetArmorClass(cre)
   cre = Game.GetObjectByID(cre)
   if not cre:GetIsValid() or cre.type ~= OBJECT_TRUETYPE_CREATURE then
      return 0
   end
   return cre:GetACVersus(OBJECT_INVALID, false)
end

function NWNXSolstice_GetWeaponFinesse(cre, item)
   cre  = Game.GetObjectByID(cre)
   item = Game.GetObjectByID(item)
   return Rules.GetIsWeaponFinessable(item, cre)
end
