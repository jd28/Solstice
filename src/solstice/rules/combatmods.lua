--- Rules module
-- @module rules

local floor = math.floor
local TA = OPT.TA

local M = require 'solstice.rules.init'

--- Combat Modifiers
-- @section

--- Zeros combat modifier.
-- @param cre Creature.
-- @param mod COMBAT\_MOD\_*
local function ZeroCombatModifier(cre, mod)
   cre.ci.mods[mod].ab = 0
   cre.ci.mods[mod].ac = 0
   cre.ci.mods[mod].hp = 0
   cre.ci.mods[mod].dmg.roll.dice = 0
   cre.ci.mods[mod].dmg.roll.sides = 0
   cre.ci.mods[mod].dmg.roll.bonus = 0
   cre.ci.mods[mod].dmg.type = 12
end

local function GetAreaCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_AREA)
   local area = cre:GetArea()
   if not area:GetIsValid() then return end

   local area_type = area.obj.area_type
   local ab = 0

   if bit.band(area_type, 4) and
      not bit.band(area_type, 2) and
      not bit.band(area_type, 1) and
      cre:GetHasFeat(FEAT_NATURE_SENSE)
   then
      cre.ci.mods[COMBAT_MOD_AREA].ab = 2
   end
end

local function GetClassCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_CLASS)
   local ac = 0

   local style = TA and cre:GetLocalInt("pc_style_fighting") or 0
   local monk, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
   local wis = cre:GetAbilityModifier(ABILITY_WISDOM)

   -- Monk
   if monk then
      ac = ac + wis
      ac = ac + floor(lvl / 5)
      if style == 6 then
         ac = ac + floor(lvl / 6)
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
   if cre:GetHasFeat(FEAT_BONE_SKIN_2) then
      local pm = cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER)
      pm = floor(pm / 4)

      ac = ac + 2

      if TA and (cre:AbilityModifier(ABILITY_STRENGTH) >= 25 or
                 cre:AbilityModifier(ABILITY_DEXTERITY) >= 25)
      then
         ac = ac + pm
      else
         ac = ac + pm * 2
      end
   end

   if TA then
      -- Ranger Wisdom
      local ranger, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_RANGER);
      if not monk and ranger then
         if wis <= 20 then
            ac = ac + math.clamp(wis, 0, floor(lvl / 2))
         elseif lvl > 20 then
            ac = ac + math.min(wis, lvl)
         end
      end

      -- Fighter Discipline
      if cre:GetIsPC() and
         cre:GetLevelByClass(CLASS_TYPE_FIGHTER) >= 30 and
         (cre:GetAbilityModifier(ABILITY_STRENGTH) >= 30 or
          style == 1)
      then
         ab = floor(cre:GetSkillRank(SKILL_DISCIPLINE, OBJECT_INVALID) / 5)
      end

      -- Assassin
      if style == 9 and not monk then
         ac = ac + cre:GetAbilityModifier(ABILITY_INTELLIGENCE)
      end
   end

   cre.ci.mods[COMBAT_MOD_CLASS].ac = ac
end

local function GetFeatCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_FEAT)
   local ab, ac = 0, 0

   if cre:GetHasFeat(FEAT_EPIC_PROWESS) then
      ab = ab + 1
   end

   if cre:GetHasFeat(FEAT_EPIC_ARMOR_SKIN) then
      ac = ac + 2
   end

   cre.ci.mods[COMBAT_MOD_FEAT].ab = ab
   cre.ci.mods[COMBAT_MOD_FEAT].ac = ac
end

local function GetRaceCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_RACE)
end

local function GetSizeCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_SIZE)
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

   cre.ci.mods[COMBAT_MOD_SIZE].ab = ab
   cre.ci.mods[COMBAT_MOD_SIZE].ac = ac
end

local function GetSkillCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_SKILL)
   local ac = cre:GetSkillRank(SKILL_TUMBLE, OBJECT_INVALID, true) / 5
   local ab = 0

   if TA then
      -- TODO modifiy tumble by PM and Rdd...
      ac = ac + cre:GetSkillRank(SKILL_CRAFT_ARMOR, OBJECT_INVALID) / 40
      local rh = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      if rh:GetIsValid() then
         ab = cre:GetSkillRank(SKILL_CRAFT_WEAPON, OBJECT_INVALID) / 40
      end
   end
   cre.ci.mods[COMBAT_MOD_SKILL].ab = math.floor(ab)
   cre.ci.mods[COMBAT_MOD_SKILL].ac = math.floor(ab)
end

local function GetTrainingVsCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_TRAINING_VS)
   if cre.ci.training_vs_mask == 0 then return end
   cre.ci.mods[COMBAT_MOD_TRAINING_VS].ab = 1
   cre.ci.mods[COMBAT_MOD_TRAINING_VS].ac = 4
end

local function GetFavoredEnemyCombatModifier(cre)
   ZeroCombatModifier(cre, COMBAT_MOD_FAVORED_ENEMY)
   if cre.ci.fe_mask == 0 then return end

   local r = cre:GetLevelByClass(CLASS_TYPE_RANGER)
   if r == 0 then return end

   local bonus = 1 + math.floor(r / 5)
   cre.ci.mods[COMBAT_MOD_FAVORED_ENEMY].ab = bonus
   cre.ci.mods[COMBAT_MOD_FAVORED_ENEMY].dmg.roll.bonus = bonus
end

local _COMBAT_MOD = {
   [0] = GetAreaCombatModifier,
   GetClassCombatModifier,
   GetFeatCombatModifier,
   GetRaceCombatModifier,
   GetSizeCombatModifier,
   GetSkillCombatModifier,
   GetTrainingVsCombatModifier,
   GetFavoredEnemyCombatModifier
}

--- Resolves combat modifier.
-- @param type COMBAT\_MOD\_*
-- @param cre Creature object.
local function ResolveCombatModifier(type, cre)
   local f = _COMBAT_MOD[type]
   if f then f(cre) else error "Invalid combat mod function" end
end

--- Sets combat modifier override.
-- @param type COMBAT\_MOD\_*
-- @param func (creature) -> nil
local function SetCombatModifierOverride(type, func)
   _COMBAT_MOD[type] = func
end

--- Resolves all combat modifiers
-- @param cre Creature object
local function ResolveCombatModifiers(cre)
   for i=0, COMBAT_MOD_NUM - 1 do
      ResolveCombatModifier(i, cre)
   end
end

-- Exports.
M.ResolveCombatModifiers       = ResolveCombatModifiers
M.ResolveCombatModifier        = ResolveCombatModifier
M.SetCombatModifierOverride    = SetCombatModifierOverride
M.ZeroCombatModifier           = ZeroCombatModifier
