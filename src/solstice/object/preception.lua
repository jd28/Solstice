--- Object
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module object

local M = require 'solstice.object.init'
local NWE = require 'solstice.nwn.engine'

--- Class Object: Preception
-- @section preception

--- Get if object is listening
function M.Object:GetIsListening()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(174, 1)

   return NWE.StackPopBoolean()
end

--- Set object to listen or not.
-- @bool val
function M.Object:SetListening(val)
   NWE.StackPushBoolean(val)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(175, 2)
end

--- Set listening patterns.
-- @param pattern Pattern to listen for.
-- @param[opt=0] number Number.
function M.Object:SetListenPattern(pattern, number)
   number = number or 0
   NWE.StackPushInteger(number)
   NWE.StackPushString(pattern)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(176, 3)
end
