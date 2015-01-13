---
-- @module creature

local M = require 'solstice.creature.init'
local Creature = M.Creature

local NWE = require 'solstice.nwn.engine'

--- Alignment
-- @section

--- Adjust creature's alignment.
-- @param alignment ALIGNMENT_* constant.
-- @param amount Amount to adjust
-- @param[opt=false] entire_party If true entire faction's alignment will be adjusted.
function Creature:AdjustAlignment(alignment, amount, entire_party)
   NWE.StackPushBoolean(entire_party)
   NWE.StackPushInteger(amount)
   NWE.StackPushInteger(alignment)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(201, 4)
end

--- Determines the disposition of a creature.
-- @return ALIGNMENT_* constant.
function Creature:GetAlignmentLawChaos()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(126, 1)
   return NWE.StackPopInteger()
end

--- Determines the disposition of a creature.
-- @return ALIGNMENT_* constant.
function Creature:GetAlignmentGoodEvil()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(127, 1)
   return NWE.StackPopInteger()
end

--- Determines a creature's law/chaos value.
function Creature:GetLawChaosValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(124, 1)
   return NWE.StackPopInteger()
end

--- Determines a creature's good/evil rating.
function Creature:GetGoodEvilValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(125, 1)
   return NWE.StackPopInteger()
end
