local Eff = require 'solstice.effect'
local C = require('ffi').C

local _SPEC_DMG = {}
local _SPEC_AB = {}
local _SPEC_EFF = {}

local function GetSpecialAttackDamage(special_attack, attacker, target)
   local f = _SPEC_DMG[special_attack]
   if not f then return damage_roll_t() end
   return f(info, attacker, target)
end

local function GetSpecialAttackEffect(special_attack, attacker, target)
   local f = _SPEC_EFF[special_attack]
   if not f then return true end
   return f(info, attacker, target)
end

local function GetSpecialAttackModifier(special_attack, info, attacker, target)
   local f = _SPEC_AB[special_attack]
   if not f then return 0 end
   return f(special_attack, info, attacker, target)
end

local function RegisterSpecialAttack(special_attack, damage, effect, attack)
   _SPEC_DMG[special_attack] = damage
   _SPEC_AB[special_attack]  = effect
   _SPEC_EFF[special_attack] = effect
end

local function smite_impact(special_attack, info, attacker, target)
   local level = 0
   local eff
   if special_attack == SPECIAL_ATTACK_SMITE_GOOD then
      local level = attacker:GetLevelByClass(CLASS_TYPE_BLACKGUARD)
      if level > 0 then
         Eff.DamageImmunity(DAMAGE_INDEX_POSITIVE, -10)
      end
   else
      local level = attacker:GetLevelByClass(CLASS_TYPE_PALADIN) +
         attacker:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION)
      if level > 0 then
         Eff.DamageImmunity(DAMAGE_INDEX_DIVINE, -10)
      end
   end

   if eff then
      eff.direct = true
      eff:SetCreator(attacker.id)
      eff:SetDurationType(DURATION_TYPE_TEMPORARY)
      eff:SetDuration(30)
      C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
   end

   return true
end

local function smite_dmg(special_attack, info, attacker, target)
   local roll = damage_roll_t()
   local feat = attacker:GetHighestFeatInRange(FEAT_EPIC_GREAT_SMITING_1,
                                               FEAT_EPIC_GREAT_SMITING_10)
   if feat == -1 then
      feat = 1
   else
      feat = 1 + feat - FEAT_EPIC_GREAT_SMITING_1 + 1
   end

   local level = 0

   if special_attack == SPECIAL_ATTACK_SMITE_GOOD then
      level = attacker:GetLevelByClass(CLASS_TYPE_BLACKGUARD)
      roll.type = DAMAGE_INDEX_POSITIVE
   else
      level = attacker:GetLevelByClass(CLASS_TYPE_PALADIN) +
         attacker:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION)
      roll.type = DAMAGE_INDEX_DIVINE
   end

   roll.roll.bonus = level * feat

   return roll
end

local function smite_ab(special_attack, info, attacker, target)
   local level = attacker:GetLevelByClass(CLASS_TYPE_PALADIN) +
      attacker:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION) +
      attacker:GetLevelByClass(CLASS_TYPE_BLACKGUARD)

   return level > 0 and attacker:GetAbilityModifier(ABILITY_CHARISMA)
      or 0
end

local function stunning_fist_dmg(special_attack, info, attacker, target)
   roll.type = DAMAGE_INDEX_BASE_WEAPON
   roll.roll.bonus = 4
   roll.mask = 1

   return roll
end

local function stunning_fist_impact(special_attack, info, attacker, target)
   if info.attack.cad_attack_result ~= 3 then return false end
   local dc = attacker:GetAbilityModifier(ABILITY_WISDOM) +
      attacker:GetLevelByClass(CLASS_TYPE_MONK)

   local feat = attacker:GetHighestFeatInRange(FEAT_EPIC_GREAT_SMITING_1,
                                               FEAT_EPIC_GREAT_SMITING_10)
   if feat ~= -1 then
      dc = dc + (feat - FEAT_EPIC_GREAT_SMITING_1 + 1) * 2
   end

   if target:FortitudeSave(dc, SAVING_THROW_VS_NONE, attacker) == 0 then
      local eff = Eff.Stunned()
      eff.direct = true
      eff:SetCreator(attacker.id)
      eff:SetDurationType(DURATION_TYPE_TEMPORARY)
      eff:SetSubType(SUBTYPE_SUPERNATURAL)
      eff:SetDuration(18)
      C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
      return true
   end
   return false
end

local function minus_four() return -4 end

local function aoo(special_attack, info, attacker, target)
   if attacker:GetHasFeat(FEAT_OPPORTUNIST) then
      return 4
   end
   return 0
end

local function disarm_ab(special_attack, info, attacker, target)
   local vs_weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not vs_weap:GetIsValid() then return 0 end

   local weap = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)

   local adj = 0
   if weap:GetIsValid() then
      adj = 4 * (C.nwn_GetItemSize(weap.obj) - C.nwn_GetItemSize(vs_weap.obj))
   end

   if special_attack == SPECIAL_ATTACK_DISARM_IMPROVED then
      return adj - 4
   else
      return adj - 6
   end
end

local function called_shot_impact(special_attack, info, attacker, target)
   local disc = target:GetSkillRank(SKILL_DISCIPLINE)

   if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
      target:GetSkillRank(SKILL_DISCIPLINE)
   then
      if special_attack == SPECIAL_ATTACK_CALLED_SHOT_ARM then
         local eff = Eff.AttackBonus(-2)
         eff.direct = true
         eff:SetCreator(attacker.id)
         eff:SetDurationType(DURATION_TYPE_TEMPORARY)
         eff:SetDuration(24)
         C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
      elseif special_attack == SPECIAL_ATTACK_CALLED_SHOT_LEG then
         local eff = Eff.Ability(ABILITY_DEXTERITY, -2)
         eff.direct = true
         eff:SetCreator(attacker.id)
         eff:SetDurationType(DURATION_TYPE_TEMPORARY)
         eff:SetDuration(24)
         C.nwn_AddOnHitEffect(attacker.obj, eff.eff)

         eff = Eff.MovementSpeed(-20)
         eff.direct = true
         eff:SetCreator(attacker.id)
         eff:SetDurationType(DURATION_TYPE_TEMPORARY)
         eff:SetDuration(24)
         C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
      end
      return true
   end
   return false
end

local function disarm_impact(special_attack, info, attacker, target)
   local vs_weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not vs_weap:GetIsValid() then return false end

   if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
      target:GetSkillRank(SKILL_DISCIPLINE)
   then
      local eff = Eff.Disarm()
      eff.direct = true
      eff:SetCreator(attacker.id)
      eff:SetDurationType(DURATION_TYPE_INSTANT)
      C.nwn_AddOnHitEffect(attacker.obj, eff.eff)
      return true
   end

   return false
end

local function sap_impact(special_attack, info, attacker, target)
   return true
end

RegisterSpecialAttack(SPECIAL_ATTACK_SAP, nil, sap_impact, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_KNOCKDOWN_IMPROVED, nil, nil, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_KNOCKDOWN, nil, nil, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_CALLED_SHOT_ARM, nil, called_shot_impact, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_CALLED_SHOT_LEG, nil, called_shot_impact, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_STUNNING_FIST, nil, nil, minus_four)
RegisterSpecialAttack(SPECIAL_ATTACK_AOO, nil, nil, aoo)
RegisterSpecialAttack(SPECIAL_ATTACK_SMITE_EVIL, smite_dmg, smite_impact, smite_ab)
RegisterSpecialAttack(SPECIAL_ATTACK_SMITE_GOOD, smite_dmg, smite_impact, smite_ab)
RegisterSpecialAttack(SPECIAL_ATTACK_DISARM_IMPROVED, nil, nil, disarm_ab)
RegisterSpecialAttack(SPECIAL_ATTACK_DISARM, nil, disarm_impact, disarm_ab)

local M = require 'solstice.rules.init'
M.GetSpecialAttackDamage   = GetSpecialAttackDamage
M.GetSpecialAttackEffect   = GetSpecialAttackEffect
M.GetSpecialAttackModifier = GetSpecialAttackModifier
M.RegisterSpecialAttack    = RegisterSpecialAttack
