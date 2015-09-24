local ffi = require 'ffi'
local C = ffi.C

--- Update attack bonus/penalty effects.
-- @param cre Creature object.
local function UpdateAttackBonusEffects(cre)
   if cre.obj.obj.obj_effects_len <= 0 then return end
   local bon, pen = {}, {}

   for i = cre.obj.cre_stats.cs_first_ab_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type > EFFECT_TYPE_ATTACK_DECREASE then
         break
      end

      if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_INCREASE
         or cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_DECREASE
      then

         local amount    = cre.obj.obj.obj_effects[i].eff_integers[0]
         local atktype   = cre.obj.obj.obj_effects[i].eff_integers[1]
         local race      = cre.obj.obj.obj_effects[i].eff_integers[2]
         local lawchaos  = cre.obj.obj.obj_effects[i].eff_integers[3]
         local goodevil  = cre.obj.obj.obj_effects[i].eff_integers[4]

         bon[atktype] = bon[atktype] or 0
         pen[atktype] = pen[atktype] or 0

         if race == 28 and lawchaos == 0 and goodevil == 0 then
            if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_INCREASE then
               if atktype == ATTACK_TYPE_MISC then
                  bon[atktype] = bon[atktype] + amount
               else
                  bon[atktype] = math.max(bon[atktype], amount)
               end
            elseif cre.obj.obj.obj_effects[i].eff_type ==  EFFECT_TYPE_ATTACK_DECREASE then
               if atktype == ATTACK_TYPE_MISC then
                  pen[atktype] = pen[atktype] + amount
               else
                  pen[atktype] = math.max(pen[atktype], amount)
               end
            end
         end
      end
   end

   cre.ci.offense.ab_transient =
      (bon[ATTACK_TYPE_MISC] or 0) - (pen[ATTACK_TYPE_MISC] or 0)

   cre.ci.equips[EQUIP_TYPE_ONHAND].transient_ab_mod =
      (bon[ATTACK_TYPE_ONHAND] or 0) - (pen[ATTACK_TYPE_ONHAND] or 0)

   cre.ci.equips[EQUIP_TYPE_OFFHAND].transient_ab_mod =
      (bon[ATTACK_TYPE_OFFHAND] or 0) - (pen[ATTACK_TYPE_OFFHAND] or 0)

   cre.ci.equips[EQUIP_TYPE_UNARMED].transient_ab_mod =
      (bon[ATTACK_TYPE_UNARMED] or 0) - (pen[ATTACK_TYPE_UNARMED] or 0)

   cre.ci.equips[EQUIP_TYPE_CREATURE_1].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON1] or 0) - (pen[ATTACK_TYPE_CWEAPON1] or 0)

   cre.ci.equips[EQUIP_TYPE_CREATURE_2].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON2] or 0) - (pen[ATTACK_TYPE_CWEAPON2] or 0)

   cre.ci.equips[EQUIP_TYPE_CREATURE_3].transient_ab_mod =
      (bon[ATTACK_TYPE_CWEAPON3] or 0) - (pen[ATTACK_TYPE_CWEAPON3] or 0)
end

local function UpdateAbilityEffects(cre)
   if cre.obj.obj.obj_effects_len <= 0 then return end
   for i = 0, ABILITY_NUM - 1 do
      cre.ci.ability_eff[i] = 0
   end

   for i = cre.obj.cre_stats.cs_first_ability_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type > EFFECT_TYPE_ABILITY_DECREASE then
         break
      end
      if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ABILITY_INCREASE
         or cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ABILITY_DECREASE
      then
         local abil = cre.obj.obj.obj_effects[i].eff_integers[0]
         if abil >= 0 and abil < ABILITY_NUM then
            if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ABILITY_INCREASE then
               cre.ci.ability_eff[abil] = cre.ci.ability_eff[abil] + cre.obj.obj.obj_effects[i].eff_integers[1]
            else
               cre.ci.ability_eff[abil] = cre.ci.ability_eff[abil] - cre.obj.obj.obj_effects[i].eff_integers[1]
            end
         end
      end
   end

   for i = 0, ABILITY_NUM - 1 do
      local min, max = Rules.GetAbilityEffectLimits(cre, i)
      cre.ci.ability_eff[i] = math.clamp(cre.ci.ability_eff[i], min, max)
   end
end

local function UpdateMiscImmunityEffects(cre)
   if cre.obj.obj.obj_effects_len <= 0 then return end
   for i = 0, IMMUNITY_TYPE_NUM - 1 do
      cre['SOL_IMMUNITY_MISC']:set(i, 0)
   end
   for i = cre.obj.cre_stats.cs_first_imm_eff, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_IMMUNITY then
         break
      end
      local imm = cre.obj.obj.obj_effects[i].eff_integers[0]
      if imm >= 0 and imm < IMMUNITY_TYPE_NUM then
         local amt = cre.obj.obj.obj_effects[i].eff_integers[4]
         amt = amt == 0 and 100 or amt
         cre['SOL_IMMUNITY_MISC']:set(imm, cre['SOL_IMMUNITY_MISC']:get(imm) + amt)
      end
   end
end

local function UpdateDamageImmunityEffects(cre)
   if not cre['SOL_DMG_IMMUNITY'] then return end

   for i = 0, DAMAGE_INDEX_NUM - 1 do
      cre['SOL_DMG_IMMUNITY']:set(i, 0)
   end
   for i = 0, cre.obj.obj.obj_effects_len - 1 do
      local type = cre.obj.obj.obj_effects[i].eff_type
      if type > EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then break end

      if type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
         or type == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE
      then
         local idx = C.ns_BitScanFFS(cre.obj.obj.obj_effects[i].eff_integers[0])
         local amt = cre.obj.obj.obj_effects[i].eff_integers[1]
         if type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then
            amt = -amt
         end
         cre.ci.defense.immunity[idx] = cre.ci.defense.immunity[idx] + amt
         cre['SOL_DMG_IMMUNITY']:set(i, amt + cre['SOL_DMG_IMMUNITY']:get(i))
      end
   end
end

local M = require 'solstice.rules.init'
M.UpdateAttackBonusEffects = UpdateAttackBonusEffects
M.UpdateAbilityEffects = UpdateAbilityEffects
M.UpdateMiscImmunityEffects = UpdateMiscImmunityEffects
M.UpdateDamageImmunityEffects = UpdateDamageImmunityEffects
