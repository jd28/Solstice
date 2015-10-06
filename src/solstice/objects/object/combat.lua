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

function Object:GetHardness()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(796, 1)
   return NWE.StackPopInteger()
end

function Object:GetIsImmune(immunity)
   return false
end

function Object:GetLastAttacker()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_attacker

   return GetObjectByID(actor)
end

function Object:GetLastDamager()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_damager

   return GetObjectByID(actor)
end

function Object:GetKiller()
   if not self:GetIsValid() then return M.INVALID end

   local actor = self.obj.obj.obj_killer
   return GetObjectByID(actor)
end

function Object:GetLastHostileActor()
   if not self:GetIsValid() then return M.INVALID end
   local actor = self.obj.obj.obj_last_hostile_actor

   return GetObjectByID(actor)
end

function Object:SetHardness(hardness)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(hardness)
   NWE.ExecuteCommand(797, 2)
end

function Object:SetLastHostileActor(actor)
   if not self:GetIsValid() or not actor:GetIsValid() then return end

   self.obj.obj.obj_last_hostile_actor = actor.id
end

function Object:GetIsInvulnerable()
   if not self:GetIsValid() then
      return false
   end
   return self.obj.obj.obj_is_invulnerable == 1
end
