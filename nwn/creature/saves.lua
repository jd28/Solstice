require 'nwn.effects'

local ffi = require 'ffi'

function Creature:DebugSaves()
   return ""
end

--- Gets creatures saving throw bonus
-- @param save nwn.SAVING_THROW_*
function Creature:GetSavingThrowBonus(save)
   if not self:GetIsValid() then return 0 end

   local bonus = 0

   if save == nwn.SAVING_THROW_FORT then
      bonus = self.stats.cs_save_fort
   elseif save == nwn.SAVING_THROW_REFLEX then
      bonus = stats.cs_save_reflex
   elseif save == nwn.SAVING_THROW_WILL then
      bonus = stats.cs_save_will
   end

   return bonus
end

--- Sets creatures saving throw bonus
-- @param save nwn.SAVING_THROW_*
-- @param bonus New saving throw bonus
function Creature:SetSavingThrowBonus(save, bonus)
   if not self:GetIsValid() then return 0 end

   if save == nwn.SAVING_THROW_FORT then
      self.stats.cs_save_fort = bonus
   elseif save == nwn.SAVING_THROW_REFLEX then
      stats.cs_save_reflex = bonus
   elseif save == nwn.SAVING_THROW_WILL then
      stats.cs_save_will = bonus
   end

   return bonus
end

