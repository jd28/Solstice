--- Simple Log function.
--    Based on NWScript function posted by Funkyswerve to bioboards.
-- @param log_level nwn.LOGLEVEL_*
-- @param format_str The format string see Lua's string.format function.
-- @param ... Values to pass to string.format
-- @return Formatted log string.
function nwn.Log(log_level, format_str, ...)
   local log = ""
   if log_level == nwn.LOGLEVEL_NONE then
      return log
   elseif log_level == nwn.LOGLEVEL_DEBUG then
      log = "DEBUG : "
   elseif log_level == nwn.LOGLEVEL_INFO then
      log = "INFO : "
   elseif log_level == nwn.LOGLEVEL_NOTICE then
      log = "NOTICE : "
   elseif log_level == nwn.LOGLEVEL_ERROR then
      log = "ERROR : "
   else
      log = "LOG : " 
   end
   
   log = log .. string.format(format_str, ...)
   nwn.WriteTimestampedLogEntry(log)
   return log
end

--- Write string to NWN server log file
function nwn.WriteTimestampedLogEntry(log)
   nwn.engine.StackPushString(log)
   nwn.engine.ExecuteCommand(560, 1)
end 