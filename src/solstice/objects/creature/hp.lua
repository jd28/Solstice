--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature
GetObjectByID = Game.GetObjectByID

--- Hitpoints
-- @section hitpoints

function Creature:GetMaxHitPointsByLevel(level)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   return ls.ls_hp
end

function Creature:SetMaxHitPointsByLevel(level, hp)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   ls.ls_hp = hp

   return ls.ls_hp
end

function Creature:GetMaxHitPoints()
   return Rules.GetMaxHitPoints(self)
end
