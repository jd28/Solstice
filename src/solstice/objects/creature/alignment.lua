---
-- @module creature

local M = require 'solstice.objects.init'
local Creature = M.Creature

local NWE = require 'solstice.nwn.engine'

--- Alignment
-- @section

function Creature:AdjustAlignment(alignment, amount, entire_party)
   NWE.StackPushBoolean(entire_party)
   NWE.StackPushInteger(amount)
   NWE.StackPushInteger(alignment)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(201, 4)
end

function Creature:GetAlignmentLawChaos()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(126, 1)
   return NWE.StackPopInteger()
end

function Creature:GetAlignmentGoodEvil()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(127, 1)
   return NWE.StackPopInteger()
end

function Creature:GetLawChaosValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(124, 1)
   return NWE.StackPopInteger()
end

function Creature:GetGoodEvilValue()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(125, 1)
   return NWE.StackPopInteger()
end
