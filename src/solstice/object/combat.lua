--- Object
-- @module object

local M = require 'solstice.object.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'

--- Class Object: Combat
-- @section

---
function M.Object:DoDamage(amount)
   print("Object:DoDamage")
   return C.nwn_DoDamage(self.obj.obj, self.type, amount)
end

--- Get an objects AC versus
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable AC.
-- @param attacker Whoever is attacking the object
-- @param attack Attack instance, just in case.
function M.Object:GetACVersus(attacker, attack)
   return 0
end

--- Get an objects concealment
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable concealment.
function M.Object:GetConcealment()
   return 0
end

---
function M.Object:GetHardness()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(796, 1)
   return NWE.StackPopInteger()
end

---
function M.Object:GetIsImmune(immunity)
   return false
end

--- Determine who last attacked a creature, door or placeable object.
function M.Object:GetLastAttacker()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_attacker

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Get the object which last damaged a creature or placeable object.
function M.Object:GetLastDamager()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_damager

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Gets the object's killer.
-- @return Killer or solstice.object.INVALID
function M.Object:GetKiller()
   if not self:GetIsValid() then return M.INVALID end

   local actor = self.obj.obj.obj_killer
   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Gets the last living, non plot creature that performed a
-- hostile act against the object.
-- @return Killer or OBJECT_INVALID
function M.Object:GetLastHostileActor()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor

   return _SOL_GET_CACHED_OBJECT(actor)
end

--- Set's an object's hardness.q
-- @param hardness New hardness value.
function M.Object:SetHardness(hardness)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(hardness)
   NWE.ExecuteCommand(797, 2)
end

--- Sets the last hostile actor
-- Source: nwnx_funcs by Acaos
function M.Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end

   self.obj.obj.obj_last_hostile_actor = actor.id
end

function M.Object:GetDamageReductionAdj(base_damage, damage_power, burn_eff)
   return base_damage, 0
end

function M.Object:GetDamageResistAdj(amt, dmgidx, burn_eff)
   return amt, 0
end

function M.Object:GetDamageImmunityAdj(amt, dmgidx)
   return amt, 0
end
