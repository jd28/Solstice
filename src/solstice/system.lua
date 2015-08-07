--- System module.
-- Exported globally as System

local M = require 'solstice.system.init'
require 'solstice.system.logging'
safe_require 'solstice.system.campaigndb'
require 'solstice.system.database'

--- Run Lua garbage collector.
-- @return The amount in KB freed.
function M.CollectGarbage()
   local before = collectgarbage("count")
   collectgarbage()
   return before - collectgarbage("count")
end

function M.LogGlobalTable()
   local Log = M.GetLogger()
   for k, v in pairs(_G) do
      local m = string.format("Key: %s, Value: %s\n", tostring(k), tostring(v))
      Log:info(m)
   end
end

return M
