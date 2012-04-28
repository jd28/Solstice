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

---
function Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_age
end

---
function Creature:GetAppearanceType()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_appearance
end

---
-- @param part
function Creature:GetBodyPart(part)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(part)
   nwn.engine.ExecuteCommand(792, 2)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetConversation()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_conv)
end

---
function Creature:GetSize()
   return self.obj.cre_size
end

---
function Creature:GetDeity()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_deity)
end

---
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

---
function Creature:GetIsDMPossessed()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(723, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetIsEncounterCreature()
   if not self:GeIsValid() then return false end
   return self.obj.cre_encounter_obj ~= nwn.OBJECT_INVALID.id
end

---
function Creature:GetGender(gender)
   if not self:GeIsValid() then return -1 end
   return self.stats.cs_gender
end

---
function Creature:GetPCFileName()
   if not self:GetIsValid() then return "" end

   local pl = C.nwn_GetPlayerByID(self.id)
   return ffi.string(pl.pl_bicfile)
end

---
function Creature:GetRacialType()
   if not self:GetIsValid() then
      return nwn.RACIAL_TYPE_INVALID
   end

   return self.stats.cs_race
end

---
function Creature:GetStartingPackage()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_starting_package
end

---
--
function Creature:GetSubrace()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_subrace)
end

---
function Creature:GetSubraceId()
   return 0
end

---
function Creature:GetTail()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_tail
end

---
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

---
-- @param type
function Creature:SetAppearanceType(type)
   if not self:GetIsValid() then return -1 end
   
   self.stats.cs_appearance = type
   return self.stats.cs_appearance
end

---
-- @param part
-- @param model_number
function Creature:SetBodyPart(part, model_number)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(model_number)
   nwn.engine.StackPushInteger(part)
   nwn.engine.ExecuteCommand(793, 3)
end

---
--
function Creature:SetDeity(deity)
   if not self:GetIsValid() then return "" end
   
   if self.stats.cs_deity ~= nil then
      C.free(self.stats.cs_deity)
   end
   
   self.stats.cs_deity = C.strdup(deity)
   return deity
end

---
-- @param gender
function Creature:SetGender(gender)
   if not self:GetIsValid() then return -1 end
   self.stats.cs_gender = gender
   return self:GetGender()
end

---
-- @param lootable
function Creature:SetLootable(lootable)
   nwn.engine.StackPushBoolean(lootable)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(740, 2)
end

---
--
function Creature:SetSubrace(subrace)
   if not self:GetIsValid() then return "" end
   
   if self.stats.cs_deity ~= nil then
      C.free(self.stats.cs_subrace)
   end
   
   self.stats.cs_subrace = C.strdup(subrace)
   self.stats.cs_subrace_len = #subrace
   return subrace
end
