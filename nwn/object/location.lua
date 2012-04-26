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

---
function Object:GetArea()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(24, 1)
   return nwn.engine.StackPopObject()
end

---
function Object:GetFacing()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(28, 1)
   return nwn.engine.StackPopFloat()
end

---
function Object:GetLocation()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(213, 1)
   return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION)
end

---
function Object:GetPosition()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(27, 1)
   return nwn.engine.StackPopVector(vRetVal)
end

---
function Object:JumpToLocation(loc)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.ExecuteCommand(313, 1)
end

---
function Object:LineOfSight(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(752, 2)
   return nwn.engine.StackPopBoolean()
end

---
function Object:SetFacing(fDirection)
   nwn.engine.StackPushFloat(fDirection)
   nwn.engine.ExecuteCommand(10, 1)
end

---
function Object:SetFacingPoint(vTarget)
   nwn.engine.StackPushVector(vTarget)
   nwn.engine.ExecuteCommand(143, 1)
end
