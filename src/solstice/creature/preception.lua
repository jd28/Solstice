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
function Creature:GetIsSeen(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(289, 2)
   return NWE.StackPopInteger()
end

--- Determines if an object can hear another object.
-- @param target The object that may be heard.
function Creature:GetIsHeard(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommand(290, 2)
   return NWE.StackPopBoolean()
end