local ffi = require 'ffi'
local C = ffi.C

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
