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

require 'nwn.ctypes.placeable'
local ffi = require 'ffi'

ffi.cdef [[
typedef struct Placeable {
    uint32_t        type;
    uint32_t        id;
    CNWSPlaceable   *obj;
} Placeable;
]]

local placeable_mt = { __index = Placeable }
placeable_t = ffi.metatype("Placeable", placeable_mt)

--- Make placeable do an action
-- @param action Action to do.
function Placeable:DoAction(action)
   nwn.engine.StackPushInteger(action)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(547, 2)
end

--- Get if an action is possible
-- @param action Action type
function Placeable:GetIsActionPossible(action)
   nwn.engine.StackPushInteger(action)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(546, 2)
   return nwn.engine.StackPopBoolean()
end

--- Get if a placeable is static.
function Placeable:GetIsStatic()
   if not self:GetIsValid() then return false end

   return self.obj.plc_static == 1
end

--- Get placeable illumination
function Placeable:GetIllumination()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(545, 1)
   return nwn.engine.StackPopInteger()
end

--- Get if a creature is sitting on placeable.
function Placeable:GetSittingCreature()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(210, 1)
   return nwn.engine.StackPopObject()
end

--- Get if placeable is useable
function Placeable:GetUseable()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(587, 1)
   return nwn.engine.StackPopBoolean()
end

--- Set placeable appearance.
-- @param value See placeables.2da
function Placeable:SetAppearance(value)
   if not self:GetIsValid() or value < 0 then return end

   self.obj.plc_appearance = value
   return self.obj.plc_appearance
end

--- Set placeable illumination
-- @param illuminate If true turn on placeables illumination
function Placeable:SetIllumination(illuminate)
   nwn.engine.StackPushBoolean(illuminate)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(544, 2)
end

--- Set placeable useable
-- @param useable If true placeable is useable
function Placeable:SetUseable(useable)
   nwn.engine.StackPushBoolean(useable)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(835, 2)
end