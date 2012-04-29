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

function NSGetIsDead(obj)
   obj = _NL_GET_CACHED_OBJECT(obj)
   return obj:GetIsDead()
end

---
function Object:GetCommandable()
   nwn.engine.StackPushObject(self);
   nwn.engine.ExecuteCommand(163, 1);
   return nwn.engine.StackPopBoolean();
end

--- Determines if a creature is dead or dying.
function Object:GetIsDead()
   if not self:GetIsValid() then
      return true
   end

   local hp = self:GetCurrentHitPoints()
   if self.type == nwn.GAME_OBJECT_TYPE_CREATURE 
      and (self:GetIsPC() or self:GetIsPossessedFamiliar())
   then
      if hp <= NS_SETTINGS.NS_OPT_HP_LIMIT then
         return true
      end
   else
      if hp <= 0 then
         return true
      end
   end

   return false
end

function NSGetIsPCDying(obj)
   obj = _NL_GET_CACHED_OBJECT(obj)
   return obj:GetIsPCDying()
end

--- Determines if a creature is dead or dying.
function Object:GetIsPCDying()
   if not self:GetIsValid() 
      or self.type ~= nwn.GAME_OBJECT_TYPE_CREATURE 
      or not self:GetIsPC()
      or not self:GetIsPossessedFamiliar()
   then
      return false
   end

   local hp = self:GetCurrentHitPoints()
   if hp <= 0 and hp > NS_SETTINGS.NS_OPT_HP_LIMIT then
      return true
   end

   return false
end

---
function Object:SetCommandable(commandable)
   nwn.engine.StackPushObject(self);
   nwn.engine.StackPushBoolean(commandable);
   nwn.engine.ExecuteCommand(162, 2);
end
