--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

local L = require 'solstice.log'
local Log = L.Log

--- Logging
-- @section

--- Wrapper for solstice.nwn.Log that sends a copy of the message if a specified local
-- variable is set to true.
-- @string logger Logger name.
-- @param log_var If self:GetLocalBool(log_var) is true a copy of the 
-- log is sent to the combat log of self.
-- @param log_level solstice.log.LEVEL_*
-- @param format_str The format string see Lua's string.format function.
-- @return Formatted log string.
function M.Creature:Log(logger, log_var, log_level, format_str, ...)
   if log_level == L.LEVEL_NONE then return "" end
   local log = Log(logger, log_level, format_str, ...)

   if self:GetLocalBool(log_var) then
      self:SendMessage(log);
   end
   return log
end