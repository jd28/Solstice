--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

local ffi = require 'ffi'

local NWE = require 'solstice.nwn.engine'

--- Attack Bonus
-- @section

--- Determine creature's BAB.
function M.Creature:GetBaseAttackBonus()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(699, 1)
   return NWE.StackPopInteger()
end
