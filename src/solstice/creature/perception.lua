--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M   = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'

--- Preception
-- @section

--- Determines whether an object sees another object.
-- @param target Object to determine if it is seen.
function M.Creature:GetIsSeen(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(289, 2)
   return NWE.StackPopBoolean()
end

--- Determines if an object can hear another object.
-- @param target The object that may be heard.
function M.Creature:GetIsHeard(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(290, 2)
   return NWE.StackPopBoolean()
end
