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
function Creature:AddHenchman(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(365, 2)
end

---
function Creature:GetAnimalCompanionType()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(498, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetAnimalCompanionName()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(500, 1)
   return nwn.engine.StackPopString()
end

---
-- @param assoc_type
-- @param nth
function Creature:GetAssociate(assoc_type, nth)
   nwn.engine.StackPushInteger(nth or 1)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(assoc_type)
   nwn.engine.ExecuteCommand(364, 3)

   return nwn.engine.StackPopObject()
end

function Creature:GetAssociateType()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   return self.obj.cre_associate_type
end

---
function Creature:GetFamiliarType()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(497, 1)
   return nwn.engine.StackPopInteger()
end

---
function Creature:GetFamiliarName()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(499, 1)
   return nwn.engine.StackPopString()
end

---
function Creature:GetHenchman(nth)
   nwn.engine.StackPushInteger(nth or 1)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(354, 2)
   return nwn.engine.StackPopObject()
end

function Creature:GetIsPossessedFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(714, 1)
   return nwn.engine.StackPopBoolean()
end

---
function Creature:GetMaster()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(319, 1)
   return nwn.engine.StackPopObject()
end

---
function Creature:GetLastAssociateCommand()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(321, 1)
   return nwn.engine.StackPopInteger()
end

function Creature:LevelUpHenchman(class, ready_spells, package)
   class = class or nwn.CLASS_TYPE_INVALID
   package = package or nwn.PACKAGE_INVALID

   nwn.engine.StackPushInteger(package)
   nwn.engine.StackPushInteger(ready_spells)
   nwn.engine.StackPushInteger(class)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(704, 4)
   return nwn.engine.StackPopInteger()
end

---
-- @param master
function Creature:RemoveHenchman(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(366, 2)
end

---
-- @param master
function Creature:RemoveSummonedAssociate(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(503, 2)
end

---
function Creature:SetAssociateListenPatterns()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(327, 1);
end

---
function Creature:SummonAnimalCompanion()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(334, 1)
end

---
function Creature:SummonFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(335, 1)
end

---
function Creature:UnpossessFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(715, 1)
end
