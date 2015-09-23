--- Rules
-- @module rules

local function sneak_attack(modifier, cre)
  if modifier ~= ATTACK_MODIFIER_DAMAGE then return end
  local feat
  local normal = false
  local dmg = damage_roll_t()
  dmg.type = 12
  dmg.roll.sides = 6

  -- Normal sneak.
  feat = cre:GetHighestFeatInRange(FEAT_SNEAK_ATTACK_11,
                        FEAT_SNEAK_ATTACK_20)

  if feat ~= -1 then
    dmg.roll.dice = feat - FEAT_SNEAK_ATTACK_11 + 11
    normal = true
  end

  if not normal then
    feat = cre:GetHighestFeatInRange(FEAT_SNEAK_ATTACK_2,
                          FEAT_SNEAK_ATTACK_10)

    if feat ~= -1 then
      dmg.roll.dice = feat - FEAT_SNEAK_ATTACK_2 + 2
      normal = true
    end
  end

  if not normal and cre:GetHasFeat(FEAT_SNEAK_ATTACK_1) then
    dmg.roll.dice = 1
  end

  local bg = false

  feat = cre:GetHighestFeatInRange(FEAT_BLACKGUARD_SNEAK_ATTACK_4D6,
                        FEAT_BLACKGUARD_SNEAK_ATTACK_15D6)

  if feat ~= -1 then
    local add = feat - FEAT_BLACKGUARD_SNEAK_ATTACK_4D6 + 4
    dmg.roll.dice = dmg.roll.dice + add
    bg = true
  end

  if not bg then
    feat = cre:GetHighestFeatInRange(FEAT_BLACKGUARD_SNEAK_ATTACK_1D6,
                          FEAT_BLACKGUARD_SNEAK_ATTACK_3D6)
    if feat ~= -1 then
      local add = feat - FEAT_BLACKGUARD_SNEAK_ATTACK_1D6 + 1
      dmg.roll.dice = dmg.roll.dice + add
      bg = true
    end
  end

  -- Improved Sneak Attack
  feat = cre:GetHighestFeatInRange(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1,
                        FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10)
  if feat ~= -1 then
    local add = feat - FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1 + 1
    dmg.roll.dice = dmg.roll.dice + add
    normal = true
  end
  if normal or bg then return dmg end
end

local function death_attack(modifier, cre)
  if modifier ~= ATTACK_MODIFIER_DAMAGE then return end

  local dmg = damage_roll_t()
  dmg.type = 12
  dmg.roll.sides = 6
  local death = false

  local feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_9,
                            FEAT_PRESTIGE_DEATH_ATTACK_20)
  if feat ~= -1 then
    dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_9 + 9
    death = true
  end

  if not death then
    feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_6,
                          FEAT_PRESTIGE_DEATH_ATTACK_8)

    if feat ~= -1 then
      dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_6 + 6
      death = true
    end
  end

  if not death then
    feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_DEATH_ATTACK_1,
                          FEAT_PRESTIGE_DEATH_ATTACK_5)

    if feat ~= -1 then
      dmg.roll.dice = feat - FEAT_PRESTIGE_DEATH_ATTACK_1 + 1
      death = true
    end
  end
  if death then return dmg end
end

local _SITU_MOD = {
  [0] = coupdegrace,
  sneak_attack,
  death_attack,
}

--- Situation Modifiers
-- @section

local function GetSituationModifier(situ, modifier, cre)
  if not _SITU_MOD[situation] then return end
  return _SITU_MOD[situation](modifier, cre)
end

--- Override Situation Modifier.
local function RegisterSituation(situation, func)
  _SITU_MOD[situation] = func
end

local M = require 'solstice.rules.init'
M.GetSituationModifier = GetSituationModifier
M.RegisterSituation = RegisterSituation
