--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

--- Simple Log function.
-- @param log_level nwn.LOGLEVEL_*
-- @param format_str The format string see Lua's string.format function.
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