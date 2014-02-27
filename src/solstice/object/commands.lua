--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = safe_require 'solstice.object.init'
local C = require('ffi').C
local NWE = safe_require 'solstice.nwn.engine'

--- Class Object: Commands
-- @section commands

--- Assigns a command to an object.
-- No longer really nessary as all actions are explicitly assigned.
-- @param f A closure
function M.Object:AssignCommand(f)
   local temp = NWNE.GetCommandObject()
   NWNE.SetCommandObject(self)
   f()
   NWNE.SetCommandObject(temp)
end

--- Delays a command
-- @param delay Time in seconds.
-- @param action A closure
function M.Object:DelayCommand(delay, action)
   local delay = delay or 0
   local count = table.maxn(_COMMANDS) + 1
   _COMMANDS[count] = { f = action, id = self.id }

   C.ns_DelayCommand(self.id, delay, count)
end

--- Repeats a command.
-- @param delay Time in seconds.
-- @param action A closure
-- @param step Change in seconds from one application to the next.
function M.Object:RepeatCommand(delay, action, step)
   local count = table.maxn(_COMMANDS) + 1

   -- No zero or negative .
   if delay <= 0 then return end

   step = step or 0
   _COMMANDS[count] = { f = action, d = delay, s = step, self = self }

   C.ns_RepeatCommand(self.id, delay, count)
end

--- Inserts action into acction queue
-- @param action A closure
function M.Object:DoCommand(action)
   local count = table.maxn(_COMMANDS) + 1
   _COMMANDS[count] = { f = action, id = self.id }

   C.ns_ActionDoCommand(self.obj.obj, count)
end

--- Get is object commandable
function M.Object:GetCommandable()
   NWNE.StackPushObject(self);
   NWNE.ExecuteCommand(163, 1);
   return NWNE.StackPopBoolean();
end

--- Set is object commandable
-- @param[opt=false] commandable New value.
function M.Object:SetCommandable(commandable)
   NWNE.StackPushObject(self);
   NWNE.StackPushBoolean(commandable);
   NWNE.ExecuteCommand(162, 2);
end
