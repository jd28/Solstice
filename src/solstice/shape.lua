--- Shape
-- @module shape

local M = {}

local NWE = require 'solstice.nwn.engine'

--- Constants
-- @section


M.RADIUS_SIZE_SMALL           = 1.67
M.RADIUS_SIZE_MEDIUM          = 3.33
M.RADIUS_SIZE_LARGE           = 5.0
M.RADIUS_SIZE_HUGE            = 6.67
M.RADIUS_SIZE_GARGANTUAN      = 8.33
M.RADIUS_SIZE_COLOSSAL        = 10.0

M.SPELLCYLINDER      = 0
M.CONE               = 1
M.CUBE               = 2
M.SPELLCONE          = 3
M.SPHERE             = 4

--- Functions
-- @section

--- Gets first object in a shape
-- @param shape solstice.shape.* constant
-- @param size The size of the shape. Dependent on shape or solstice.shape.RADIUS\_SIZE\_*.
-- @param location Shapes location
-- @param[opt=false] line_of_sight This can be used to ensure that spell effects do not go through walls.
-- @func[opt] predicate A function predicate 
-- @param[opt=vector(0)] origin Normally the spell-caster's position.
function M.GetFirstObject(shape, size, location, line_of_sight, predicate, origin)
   local function pred(obj) 
      return isinstance(obj, Creature) 
   end

   origin = origin or vector_t(0, 0, 0)
   predicate = predicate or pred

   NWE.StackPushVector(origin)
   NWE.StackPushInteger(mask)
   NWE.StackPushBoolean(line_of_sight)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushFloat(size)
   NWE.StackPushInteger(shape)

   NWE.ExecuteCommand(128, 6)

   return NWE.StackPopObject()
end

--- Gets next object in a shape
-- @param shape solstice.shape constant.
-- @param size The size of the shape. Dependent on shape or solstice.shape.RADIUS\_SIZE\_*.
-- @param location Shapes location
-- @param[opt=false] line_of_sight This can be used to ensure that spell effects do not go through walls.
-- @func[opt] predicate A function predicate. Default predicate tests
-- for the object being an instance of type Creature.
-- @param[opt=vector(0)] origin Normally the spell-caster's position.
function M.GetNextObject(shape, size, location, line_of_sight, mask, origin)
   local function test(obj) return isinstance(Creature) end
   predicate = predicate or test

   origin = origin or vector_t(0, 0, 0)

   NWE.StackPushVector(origin)
   NWE.StackPushInteger(mask)
   NWE.StackPushBoolean(line_of_sight)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushFloat(size)
   NWE.StackPushInteger(shape)

   NWE.ExecuteCommand(129, 6)

   return NWE.StackPopObject()
end

--- Iterator over objects in a shape.
-- @param shape solstice.shape constant
-- @param size The size of the shape. Dependent on shape or solstice.shape.RADIUS\_SIZE\_*.
-- @param location Shapes location
-- @param[opt=false] line_of_sight This can be used to ensure that spell effects do not go through walls.
-- @func[opt] predicate A function predicate 
-- @param[opt=vector(0)] origin Normally the spell-caster's position.
function M.Objects(shape, size, location, line_of_sight, predicate, origin)
   local function test(obj) return isinstance(Creature) end
   predicate = predicate or test
   origin = origin or vector_t(0, 0, 0)

   local obj, _obj = M.GetFirstObjectInShape(shape, size, location, line_of_sight, predicate, origin)
   return function ()
      while obj and obj:GetIsValid() do
         _obj, obj = obj, M.GetNextObjectInShape(shape, size, location, line_of_sight, predicate, origin)
         return _obj
      end
   end
end

return M