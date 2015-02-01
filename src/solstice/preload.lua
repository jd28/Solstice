----
-- This module never needs to be required explicitly except in your
-- preload.lua.  It loads the solstice library as well as setting
-- up a few custom effect handlers.
--
-- Custom Effect Handlers:
--
-- * `CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS`
-- * `CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE`
-- * `CUSTOM_EFFECT_TYPE_RECURRING`
-- * `CUSTOM_EFFECT_TYPE_HITPOINTS`
--
-- @module preload

local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

require 'solstice.global'
require 'solstice.combat'

local Hook = require 'solstice.hooks'
local NWNXEffects = require 'solstice.nwnx.effects'
local Dice = require 'solstice.dice'
local Eff = require 'solstice.effect'
local GetObjectByID = require('solstice.game').GetObjectByID

if OPT.JIT_DUMP then
   local dump = require 'jit.dump'
   dump.on(nil, "luajit.dump")
end

-- Seed random number generator.
math.randomseed(os.time())
math.random(100)

-- Do necessary NWNX hooking.

ffi.cdef [[
typedef struct {
   void *unknown;
} CNWSEffectListHandler;
]]

function NWNXSolstice_HandleEffect()
   local data = ffi.C.Local_GetLastEffect()
   if data == nil then return end

   local cre = GetObjectByID(data.obj.obj_id)
   if not cre:GetIsValid() then return end

   if data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE then
      local idx = C.ns_BitScanFFS(data.eff.eff_integers[0])
      local amt = data.eff.eff_integers[1]
      if data.is_remove then amt = -amt end
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   elseif data.eff.eff_type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then
      local idx = C.ns_BitScanFFS(data.eff.eff_integers[0])
      local amt = data.eff.eff_integers[1]
      if not data.is_remove then amt = -amt end
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   elseif data.eff.eff_type == EFFECT_TYPE_IMMUNITY then
      if data.eff.eff_integers[1] == 28
         and data.eff.eff_integers[2] == 0
         and data.eff.eff_integers[3] == 0
      then
         local amt = data.eff.eff_integers[4]
         amt = amt == 0 and 100 or amt
         local idx = data.eff.eff_integers[0]
         if data.is_remove then amt = -amt end
         cre.ci.defense.immunity_misc[idx] = cre.ci.defense.immunity_misc[idx] + amt
      end
   elseif data.eff.eff_type == EFFECT_TYPE_ABILITY_INCREASE then
      local idx = data.eff.eff_integers[0]
      local amt = data.eff.eff_integers[1]
      if data.is_remove then amt = -amt end
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
   elseif data.eff.eff_type == EFFECT_TYPE_ABILITY_DECREASE then
      local idx = data.eff.eff_integers[0]
      local amt = data.eff.eff_integers[1]
      if not data.is_remove then amt = -amt end
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
   end
end

function NWNXSolstice_GetEffectImmunity(obj, imm)
   local cre = Game.GetObjectByID(obj)
   if not cre:GetIsValid() then return false end
   return cre:GetIsImmune(imm, OBJECT_INVALID)
end

function NWNXSolstice_GetSaveEffectBonus(obj, save, save_vs)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end
   local min, max = Rules.GetSaveEffectLimits(obj, save, save_vs)
   local eff = Rules.GetSaveEffectBonus(obj, save, save_vs)
   return  math.clamp(eff, min, max)
end

function NWNXSolstice_GetAbilityEffectBonus(obj, ability)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end
   local min, max = Rules.GetAbilityEffectLimits(obj, ability)
   local eff = Rules.GetAbilityEffectModifier(obj, ability)
   eff = math.clamp(eff, min, max)

   -- Just to make sure...that the modifiers are updated.
   -- Depending on how abilities are implemented it can be
   -- an issue.
   local base = obj:GetAbilityScore(ability, true) + eff
   local mod  = math.floor((base - 10) / 2)
   if ability == ABILITY_STRENGTH then
      obj.obj.cre_stats.cs_str_mod = mod
   elseif ability == ABILITY_DEXTERITY then
      obj.obj.cre_stats.cs_dex_mod = mod
   elseif ability == ABILITY_CONSTITUTION then
      obj.obj.cre_stats.cs_con_mod = mod
   elseif ability == ABILITY_INTELLIGENCE then
      obj.obj.cre_stats.cs_int_mod = mod
   elseif ability == ABILITY_WISDOM then
      obj.obj.cre_stats.cs_wis_mod = mod
   elseif ability == ABILITY_CHARISMA then
      obj.obj.cre_stats.cs_cha_mod = mod
   end
   return eff
end

function NWNXSolstice_GetSkillEffectBonus(obj, skill)
   obj = Game.GetObjectByID(obj)
   if not obj:GetIsValid() or obj:GetType() ~= OBJECT_TYPE_CREATURE then
      return 0
   end

   local min, max = Rules.GetSkillEffectLimits(obj, skill)
   local eff = Rules.GetSkillEffectModifier(obj, skill)
   return math.clamp(eff, min, max)
end

function NWNXSolstice_InitializeNumberOfAttacks(id)
    local cre = GetObjectByID(id)
    if not cre:GetIsValid() then return end
    Rules.InitializeNumberOfAttacks(cre)
end

function NWNXSolstice_GetWeaponFinesse(obj, it)
   local cre  = GetObjectByID(obj)
   local item = GetObjectByID(it)
   return Rules.GetIsWeaponFinessable(item, cre)
end

function NWNXSolstice_GetCriticalHitMultiplier(obj, is_offhand)
   local attacker = GetObjectByID(obj)
   if not attacker:GetIsValid() then return 0 end
   local equip = EQUIP_TYPE_UNARMED
   local it
   if is_offhand then
      it = attacker:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if not it:GetIsValid() or Rules.BaseitemToWeapon(it) == 0 then
         return 0
      end
      equip = EQUIP_TYPE_OFFHAND
   else
      it = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if it:GetIsValid() and Rules.BaseitemToWeapon(it) ~= 0 then
         equip = EQUIP_TYPE_ONHAND
      end
   end
   return attacker.ci.equips[equip].crit_mult
end

function NWNXSolstice_GetCriticalHitRoll(obj, is_offhand)
   local attacker = GetObjectByID(obj)
   if not attacker:GetIsValid() then return 0 end
   local equip = EQUIP_TYPE_UNARMED
   local it
   if is_offhand then
      it = attacker:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if not it:GetIsValid() or Rules.BaseitemToWeapon(it) == 0 then
         return 0
      end
      equip = EQUIP_TYPE_OFFHAND
   else
      it = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if it:GetIsValid() and Rules.BaseitemToWeapon(it) ~= 0 then
         equip = EQUIP_TYPE_ONHAND
      end
   end
   return 21 - attacker.ci.equips[equip].crit_range
end

function NWNXSolstice_ResolveDamageShields(cre, attacker)
   cre = GetObjectByID(cre)
   attacker = GetObjectByID(attacker)

   for i = cre.obj.cre_stats.cs_first_dmgshield_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_SHIELD then
         break
      end
      local ip = cre.obj.obj.obj_effects[i].eff_integers[1]
      local d, s, b = Rules.UnpackItempropDamageRoll(ip)
      b = b + cre.obj.obj.obj_effects[i].eff_integers[0]
      local dflag = cre.obj.obj.obj_effects[i].eff_integers[2]
      local chance = cre.obj.obj.obj_effects[i].eff_integers[3]

      if chance == 0 or math.random(chance) <= chance then
         local dindex = ffi.C.ns_BitScanFFS(dflag)
         local amt = Dice.Roll(d, s, b)
         -- This HAS to be in a delay command as apply damage immediately
         -- might cause the cross the Lua/C boundary multiple times.
         cre:DelayCommand(0.1,
                          function (self)
                             if attacker:GetIsValid() then
                                local e = Eff.Damage(amt, dindex)
                                e:SetCreator(self)
                                attacker:ApplyEffect(DURATION_TYPE_INSTANT, e)
                             end
                          end)
      end
   end
end

local Eff = require 'solstice.effect'

-- This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are
-- fully healable. Since it's kind of annoying to have the effect applied but
-- not to have those HP usable this will heal the target amount for the
-- additional hitpoints that it receives.
NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local amount = eff:GetInt(1)
      if not is_remove then
         if target:GetIsDead() then return true end
         target.ci.defense.hp_eff = target.ci.defense.hp_eff + amount
         target:ApplyEffect(DURATION_TYPE_INSTANT, Eff.Heal(amount))
      else
         target.ci.defense.hp_eff = target.ci.defense.hp_eff - amount
      end
   end,
   CUSTOM_EFFECT_TYPE_HITPOINTS)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      if not is_remove and target:GetIsDead() then
         return true
      end
      return false
   end,
   CUSTOM_EFFECT_TYPE_RECURRING)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      local immunity = effect:GetInt(1)
      local amount   = effect:GetInt(4)
      local new      = target.ci.defense.immunity_misc[immunity]

      if not is_remove then
         if target:GetIsDead() then return true end
         new = new - amount
      else
         new = new + amount
      end

      target.ci.defense.immunity_misc[immunity] = new
      return false
   end,
   CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE)

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local new = 0
      local old = target.obj.cre_combat_round.cr_effect_atks
      if not is_remove then
         if target:GetIsDead() or target:GetType() ~= OBJECT_TYPE_CREATURE then
            return true
         end
         new = math.clamp(old + eff:GetInt(1), 0, 5)
      else
         local att = -eff:GetInt(1)
         for eff in target:Effects(true) do
            if eff:GetType() > 44 then break end
            if eff:GetType() == 44
               and eff:GetInt(0) == CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS
            then
               att = att + eff:GetInt(2)
            end
         end
         new = math.clamp(att, 0, 5)
      end
      target.obj.cre_combat_round.cr_effect_atks = new
   end,
   CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS)
