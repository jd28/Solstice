---
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Preception
-- @section preception

function Object:GetIsListening()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(174, 1)

   return NWE.StackPopBoolean()
end

function Object:SetListening(val)
   NWE.StackPushBoolean(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(175, 2)
end

function Object:SetListenPattern(pattern, number)
   number = number or 0
   NWE.StackPushInteger(number)
   NWE.StackPushString(pattern)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(176, 3)
end
