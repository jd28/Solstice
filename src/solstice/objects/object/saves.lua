--- Object
-- @module object

local M = require 'solstice.objects.init'
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Saves
-- @section saves

function Object:FortitudeSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(108, 4)
   return NWE.StackPopInteger()
end

function Object:GetFortitudeSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(491, 1)
   return NWE.StackPopInteger()
end

function Object:GetReflexSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(493, 1)
   return NWE.StackPopInteger()
end

function Object:GetWillSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(492, 1)
   return NWE.StackPopInteger()
end

function Object:ReflexSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(109, 4)
   return NWE.StackPopInteger()
end

function Object:SetFortitudeSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(813, 2)
end

function Object:SetReflexSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(812, 2)
end

function Object:SetWillSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(811, 2)
end

function Object:WillSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(110, 4)
   return NWE.StackPopInteger()
end
