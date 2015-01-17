--- Game module.
-- @module game

--- Objects
-- @section

local NWE = require 'solstice.nwn.engine'
local C = require('ffi').C
local M = require 'solstice.game.init'

--- Create an object of a specified type at a given location
-- NWScript: CreateObject
-- @param object_type OBJECT_TYPE_*
-- @param template The resref of the object to create from the pallet.
-- @param loc The location to create the object at.
-- @param[opt=false] appear If `true`, the object will play its spawn in animation.
-- @param[opt=""] newtag If this string is not empty, it will replace the default tag from the template.
-- @return New object or OBJECT_INVALID
function M.CreateObject(object_type, template, loc, appear, newtag)
   if appear == nil then appear = false end
   newtag = newtag or ""
   NWE.StackPushString(newtag)
   NWE.StackPushBoolean(appear)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.StackPushString(template)
   NWE.StackPushInteger(object_type)
   NWE.ExecuteCommand(243, 5)

   return NWE.StackPopObject()
end

local mod
--- Get Module.
function M.GetModule()
   if not mod then
      NWE.ExecuteCommandUnsafe(242, 0)
      mod = NWE.StackPopObject()
   end
   return mod
end

--- Get object by ID.
-- @param id Object ID.
-- @return An object or OBJECT_INVALID
function M.GetObjectByID(id)
   return _SOL_GET_CACHED_OBJECT(id)
end

--- Remove object from Solstice object cache.
-- @param obj Any object.
function M.RemoveObject(obj)
   _SOL_REMOVE_CACHED_OBJECT(obj.id)
   C.Local_DeleteCreature(obj.id)
end

--- Gets an object by tag
-- @param tag Tag of object
-- @param[opt=1] nth Nth object.
function M.GetObjectByTag(tag, nth)
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushString(tag)
   NWE.ExecuteCommand(200, 2)
   return NWE.StackPopObject()
end

--- Iterator over objects by tag
-- @param tag Tag of object
function M.ObjectsByTag(tag)
   local function f(n)
      return M.GetObjectByTag(tag, n+1)
   end

   return take_while(function (x) return x ~= OBJECT_INVALID end, tabulate(f))
end

-- Gets first PC.
-- @return OBJECT_INVALID if no PCs are logged into the server.
local function GetFirstPC()
   NWE.ExecuteCommand(548, 0)
   return NWE.StackPopObject()
end

-- Get next PC.
-- @return OBJECT_INVALID if there are no furter PCs.
local function GetNextPC()
   NWE.ExecuteCommand(549, 0)
   return NWE.StackPopObject()
end

--- Iterator over all PCs
function M.PCs()
   return make_iter_valid(GetFirstPC, GetNextPC)
end

--- Gets the PC speaker.
function M.GetPCSpeaker()
   NWE.ExecuteCommand(238, 0)
   return NWE.StackPopObject()
end

local function GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)
   NWE.StackPushVector(origin)
   NWE.StackPushInteger(mask)
   NWE.StackPushBoolean(line_of_sight)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, location)
   NWE.StackPushFloat(size)
   NWE.StackPushInteger(shape)

   NWE.ExecuteCommand(128, 6)

   return NWE.StackPopObject()
end

local function GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)
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
-- @param shape SHAPE_*
-- @param size The size of the shape. Dependent on shape or RADIUS_SIZE_*.
-- @param location Shapes location
-- @param[opt=false] line_of_sight This can be used to ensure that spell effects do not go through walls.
-- @param[opt=OBJECT_TYPE_CREATURE] mask Object type mask.
-- @param[opt=vector(0)] origin Normally the spell-caster's position.
function M.ObjectsInShape(shape, size, location, line_of_sight, mask, origin)
   local function first()
      return GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)
   end
   local function next()
      return GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)
   end

   return make_iter_valid(first, next)
end

--- Finds a waypiont by tag
-- @param tag Tag of waypoint.
-- @return OBJECT_INVALID if no Waypoint is found.
function M.GetWaypointByTag(tag)
   NWE.StackPushString(tag)
   return NWE.StackPopObject()
end
