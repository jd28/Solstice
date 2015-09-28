--- Game module.
-- @module game

--- Objects
-- @section

local NWE = require 'solstice.nwn.engine'
local C = require('ffi').C
local M = require 'solstice.game.init'
local ffi = require 'ffi'

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

function M.ExportSingleCharacter(player)
   M.OnPreExportCharacter:notify(player)
   NWE.StackPushObject(player)
   NWE.ExecuteCommand(719, 1)
   M.OnPostExportCharacter:notify(player)
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

function M.GetObjectByID(id)
   return _SOL_GET_CACHED_OBJECT(id)
end

function M.GetCanonicalID(cre)
   return _GET_CANONICAL_ID(cre)
end

function M.ClearCacheData(obj)
   obj.load_char_finished = 0
   obj['SOL_HP_EFF'] = 0
   M.OnObjectClearCacheData:notify(obj)
end

function M.RemoveObjectFromCache(obj)
   -- Don't remove PC's from the cahce
   if obj:GetType() == OBJECT_TYPE_CREATURE and obj:GetIsPC() then
      M.ClearCacheData(obj)
   else
      _SOL_REMOVE_CACHED_OBJECT(obj.id)
      M.OnObjectRemovedFromCache:notify(obj)
   end
end

function M.GetObjectByTag(tag, nth)
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushString(tag)
   NWE.ExecuteCommand(200, 2)
   return NWE.StackPopObject()
end

function M.ObjectsByTag(tag)
   local i = 1
   return function()
      local obj = M.GetObjectByTag(tag, i)
      if obj:GetIsValid() then
         i = i + 1
         return obj
      end
   end
end

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

function M.ObjectsInShape(shape, size, location, line_of_sight, mask, origin)
   local function first()
      return GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)
   end
   local function next()
      return GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)
   end

   return make_iter_valid(first, next)
end

function M.GetWaypointByTag(tag)
   NWE.StackPushString(tag)
   return NWE.StackPopObject()
end
