--- System
-- @module system
-- @alias M

local ffi = require 'ffi'
local C = ffi.C

require 'logging'

-- Had to reimpliment the lualogging file logger, since it doesn't
-- allow controlling the date pattern in the actual log message.

local lastFileNameDatePattern
local lastFileHandler

local function openFileLogger(filename, datePattern)
	if (lastFileNameDatePattern ~= filename) then
		local f = io.open(filename, "a")
		if (f) then
			f:setvbuf ("line")
			lastFileNameDatePattern = filename
			lastFileHandler = f
			return f
		else
			return nil, string.format("file `%s' could not be opened for writing", filename)
		end
	else
		return lastFileHandler
	end
end

local function file(filename, datePattern, logPattern)
	if type(filename) ~= "string" then
		filename = "lualogging.log"
	end

	return logging.new( function(self, level, message)
		local f, msg = openFileLogger(filename, datePattern)
		if not f then
			return nil, msg
		end
		local s = logging.prepareLogMsg(logPattern, os.date(datePattern), level, message)
		f:write(s)
		return true
	end)
end

ffi.cdef[[
void           Local_NWNXLog(int32_t level, const char* log);
]]

local M = require 'solstice.system.init'
M.FileLog = file(OPT.LOG_FILE, OPT.LOG_DATE_PATTERN)

local _LOGGER = M.FileLog

--- Logging
-- @section logging

--- Sets the default logging function.
-- @param logger See LuaLogging.
function M.SetLogger(logger)
   _LOGGER = logger
end

--- Get current logger.
function M.GetLogger()
   return assert(_LOGGER)
end
