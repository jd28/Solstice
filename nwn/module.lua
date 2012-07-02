require "nwn.engine"
require 'nwn.ctypes.module'
require "nwn.module.settings"
local ffi = require 'ffi'

local ExecuteCommand = nwn.engine.ExecuteCommand
local StackPopEngineStructure = nwn.engine.StackPopEngineStructure
local StackPopString = nwn.engine.StackPopString


ffi.cdef [[
typedef struct Module {
    uint32_t        type;
    uint32_t        id;
    CNWSModule     *obj;
} Module;
]]

local module_mt = { __index = Module }
module_t = ffi.metatype("Module", module_mt)

--- Area iterator
function Module:Areas()
   local i, _i = 0
   return function () 
      while i < self.obj.mod_areas_len do
         _i, i = i, i + 1
         return _NL_GET_CACHED_OBJECT(self.obj.mod_areas[_i])
      end
   end
end

--- Get module name
function Module:GetName()
   ExecuteCommand(561, 0)
   return StackPopString()
end

--- Get module starting location
function Module:GetStartingLocation()
   ExecuteCommand(411, 0)
   return StackPopEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION)
end


















