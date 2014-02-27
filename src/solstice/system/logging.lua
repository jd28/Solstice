--- System
-- @module system
-- @alias M

local C = require('ffi').C
require 'logging'
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.system.init'

-- Write string to NWN server log file
local function WriteTimestampedLogEntry(log)
   NWE.StackPushString(log)
   NWE.ExecuteCommand(560, 1)
end

--- Write string to nwnx_solstice log file
local function WriteLogEntryToNWNX(log)
   C.Local_NWNXLog(0, log)
end

--- NWN Log.
M.NWLog = logging.new(
   function(self, level, message)
      WriteTimestampedLogEntry(message)
      return true
   end)

--- nwnx_solstice log.
M.NXLog = logging.new(
   function(self, level, message)
      WriteLogEntryToNWNX(message)
      return true
   end)

local _LOGGER = M.NXLog

--- Sets the system logging function.
-- This defaults to printing to the nwnx_solstice.txt log file.
-- @param logger See LuaLogging.
function M.SetLogger(logger)
   _LOGGER = logger
end

function M.GetLogger()
   return assert(_LOGGER)
end
