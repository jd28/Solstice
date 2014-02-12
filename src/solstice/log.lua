--- Logging
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module log

safe_require 'solstice.nwn.engine'

local NWE = require 'solstice.nwn.engine'
local fmt = string.format
local ffi = require 'ffi'
local C   = ffi.C

local M = {}

--- Write string to NWN server log file
function M.WriteTimestampedLogEntry(log)
   NWE.StackPushString(log)
   NWE.ExecuteCommand(560, 1)
end

--- Write string to nwnx_solstice log file
function M.WriteTimestampedLogEntryToNWNX(log)
   C.Local_NWNXLog(0, log)
end

return M
