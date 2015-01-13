--- Creature module
-- @module creature

local M = require 'solstice.creature.init'
local Creature = M.Creature

--- Saves
-- @section

require 'solstice.effect'

function Creature:DebugSaves()
   return ""
end

--- Gets creatures saving throw bonus
-- @param save SAVING_THROW_*
function Creature:GetSavingThrowBonus(save)
   if not self:GetIsValid() then return 0 end

   local bonus = 0

   if save == SAVING_THROW_FORT then
      bonus = self.obj.cre_stats.cs_save_fort
   elseif save == SAVING_THROW_REFLEX then
      bonus = self.obj.cre_stats.cs_save_reflex
   elseif save == SAVING_THROW_WILL then
      bonus = self.obj.cre_stats.cs_save_will
   end

   return bonus
end

--- Sets creatures saving throw bonus
-- @param save solstice.save type
-- @param bonus New saving throw bonus
function Creature:SetSavingThrowBonus(save, bonus)
   if not self:GetIsValid() then return 0 end

   if save == SAVING_THROW_FORT then
      self.obj.cre_stats.cs_save_fort = bonus
   elseif save == SAVING_THROW_REFLEX then
      self.obj.cre_stats.cs_save_reflex = bonus
   elseif save == SAVING_THROW_WILL then
      self.obj.cre_stats.cs_save_will = bonus
   end

   return bonus
end
