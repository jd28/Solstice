--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ne = nwn.engine
local ffi = require 'ffi'
local C = ffi.C
local bit = require 'bit'

--- Check if a creature is using a given action mode
-- @param mode nwn.ACTION_MODE_*
function Creature:GetActionMode(mode)
   ne.StackPushInteger(mode)
   ne.StackPushObject(self)
   ne.ExecuteCommand(735, 2)
   return ne.StackPopBoolean()
end

--- Determines if a creature is blind.
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

--- Determines if a creature is flanked.
-- @param target Attacker
function Creature:GetIsFlanked(target)
   if not target:GetIsValid() then return false end
   return C.nwn_GetFlanked(self.obj, target.obj)
end

--- Determines if a creature is flatfooted
function Creature:GetIsFlatfooted()
   if not self:GetIsValid() then return false end
   return C.nwn_GetFlatFooted(self.obj)
end

--- Determines whether an object is in conversation.
function Creature:GetIsInConversation()
   ne.StackPushObject(self)
   ne.ExecuteCommand(445, 1)
   return ne.StackPopBoolean()
end

--- Check whether a creature is resting.
function Creature:GetIsResting()
   ne.StackPushObject(self)
   ne.ExecuteCommand(505, 1)
   return ne.StackPopBoolean()
end

--- Sets the status of an action mode on a creature
-- @param mode nwn.ACTION_MODE_*
-- @param true or false
function Creature:SetActionMode(mode, status)
   ne.StackPushBoolean(status)
   ne.StackPushInteger(mode)
   ne.StackPushObject(self)
   ne.ExecuteCommand(736, 3)
end