----
-- This module never needs to be required explicitly except in your
-- preload.lua.  It sets loads the solstice library as well as setting
-- up a few hooks and custom effect handlers.  Note that the hooks below
-- are not protected calls!  Modifying the functions they call can result
-- in crashes, if they contain errors.
--
-- Hooks:
--
-- * `CNWSEffectListHandler::OnApplyDamageImmunityIncrease(CNWSObject \* ,CGameEffect *,int)`
-- * `CNWSEffectListHandler::OnRemoveDamageImmunityIncrease(CNWSObject \* ,CGameEffect *)`
-- * `CNWSEffectListHandler::OnApplyDamageImmunityDecrease(CNWSObject \*,CGameEffect *,int)`
-- * `CNWSEffectListHandler::OnRemoveDamageImmunityDecrease(CNWSObject \*,CGameEffect *)`
-- * `CNWSEffectListHandler::OnApplyEffectImmunity(CNWSObject \*,CGameEffect *,int)`
-- * `CNWSEffectListHandler::OnRemoveEffectImmunity(CNWSObject \*,CGameEffect *)`
-- * `CNWSEffectListHandler::OnRemoveEffectImmunity(CNWSObject \*,CGameEffect *)`
-- * `CNWSCreature::GetTotalEffectBonus(uchar,CNWSObject \*,int,int,uchar,uchar,uchar,uchar,int)`
-- * `CNWSCombatRound::InitializeNumberOfAttacks()`
-- * `CNWSCreatureStats::GetCriticalHitMultiplier(int)`
-- * `CNWSCreatureStats::GetCriticalHitRoll(int)`
-- * `CNWSCreature::ResolveDamageShields(CNWSCreature *)`
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

-- CNWSEffectListHandler::OnApplyDamageImmunityIncrease(CNWSObject *,CGameEffect *,int)
local Orig_OnApplyDamageImmunityIncrease
local function Hook_OnApplyDamageImmunityIncrease(handler, obj, eff, force)
   local res = Orig_OnApplyDamageImmunityIncrease(handler, obj, eff, force)
   local cre = Game.GetObjectByID(obj.obj_id)
   if res == 0 and cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = C.ns_BitScanFFS(eff.eff_integers[0])
      local amt = eff.eff_integers[1]
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   end
   return res
end

Orig_OnApplyDamageImmunityIncrease = Hook.hook {
   func = Hook_OnApplyDamageImmunityIncrease,
   length = 5,
   address = 0x081712A8,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *, int32_t)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnRemoveDamageImmunityIncrease(CNWSObject *,CGameEffect *)
local Orig_OnRemoveDamageImmunityIncrease
local function Hook_OnRemoveDamageImmunityIncrease(handler, obj, eff)
   local res = Orig_OnRemoveDamageImmunityIncrease(handler, obj, eff)
   local cre = Game.GetObjectByID(obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = C.ns_BitScanFFS(eff.eff_integers[0])
      local amt = eff.eff_integers[1]
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] - amt
   end
   return res
end

Orig_OnRemoveDamageImmunityIncrease = Hook.hook {
   func = Hook_OnRemoveDamageImmunityIncrease,
   length = 5,
   address = 0x08171454,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnApplyDamageImmunityDecrease(CNWSObject *,CGameEffect *,int)
local Orig_OnApplyDamageImmunityDecrease
local function Hook_OnApplyDamageImmunityDecrease(handler, obj, eff, force)
   local res = Orig_OnApplyDamageImmunityDecrease(handler, obj, eff, force)
   local cre = Game.GetObjectByID(obj.obj_id)

   if res == 0 and cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = C.ns_BitScanFFS(eff.eff_integers[0])
      local amt = eff.eff_integers[1]
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] - amt
   end
   return res
end

Orig_OnApplyDamageImmunityDecrease = Hook.hook {
   func = Hook_OnApplyDamageImmunityDecrease,
   length = 5,
   address = 0x0817153C,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *, int32_t)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)

}

-- CNWSEffectListHandler::OnRemoveDamageImmunityDecrease(CNWSObject *,CGameEffect *)
local Orig_OnRemoveDamageImmunityDecrease
local function Hook_OnRemoveDamageImmunityDecrease(handler, obj, eff)
   local res = Orig_OnRemoveDamageImmunityDecrease(handler, obj, eff)
   local cre = Game.GetObjectByID(obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = C.ns_BitScanFFS(eff.eff_integers[0])
      local amt = eff.eff_integers[1]
      cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
   end
   return res
end

Orig_OnRemoveDamageImmunityDecrease = Hook.hook {
   func = Hook_OnRemoveDamageImmunityDecrease,
   length = 5,
   address = 0x08171734,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnApplyEffectImmunity(CNWSObject *,CGameEffect *,int) 0x08178470
local Orig_OnApplyEffectImmunity
local function Hook_OnApplyEffectImmunity(handler, obj, eff, force)
   local res = Orig_OnApplyEffectImmunity(handler, obj, eff, force)
   local cre = Game.GetObjectByID(obj.obj_id)
   if res == 0
      and cre:GetType() == OBJECT_TYPE_CREATURE
      and eff.eff_integers[1] == 28
      and eff.eff_integers[2] == 0
      and eff.eff_integers[3] == 0
   then
      local amt = eff.eff_integers[4]
      amt = amt == 0 and 100 or amt
      local idx = eff.eff_integers[0]
      cre.ci.defense.immunity_misc[idx] = cre.ci.defense.immunity_misc[idx] + amt
   end
   return res
end

Orig_OnApplyEffectImmunity = Hook.hook {
   func = Hook_OnApplyEffectImmunity,
   length = 5,
   address = 0x08178470,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *, int32_t)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnRemoveEffectImmunity(CNWSObject *,CGameEffect *)    0x0817D2F0
local Orig_OnRemoveEffectImmunity
local function Hook_OnRemoveEffectImmunity(handler, obj, eff)
   local cre = Game.GetObjectByID(obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE
      and eff.eff_integers[1] == 28
      and eff.eff_integers[2] == 0
      and eff.eff_integers[3] == 0
   then
      local amt = eff.eff_integers[4]
      amt = amt == 0 and 100 or amt
      local idx = eff.eff_integers[0]
      cre.ci.defense.immunity_misc[idx] = cre.ci.defense.immunity_misc[idx] - amt
   end
   return 1
end

Orig_OnRemoveEffectImmunity = Hook.hook {
   func = Hook_OnRemoveEffectImmunity,
   length = 6,
   address = 0x0817D2F0,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSCreatureStats::GetEffectImmunity(uchar,CNWSCreature *) 0x0815FF10
local function Hook_GetEffectImmunity(stats, immunity, vs)
   local cre = Game.GetObjectByID(stats.cs_original.obj.obj_id)
   local imm = Rules.GetEffectImmunity(cre, immunity)
   return cre:GetIsImmune(immunity, OBJECT_INVALID) and 1 or 0
end

Hook.hook {
   func = Hook_GetEffectImmunity,
   length = 5,
   address = 0x0815FF10,
   type = 'int32_t (*)(CNWSCreatureStats *, uint8_t, CNWSCreature *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSCreature::GetTotalEffectBonus(uchar,CNWSObject *,int,int,uchar,uchar,uchar,uchar,int)
local GetTotalEffectBonus_orig
local function Hook_GetTotalEffectBonus(cre, eff_switch , versus, elemental,
                                        is_crit, save, save_vs, skill,
                                        ability, is_offhand)
   local obj = Game.GetObjectByID(cre.obj.obj_id)
   if obj:GetType() == OBJECT_TYPE_CREATURE then
      if eff_switch == 3 then
         local min, max = Rules.GetSaveEffectLimits(obj, save, save_vs)
         local eff = Rules.GetSaveEffectBonus(obj, save, save_vs)
         return  math.clamp(eff, min, max)
      elseif eff_switch == 4 then
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
      elseif eff_switch == 5 then
         local min, max = Rules.GetSkillEffectLimits(obj, skill)
         local eff = Rules.GetSkillEffectModifier(obj, skill)
         return math.clamp(eff, min, max)
      end
   end

   return GetTotalEffectBonus_orig(cre, eff_switch , versus, elemental,
                                   is_crit, save, save_vs, skill,
                                   ability, is_offhand)
end

GetTotalEffectBonus_orig = Hook.hook {
   address = 0x08132298,
   func = Hook_GetTotalEffectBonus,
   type = "int (*)(CNWSCreature *, uint8_t, CNWSObject *, int32_t, int32_t, uint8_t, uint8_t, uint8_t, uint8_t, int32_t)",
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE),
   length = 5
}

-- CNWSCombatRound::InitializeNumberOfAttacks()
local function Hook_InitializeNumberOfAttacks(cr)
   local cre = GetObjectByID(cr.cr_original.obj.obj_id)
   if not cre:GetIsValid() then return end
   Rules.InitializeNumberOfAttacks(cre)
end

Hook.hook {
   address = 0x080E2260,
   func = Hook_InitializeNumberOfAttacks,
   type = "void (*)(CNWSCombatRound *)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

-- CNWSCreatureStats::GetWeaponFinesse(CNWSItem *)
local function Hook_GetWeaponFinesse(stats, item)
   local cre  = GetObjectByID(stats.cs_original.obj.obj_id)
   if item == nil then
      item = OBJECT_INVALID
   else
      item = GetObjectByID(item.obj.obj_id)
   end
   return Rules.GetIsWeaponFinessable(item, cre)
end

Hook.hook {
   address = 0x08155CF4,
   func = Hook_GetWeaponFinesse,
   type = "int32_t (*)(CNWSCreatureStats *, CNWSItem *)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

-- CNWSCreatureStats::GetCriticalHitMultiplier(int)
local function Hook_GetCriticalHitMultiplier(stats, is_offhand)
   local attacker = GetObjectByID(stats.cs_original.obj.obj_id)
   is_offhand = is_offhand == 1
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

Hook.hook {
   address = 0x0814C4A0,
   func = Hook_GetCriticalHitMultiplier,
   type = "int32_t (*)(CNWSCreatureStats *, int32_t)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

-- CNWSCreatureStats::GetCriticalHitRoll(int)
local function Hook_GetCriticalHitRoll(stats, is_offhand)
   local attacker = GetObjectByID(stats.cs_original.obj.obj_id)
   is_offhand = is_offhand == 1
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

Hook.hook {
   address = 0x0814C31C,
   func = Hook_GetCriticalHitRoll,
   type = "int32_t (*)(CNWSCreatureStats *, int32_t)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

--[[
local function Hook_GetArmorClassVersus(stats, vs, touch)
   touch = touch == 1
   local cre = GetObjectByID(stats.cs_original.obj.obj_id)
   return cre:GetACVersus(OBJECT_INVALID, touch)
end

Hook.hook {
   address = 0x0814088C,
   func = Hook_GetArmorClassVersus,
   type = "int32_t (*)(CNWSCreatureStats *, CNWSCreature *, int32_t)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

-- CNWSCreatureStats::GetAttackModifierVersus(CNWSCreature *)
local function Hook_GetAttackModifierVersus(stats, cre)
   local cre = GetObjectByID(stats.cs_original.obj.obj_id)
   return cre:GetAttackBonusVs(OBJECT_INVALID)
end

Hook.hook {
   address = 0x081445B4,
   func = Hook_GetAttackModifierVersus,
   type = "int32_t (*)(CNWSCreatureStats *, CNWSCreature *)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}
--]]

-- CNWSCreature::ResolveDamageShields(CNWSCreature *)
local function Hook_ResolveDamageShields(cre, attacker)
   if cre == nil or attacker == nil then return end
   cre = GetObjectByID(cre.obj.obj_id)
   attacker = GetObjectByID(attacker.obj.obj_id)

   for i = cre.obj.cre_stats.cs_first_dmgshield_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_SHIELD then
         break
      end
      local ip = cre.obj.obj.obj_effects[i].eff_integers[1]
      local d, s, b = Rules.UnpackItempropDamageRoll(ip)
      b = b + cre.obj.obj.obj_effects[i].eff_integers[0]
      local dflag = cre.obj.obj.obj_effects[i].eff_integers[2]
      local chance = cre.obj.obj.obj_effects[i].eff_integers[3]

      if chance == 0 or chance <= math.random(chance) then
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

Hook.hook {
   address = 0x080EFCAC,
   func = Hook_ResolveDamageShields,
   type = "void (*)(CNWSCreature *, CNWSCreature *)",
   flags = Hook.HOOK_DIRECT,
   length = 5
}

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
