--- Module
-- @module module
-- @alias M

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local GetObjectByID = Game.GetObjectByID

local M = require 'solstice.objects.init'

local Module = inheritsFrom({}, M.Object)
M.Module = Module

function Module.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_MODULE
      },
      { __index = Module })
end

--- Class Module
-- @section

--- Area iterator
function Module:Areas()
   local i, _i = 0
   return function ()
      while i < self.obj.mod_areas_len do
         _i, i = i, i + 1
         return GetObjectByID(self.obj.mod_areas[_i])
      end
   end
end

--- Get module name
function Module:GetName()
   NWE.ExecuteCommand(561, 0)
   return NWE.StackPopString()
end

--- Get module starting location
function Module:GetStartingLocation()
   NWE.ExecuteCommand(411, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

--- Get game difficulty
function Module:GetGameDifficulty()
   NWE.ExecuteCommand(513, 0);
   return NWE.StackPopInteger();
end

--- Sets max number of henchmen
function Module:GetMaxHenchmen()
   NWE.ExecuteCommand(747, 0);
   return NWE.StackPopInteger();
end

--- Sets max number of henchmen
-- @param max Max henchment
function Module:SetMaxHenchmen(max)
   NWE.StackPushInteger(max);
   NWE.ExecuteCommand(746, 1);
end

--- Sets XP scale
-- @param scale New XP scale.
function Module:SetModuleXPScale(scale)
   NWE.StackPushInteger(scale);
   NWE.ExecuteCommand(818, 1);
end
