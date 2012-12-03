--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

--- Adjust creature's alignment.
-- @param alignment nwn.ALIGNMENT_*
-- @param amount Amount to adjust
-- @param entire_party If true entire faction's alignment will be adjusted
--    (Default: false)
function Creature:AdjustAlignment(alignment, amount, entire_faction)
   nwn.engine.StackPushBoolean(entire_faction)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(alignment)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(201, 4)
end

--- Determines the disposition of a creature.
-- @return nwn.ALIGNMENT_*
function Creature:GetAlignmentLawChaos()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(126, 1)
   return nwn.engine.StackPopInteger()
end

--- Determines the disposition of a creature.
-- @return nwn.ALIGNMENT_*
function Creature:GetAlignmentGoodEvil()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(127, 1)
   return nwn.engine.StackPopInteger()
end

--- Determines a creature's law/chaos value.
function Creature:GetLawChaosValue()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(124, 1)
   return nwn.engine.StackPopInteger()
end

--- Determines a creature's good/evil rating.
function Creature:GetGoodEvilValue()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(125, 1)
   return nwn.engine.StackPopInteger()
end
