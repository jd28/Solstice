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

local M = {
   LEVEL_NONE    = 0,
   LEVEL_MINIMUM = 1,
   LEVEL_DEBUG   = 2,
   LEVEL_INFO    = 3,
   LEVEL_NOTICE  = 4,
   LEVEL_ERROR   = 5,
}

local LOGGERS = {
   ["server"] = M.WriteTimestampedLogEntry,
   ["nwnx"]   = M.WriteTimestampedLogEntryToNWNX,
}

--- Register a logger
-- @param name Name of logger.
-- @param file file to write to.
-- @see solstice.log.Log
function M.Register(name, file)
   LOGGERS[name] = file
end

--- Get's a log prefix by level.
-- @param log_level Log level. solstice.log.LEVEL_*
function M.GetLogPrefix(log_level)
   local log = ""
   if log_level == M.LEVEL_NONE then
      return log
   elseif log_level == M.LEVEL_DEBUG then
      log = "DEBUG : "
   elseif log_level == M.LEVEL_INFO then
      log = "INFO : "
   elseif log_level == M.LEVEL_NOTICE then
      log = "NOTICE : "
   elseif log_level == M.LEVEL_ERROR then
      log = "ERROR : "
   else
      log = "LOG : " 
   end
   return log
end

--- Simple Log function.
-- Based on NWScript function posted by Funkyswerve to bioboards.
-- @string logger Logger name.
-- @param log_level solstice.log.LEVEL_*
-- @param format_str Format string.
-- @param ... Values to pass to string.format
-- @see string.format
-- @return Formatted log string.
function M.Log(logger, log_level, format_str, ...)
   local log = solstice.GetLogPrefix(log_level)
   log = log .. string.format(format_str, ...)

   l = LOGGER[logger]
   if not l then
      error("Invalid logger: " .. logger)
   end
   
   if type(l) == "function" then
      l(log)
   elseif type(l) == "string" then
      local f = assert(io.open(NS_OPT_LOG_DIR .. l, "a"))
      f:write(log)
      f:close()
   end

   M.WriteTimestampedLogEntry(log)
   return log
end

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