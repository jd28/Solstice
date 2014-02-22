local C = require('ffi').C
local Log = require('solstice.log').WriteTimestampedLogEntryToNWNX
local M = {}

--- Run Lua garbage collector.
-- @return The amount in KB freed.
function M.CollectGarbage()
   local before = collectgarbage("count")
   collectgarbage()
   return before - collectgarbage("count")
end

function M.LogGlobalTable()
   for k, v in pairs(_G) do
      local m = string.format("Key: %s, Value: %s\n", tostring(k), tostring(v))
      Log(m)
   end
end

return M
