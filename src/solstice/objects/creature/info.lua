--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Info
-- @section

--- Gets creature's age
function Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_age
end

--- Gets creature's appearance type
function Creature:GetAppearanceType()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_appearance
end

--- Gets creature's body part
-- @param part
function Creature:GetBodyPart(part)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(792, 2)
   return NWE.StackPopInteger()
end

--- Gets creature's conversation resref
function Creature:GetConversation()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_conv)
end

--- Determine boss creature.
function Creature:GetIsBoss()
   return self:GetLocalInt("Boss") ~= 0
end

--- Gets creature's size
function Creature:GetSize()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_size
end

--- Gets creature's deity.
function Creature:GetDeity()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_deity)
end

--- Gets creature's deity ID.
function Creature:GetDeityId()
   return 0
end

-- Determines if Creature is a DM
function Creature:GetIsDM()
   if not self:GetIsValid() then return false end
   return self.obj.cre_stats.cs_is_dm ~= 0
end

--- Gets if creature is possessed by DM.
function Creature:GetIsDMPossessed()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(723, 1)
   return NWE.StackPopBoolean()
end

--- Get if creature was spawned by encounter.
function Creature:GetIsEncounterCreature()
   if not self:GetIsValid() then return false end
   return self.obj.cre_encounter_obj ~= 0x7f000000
end

--- Get if creature is polymorphed
function Creature:GetIsPolymorphed()
   return self:GetIsValid() and self.obj.cre_is_poly ~= 0
end

--- Gets creature's gender
function Creature:GetGender()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_gender
end

--- Gets PC characters bic file.
function Creature:GetPCFileName()
   if not self:GetIsValid() then return "" end

   local pl = C.nwn_GetPlayerByID(self.id)
   return ffi.string(pl.pl_bicfile)
end

--- Get creatures's phenotype
function Creature:GetPhenoType()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(778, 1)
   return NWE.StackPopInteger()
end

--- Gets creature's race.
function Creature:GetRacialType()
   if not self:GetIsValid() then
      return M.RACE_INVALID
   end

   return self.obj.cre_stats.cs_race
end

--- Gets creature's starting package.
function Creature:GetStartingPackage()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_starting_package
end

--- Gets creature's subrace
function Creature:GetSubrace()
   if not self:GetIsValid()
      or self.obj.cre_stats.cs_subrace == nil
   then
      return ""
   end
   return ffi.string(self.obj.cre_stats.cs_subrace)
end

--- Gets creature's subrace id.
function Creature:GetSubraceId()
   return 0
end

--- Gets creature's tail
function Creature:GetTail()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_tail
end

--- Sets creature's tail
-- @param tail Tail type constant.
function Creature:SetTail(tail)
   if not self:GetIsValid() then return end
   self.obj.cre_stats.cs_tail = tail
end

--- Gets creature's wings
function Creature:GetWings()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_wings
end

--- Sets creature's wings
-- @para wings Wing type constant.
function Creature:SetWings(wings)
   if not self:GetIsValid() then return end
   self.obj.cre_stats.cs_wings = wings
end

---
function Creature:SetAge(age)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_age = age
   return self.obj.cre_stats.cs_age
end

--- Sets creature's appearance type
-- @param type Appearance type.
function Creature:SetAppearanceType(type)
   if not self:GetIsValid() then return -1 end
   NWE.StackPushInteger(type)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(765, 2)
   return type
end

--- Sets creature's body part
-- @param part
-- @param model_number
function Creature:SetBodyPart(part, model_number)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(model_number)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(793, 3)
end

--- Sets creature's deity
-- @param deity New deity
function Creature:SetDeity(deity)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_deity)
   end

   self.obj.cre_stats.cs_deity = C.strdup(deity)
   return deity
end

--- Sets creature's gender
-- @param gender New gender
function Creature:SetGender(gender)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_gender = gender
   return self:GetGender()
end

--- Sets creature lootable
-- @param lootable New lootable value
function Creature:SetLootable(lootable)
   NWE.StackPushBoolean(lootable)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(740, 2)
end

--- Set creatures movement rate.
-- @param rate MOVE_RATE_*
function Creature:SetMovementRate(rate)
   if not self:GetIsValid() then return end
   C.nwn_SetMovementRate(self.obj, rate)
end

--- Set creatures's phenotype
-- @param phenotype Phenotype constant.
function Creature:SetPhenoType(phenotype)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(phenotype)
   NWE.ExecuteCommand(779, 2)
end

--- Set creature's subrace
-- @param subrace New subrace
function Creature:SetSubrace(subrace)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_subrace)
   end

   self.obj.cre_stats.cs_subrace = C.strdup(subrace)
   self.obj.cre_stats.cs_subrace_len = #subrace
   return subrace
end
