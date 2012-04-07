--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

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