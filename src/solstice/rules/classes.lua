--- Rules
-- @module rules

--- Class.
-- The following functions.
-- @section class

local TDA = require 'solstice.2da'
local TLK = require 'solstice.tlk'
local _CLASS = {}
local _TIERS = {}

local _TIER2 = {}
local _TIER3 = {}

local _FEATS = {}

for i=0, TDA.Get2daRowCount("cls_atk_2") - 1 do
   _TIER2[i] = TDA.Get2daInt("cls_atk_2", "BAB", i)
end

for i=0, TDA.Get2daRowCount("cls_atk_3") - 1 do
   _TIER3[i] = TDA.Get2daInt("cls_atk_3", "BAB", i)
end

for i=0, TDA.Get2daRowCount("classes") - 1 do
   local atk = TDA.Get2daString("classes", "AttackBonusTable", i)
   if atk == 'CLS_ATK_1' then
      _TIERS[i] = 1
   elseif atk == 'CLS_ATK_2' then
      _TIERS[i] = 2
   elseif atk == 'CLS_ATK_3' then
      _TIERS[i] = 3
   else
      _TIERS[i] = 0
   end

   _FEATS[i] = TDA.Get2daString("classes", "FeatsTable", i):lower()
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

--- Determine if creature can use class abilites.
-- @param cre Creature object.
-- @param class CLASS\_TYPE\_*
-- @return boolean, class level
local function CanUseClassAbilities(cre, class)
   if not cre:GetIsValid() then return false, 0 end

   local level = cre:GetLevelByClass(class)
   local f = _CLASS[class]
   if not f then return true, level end
   local r1, r2 = f(cre, class)
   return r1, assert(r2, "CanUseClassAbilities overrides must return class level!")
end

--- Registers a class ability handler.
-- @param class CLASS\_TYPE\_*
-- @func func A function that takes a creature and
-- optionally a CLASS\_TYPE\_* argument and returns
-- a boolean indicating whether the creature can use
-- the abilities for the class and the creatures class
-- level.  NOTE: you must return both or an assertion
-- will fail.
local function SetCanUseClassAbilitiesOverride(class, func)
   _CLASS[class] = func
end

local function monk(cre, class)
   local level = cre:GetLevelByClass(class)
   if level == 0 then return false, 0 end

   local can = (cre.obj.cre_stats.cs_ac_armour_base == 0 and
                cre.obj.cre_stats.cs_ac_shield_base == 0) or
      cre:GetIsPolymorphed()

   return can, level
end

local function ranger(cre, class)
   local level = cre:GetLevelByClass(class)
   if level == 0 then return false, 0 end

   local can = (cre.obj.cre_stats.cs_ac_armour_base >= 1 and
                cre.obj.cre_stats.cs_ac_armour_base <= 3)
   return can, level
end

local function assassin(cre, class)
   local level = cre:GetLevelByClass(class)
   if level == 0 then return false, 0 end
   local can = cre.obj.cre_stats.cs_ac_armour_base == 0

   return can, level
end

SetCanUseClassAbilitiesOverride(CLASS_TYPE_MONK, monk)
SetCanUseClassAbilitiesOverride(CLASS_TYPE_ASSASSIN, assassin)
SetCanUseClassAbilitiesOverride(CLASS_TYPE_RANGER, ranger)

--- Get bonus feats for level.
-- @param cre Creature
-- @param class CLASS\_TYPE\_*
-- @param level Character level.
-- @return List of feats.
local function GetLevelBonusFeats(cre, class, level)
   local t = {}
   local s = _FEATS[class]
   if not s or #s == 0 then return t end

   for i = 0, TDA.Get2daRowCount(s) - 1 do
      if TDA.Get2daInt(s, "GrantedOnLevel", i) == level then
         table.insert(t, TDA.Get2daInt(s, "FeatIndex", i))
      end
   end

   return t
end

--- Get class name.
-- @param class CLASS\_TYPE\_*
local function GetClassName(class)
   local strref = TDA.Get2daInt('classes', 'Name', class)
   if strref == 0 then
      error("Unknown class: " .. tostring(class))
   end
   return TLK.GetString(strref)
end

--- Get number of skillpoints class gains on level up.
-- @param class CLASS\_TYPE\_*
-- @param pc PC
local function GetSkillPointsGainedOnLevelUp(class, pc)
   local sps = TDA.Get2daInt('classes', 'SkillPointBase', class)
   if pc:GetRacialType(pc) == RACIAL_TYPE_HUMAN then
      sps = sps + 1
   end
   sps = sps + pc:GetAbilityModifier(ABILITY_INTELLIGENCE, true)
   return sps > 0 and sps or 1
end

--- Get number of hitpoints class gains on level up.
-- @param class CLASS\_TYPE\_*
-- @param pc PC
local function GetHitPointsGainedOnLevelUp(class, pc)
   local hp = TDA.Get2daInt('classes', 'HitDie', class)
   if class == CLASS_TYPE_DRAGON_DISCIPLE then
      local level = pc:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) + 1
      if level >= 6 then
         return 10
      elseif level >= 4 then
         return 8
      end
   end

   return hp
end

local M = require 'solstice.rules.init'
M.CanUseClassAbilities            = CanUseClassAbilities
M.SetCanUseClassAbilitiesOverride = SetCanUseClassAbilitiesOverride
M.GetBaseAttackBonus              = GetBaseAttackBonus
M.GetLevelBonusFeats              = GetLevelBonusFeats
M.GetClassName                    = GetClassName
M.GetSkillPointsGainedOnLevelUp   = GetSkillPointsGainedOnLevelUp
M.GetHitPointsGainedOnLevelUp     = GetHitPointsGainedOnLevelUp
