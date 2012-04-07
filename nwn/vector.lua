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

require 'nwn.ctypes.vector'
local ffi = require 'ffi'

local vector_mt = {
   __add = function (a, b) return vector_t(a.x + b.x, a.y + b.y, a.z + a.z) end,
   __index = Vector
}

--- Normalizes vector
function Vector:Normalize()
   local magnitude = self:Magnitude()
   return vector_t(self.x / magnitude, self.y / magnitude, self.z / magnitude)
end

--- Calculates vector's magnitude
function Vector:Magnitude()
   return math.sqrt((self.x * self.x) + (self.y * self.y) + (self.z * self.z))
end

--- Checks if target is in line of sight.
-- @param target Any object
function Vector:LineOfSight(target)
   nwn.engine.StackPushVector(target)
   nwn.engine.StackPushVector(self)
   nwn.engine.ExecuteCommand(753, 2)
   nwn.engine.StackPopBoolean()
end

function Vector.__sub (a, b) return vector_t(a.x - b.x, a.y - b.y, a.z - a.z) end

vector_t = ffi.typeof("Vector")
vector_t = ffi.metatype(vector_t, vector_mt)

--- Converts angle to vector
function Vector.FromAngle(angle)
   nwn.engine.StackPushFloat(angle)
   nwn.engine.ExecuteCommand(144, 1)
   return nwn.engine.StackPopVector(vRetVal)
end

--- Converts vector to angle
function Vector:ToAngle()
   nwn.engine.StackPushVector(self)
   nwn.engine.ExecuteCommand(145, 1)
   return nwn.engine.StackPopFloat()
end