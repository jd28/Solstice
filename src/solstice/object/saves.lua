--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'

--- Class Object: Saves
-- @section saves

--- Do fortitude save
-- @param dc Difficult class
-- @param save_type solstice.save.VS_*
-- @param vs Save versus object
function M.Object:FortitudeSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(108, 4)
   return NWE.StackPopInteger()
end

--- Get fortitude saving throw
function M.Object:GetFortitudeSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(491, 1)
   return NWE.StackPopInteger()
end

--- Get reflex saving throw
function M.Object:GetReflexSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(493, 1)
   return NWE.StackPopInteger()
end

--- Get will saving throw
function M.Object:GetWillSavingThrow()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(492, 1)
   return NWE.StackPopInteger()
end

--- Do reflex save
-- @param dc Difficult class
-- @param save_type solstice.save.VS_*
-- @param vs Save versus object
function M.Object:ReflexSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(109, 4)
   return NWE.StackPopInteger()
end

--- Set fortitude saving throw
-- @param val New value
function M.Object:SetFortitudeSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(813, 2)
end

--- Set reflex saving throw
-- @param val New value.
function M.Object:SetReflexSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(812, 2)
end

--- Set will saving throw
-- @param val New value.
function M.Object:SetWillSavingThrow(val)
   NWE.StackPushInteger(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(811, 2)
end

--- Do will save
-- @param dc Difficult class
-- @param save_type solstice.save.VS_*
-- @param vs Save versus object.
function M.Object:WillSave(dc, save_type, vs)
   NWE.StackPushObject(vs)
   NWE.StackPushInteger(save_type)
   NWE.StackPushInteger(dc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(110, 4)
   return NWE.StackPopInteger()
end
