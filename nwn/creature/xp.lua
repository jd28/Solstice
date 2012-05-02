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

local ne = nwn.engine
local ffi = require 'ffi'

--- Gets a creatures XP
function Creature:GetXP()
   if not self:GetIsValid() then return 0 end
   return self.stats.cs_xp
end

--- Modifies a creatures XP.
-- @param amount Amount of XP to give or take.
-- @param direct If true the xp amount is set directly. (Default: false)
function Creature:ModifyXP(amount, direct)
   local cmd = 393
   if amount < 0 then
      amount = -amount
   end 

   if direct then
      self:SetXP(self:GetXP() + amount, direct)
   end
   
   ne.StackPushInteger(amount)
   ne.StackPushObject(self)
   ne.ExecuteCommand(393, 2)
end


--- Sets a creatures XP
-- @param amount Amount to set XP to
-- @param direct If true the xp amount is set directly. (Default: false)
function Creature:SetXP(amount, direct)
   if direct then
      if not self:GetIsValid() then return end
      self.stats.cs_xp = amount
   else
      ne.StackPushInteger(amount)
      ne.StackPushObject(self)
      ne.ExecuteCommand(394, 2)
   end
end



