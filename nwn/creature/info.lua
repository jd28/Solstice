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

---
function Creature:GetAge()
   if not self:GetIsValid() then return -1 end
   return self.stats.cs_age
end

---
function Creature:GetAppearanceType()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(577, 1)
   return nwn.engine.StackPopInteger()
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
function Creature:GetHitDice()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(166, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetIsDMPossessed()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(723, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetIsEncounterCreature()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(409, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetGender(gender)
   if not self:GeIsValid() then return -1 end
   return self.stats.cs_gender
end

---
function Creature:GetPCFileName()
   error "not implemented yet"
end

---
function Creature:GetStartingPackage()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(766, 1)
   return nwn.engine.StackPopInteger()
end

---
--
function Creature:GetSubrace()
   if not self:GetIsValid() then return "" end
   return ffi.string(self.stats.cs_subrace)
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
   return self:GetAge()
end

---
-- @param type
function Creature:SetAppearanceType(type)
   nwn.engine.StackPushInteger(type)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(765, 2)
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
function Creature:SetDeity(sDeity)
   error "unimplemented"
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
   error "unimplemented"
end
