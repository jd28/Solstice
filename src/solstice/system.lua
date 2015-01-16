--- System module.
-- Exported globally as System

local M = require 'solstice.system.init'
require 'solstice.system.logging'
require 'solstice.system.database'

--- Run Lua garbage collector.
-- @return The amount in KB freed.
function M.CollectGarbage()
   local before = collectgarbage("count")
   collectgarbage()
   return before - collectgarbage("count")
end

local Log = M.GetLogger()
function M.LogGlobalTable()
   for k, v in pairs(_G) do
      local m = string.format("Key: %s, Value: %s\n", tostring(k), tostring(v))
      Log:info(m)
   end
end

return M
