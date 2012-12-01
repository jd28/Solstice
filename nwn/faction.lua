-- TODO: this all needs to be redone /if/ there is going to be a proxy faction
-- object

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

--- Get faction average XP
function Faction:GetAverageXP()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(190, 1)
   return nwn.engine.StackPopInteger()
end

--- Get faction member with best AC
-- @param visible If true member must be visible
function Faction:GetBestAC(visible)
   if visible == nil then visible = true end
   
   nwn.engine.StackPushInteger(visible)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(193, 2)
   return nwn.engine.StackPopObject()
end

--- Get factions gold
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

