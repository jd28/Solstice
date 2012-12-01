require 'nwn.ctypes.vector'
local ffi = require 'ffi'

local vector_mt = {
   __add = function (a, b) return vector_t(a.x + b.x, a.y + b.y, a.z + a.z) end,
   __index = Vector,
   __sub = function (a, b) return vector_t(a.x - b.x, a.y - b.y, a.z - a.z) end
}

vector_t = ffi.typeof("Vector")
vector_t = ffi.metatype(vector_t, vector_mt)

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

--- Converts angle to vector
function Vector.FromAngle(angle)
   nwn.engine.StackPushFloat(angle)
   nwn.engine.ExecuteCommand(144, 1)
   return nwn.engine.StackPopVector(vRetVal)
end

--- Converts a string to a Vector
function Vector.FromString(str)
   local x, y, z = string.match(str, "([%d%.]+), ([%d%.]+), ([%d%.]+)")
   return vector_t(x, y, z)
end

--- Converts vector to angle
function Vector:ToAngle()
   nwn.engine.StackPushVector(self)
   nwn.engine.ExecuteCommand(145, 1)
   return nwn.engine.StackPopFloat()
end

--- Converts Vector to string
function Vector:ToString()
   return string.format("(%.4f, %.4f, %.4f)", self.x, self.y, self.z)
end
