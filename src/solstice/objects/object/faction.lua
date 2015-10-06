--- Object
-- @module object

local M = require 'solstice.objects.init'
local Object = M.Object
local ffi = require 'ffi'
local C = ffi.C

local NWE = require 'solstice.nwn.engine'

--- Class Object: Faction
-- @section faction

function Object:ChangeFaction(faction)
   NWE.StackPushObject(faction)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(173, 2)
end

function Object:GetFactionId()
   if not self:GetIsValid() then return -1 end

   return C.nl_Object_GetFactionId(self.id)
end

function Object:SetFactionId(faction)
   if not self:GetIsValid() or not faction then return -1 end

   return C.nl_Object_SetFactionId(self.id, faction)
end

---
function Object:GetFactionAverageGoodEvilAlignment()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(187, 1)
   return NWE.StackPopInteger()
end

---
function Object:GetFactionAverageLawChaosAlignment()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(188, 1)
   return NWE.StackPopInteger()
end

---
function Object:GetFactionAverageLevel()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(189, 1)
   return NWE.StackPopInteger()
end

---
function Object:GetFactionAverageReputation(target)
   NWE.StackPushObject(target)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(186, 2)
   return NWE.StackPopInteger()
end

--- Get faction average XP
function Object:GetFactionAverageXP()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(190, 1)
   return NWE.StackPopInteger()
end

function Object:GetFactionBestAC(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(193, 2)
   return NWE.StackPopObject()
end

function Object:GetFactionGold()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(185, 1)
   return NWE.StackPopInteger()
end

---
function Object:GetFactionLeastDamagedMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(184, 2)
   return NWE.StackPopObject()
end

---
function Object:GetFactionMostDamagedMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(183, 2)
   return NWE.StackPopObject()
end

---
function Object:GetFactionMostFrequentClass()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(191, 1)
   return NWE.StackPopInteger()
end

---
function Object:GetFactionLeader()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(562, 1)
   return NWE.StackPopObject()
end

---
function Object:GetFactionStrongestMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(182, 2)
   return NWE.StackPopObject()
end

---
function Object:GetFactionWeakestMember(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(181, 2)

   return NWE.StackPopObject()
end

---
function Object:GetFactionWorstAC(visible)
   if visible == nil then visible = true end

   NWE.StackPushInteger(visible)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(192, 2)
   return NWE.StackPopObject()
end
