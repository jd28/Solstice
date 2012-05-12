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

--- Gets an object's current hitpoints
function Object:GetCurrentHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_cur
end

--- Modifies an object's current hitpoints
-- @param amount Amount to modifiy.
function Object:ModifyCurrentHitPoints(amount)
   local hp = self:GetCurrentHitPoints() + amount
   self:SetCurrentHitPoints(hp)
end

--- Sets an object's current hitpoints.
-- @param hp A number between 1 and 10000
function Object:SetCurrentHitPoints(hp)
   if not self:GetIsValid() then return -1 end
   
   if hp < 1 then hp = 1
   elseif hp > 10000 then hp = 10000
   end

   self.obj.obj.obj_hp_cur = hp
   
   return self.obj.obj.obj_hp_cur
end

--- Get object's max hitpoints
function Object:GetMaxHitPoints()
   if not self:GetIsValid() then return 0 end
   return self.obj.obj.obj_hp_max
end

--- Sets an object's max hitpoints
function Object:SetMaxHitPoints(hp)
   if not self:GetIsValid() then return -1 end
   if hp < 1 then hp = 1 end
   
   self.obj.obj.obj_hp_max = hp
   return self.obj.obj.obj_hp_max
end