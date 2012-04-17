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

--- Determines if a creature is dead or dying.
function Creature:GetIsDead()
   ne.StackPushObject(self)
   ne.ExecuteCommand(140, 1)
   return ne.StackPopBoolean()
end

function Creature:GetIsFlanked(target)
   if not target:GetIsValid() then return false end
   return C.nwn_GetFlanked(self.obj, target.obj)
end

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