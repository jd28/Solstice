--- Rules module
-- @module rules

local floor = math.floor
local TA = OPT.TA

local M = require 'solstice.rules.init'

--- Combat Modifiers
-- @section

local function GetAreaCombatModifier(modifier, cre)
  local area = cre:GetArea()
  if not area:GetIsValid() then return end

  local area_type = area.obj.area_type

  if modifier == ATTACK_MODIFIER_AB
    and bit.band(area_type, 4)
    and not bit.band(area_type, 2)
    and not bit.band(area_type, 1)
    and cre:GetHasFeat(FEAT_NATURE_SENSE)
  then
    return 2
  end
end

local function GetClassCombatModifier(modifier, cre)
  local ac = 0

  local style = TA and cre:GetLocalInt("pc_style_fighting") or 0
  local monk, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)

  if modifier == ATTACK_MODIFIER_AC then
    local monk_ac, ass_ac, ranger_ac = 0, 0, 0
    local wis = cre:GetAbilityModifier(ABILITY_WISDOM)

    -- Monk
    if monk then
      monk_ac = wis
      monk_ac = monk_ac + floor(lvl / 5)
      if style == 6 then
        monk_ac = monk_ac + floor(lvl / 6)
      end
    end

    -- RDD
    if cre:GetHasFeat(FEAT_DRAGON_ARMOR) then
      local rdd = cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE)
      if rdd == 1 or rdd == 2 or rdd == 3 or rdd == 4 then
        ac = ac + 1
      elseif rdd == 5 or rdd == 6 or rdd == 7 then
        ac = ac + 2
      elseif rdd == 5 or rdd == 6 then
        ac = ac + 3
      else
        ac = ac + 4 + floor((rdd - 10) / 5)
      end
    end

    -- Palemaster
    local pm = cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER)
    if pm > 0 then
      pm = floor(pm / 4)
      ac = ac + 2
      if TA and (cre:GetAbilityModifier(ABILITY_STRENGTH) >= 25 or
              cre:GetAbilityModifier(ABILITY_DEXTERITY) >= 25)
      then
        ac = ac + pm
      else
        ac = ac + pm * 2
      end
    end

    if TA then
      -- Ranger Wisdom
      local ranger, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_RANGER)
      if not monk and ranger then
        if wis <= 20 then
          ranger_ac = math.clamp(wis, 0, floor(lvl / 2))
        elseif lvl > 20 then
          ranger_ac = math.min(wis, lvl)
        end
      end

      -- Fighter Discipline
      if cre:GetIsPC() and
        cre:GetLevelByClass(CLASS_TYPE_FIGHTER) >= 30 and
        (cre:GetAbilityScore(ABILITY_STRENGTH, true) >= 30 or
         style == 1)
      then
        ac = ac + floor(cre:GetSkillRank(SKILL_DISCIPLINE, OBJECT_INVALID, true) / 5)
      end
      -- Assassin
      local ass, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_ASSASSIN)
      if ass and lvl >= 5 then
        ass_ac = cre:GetAbilityModifier(ABILITY_INTELLIGENCE)
      end
    end
    return ac + math.max(monk_ac, ass_ac, ranger_ac)
  end
  if modifier == ATTACK_MODIFIER_AB and TA then
    local rogue = cre:GetLevelByClass(CLASS_TYPE_ROGUE)
    if rogue >= 25 and cre:GetHasFeat(FEAT_OPPORTUNIST) then
      local int = cre:GetAbilityModifier(ABILITY_INTELLIGENCE)
      if int > 0 then
        local cap = 1
        if rogue >= 40 then
          cap = 5
        elseif rogue >= 35 then
          cap = 4
        elseif rogue >= 30 then
          cap = 3
        end
        return math.min(cap, int)
      end
    end
  end
end

local function GetFeatCombatModifier(modifier, cre)
  local ab, ac = 0, 0

  if modifier == ATTACK_MODIFIER_AC then
    if cre:GetHasFeat(FEAT_EPIC_ARMOR_SKIN) then
      ac = ac + 2
    end
    return ac
  elseif modifier == ATTACK_MODIFIER_AB then
    if cre:GetHasFeat(FEAT_EPIC_PROWESS) then
      ab = ab + 1
    end
    return ab
  end
end

local function GetRaceCombatModifier(modifier, cre)
end

local function GetSizeCombatModifier(modifier, cre)
  local size = cre:GetSize()
  local ac, ab = 0, 0

  if size == CREATURE_SIZE_TINY then
    ac, ab = 2, 2
  elseif size == CREATURE_SIZE_SMALL then
    ac, ab = 1, 1
  elseif size == CREATURE_SIZE_LARGE then
    ac, ab = -1, -1
  elseif size == CREATURE_SIZE_HUGE then
    ac, ab = -2, -2
  end

  if modifier == ATTACK_MODIFIER_AC then
    return ac
  elseif modifier == ATTACK_MODIFIER_AB then
    return ab
  end
end

local function GetSkillCombatModifier(modifier, cre)
  if modifier == ATTACK_MODIFIER_AC then
    return math.floor(cre:GetSkillRank(SKILL_TUMBLE, OBJECT_INVALID, true) / 5)
  end
end

local function GetTrainingVsCombatModifier(modifier, cre)
  if not cre.sol_training_vs_mask
    or cre.sol_training_vs_mask == 0
  then
    return
  end

  if modifier == ATTACK_MODIFIER_AB then
    return 1
  elseif modifier == ATTACK_MODIFIER_DAMAGE then
    return 4
  end
end

local function GetFavoredEnemyCombatModifier(modifier, cre)
  if not cre.sol_fe_mask
    or cre.sol_fe_mask == 0
  then
    return
  end

  local r = cre:GetLevelByClass(CLASS_TYPE_RANGER)
  if r == 0 then return end

  local bonus = 1 + math.floor(r / 5)

  if modifier == ATTACK_MODIFIER_AB then
    if cre:GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES) then
      return bonus + 2
    end
    return bonus
  elseif modifier == ATTACK_MODIFIER_DAMAGE then
    local dmg = damage_roll_t()
    dmg.type = 12
    dmg.roll.bonus = bonus
    if cre:GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES) then
      dmg.roll.dice = 2
      dmg.roll.sides = 6
    end
    return dmg
  end
end

local _COMBAT_MOD = {
  [0] = GetAreaCombatModifier,
  GetClassCombatModifier,
  GetFeatCombatModifier,
  GetRaceCombatModifier,
  GetSizeCombatModifier,
  GetSkillCombatModifier,
  GetTrainingVsCombatModifier,
  GetFavoredEnemyCombatModifier,
  GetAbilityCombatModifier,
}

local function GetCombatModifier(type, modifier, cre)
  if not _COMBAT_MOD[type] then return end
end

--- Sets combat modifier override.
local function RegisterComabtModifier(type, func)
  _COMBAT_MOD[type] = func
end

-- Exports.
M.RegisterComabtModifier = RegisterComabtModifier
M.GetCombatModifier = GetCombatModifier
