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

require 'nwn.funcs'
local ffi = require 'ffi'
local C = ffi.C
local cmd = require 'nwn.internal.commands'

--- Assigns a command to an object.
-- No longer really nessary as all actions are explicitly assigned.
-- @param f A closure
function Object:AssignCommand(f)
   local temp = nwn.engine.GetNWNCommandObjectId()
   nwn.engine.SetNWNCommandObjectId(self)
   f()
   nwn.engine.SetNWNCommandObjectId(temp)
end

--- Delays a command
-- @param delay Time in seconds.
-- @param action A closure
function Object:DelayCommand(delay, action)
    local delay = delay or 0
    local count = table.maxn(cmd) + 1
    cmd[count] = { f = action, id = self.id }
         
    C.ns_DelayCommand(ffi.cast("Object*", self), delay, count)
end

--- Repeats a command.
-- @param delay Time in seconds.
-- @param action A closure
-- @param step Change in seconds from one application to the next.
function Object:RepeatCommand(delay, action, step)
   local count = table.maxn(cmd) + 1
   
   -- No zero or negative .
   if delay <= 0 then return end
   
   step = step or 0
   cmd[count] = { f = action, d = delay, s = step, self = self }
   
   C.ns_RepeatCommand(ffi.cast("Object*", self), delay, count)
end

--- Inserts action into acction queue
-- @param action A closure
function Object:DoCommand(action)
    local count = table.maxn(cmdS) + 1
    cmd[count] = { f = action, id = self.id }

   C.ns_ActionDoCommand(ffi.cast("Object*", self), count)
end
