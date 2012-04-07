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

---
-- @param alignment
-- @param amount
-- @param entire_party
function Creature:AdjustAlignment(alignment, amount, entire_party)
   nwn.engine.StackPushBoolean(entire_party)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(alignment)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(201, 4)
end

---
function Creature:GetAlignmentLawChaos()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(126, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetAlignmentGoodEvil()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(127, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetLawChaosValue()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(124, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetGoodEvilValue()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(125, 1)
   return nwn.engine.StackPopInteger()
end
