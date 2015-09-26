--- Modes
-- @module rules

--- Modes
-- @section modes

local ffi = require 'ffi'
local jit = require 'jit'
local MODES = {}
local M = require 'solstice.rules.init'
GetObjectByID = Game.GetObjectByID

-- Internal toggle mode function
-- @param cre Creature to toggle mode on
-- @param mode ACTION_MODE_*
function __ToggleMode(cre, mode)
  cre = GetObjectByID(cre)
  if not cre:GetIsValid() then return false end

  local bypass = true
  local act, on

  if cre:GetIsDead() or cre:GetIsPCDying() then
    return false
  end

  if mode == ACTION_MODE_DETECT then
    if cre:GetDetectMode() == 1 then
      act, on = 2, 0
    else
      act, on = 2, 1
    end
    cre:SetActivity(act, on)
  elseif mode == ACTION_MODE_STEALTH then
    if cre.obj.cre_attack_target ~= OBJECT_INVALID.id
      or cre.obj.cre_attempted_target ~= OBJECT_INVALID.id
    then
      cre:SendMessageByStrRef(60)
    elseif cre:CanUseSkill(SKILL_HIDE) or cre:CanUseSkill(SKILL_MOVE_SILENTLY) then
      if cre.obj.cre_mode_stealth == 1 then
        act, on = 1, 0
      else
        act, on = 1, 1
      end
      cre:SetActivity(act, on)
    end
  elseif mode == ACTION_MODE_PARRY then
    if cre.obj.cre_mode_combat == COMBAT_MODE_PARRY then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_PARRY, false)
    end
  elseif mode == ACTION_MODE_POWER_ATTACK then
    if not cre:GetHasFeat(FEAT_POWER_ATTACK) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_POWER_ATTACK then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_POWER_ATTACK, false)
    end
  elseif mode == ACTION_MODE_IMPROVED_POWER_ATTACK then
    if not cre:GetHasFeat(FEAT_IMPROVED_POWER_ATTACK) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_IMPROVED_POWER_ATTACK then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_IMPROVED_POWER_ATTACK, false)
    end
  elseif mode == ACTION_MODE_COUNTERSPELL then
    if cre.obj.cre_mode_combat == COMBAT_MODE_COUNTERSPELL then
      cre:SetCombatMode(COMBAT_MODE_COUNTERSPELL, false)
    else
      cre:SetCombatMode(COMBAT_MODE_COUNTERSPELL, true)
    end
  elseif mode == ACTION_MODE_FLURRY_OF_BLOWS then
    if not cre:GetHasFeat(FEAT_FLURRY_OF_BLOWS) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_FLURRY_OF_BLOWS then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_FLURRY_OF_BLOWS, false)
    end
  elseif mode == ACTION_MODE_RAPID_SHOT then
    if not cre:GetHasFeat(FEAT_RAPID_SHOT) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_RAPID_SHOT then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_RAPID_SHOT, false)
    end
  elseif mode == ACTION_MODE_EXPERTISE then
    if not cre:GetHasFeat(FEAT_EXPERTISE) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_EXPERTISE then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_EXPERTISE, false)
    end
  elseif mode == ACTION_MODE_IMPROVED_EXPERTISE then
    if not cre:GetHasFeat(FEAT_IMPROVED_EXPERTISE) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_IMPROVED_EXPERTISE then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_IMPROVED_EXPERTISE, true)
    end
  elseif mode == ACTION_MODE_DEFENSIVE_CAST then
    if cre.obj.cre_mode_combat == COMBAT_MODE_DEFENSIVE_CASTING then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_DEFENSIVE_CASTING, false)
    end
  elseif mode == ACTION_MODE_DIRTY_FIGHTING then
    if not cre:GetHasFeat(FEAT_DIRTY_FIGHTING) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_DIRTY_FIGHTING then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_DIRTY_FIGHTING, false)
    end
  elseif mode == ACTION_MODE_DEFENSIVE_STANCE then
    if not cre:GetHasFeat(FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE) then
      return false
    end

    if cre.obj.cre_mode_combat == COMBAT_MODE_DEFENSIVE_STANCE then
      cre:SetCombatMode(COMBAT_MODE_INVALID, true)
    else
      cre:SetCombatMode(COMBAT_MODE_DEFENSIVE_STANCE, false)
      cre:DecrementRemainingFeatUses(FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE)
    end
  end

  cre:NotifyAssociateActionToggle(mode)
  return true
end

jit.off(__ToggleMode)

--- Register a combat mode.
local function RegisterMode(mode, ...)
  local t = table.pack(...)
  for i=1, t.n do
    if not t[i] then
      local Log = System.GetLogger()
      Log:error("Nil combat mode!\nStack Trace: %s", debug.traceback())
    else
      MODES[t[i]] = mode
    end
  end
end

local function GetCanUseMode(mode, cre)
  if not MODES[mode] then return false end
  if type(MODES[mode]) == 'boolean' then return true end
  return MODES[mode].use(mode, cre)
end

local function GetModeModifier(mode, modifier, cre)
  if not MODES[mode] or not MODES[mode].modifier then return end
  return MODES[mode].modifier(mode, modifier, cre)
end

--- Convert COMBAT_MODE_\* to ACTION_MODE_\*.
-- @param mode COMBAT_MODE_\*.
-- @return -1 on error.
function M.ToAction(mode)
  if mode == COMBAT_MODE_PARRY then
    return ACTION_MODE_PARRY
  elseif mode == COMBAT_MODE_POWER_ATTACK then
    return ACTION_MODE_POWER_ATTACK
  elseif mode == COMBAT_MODE_IMPROVED_POWER_ATTACK then
    return ACTION_MODE_IMPROVED_POWER_ATTACK
  elseif mode == COMBAT_MODE_COUNTER_SPELL then
    return ACTION_MODE_COUNTERSPELL
  elseif mode == COMBAT_MODE_FLURRY_OF_BLOWS then
    return ACTION_MODE_FLURRY_OF_BLOWS
  elseif mode == COMBAT_MODE_RAPID_SHOT then
    return ACTION_MODE_RAPID_SHOT
  elseif mode == COMBAT_MODE_EXPERTISE then
    return ACTION_MODE_EXPERTISE
  elseif mode == COMBAT_MODE_IMPROVED_EXPERTISE then
    return ACTION_MODE_IMPROVED_EXPERTISE
  elseif mode == COMBAT_MODE_DEFENSIVE_CASTING then
    return ACTION_MODE_DEFENSIVE_CAST
  elseif mode == COMBAT_MODE_DIRTY_FIGHTING then
    return ACTION_MODE_DIRTY_FIGHTING
  elseif mode == COMBAT_MODE_DEFENSIVE_STANCE then
    return ACTION_MODE_DEFENSIVE_STANCE
  end

  return -1
end

-- The following modes can always be used.
RegisterMode({ use = true},
  COMBAT_MODE_DEFENSIVE_CASTING,
  COMBAT_MODE_DEFENSIVE_STANCE,
  COMBAT_MODE_PARRY)


--Dirty Fighting--------------------------------------------------------
local function dirty(mode, modifier, cre)
  if modifier == ATTACK_MODIFIER_DAMAGE then
    local roll = damage_roll_t()
    roll.type = DAMAGE_INDEX_BASE_WEAPON
    roll.roll.dice = 1
    roll.roll.sides = 4
    return roll
  end
end

RegisterMode(
  { use = true, modifier = dirty },
  COMBAT_MODE_DIRTY_FIGHTING)

--Expertise-------------------------------------------------------------

local function expertise(mode, modifier, cre)
  local res = 0
  if modifier == ATTACK_MODIFIER_AB then
    res = -5
  elseif modifier == ATTACK_MODIFIER_AC then
    res = 5
  end

  if mode == COMBAT_MODE_IMPROVED_EXPERTISE then
    res = res * 2
  end

  return res
end

RegisterMode(
  { use = true, modifier = expertise },
  COMBAT_MODE_EXPERTISE,
  COMBAT_MODE_IMPROVED_EXPERTISE)

--Flurry of Blows-------------------------------------------------------
local function flurry_use(mode, cre)
  local result = false
  local monk = cre:GetLevelByClass(CLASS_TYPE_MONK)
  local rh = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)

  if not rh:GetIsValid() then
    -- Creature is unarmed
    result = true
  elseif Rules.GetIsRangedWeapon(rh) then
    -- Right hand is valid and is a ranged weapon.
    result = false
  else
    -- If it's a monk weapon and creature has enough levels of monk to
    -- use it, then check if there is an offhand weapon.
    if Rules.GetIsMonkWeapon(rh) then
      local lh = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if not lh:GetIsValid() then
        -- lefthand weapon if invalid
        -- righthand weapon is a monk weapon
        result = true
      else
        result = Rules.GetIsMonkWeapon(lh)
      end
    else
      -- righthand weapon is not a monk weapon.
      result = false
    end
  end

  if not result then
    cre:SendMessageByStrRef(66246)
  end

  return result
end

local function flurry(mode, modifier, cre)
  if modifier == ATTACK_MODIFIER_AB then
    return -2
  end
end

RegisterMode(
  { use = flurry_use , modifier = flurry },
  COMBAT_MODE_FLURRY_OF_BLOWS)

--Power Attack----------------------------------------------------------

local function power_attack(mode, modifier, cre)
  if off then return true end

  if modifier == ATTACK_MODIFIER_DAMAGE then
    local dmg = damage_roll_t()
    dmg.type = DAMAGE_INDEX_BASE_WEAPON
    local res = 5
    if mode == COMBAT_MODE_IMPROVED_POWER_ATTACK then
       res = res * 2
    end
    dmg.roll.bonus = res
    return dmg
  elseif modifier == ATTACK_MODIFIER_AB then
    local res = -5
    if mode == COMBAT_MODE_IMPROVED_POWER_ATTACK then
       res = res * 2
    end
    return res
  end
end

RegisterMode(
  { use = true, modifier = power_attack },
  COMBAT_MODE_IMPROVED_POWER_ATTACK,
  COMBAT_MODE_POWER_ATTACK)

--Rapid Shot------------------------------------------------------------
local function rapid_shot_use(mode, cre)
  local weap = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
  if not Rules.GetIsRangedWeapon(weap) then
    cre:SendMessageByStrRef(66246)
    return false
  end
  return true
end

local function rapid_shot(mode, modifier, cre)
  if modifier == ATTACK_MODIFIER_AB then
    return -2
  end
end

RegisterMode(
  { use = rapid_shot_use, modifier = rapid_shot },
  COMBAT_MODE_RAPID_SHOT)

-- Exports
M.RegisterMode = RegisterMode
M.GetCanUseMode = GetCanUseMode
M.GetModeModifier = GetModeModifier
return M
