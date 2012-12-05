local fmt = string.format

--- Creates new log table.
-- @param log_level nwn.LOGLEVEL_*
-- @param title Title of the log table.
-- @param timestamp If true a timestamp will be add to every string in the Log table.
function nwn.CreateLogTable(log_level, title, timestamp)
   if log_level == nwn.LOGLEVEL_NONE then return end

   return { level = log_level,
	    title = title or "Log Table",
	    timestamp = timestamp}
end

--- Get's a log prefix by level.
-- @param log_level Log level.
function nwn.GetLogPrefix(log_level)
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
   return log
end

--- Simple Log function.
--    Based on NWScript function posted by Funkyswerve to bioboards.
-- @param log_level nwn.LOGLEVEL_*
-- @param format_str The format string see Lua's string.format function.
-- @param ... Values to pass to string.format
-- @return Formatted log string.
function nwn.Log(log_level, format_str, ...)
   local log = nwn.GetLogPrefix(log_level)
   log = log .. string.format(format_str, ...)
   nwn.WriteTimestampedLogEntry(log)
   return log
end

--- Add string to log table.
-- @param log The log table
-- @param str String to log, can be string.format string.
-- @param ... Values to pass to string.format
function nwn.LogTableAdd(log, str, ...)
   if not log then return end
   if not log.timestamp then
      log[#log + 1] = fmt(str, ...)
   else
      log[#log + 1] = fmt("[%s] " .. str, os.date("%c"), ...)
   end
end

--- Converts log table to string
-- @param log The log table
function nwn.LogTableToString(log, sort)
   if not log then return "" end
   if sort then table.sort(log) end

   return fmt("%s:\n%s", log.title, table.concat(log, "\n"))
end

-- @param log The log table
function nwn.LogTableLog(log, sort)
   if not log then return end
   local out = nwn.LogTableToString(log, sort)
   return nwn.Log(log.level, out)
end

--- Write string to NWN server log file
function nwn.WriteTimestampedLogEntry(log)
   nwn.engine.StackPushString(log)
   nwn.engine.ExecuteCommand(560, 1)
end 


