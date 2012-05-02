--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

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
