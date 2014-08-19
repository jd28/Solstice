--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

--- Hitpoints
-- @section hitpoints

require 'solstice.nwn.funcs'

--- Get max hit points by level
-- @param level The level in question.
function M.Creature:GetMaxHitPointsByLevel(level)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   return ls.ls_hp
end

--- Set max hitpoints by level.
-- @param level The level in question.
-- @param hp Amount of hitpoints.
function M.Creature:SetMaxHitPointsByLevel(level, hp)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   ls.ls_hp = hp

   return ls.ls_hp
end

--- Get cretures maximum hit points.
function M.Creature:GetMaxHitPoints()
   self.ci.defense.hp_max = Rules.GetMaxHitPoints(self)
   return self.ci.defense.hp_max + self.ci.defense.hp_eff
end

function NWNXSolstice_GetMaxHitpoints(id)
   local cre = _SOL_GET_CACHED_OBJECT(id)
   if not cre:GetIsValid() then return 0 end
   return cre:GetMaxHitPoints()
end
