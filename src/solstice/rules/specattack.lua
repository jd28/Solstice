--- Rules
-- @module rules

local Eff = require 'solstice.effect'
local C = require('ffi').C
local M = require 'solstice.rules.init'
local Log = System.GetLogger()
NWNXEvents = require 'solstice.nwnx.events'

local _SPEC = {}

--- Special Attacks
-- @section

-- For combat engine, don't publicly document
local function GetSpecialAttackDamage(id, info, attacker, target)
   local f = _SPEC[id] and _SPEC[id].damage
   if not f then return damage_roll_t()
   elseif type(f) ~= "function" then return f end
   return f(id, info, attacker, target)
end

-- For combat engine, don't publicly document
local function GetSpecialAttackImpact(id, info, attacker, target)
   local f = _SPEC[id] and _SPEC[id].impact
   if not f then return true end
   return f(id, info, attacker, target)
end

-- For combat engine, don't publicly document
local function GetSpecialAttackModifier(id, info, attacker, target)
  local f = _SPEC[id] and _SPEC[id].ab
  if not f then
    return 0
  elseif type(f) ~= "function" then
    return f
  end
  return f(id, info, attacker, target)
end

--- Register special attack handlers.
local function RegisterSpecialAttack(special_attack, ...)
  local t = table.pack(...)
  for i=1, t.n do
    M.SetUseFeatOverride(
      function (feat, user, target, pos)
        if not target:GetIsValid() then return true end
        C.nwn_AddAttackActions(user.obj, target.id);

        if not _SPEC[feat] then return false end
        if not _SPEC[feat].use or _SPEC[feat].use(feat, user, target) then
          C.nwn_AddSpecialAttack(user.obj.cre_combat_round, feat);
        end

        return true
      end,
      t[i])
    _SPEC[t[i]] = special_attack
  end
end

-- Default implementations.

local function smite_impact(id, info, attacker, target)
   local level = 0
   local eff
   if id == SPECIAL_ATTACK_SMITE_GOOD then
      local level = attacker:GetLevelByClass(CLASS_TYPE_BLACKGUARD)
      if level > 0 then
         eff = Eff.DamageImmunity(DAMAGE_INDEX_POSITIVE, -10)
      end
   else
      local level = attacker:GetLevelByClass(CLASS_TYPE_PALADIN) +
         attacker:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION)
      if level > 0 then
         eff = Eff.DamageImmunity(DAMAGE_INDEX_DIVINE, -10)
      end
   end

   if eff then
      eff:SetDurationType(DURATION_TYPE_TEMPORARY)
      eff:SetDuration(30)
   end

   return true, eff
end

local function smite_dmg(id, info, attacker, target)
   local roll = damage_roll_t()
   local feat = attacker:GetHighestFeatInRange(FEAT_EPIC_GREAT_SMITING_1,
                                               FEAT_EPIC_GREAT_SMITING_10)
   if feat == -1 then
      feat = 1
   else
      feat = 1 + feat - FEAT_EPIC_GREAT_SMITING_1 + 1
   end

   local level = 0

   if id == SPECIAL_ATTACK_SMITE_GOOD then
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

local function smite_ab(id, info, attacker, target)
   local level = attacker:GetLevelByClass(CLASS_TYPE_PALADIN) +
      attacker:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION) +
      attacker:GetLevelByClass(CLASS_TYPE_BLACKGUARD)

   return level > 0 and attacker:GetAbilityModifier(ABILITY_CHARISMA)
      or 0
end

local function stunning_fist_dmg(id, info, attacker, target)
   local roll = damage_roll_t()
   roll.type = DAMAGE_INDEX_BASE_WEAPON
   roll.roll.bonus = 4
   roll.mask = 1

   return roll
end

local function stunning_fist_impact(id, info, attacker, target)
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
      eff:SetDurationType(DURATION_TYPE_TEMPORARY)
      eff:SetSubType(SUBTYPE_SUPERNATURAL)
      eff:SetDuration(18)
      return true, eff
   end
   return false
end

local function aoo(id, info, attacker, target)
   if attacker:GetHasFeat(FEAT_OPPORTUNIST) then
      return 4
   end
   return 0
end

local function disarm_ab(id, info, attacker, target)
   local vs_weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not vs_weap:GetIsValid() then return 0 end

   local weap = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)

   local adj = 0
   if weap:GetIsValid() then
      adj = 4 * (C.nwn_GetItemSize(weap.obj) - C.nwn_GetItemSize(vs_weap.obj))
   end

   if id == SPECIAL_ATTACK_DISARM_IMPROVED then
      return adj - 4
   else
      return adj - 6
   end
end

local function called_shot_impact(id, info, attacker, target)
   if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
      target:GetSkillRank(SKILL_DISCIPLINE)
   then
      local eff
      if id == SPECIAL_ATTACK_CALLED_SHOT_ARM then
         eff = Eff.AttackBonus(-2)
         eff:SetDurationType(DURATION_TYPE_TEMPORARY)
         eff:SetDuration(24)
      elseif id == SPECIAL_ATTACK_CALLED_SHOT_LEG then
         local ab = Eff.Ability(ABILITY_DEXTERITY, -2)
         ab:SetDurationType(DURATION_TYPE_TEMPORARY)
         ab:SetDuration(24)

         local move = Eff.MovementSpeed(-20)
         move:SetCreator(attacker.id)
         move:SetDurationType(DURATION_TYPE_TEMPORARY)
         move:SetDuration(24)
         eff = {ab, move}
      end
      return true, eff
   end
   return false
end

local function disarm_impact(id, info, attacker, target)
   local vs_weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not vs_weap:GetIsValid() then return false end

   if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
      target:GetSkillRank(SKILL_DISCIPLINE)
   then
      local eff = Eff.Disarm()
      eff:SetDurationType(DURATION_TYPE_INSTANT)
      return true, eff
   end

   return false
end

local function sap_impact(id, info, attacker, target)
   return true
end

local function kd_use(id, attacker, target)
  if M.GetIsRangedWeapon(attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) then
    if attacker:GetIsPC() then
      attacker:SendMessage("You can not use Knockdown with ranged weapons.")
    end
    return false
  end
  return true
end

local function kd_impact(id, info, attacker, target)
   local size_bonus = id == SPECIAL_ATTACK_KNOCKDOWN_IMPROVED and 1 or 0
   if target:GetSize() > attacker:GetSize() + size_bonus then return false end

   if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
      target:GetSkillRank(SKILL_DISCIPLINE)
   then
      local eff = Eff.Knockdown()
      eff:SetDurationType(DURATION_TYPE_TEMPORARY)
      eff:SetDuration(6)
      return true, eff
   end

   return false
end

RegisterSpecialAttack({ impact = sap_impact, ab = -4}, SPECIAL_ATTACK_SAP)
RegisterSpecialAttack({ use = kd_use, impact = kd_impact, ab = -4},
                      SPECIAL_ATTACK_KNOCKDOWN_IMPROVED,
                      SPECIAL_ATTACK_KNOCKDOWN)
RegisterSpecialAttack({ impact = called_shot_impact, ab = -4},
                      SPECIAL_ATTACK_CALLED_SHOT_ARM,
                      SPECIAL_ATTACK_CALLED_SHOT_LEG)
RegisterSpecialAttack({ ab = -4}, SPECIAL_ATTACK_STUNNING_FIST)
RegisterSpecialAttack({ ab = aoo }, SPECIAL_ATTACK_AOO)
RegisterSpecialAttack({ damage = smite_dmg, impact = smite_impact, ab = smite_ab },
                      SPECIAL_ATTACK_SMITE_EVIL)

RegisterSpecialAttack({ damage = smite_dmg, impact = smite_impact, ab = smite_ab }, SPECIAL_ATTACK_SMITE_GOOD)
RegisterSpecialAttack({ impact = disarm_impact, ab = disarm_ab },
                      SPECIAL_ATTACK_DISARM_IMPROVED,
                      SPECIAL_ATTACK_DISARM)

M.GetSpecialAttackDamage   = GetSpecialAttackDamage
M.GetSpecialAttackImpact   = GetSpecialAttackImpact
M.GetSpecialAttackModifier = GetSpecialAttackModifier
M.RegisterSpecialAttack    = RegisterSpecialAttack

