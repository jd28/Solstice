--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature
GetObjectByID = Game.GetObjectByID

--- Hitpoints
-- @section hitpoints

require 'solstice.nwn.funcs'

--- Get max hit points by level
-- @param level The level in question.
function Creature:GetMaxHitPointsByLevel(level)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   return ls.ls_hp
end

--- Set max hitpoints by level.
-- @param level The level in question.
-- @param hp Amount of hitpoints.
function Creature:SetMaxHitPointsByLevel(level, hp)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   ls.ls_hp = hp

   return ls.ls_hp
end

--- Get cretures maximum hit points.
function Creature:GetMaxHitPoints()
   self.ci.defense.hp_max = Rules.GetMaxHitPoints(self)
   return self.ci.defense.hp_max + self.ci.defense.hp_eff
end
