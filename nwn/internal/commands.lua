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

local ffi = require 'ffi'
local C = ffi.C

-- Table holding stored commands.  See DoCommand, DelayCommand, etc.
local _COMMANDS = { }

_COMMANDS.COMMAND_TYPE_DELAY      = 0
_COMMANDS.COMMAND_TYPE_DO         = 1
_COMMANDS.COMMAND_TYPE_REPEAT     = 2

--- Internal Function handling DoCommand 
function _RUN_DO_COMMAND (token)
   if not token then return end
   if _COMMANDS[token] ~= nill then
      local f = _COMMANDS[token]["f"]
      f(_NL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
end

function _RUN_DELAY_COMMAND (token)
   if not token then return end
   if _COMMANDS[token] ~= nil then
      print("Delay Token: " .. token)
      local f = _COMMANDS[token]["f"]
      f(_NL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
end

--- Internal Function handling RepeatCommand
-- @return If nil the command ceases repeating, if true it will continue to repeat
function _RUN_REPEAT_COMMAND(token)
   if token and _COMMANDS[token] ~= nil then
      local f = _COMMANDS[token]["f"]
      if f(_NL_GET_CACHED_OBJECT(_COMMANDS[token].id)) then
         local newdelay = _COMMANDS[token]["d"] + _COMMANDS[token]["s"]; 
         -- Delay can never be a negative or equal to zero.
         if newdelay <= 0 then
            _COMMANDS[token] = nil
         else    
            _COMMANDS[token]["d"] = newdelay 
            --nwn.engine.DelayCommand(_COMMANDS[token].id, delay, token)
            print("Repeat Delay:", newdelay)
            return newdelay
         end
      else
         _COMMANDS[token] = nil
      end
      return 0
   end
end

function _RUN_COMMAND(ctype, token, objid)
   local res = 0
   if ctype == _COMMANDS.COMMAND_TYPE_DELAY then
      _RUN_DELAY_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_DO then
      _RUN_DO_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_REPEAT then
      res = _RUN_REPEAT_COMMAND(token)
   end
   
   return res
end

return _COMMANDS