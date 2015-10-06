----
-- @module creature

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'
local Creature = M.Creature

--- State
-- @section

function Creature:GetActionMode(mode)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(735, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsBlind()
   if not self:GetIsValid() then return false end

   if bit.band(self.obj.cre_vision_type, 4) == 0
      and bit.band(self.obj.cre_vision_type, 0x20) == 0
      and (bit.band(self.obj.cre_vision_type, 0x10) ~= 0
           or (bit.band(self.obj.cre_vision_type, 0x8) ~= 0
               and bit.band(self.obj.cre_vision_type, 0x2) == 0))
   then
      return true
   end

   return false
end

function Creature:GetIsFlanked(vs)
   if not vs:GetIsValid() then return false end
   return C.nwn_GetFlanked(self.obj, vs.obj)
end

function Creature:GetIsFlatfooted()
   if not self:GetIsValid() then return false end
   return C.nwn_GetFlatFooted(self.obj)
end

function Creature:GetIsInConversation()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(445, 1)
   return NWE.StackPopBoolean()
end

--- Determine if PC is dying
-- HACK: This returns that they're dead...
function Creature:GetIsPCDying()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(140, 1);
   return NWE.StackPopBoolean();
end

function Creature:GetIsResting()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(505, 1)
   return NWE.StackPopBoolean()
end

function Creature:SetActionMode(mode, status)
   NWE.StackPushBoolean(status)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(736, 3)
end
