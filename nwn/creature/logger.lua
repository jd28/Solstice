--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.logger'

--- Wrapper for nwn.Log that sends a copy of the message if a specified local
-- variable is set to true.
-- @param log_var If self:GetLocalBool(log_var) is true a copy of the 
-- log is sent to the combat log of self.
-- @param log_level nwn.LOGLEVEL_*
-- @param format_str The format string see Lua's string.format function.
-- @return Formatted log string.
function Creature:Log(log_var, log_level, format_str, ...)
   if log_level == nwn.LOGLEVEL_NONE then return "" end
   local log = nwn.Log(log_level, format_str, ...)

   if self:GetLocalBool(log_var) then
      self:SendMessage(oLogger, "<cþþþ>" + log + "</c>");
   end
   return log
end