--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Info
-- @section

function Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_age
end

function Creature:GetAppearanceType()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_appearance
end

function Creature:GetBodyPart(part)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(792, 2)
   return NWE.StackPopInteger()
end

function Creature:GetConversation()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_conv)
end

function Creature:GetIsBoss()
   return self:GetLocalInt("Boss") ~= 0
end

function Creature:GetSize()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_size
end

function Creature:GetDeity()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_deity)
end

function Creature:GetIsDM()
   if not self:GetIsValid() then return false end
   return self.obj.cre_stats.cs_is_dm ~= 0
end

function Creature:GetIsDMPossessed()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(723, 1)
   return NWE.StackPopBoolean()
end

function Creature:GetIsEncounterCreature()
   if not self:GetIsValid() then return false end
   return self.obj.cre_encounter_obj ~= 0x7f000000
end

function Creature:GetIsPolymorphed()
   return self:GetIsValid() and self.obj.cre_is_poly ~= 0
end

function Creature:GetGender()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_gender
end

function Creature:GetPCFileName()
   if not self:GetIsValid() then return "" end

   local pl = C.nwn_GetPlayerByID(self.id)
   return ffi.string(pl.pl_bicfile)
end

function Creature:GetPhenoType()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(778, 1)
   return NWE.StackPopInteger()
end

function Creature:GetRacialType()
   if not self:GetIsValid() then
      return RACIAL_TYPE_INVALID
   end

   return self.obj.cre_stats.cs_race
end

function Creature:GetStartingPackage()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_starting_package
end

function Creature:GetSubrace()
   if not self:GetIsValid()
      or self.obj.cre_stats.cs_subrace == nil
   then
      return ""
   end
   return ffi.string(self.obj.cre_stats.cs_subrace)
end

function Creature:GetTail()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_tail
end

function Creature:SetTail(tail)
   if not self:GetIsValid() then return end
   self.obj.cre_stats.cs_tail = tail
end

function Creature:GetWings()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_wings
end

function Creature:SetWings(wings)
   if not self:GetIsValid() then return end
   self.obj.cre_stats.cs_wings = wings
end

function Creature:SetAge(age)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_age = age
   return self.obj.cre_stats.cs_age
end

function Creature:SetAppearanceType(type)
   if not self:GetIsValid() then return -1 end
   NWE.StackPushInteger(type)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(765, 2)
   return type
end

function Creature:SetBodyPart(part, model_number)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(model_number)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(793, 3)
end

function Creature:SetDeity(deity)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_deity)
   end

   self.obj.cre_stats.cs_deity = C.strdup(deity)
   return deity
end

function Creature:SetGender(gender)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_gender = gender
   return self:GetGender()
end

function Creature:SetLootable(lootable)
   NWE.StackPushBoolean(lootable)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(740, 2)
end

function Creature:SetMovementRate(rate)
   if not self:GetIsValid() then return end
   C.nwn_SetMovementRate(self.obj, rate)
end

function Creature:SetPhenoType(phenotype)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(phenotype)
   NWE.ExecuteCommand(779, 2)
end

function Creature:SetSubrace(subrace)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_subrace)
   end

   self.obj.cre_stats.cs_subrace = C.strdup(subrace)
   self.obj.cre_stats.cs_subrace_len = #subrace
   return subrace
end
