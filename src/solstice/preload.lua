local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

require 'solstice.global'
require 'solstice.combat'
local Hook = require 'solstice.hooks'
local NWNXEffects = require 'solstice.nwnx.effects'

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
