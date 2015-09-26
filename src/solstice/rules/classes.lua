--- Rules
-- @module rules

--- Class.
-- The following functions.
-- @section class

local _CLASS = {}
local _FEATS = {}


for i=0, Game.Get2daRowCount("classes") - 1 do
   _FEATS[i] = Game.Get2daString("classes", "FeatsTable", i):lower()
end

--- Determine if creature can use class abilites.
-- @param cre Creature object.
-- @param class CLASS_TYPE_*
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
-- @param class CLASS_TYPE_*
-- @func func A function that takes a creature and
-- optionally a CLASS_TYPE_* argument and returns
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

   if not cre:GetIsPolymorphed() then
      local chest = cre:GetItemInSlot(INVENTORY_SLOT_CHEST)
      if chest:GetIsValid() and chest:ComputeArmorClass() > 0 then
         return false, level
      end

      local shield = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
      if shield:GetIsValid() and
         (shield:GetBaseType() == BASE_ITEM_SMALLSHIELD
          or shield:GetBaseType() == BASE_ITEM_LARGESHIELD
          or shield:GetBaseType() == BASE_ITEM_TOWERSHIELD)
      then
         return false, level
      end
   end

   return true, level
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
   local can = cre.obj.cre_stats.cs_ac_armour_base > 0

   return can, level
end

SetCanUseClassAbilitiesOverride(CLASS_TYPE_MONK, monk)
SetCanUseClassAbilitiesOverride(CLASS_TYPE_ASSASSIN, assassin)
SetCanUseClassAbilitiesOverride(CLASS_TYPE_RANGER, ranger)

--- Get bonus feats for level.
-- @param cre Creature
-- @param class CLASS_TYPE_*
-- @param level Character level.
-- @return List of feats.
local function GetLevelBonusFeats(cre, class, level)
   local t = {}
   local s = _FEATS[class]
   if not s or #s == 0 then return t end

   for i = 0, Game.Get2daRowCount(s) - 1 do
      if Game.Get2daInt(s, "GrantedOnLevel", i) == level then
         table.insert(t, Game.Get2daInt(s, "FeatIndex", i))
      end
   end

   return t
end

--- Get class name.
-- @param class CLASS_TYPE_*
local function GetClassName(class)
   local strref = Game.Get2daInt('classes', 'Name', class)
   if strref == 0 then
      error("Unknown class: " .. tostring(class))
   end
   return Game.GetTlkString(strref)
end

--- Get number of skillpoints class gains on level up.
-- @param class CLASS_TYPE_*
-- @param pc PC
local function GetSkillPointsGainedOnLevelUp(class, pc)
   local sps = Game.Get2daInt('classes', 'SkillPointBase', class)
   if pc:GetRacialType(pc) == RACIAL_TYPE_HUMAN then
      sps = sps + 1
   end
   sps = sps + pc:GetAbilityModifier(ABILITY_INTELLIGENCE, true)
   return sps > 0 and sps or 1
end

--- Get number of hitpoints class gains on level up.
-- @param class CLASS_TYPE_*
-- @param pc PC
local function GetHitPointsGainedOnLevelUp(class, pc)
   local hp = Game.Get2daInt('classes', 'HitDie', class)
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
