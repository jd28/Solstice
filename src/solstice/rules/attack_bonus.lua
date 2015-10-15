local M = require 'solstice.rules.init'

local ffi = require 'ffi'
local clamp = math.clamp
local sm = string.strip_margin

local bonus = ffi.new("int32_t[10]")
local penalty = ffi.new("int32_t[10]")
local result = ffi.new("int32_t[10]")

local function GetEffectAttackModifier(cre, atype, target)
  ffi.fill(bonus, 4 * 10)
  ffi.fill(penalty, 4 * 10)
  ffi.fill(result, 4 * 10)

  if cre.obj.obj.obj_effects_len <= 0 then return end

  for i = cre.obj.cre_stats.cs_first_ab_eff, cre.obj.obj.obj_effects_len - 1 do
    if cre.obj.obj.obj_effects[i].eff_type > EFFECT_TYPE_ATTACK_DECREASE then
      break
    end

    if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_INCREASE
      or cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_DECREASE
    then

      local amount  = cre.obj.obj.obj_effects[i].eff_integers[0]
      local atktype  = cre.obj.obj.obj_effects[i].eff_integers[1]
      local race   = cre.obj.obj.obj_effects[i].eff_integers[2]
      local lawchaos = cre.obj.obj.obj_effects[i].eff_integers[3]
      local goodevil = cre.obj.obj.obj_effects[i].eff_integers[4]

      if race == 28 and lawchaos == 0 and goodevil == 0 then
       if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_INCREASE then
         if atktype == ATTACK_TYPE_MISC then
           bonus[atktype] = bonus[atktype] + amount
         else
           bonus[atktype] = math.max(bonus[atktype], amount)
         end
       elseif cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_ATTACK_DECREASE then
         if atktype == ATTACK_TYPE_MISC then
           penalty[atktype] = penalty[atktype] + amount
         else
           penalty[atktype] = math.max(penalty[atktype], amount)
         end
       end
      end
    end
  end

  for i=0, 9 do
    result[i] = bonus[i] - penalty[i]
  end

  if atype == nil then
    return result
  else
    return result[atype]
  end
end

local function GetEffectAttackLimits(cre)
  return -20, 20
end

local _TIERS = {}
local _TIER2 = {}
local _TIER3 = {}

for i=0, Game.Get2daRowCount("cls_atk_2") - 1 do
  _TIER2[i] = Game.Get2daInt("cls_atk_2", "BAB", i)
end

for i=0, Game.Get2daRowCount("cls_atk_3") - 1 do
  _TIER3[i] = Game.Get2daInt("cls_atk_3", "BAB", i)
end

for i=0, Game.Get2daRowCount("classes") - 1 do
  local atk = Game.Get2daString("classes", "AttackBonusTable", i)
  if atk == 'CLS_ATK_1' then
    _TIERS[i] = 1
  elseif atk == 'CLS_ATK_2' then
    _TIERS[i] = 2
  elseif atk == 'CLS_ATK_3' then
    _TIERS[i] = 3
  else
    _TIERS[i] = 0
  end
end

--- Get base attack bonus
-- @param cre Creature object.
-- @param[opt=false] pre_epic Only calculate pre-epic BAB.
local function GetBaseAttackBonus(cre, pre_epic)
  local t = {0, 0, 0}
  local hd = cre:GetHitDice()

  if not cre:GetIsPC() or cre:GetIsPossessedFamiliar()
    or cre:GetIsDMPossessed()
  then
    local l = math.min(20, cre:GetLevelByPosition(0))
    local remaining = 20 - l
    local c = cre:GetClassByPosition(0)
    t[_TIERS[c]] = t[_TIERS[c]] + l

    if remaining > 0 and cre.obj.cre_stats.cs_classes_len > 1 then
      l = math.min(remaining, cre:GetLevelByPosition(1))
      remaining = remaining - l
      c = cre:GetClassByPosition(1)
      t[_TIERS[c]] = t[_TIERS[c]] + l
    end

    if remaining > 0 and cre.obj.cre_stats.cs_classes_len > 2 then
      l = math.min(remaining, cre:GetLevelByPosition(2))
      remaining = remaining - l
      c = cre:GetClassByPosition(2)
      t[_TIERS[c]] = t[_TIERS[c]] + l
    end
  else
    for i = 1, math.min(20, hd) do
      local c = cre:GetClassByLevel(i)
      if c == -1 then break end
      t[_TIERS[c]] = t[_TIERS[c]] + 1
    end
  end

  local res = t[1] + _TIER2[t[2]] + _TIER3[t[3]]
  if pre_epic then return res end

  if hd > 20 then
    local epic = math.floor((hd - 20) / 2)
    res = res + epic
  end

  return res
end

--- Get attack bonus vs target.
local function GetAttackBonusVs(attacker, atype, target)
  local ab = GetBaseAttackBonus(attacker)
  local eff_ab = GetEffectAttackModifier(attacker, nil, target)
  local min, max = GetEffectAttackLimits(attacker)

  ab = ab + clamp(eff_ab[ATTACK_TYPE_MISC] + eff_ab[atype], min, max)

  local weapon = attacker:GetWeaponFromAttackType(atype)
  ab = ab + M.GetWeaponAttackBonus(attacker, weapon)
  ab = ab + M.GetWeaponAttackAbility(attacker, weapon)

  local on, off = Rules.GetDualWieldPenalty(attacker)
  if equip == EQUIP_TYPE_ONHAND then
    ab = ab + on
  elseif equip == EQUIP_TYPE_OFFHAND then
    ab = ab + off
  end

  for i = 0, COMBAT_MOD_SKILL do
    ab = ab + (Rules.GetCombatModifier(i, ATTACK_MODIFIER_AB, attacker) or 0)
  end

  if attacker:GetHasTrainingVs(target) then
    ab = ab + (Rules.GetCombatModifier(COMBAT_MOD_TRAINING_VS, ATTACK_MODIFIER_AB, attacker) or 0)
  end

  if attacker:GetIsFavoredEnemy(target) then
    ab = ab + (Rules.GetCombatModifier(COMBAT_MOD_FAVORED_ENEMY, ATTACK_MODIFIER_AB, attacker) or 0)
  end

  ab = ab + (Rules.GetModeModifier(attacker:GetCombatMode(), ATTACK_MODIFIER_AB, cre) or 0)

  return ab
end

--- Get ranged attack bonus/penalty vs a target.
-- @param target Creature's target.
-- @param distance Distance to target.
local function GetRangedAttackMod(attacker, target, distance)
  local ab = 0

  -- Point Blank Shot
  if distance <= 25 and attacker:GetHasFeat(FEAT_POINT_BLANK_SHOT) then
    ab = ab + 1
  end

  if target.type == OBJECT_TRUETYPE_CREATURE then
    -- Ranged Attack in Melee Target Range
    local max = target:GetMaxAttackRange(attacker)
    local weap = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
    if distance <= max * max
      and weap:GetIsValid()
      and not weap:GetIsRangedWeapon()
    then
      ab = ab - 4
    end
  end

  return ab
end

local function DebugAttackBonus(cre)
  local t = {}
  local eff_ab = GetEffectAttackModifier(cre, nil, OBJECT_INVALID)
  table.insert(t, "Attack Bonus")
  table.insert(t, string.format("  BAB: %d", GetBaseAttackBonus(cre)))
  local on, off = Rules.GetDualWieldPenalty(cre)
  table.insert(t, string.format("  Dual Wield Penalty: On: %d, Off: %d", on, off))
  table.insert(t, string.format("  Effect AB Bonus: %d", eff_ab[ATTACK_TYPE_MISC]))
  table.insert(t, "  Combat Modifiers:")
  for i=0, COMBAT_MOD_NUM - 1 do
    local mod = Rules.GetCombatModifier(i, ATTACK_MODIFIER_AB, cre)
    if mod then
      table.insert(t, string.format("   %d: %d", i, mod))
    end
  end

  table.insert(t, "")
  table.insert(t, "  Weapons")
  local fmt = sm([[   Slot: %s
                  |   ID: %x:
                  |   Ability AB: %d,
                  |   AB Modifier : %d,
                  |   Effect AB Modifier: %d]])

  local function weapon(slot, name, atype)
    local it = cre:GetItemInSlot(slot)
    if it:GetIsValid() or slot == INVENTORY_SLOT_ARMS then
      table.insert(t,
        string.format(fmt,
                      name,
                      it.id,
                      M.GetWeaponAttackAbility(cre, it),
                      M.GetWeaponAttackBonus(cre, it),
                      eff_ab[atype]))
      table.insert(t, "")
    end
  end

  weapon(INVENTORY_SLOT_RIGHTHAND, 'Righthand', ATTACK_TYPE_ONHAND)
  weapon(INVENTORY_SLOT_LEFTHAND, 'Lefthand', ATTACK_TYPE_OFFHAND)
  weapon(INVENTORY_SLOT_ARMS, 'Unarmed', ATTACK_TYPE_UNARMED)
  weapon(INVENTORY_SLOT_CWEAPON_R, 'Creature 1', ATTACK_TYPE_CWEAPON1)
  weapon(INVENTORY_SLOT_CWEAPON_L, 'Creature 2', ATTACK_TYPE_CWEAPON2)
  weapon(INVENTORY_SLOT_CWEAPON_B, 'Creature 3', ATTACK_TYPE_CWEAPON3)

  return table.concat(t, '\n')
end


-- Exports
M.DebugAttackBonus = DebugAttackBonus
M.GetEffectAttackModifier = GetEffectAttackModifier
M.GetEffectAttackLimits = GetEffectAttackLimits
M.GetBaseAttackBonus = GetBaseAttackBonus
M.GetAttackBonusVs = GetAttackBonusVs
M.GetRangedAttackMod = GetRangedAttackMod