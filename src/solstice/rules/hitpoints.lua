--- Rules
-- @module rules

--- Hitpoints.
-- The following functions.
-- @section hp

--- Determine Maximum Hitpoints.
-- @param cre Creature
local function GetMaxHitPoints(cre)
   if cre.ta_clone then
      return cre.obj.obj.obj_hp_max
   end
   local res = 0
   local not_pc = cre:GetIsAI()
   local level = cre:GetHitDice()
   if cre:GetHasFeat(FEAT_TOUGHNESS) then
      res = res + level
   end

   res = res + math.max(0, cre:GetAbilityModifier(ABILITY_CONSTITUTION) * level)

   local pm = cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER)
   local pmhp = 0
   if pm >= 5 then
      if pm >= 25 then
         pmhp = 18 + (math.floor(pm / 5) * 20)
      elseif pm >= 15 then
         pmhp = 18 + (math.floor(pm / 5) * 10)
      elseif pm >= 10 then
         pmhp = 18 + math.floor((pm - 10) / 5)
      else
         pmhp = pm * 3
      end
   end
   res = res + pmhp


   local epictough = cre:GetHighestFeatInRange(FEAT_EPIC_TOUGHNESS_1, FEAT_EPIC_TOUGHNESS_10)
   if epictough ~= -1 then
      local et = 20 * (epictough - FEAT_EPIC_TOUGHNESS_1 + 1)
      res = res + et
   end

   if not_pc then
      res = res + cre.obj.obj.obj_hp_max
   else
      local base = 0
      for i = 1, cre:GetHitDice() do
         base = base + cre:GetMaxHitPointsByLevel(i)
      end
      res = res + base
      cre.obj.obj.obj_hp_max = res
   end

   if res <= 0 then res = 1 end

   return res
end

local M = require 'solstice.rules.init'
M.GetMaxHitPoints = GetMaxHitPoints
