--- Object
-- @module object

local M = require 'solstice.objects.init'
local C = require('ffi').C
local NWE = safe_require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Commands
-- @section commands

function Object:AssignCommand(f)
   local temp = NWE.GetCommandObject()
   NWE.SetCommandObject(self)
   f()
   NWE.SetCommandObject(temp)
end

function Object:DelayCommand(delay, action)
   local delay = delay or 0
   local token = _SOL_ADD_COMMAND(self.id, action)
   C.ns_DelayCommand(self.id, delay, token)
end

function Object:DoCommand(action)
   local token = _SOL_ADD_COMMAND(self.id, action)
   C.ns_ActionDoCommand(self.obj.obj, token)
end

function Object:GetCommandable()
   NWE.StackPushObject(self);
   NWE.ExecuteCommand(163, 1);
   return NWE.StackPopBoolean();
end

function Object:SetCommandable(commandable)
   NWE.StackPushObject(self);
   NWE.StackPushBoolean(commandable);
   NWE.ExecuteCommand(162, 2);
end
