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

---
function Object:GetHardness()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(796, 1)
   return nwn.engine.StackPopInteger()
end

--- Determine who last attacked a creature, door or placeable object.
function Object:GetLastAttacker()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(36, 1)
   return nwn.engine.StackPopObject()
end

--- Get the object which last damaged a creature or placeable object.
function Object:GetLastDamager()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(346, 1)
   nwn.engine.StackPopObject()
end

--- Gets the last living, non plot creature that performed a
-- hostile act against the object.
function Object:GetLastHostileActor()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor
   
   return _NL_GET_CACHED_OBJECT(actor)
end

---
function Object:SetHardness(hardness)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(hardness)
   nwn.engine.ExecuteCommand(797, 2)
end

--- Sets the last hostile actor
-- Source: nwnx_funcs by Acaos
function Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end
   
   self.obj.obj.obj_last_hostile_actor = actor.id
end