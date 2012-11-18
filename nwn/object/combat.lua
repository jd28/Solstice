local ffi = require 'ffi'
local C = ffi.C

---
function Object:DoDamage(amount)
   print("Object:DoDamage")
   return C.nwn_DoDamage(self.obj.obj, self.type, amount)
end

---
function Object:GetHardness()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(796, 1)
   return nwn.engine.StackPopInteger()
end

--- Determine who last attacked a creature, door or placeable object.
function Object:GetLastAttacker()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_attacker
   
   return _NL_GET_CACHED_OBJECT(actor)
end

--- Get the object which last damaged a creature or placeable object.
function Object:GetLastDamager()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local actor = self.obj.obj.obj_last_damager
   
   return _NL_GET_CACHED_OBJECT(actor)
end

function Object:GetKiller()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end

   local actor = self.obj.obj.obj_killer
   return _NL_GET_CACHED_OBJECT(actor)
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