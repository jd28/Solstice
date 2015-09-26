--- Object
-- @module object

local NWE = require 'solstice.nwn.engine'

local ffi = require 'ffi'
local C = ffi.C
local min    = math.min
local max    = math.max
local GetObjectByID = Game.GetObjectByID

local bit    = require 'bit'

local M = require 'solstice.objects.init'
local Object = M.Object

--- Class Object: Combat
-- @section

--- Do Damage to Object.
-- NOTE: Untested!!
-- Directly do damage (with no specified type or feedback) to an object.
-- @param amount amount of damage to do.
function Object:DoDamage(amount)
   return C.nwn_DoDamage(self.obj.obj, self.type, amount)
end

--- Get an objects AC versus
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable AC.
-- @param attacker Whoever is attacking the object
-- @param attack Attack instance, just in case.
function Object:GetACVersus(attacker, attack)
   return 0
end

--- Get an objects concealment
-- This is just a placeholder function, if anyone wants to hook in and give, say, a
-- placeable concealment.
function Object:GetConcealment()
   return 0
end

--- Determine object's 'hardness'
function Object:GetHardness()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(796, 1)
   return NWE.StackPopInteger()
end

--- Determines if object is immune to an effect.
-- @param immunity IMMUNITY_TYPE_*
-- @return Always `false`.
function Object:GetIsImmune(immunity)
   return false
end

--- Determine who last attacked a creature, door or placeable object.
function Object:GetLastAttacker()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_attacker

   return GetObjectByID(actor)
end

--- Get the object which last damaged a creature or placeable object.
function Object:GetLastDamager()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_damager

   return GetObjectByID(actor)
end

--- Gets the object's killer.
-- @return Killer or solstice.object.INVALID
function Object:GetKiller()
   if not self:GetIsValid() then return M.INVALID end

   local actor = self.obj.obj.obj_killer
   return GetObjectByID(actor)
end

--- Gets the last living, non plot creature that performed a
-- hostile act against the object.
-- @return Killer or OBJECT_INVALID
function Object:GetLastHostileActor()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor

   return GetObjectByID(actor)
end

--- Set's an object's hardness.q
-- @param hardness New hardness value.
function Object:SetHardness(hardness)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(hardness)
   NWE.ExecuteCommand(797, 2)
end

--- Sets the last hostile actor
-- Source: nwnx_funcs by Acaos
function Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end

   self.obj.obj.obj_last_hostile_actor = actor.id
end

--- Determine if object is invulnerable
function Object:GetIsInvulnerable()
   if not self:GetIsValid() then
      return false
   end
   return self.obj.obj.obj_is_invulnerable == 1
end
