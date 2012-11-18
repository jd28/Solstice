require 'nwn.funcs'
local ffi = require 'ffi'
local C = ffi.C
local cmd = require 'nwn.internal.commands'

--- Assigns a command to an object.
-- No longer really nessary as all actions are explicitly assigned.
-- @param f A closure
function Object:AssignCommand(f)
   local temp = nwn.engine.GetCommandObject()
   nwn.engine.SetCommandObject(self)
   f()
   nwn.engine.SetCommandObject(temp)
end

--- Delays a command
-- @param delay Time in seconds.
-- @param action A closure
function Object:DelayCommand(delay, action)
   local delay = delay or 0
   local count = table.maxn(cmd) + 1
   cmd[count] = { f = action, id = self.id }
   
   C.ns_DelayCommand(self.obj.obj, delay, count)
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
   
   C.ns_RepeatCommand(self.obj.obj, delay, count)
end

--- Inserts action into acction queue
-- @param action A closure
function Object:DoCommand(action)
   local count = table.maxn(cmd) + 1
   cmd[count] = { f = action, id = self.id }

   C.ns_ActionDoCommand(self.obj.obj, count)
end
