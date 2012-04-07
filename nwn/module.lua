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

require "nwn.engine"
require 'nwn.ctypes.module'
require "nwn.module.settings"
local ffi = require 'ffi'

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

---
function Module:GetName()
   nwn.engine.ExecuteCommand(561, 0)
   return StackPopString()
end

---
function Module:GetStartingLocation()
   nwn.engine.ExecuteCommand(411, 0)
   return StackPopEngineStructure(ENGINE_STRUCTURE_LOCATION)
end


















