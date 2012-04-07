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
function Faction:GetAverageGoodEvilAlignment()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(187, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetAverageLawChaosAlignment()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(188, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetAverageLevel()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(189, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetAverageReputation(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(186, 2)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetAverageXP()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(190, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetBestAC(bMustBeVisible)
   if bMustBeVisible == nil then
      bMustBeVisible = true
   end
   
   nwn.engine.StackPushInteger(bMustBeVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(193, 2)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetGold()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(185, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetLeastDamagedMember(bVisible)
   if bVisible == nil then bVisible = true end

   nwn.engine.StackPushInteger(bVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(184, 2)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetMostDamagedMember(bVisible)
   if bVisible == nil then bVisible = true end
   
   nwn.engine.StackPushInteger(bVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(183, 2)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetMostFrequentClass()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(191, 1)
   return nwn.engine.StackPopInteger()
end

---
function Faction:GetLeader()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(562, 1)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetStrongestMember(bVisible)
   if bVisible == nil then bVisible = true end
   
   nwn.engine.StackPushInteger(bVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(182, 2)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetWeakestMember(bVisible)
   if bVisible == nil then bVisible = true end

   nwn.engine.StackPushInteger(bVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(181, 2)

   return nwn.engine.StackPopObject()
end

---
function Faction:GetWorstAC(bVisible)
   if bVisible == nil then bVisible = true end

   nwn.engine.StackPushInteger(bVisible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(192, 2)
   return nwn.engine.StackPopObject()
end

---
function Faction:GetFirstFactionMember(bPCOnly)
   if bPCOnly == nil then bPCOnly = true end
   
   nwn.engine.StackPushInteger(bPCOnly)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(380, 2)

   return nwn.engine.StackPopObject()
end

---
function Faction:GetNextFactionMember(bPCOnly)
   if bPCOnly == nil then bPCOnly = true end
   
   nwn.engine.StackPushInteger(bPCOnly)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(381, 2)
   return nwn.engine.StackPopObject()
end