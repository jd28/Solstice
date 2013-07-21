--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'

local NWE = require 'solstice.nwn.engine'

--- Alignment
-- @section

--- Adjust creature's alignment.
-- @param alignment solstice.alignment constant.
-- @param amount Amount to adjust
-- @param[opt=false] entire_party If true entire faction's alignment will be adjusted.
function M.Creature:AdjustAlignment(alignment, amount, entire_party)
   NWE.StackPushBoolean(entire_faction)
   NWE.StackPushInteger(amount)
   NWE.StackPushInteger(alignment)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(201, 4)
end

--- Determines the disposition of a creature.
-- @return solstice.alignment constant.
function M.Creature:GetAlignmentLawChaos()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(126, 1)
   return NWE.StackPopInteger()
end

--- Determines the disposition of a creature.
-- @return solstice.alignment constant.
function M.Creature:GetAlignmentGoodEvil()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(127, 1)
   return NWE.StackPopInteger()
end

--- Determines a creature's law/chaos value.
function M.Creature:GetLawChaosValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(124, 1)
   return NWE.StackPopInteger()
end

--- Determines a creature's good/evil rating.
function M.Creature:GetGoodEvilValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(125, 1)
   return NWE.StackPopInteger()
end
