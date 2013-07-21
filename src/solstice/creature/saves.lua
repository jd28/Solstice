--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'
   
--- Saves
-- @section

require 'solstice.effect'

local ffi = require 'ffi'
local Save = require 'solstice.save'

function M.Creature:DebugSaves()
   return ""
end

--- Gets creatures saving throw bonus
-- @param save solstice.save constant
function M.Creature:GetSavingThrowBonus(save)
   if not self:GetIsValid() then return 0 end

   local bonus = 0

   if save == Save.FORT then
      bonus = self.stats.cs_save_fort
   elseif save == Save.REFLEX then
      bonus = stats.cs_save_reflex
   elseif save == Save.WILL then
      bonus = stats.cs_save_will
   end

   return bonus
end

--- Sets creatures saving throw bonus
-- @param save solstice.save type 
-- @param bonus New saving throw bonus
function M.Creature:SetSavingThrowBonus(save, bonus)
   if not self:GetIsValid() then return 0 end

   if save == Save.FORT then
      self.stats.cs_save_fort = bonus
   elseif save == Save.REFLEX then
      stats.cs_save_reflex = bonus
   elseif save == Save.WILL then
      stats.cs_save_will = bonus
   end

   return bonus
end
