--- Module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module module

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Obj = require 'solstice.object'

local M = {}

M.Module = inheritsFrom(Obj.Object, "solstice.module.Module" )

--- Internal ctype.
M.module_t = ffi.metatype("Module", { __index = Module })

--- Class Module
-- @section

--- Area iterator
function M.Module:Areas()
   local i, _i = 0
   return function ()
      while i < self.obj.mod_areas_len do
         _i, i = i, i + 1
         return _SOL_GET_CACHED_OBJECT(self.obj.mod_areas[_i])
      end
   end
end

--- Get module name
function M.Module:GetName()
   NWE.ExecuteCommand(561, 0)
   return NWE.StackPopString()
end

--- Get module starting location
function M.Module:GetStartingLocation()
   NWE.ExecuteCommand(411, 0)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_LOCATION)
end

--- Get game difficulty
function M.Module:GetGameDifficulty()
   NWE.ExecuteCommand(513, 0);
   return NWE.StackPopInteger();
end

--- Sets max number of henchmen
function M.Module:GetMaxHenchmen()
   NWE.ExecuteCommand(747, 0);
   return NWE.StackPopInteger();
end

--- Sets max number of henchmen
-- @param max Max henchment
function M.Module:SetMaxHenchmen(max)
   NWE.StackPushInteger(max);
   NWE.ExecuteCommand(746, 1);
end

--- Sets XP scale
-- @param scale New XP scale.
function M.Module:SetModuleXPScale(scale)
   NWE.StackPushInteger(scale);
   NWE.ExecuteCommand(818, 1);
end

return M
