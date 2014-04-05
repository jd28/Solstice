--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M = require 'solstice.creature.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'

--- Info
-- @section


--- Gets creature's age
function M.Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_age
end

--- Gets creature's appearance type
function M.Creature:GetAppearanceType()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_appearance
end

--- Gets creature's body part
-- @param part
function M.Creature:GetBodyPart(part)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(792, 2)
   return NWE.StackPopInteger()
end

--- Gets creature's conversation resref
function M.Creature:GetConversation()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_conv)
end

--- Determine boss creature.
function M.Creature:GetIsBoss()
   return self:GetLocalInt("Boss") ~= 0
end

--- Gets creature's size
function M.Creature:GetSize()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_size
end

--- Gets creature's deity.
function M.Creature:GetDeity()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_deity)
end

--- Gets creature's deity ID.
function M.Creature:GetDeityId()
   return 0
end

-- Determines if Creature is a DM
function M.Creature:GetIsDM()
   if not self:GetIsValid() then return false end

   return self.obj.cre_stats.cs_is_dm ~= 0
end

--- Gets if creature is possessed by DM.
function M.Creature:GetIsDMPossessed()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(723, 1)
   return NWE.StackPopBoolean()
end

--- Get if creature was spawned by encounter.
function M.Creature:GetIsEncounterCreature()
   if not self:GetIsValid() then return false end
   return self.obj.cre_encounter_obj ~= 0x7f000000
end

--- Gets creature's gender
function M.Creature:GetGender()
   if not self:GeIsValid() then return -1 end
   return self.obj.cre_stats.cs_gender
end

--- Gets PC characters bic file.
function M.Creature:GetPCFileName()
   if not self:GetIsValid() then return "" end

   local pl = C.nwn_GetPlayerByID(self.id)
   return ffi.string(pl.pl_bicfile)
end

--- Gets creature's race.
function M.Creature:GetRacialType()
   if not self:GetIsValid() then
      return M.RACE_INVALID
   end

   return self.obj.cre_stats.cs_race
end

--- Gets creature's starting package.
function M.Creature:GetStartingPackage()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_starting_package
end

--- Gets creature's subrace
function M.Creature:GetSubrace()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.obj.cre_stats.cs_subrace)
end

--- Gets creature's subrace id.
function M.Creature:GetSubraceId()
   return 0
end

--- Gets creature's tail
function M.Creature:GetTail()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_tail
end

--- Gets creature's wings
function M.Creature:GetWings()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_stats.cs_wings
end

---
function M.Creature:SetAge(age)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_age = age
   return self.obj.cre_stats.cs_age
end

--- Sets creature's appearance type
-- @param type Appearance type.
function M.Creature:SetAppearanceType(type)
   if not self:GetIsValid() then return -1 end

   self.obj.cre_stats.cs_appearance = type
   return self.obj.cre_stats.cs_appearance
end

--- Sets creature's body part
-- @param part
-- @param model_number
function M.Creature:SetBodyPart(part, model_number)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(model_number)
   NWE.StackPushInteger(part)
   NWE.ExecuteCommand(793, 3)
end

--- Sets creature's deity
-- @param deity New deity
function M.Creature:SetDeity(deity)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_deity)
   end

   self.obj.cre_stats.cs_deity = C.strdup(deity)
   return deity
end

--- Sets creature's gender
-- @param gender New gender
function M.Creature:SetGender(gender)
   if not self:GetIsValid() then return -1 end
   self.obj.cre_stats.cs_gender = gender
   return self:GetGender()
end

--- Sets creature lootable
-- @param lootable New lootable value
function M.Creature:SetLootable(lootable)
   NWE.StackPushBoolean(lootable)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(740, 2)
end

--- Set creatures movement rate.
-- @param rate MOVE\_RATE\_*
function M.Creature:SetMovementRate(rate)
   if not self:GetIsValid() then return end
   C.nwn_SetMovementRate(self.obj, rate)
end

--- Set creature's subrace
-- @param subrace New subrace
function M.Creature:SetSubrace(subrace)
   if not self:GetIsValid() then return "" end

   if self.obj.cre_stats.cs_deity ~= nil then
      C.free(self.obj.cre_stats.cs_subrace)
   end

   self.obj.cre_stats.cs_subrace = C.strdup(subrace)
   self.obj.cre_stats.cs_subrace_len = #subrace
   return subrace
end
