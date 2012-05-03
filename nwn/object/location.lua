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

--- Get area object is in.
function Object:GetArea()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(24, 1)
   return nwn.engine.StackPopObject()
end

--- Get direction object is facing
function Object:GetFacing()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(28, 1)
   return nwn.engine.StackPopFloat()
end

--- Get object's location
function Object:GetLocation()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(213, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION)
end

--- Get object's position
function Object:GetPosition()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(27, 1)
   return nwn.engine.StackPopVector(vRetVal)
end

--- Jump object to location
-- @param loc Destination
function Object:JumpToLocation(loc)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.ExecuteCommand(313, 1)
end

--- Get is target in line of sight
-- @param target Target to check.
function Object:LineOfSight(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(752, 2)
   return nwn.engine.StackPopBoolean()
end

--- Set direction object is facing in.
function Object:SetFacing(direction)
   nwn.engine.StackPushFloat(direction)
   nwn.engine.ExecuteCommand(10, 1)
end

--- Set the poin the object is facing.
-- @param target Vector position.
function Object:SetFacingPoint(target)
   nwn.engine.StackPushVector(target)
   nwn.engine.ExecuteCommand(143, 1)
end
