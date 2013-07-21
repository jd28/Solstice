--- Creature
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

--- State
-- @section

--- Check if a creature is using a given action mode
-- @param mode solstice.nwn.ACTION_MODE_*
function M.Creature:GetActionMode(mode)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(735, 2)
   return NWE.StackPopBoolean()
end

--- Determines if a creature is blind.
function M.Creature:GetIsBlind()
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

--- Determines if a creature is flanked.
-- @param target Attacker
function M.Creature:GetIsFlanked(target)
   if not target:GetIsValid() then return false end
   return C.nwn_GetFlanked(self.obj, target.obj)
end

--- Determines if a creature is flatfooted
function M.Creature:GetIsFlatfooted()
   if not self:GetIsValid() then return false end
   return C.nwn_GetFlatFooted(self.obj)
end

--- Determines whether an object is in conversation.
function M.Creature:GetIsInConversation()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(445, 1)
   return NWE.StackPopBoolean()
end

--- Check whether a creature is resting.
function M.Creature:GetIsResting()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(505, 1)
   return NWE.StackPopBoolean()
end

--- Sets the status of an action mode on a creature
-- @param mode solstice.nwn.ACTION_MODE_*
-- @bool status New value.
function M.Creature:SetActionMode(mode, status)
   NWE.StackPushBoolean(status)
   NWE.StackPushInteger(mode)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(736, 3)
end