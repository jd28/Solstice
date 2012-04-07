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

require 'nwn.ctypes.aoe'

--- An iterator over all objects in an AoE
-- @param object_mask OBJECT_TYPE_* (Default: OBJECT_TYPE_CREATURE)
-- @param persistent_zone PERSISTENT_ZONE_ACTIVE. [This could also
-- take the value PERSISTENT_ZONE_FOLLOW, but this is no longer used.] (Default: PERSISTENT_ZONE_ACTIVE) 
-- @return All objects satisfying the object mask.
function AoE:ObjectsInEffect(object_mask, persistent_zone)
   local obj, _obj = self:GetFirstInPersistentObject(object_mask, persistent_zone)
   while obj:GetIsValid() do
      _obj, obj = obj, self:GetNextInPersistentObject(object_mask, persistent_zone)
      return _obj
   end
end

--- Gets the first object in an AoE
-- @param object_mask OBJECT_TYPE_* (Default: OBJECT_TYPE_CREATURE)
-- @param persistent_zone PERSISTENT_ZONE_ACTIVE. [This could also
-- take the value PERSISTENT_ZONE_FOLLOW, but this is no longer used.] (Default: PERSISTENT_ZONE_ACTIVE) 
-- @return First object in AoE
function AoE:GetFirstInPersistentObject(object_mask, persistent_zone)
   obj_type = obj_type or nwn.OBJECT_TYPE_CREATURE
   zone = zone or nwn.PERSISTENT_ZONE_ACTIVE
   
   nwn.engine.StackPushInteger(persistent_zone)
   nwn.engine.StackPushInteger(object_mask)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(262, 3)
   return nwn.engine.StackPopObject()
end

--- Gets the first object in an AoE
-- @param object_mask nwn.OBJECT_TYPE_* (Default: nwn.OBJECT_TYPE_CREATURE)
-- @param persistent_zone nwn.PERSISTENT_ZONE_ACTIVE. [This could also
-- take the value PERSISTENT_ZONE_FOLLOW, but this is no longer used.] (Default: nwn.PERSISTENT_ZONE_ACTIVE) 
-- @return Next object in AoE and finally nwn.OBJECT_INVALID
function AoE:GetNextInPersistentObject(object_mask, persistent_zone)
   obj_type = obj_type or nwn.OBJECT_TYPE_CREATURE
   zone = zone or nwn.PERSISTENT_ZONE_ACTIVE
   
   nwn.engine.StackPushInteger(persistent_zone)
   nwn.engine.StackPushInteger(object_mask)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(263, 3)
   return nwn.engine.StackPopObject()
end

--- Get's the creator of the AoE
-- @return The creator or nwn.OBJECT_INVALID.
function AoE:GetCreator()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(264, 1)
   return nwn.engine.StackPopObject()
end
