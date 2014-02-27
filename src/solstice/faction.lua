--- Faction
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module faction

-- TODO: this all needs to be redone /if/ there is going to be a proxy faction
-- object

local NWE = require 'solstice.nwn.engine'

local M = {}

---
function M.Faction:GetAverageGoodEvilAlignment()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(187, 1)
   return NWE.StackPopInteger()
end

---
function M.Faction:GetAverageLawChaosAlignment()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(188, 1)
   return NWE.StackPopInteger()
end

---
function M.Faction:GetAverageLevel()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(189, 1)
   return NWE.StackPopInteger()
end

---
function M.Faction:GetAverageReputation(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(186, 2)
   return NWE.StackPopInteger()
end

--- Get faction average XP
function M.Faction:GetAverageXP()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(190, 1)
   return NWE.StackPopInteger()
end

--- Get faction member with best AC
-- @param visible If true member must be visible
function M.Faction:GetBestAC(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(193, 2)
   return NWE.StackPopObject()
end

--- Get factions gold
function M.Faction:GetGold()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(185, 1)
   return NWE.StackPopInteger()
end

---
function M.Faction:GetLeastDamagedMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(184, 2)
   return NWE.StackPopObject()
end

---
function M.Faction:GetMostDamagedMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(183, 2)
   return NWE.StackPopObject()
end

---
function M.Faction:GetMostFrequentClass()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(191, 1)
   return NWE.StackPopInteger()
end

---
function M.Faction:GetLeader()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(562, 1)
   return NWE.StackPopObject()
end

---
function M.Faction:GetStrongestMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(182, 2)
   return NWE.StackPopObject()
end

---
function M.Faction:GetWeakestMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(181, 2)

   return NWE.StackPopObject()
end

---
function M.Faction:GetWorstAC(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(192, 2)
   return NWE.StackPopObject()
end
