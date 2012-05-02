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

local ffi = require 'ffi'
local C = ffi.C

--- Gets creature's age
function Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_age
end

--- Gets creature's appearance type
function Creature:GetAppearanceType()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_appearance
end

--- Gets creature's body part
-- @param part
function Creature:GetBodyPart(part)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(part)
   nwn.engine.ExecuteCommand(792, 2)
   return nwn.engine.StackPopInteger()
end

--- Gets creature's conversation resref
function Creature:GetConversation()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_conv)
end

--- Gets creature's size
function Creature:GetSize()
   if not self:GetIsValid() then return -1 end
   return self.obj.cre_size
end

--- Gets creature's deity.
function Creature:GetDeity()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_deity)
end

--- Gets creature's deity ID.
function Creature:GetDeityId()
   return 0
end

--- Calculate a creature's hit dice.
-- @param use_neg_levels If true negative levels factored in to
--    total hit dice. (Default: false)
function Creature:GetHitDice(use_neg_levels)
   local total = 0
   for cl in self:Classes() do
      -- Class level can never be negative.
      if use_neg_levels then
         total = total + math.max(0, cl.cl_level - cl.cl_negative_level)
      else
         total = total + cl.cl_level
      end
   end
   return total
end

--- Gets if creature is possessed by DM.
function Creature:GetIsDMPossessed()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(723, 1)
   return nwn.engine.StackPopBoolean()
end

--- Get if creature was spawned by encounter.
function Creature:GetIsEncounterCreature()
   if not self:GeIsValid() then return false end
   return self.obj.cre_encounter_obj ~= nwn.OBJECT_INVALID.id
end

--- Gets creature's gender
function Creature:GetGender()
   if not self:GeIsValid() then return -1 end
   return self.stats.cs_gender
end

--- Gets PC characters bic file.
function Creature:GetPCFileName()
   if not self:GetIsValid() then return "" end

   local pl = C.nwn_GetPlayerByID(self.id)
   return ffi.string(pl.pl_bicfile)
end

--- Gets creature's race.
function Creature:GetRacialType()
   if not self:GetIsValid() then
      return nwn.RACIAL_TYPE_INVALID
   end

   return self.stats.cs_race
end

--- Gets creature's starting package.
function Creature:GetStartingPackage()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_starting_package
end

--- Gets creature's subrace
function Creature:GetSubrace()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_subrace)
end

--- Gets creature's subrace id.
function Creature:GetSubraceId()
   return 0
end

--- Gets creature's tail
function Creature:GetTail()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_tail
end

--- Gets creature's wings
function Creature:GetWings()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_wings
end

---
function Creature:SetAge(age)
   if not self:GetIsValid() then return -1 end
   self.stats.cs_age = age
   return self.stats.cs_age
end

--- Sets creature's appearance type
-- @param type Appearance type.
function Creature:SetAppearanceType(type)
   if not self:GetIsValid() then return -1 end
   
   self.stats.cs_appearance = type
   return self.stats.cs_appearance
end

--- Sets creature's body part
-- @param part
-- @param model_number
function Creature:SetBodyPart(part, model_number)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(model_number)
   nwn.engine.StackPushInteger(part)
   nwn.engine.ExecuteCommand(793, 3)
end

--- Sets creature's deity
-- @param deity New deity
function Creature:SetDeity(deity)
   if not self:GetIsValid() then return "" end
   
   if self.stats.cs_deity ~= nil then
      C.free(self.stats.cs_deity)
   end
   
   self.stats.cs_deity = C.strdup(deity)
   return deity
end

--- Sets creature's gender
-- @param gender New gender
function Creature:SetGender(gender)
   if not self:GetIsValid() then return -1 end
   self.stats.cs_gender = gender
   return self:GetGender()
end

--- Sets creature lootable
-- @param lootable New lootable value
function Creature:SetLootable(lootable)
   nwn.engine.StackPushBoolean(lootable)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(740, 2)
end

--- Set creature's subrace
-- @param subrace New subrace
function Creature:SetSubrace(subrace)
   if not self:GetIsValid() then return "" end
   
   if self.stats.cs_deity ~= nil then
      C.free(self.stats.cs_subrace)
   end
   
   self.stats.cs_subrace = C.strdup(subrace)
   self.stats.cs_subrace_len = #subrace
   return subrace
end
