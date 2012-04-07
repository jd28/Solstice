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