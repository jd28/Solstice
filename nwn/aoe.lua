--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.ctypes.aoe'

--- An iterator over all objects in an AoE
-- @param object_mask nwn.OBJECT_TYPE_* (Default: OBJECT_TYPE_CREATURE)
-- @param persistent_zone nwn.PERSISTENT_ZONE_ACTIVE. [This could also
--     take the value nwn.PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
--     (Default: nwn.PERSISTENT_ZONE_ACTIVE) 
-- @return All objects satisfying the object mask.
function AoE:ObjectsInEffect(object_mask, persistent_zone)
   return function ()
      local obj, _obj = self:GetFirstInPersistentObject(object_mask, persistent_zone)
      while obj:GetIsValid() do
         _obj, obj = obj, self:GetNextInPersistentObject(object_mask, persistent_zone)
         return _obj
      end
   end
end

--- Gets the first object in an AoE
-- @param object_mask nwn.OBJECT_TYPE_* (Default: OBJECT_TYPE_CREATURE)
-- @param persistent_zone nwn.PERSISTENT_ZONE_ACTIVE. [This could also
--    take the value nwn.PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
--    (Default: nwn.PERSISTENT_ZONE_ACTIVE) 
-- @return First object in AoE
function AoE:GetFirstInPersistentObject(object_mask, persistent_zone)
   object_mask = object_mask or nwn.OBJECT_TYPE_CREATURE
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
--     take the value nwn.PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
--     (Default: nwn.PERSISTENT_ZONE_ACTIVE) 
-- @return Next object in AoE and finally nwn.OBJECT_INVALID
function AoE:GetNextInPersistentObject(object_mask, persistent_zone)
   object_mask = object_mask or nwn.OBJECT_TYPE_CREATURE
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
   if not self:GetIsValid() then
      return nwn.OBJECT_INVALID
   end
   return _NL_GET_CACHED_OBJECT(self.obj.aoe_creator)
end

---
function AoE:SetSpellDC(dc)
   if not self:GetIsValid() then return -1 end
   
   self.obj.aoe_spell_dc = dc
   return self.obj.aoe_spell_dc
end

---
function AoE:SetSpellLevel(level)
   if not self:GetIsValid() then return -1 end
   
   self.obj.aoe_spell_level = level
   return self.obj.aoe_spell_level
end
