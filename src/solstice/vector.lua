--- Vector
-- Defines the `Vector` class.
-- @module vector

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = {}
local Vector = {}
M.Vector = Vector

-- Internal ctype.
M.vector_t = ffi.metatype("Vector", vector_mt)

local vector_mt = {
   __add = function (a, b) return M.vector_t(a.x + b.x,
					     a.y + b.y,
					     a.z + a.z) end,
   __index = M.Vector,
   __sub = function (a, b) return M.vector_t(a.x - b.x,
					     a.y - b.y,
					     a.z - a.z) end
}

--- Normalizes vector
function Vector:Normalize()
   local magnitude = self:Magnitude()
   return M.vector_t(self.x / magnitude, self.y / magnitude, self.z / magnitude)
end

--- Calculates vector's magnitude
function Vector:Magnitude()
   return math.sqrt((self.x * self.x) + (self.y * self.y) + (self.z * self.z))
end

--- Checks if target is in line of sight.
-- @param target Any object
function Vector:LineOfSight(target)
   NWE.StackPushVector(target)
   NWE.StackPushVector(self)
   NWE.ExecuteCommand(753, 2)
   NWE.StackPopBoolean()
end

--- Converts angle to vector
function Vector.FromAngle(angle)
   NWE.StackPushFloat(angle)
   NWE.ExecuteCommand(144, 1)
   return NWE.StackPopVector()
end

--- Converts a string to a Vector
-- Format: "<x>, <y>, <z>"
function Vector.FromString(str)
   local x, y, z = string.match(str, "%(([%d%.]+), ([%d%.]+), ([%d%.]+)%)")
   return M.vector_t(x, y, z)
end

--- Converts vector to angle
function Vector:ToAngle()
   NWE.StackPushVector(self)
   NWE.ExecuteCommand(145, 1)
   return NWE.StackPopFloat()
end

--- Converts Vector to string
function Vector:ToString()
   return string.format("(%.4f, %.4f, %.4f)", self.x, self.y, self.z)
end

return M
