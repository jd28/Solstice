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

--- Adds a henchman NPC to a PC.
-- @param master NPCs new master.
function Creature:AddHenchman(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(365, 2)
end

--- Get a creature's familiar creature type.
-- @return nwn.FAMILIAR_CREATURE_TYPE_*
function Creature:GetAnimalCompanionType()
   if not self:GetIsValid() then return nwn.FAMILIAR_CREATURE_TYPE_NONE end
   return self.stats.cs_acomp_type
end

--- Gets a creature's familiar name.
function Creature:GetAnimalCompanionName()
   if not self:GetIsValid() or self.stats.cs_acomp_name == nil then
      return "" 
   end

   return ffi.string(self.stats.cs_acomp_name)
end

--- Returns an object's associate.
-- @param assoc_type nwn.ASSOCIATE_TYPE_*
-- @param nth Which associate to return. (Default: 1) 
function Creature:GetAssociate(assoc_type, nth)
   nwn.engine.StackPushInteger(nth or 1)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(assoc_type)
   nwn.engine.ExecuteCommand(364, 3)

   return nwn.engine.StackPopObject()
end

--- Returns the associate type of the specified creature
-- @return nwn.ASSOCIATE_TYPE_*
function Creature:GetAssociateType()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   return self.obj.cre_associate_type
end

--- Gets the creature's familiar creature type.
-- @return nwn.FAMILIAR_CREATURE_TYPE_*
function Creature:GetFamiliarType()
   if not self:GetIsValid() then
      return nwn.FAMILIAR_CREATURE_TYPE_NONE
   end

   return self.stats.cs_famil_type
end

--- Gets the creature's familiar creature name.
function Creature:GetFamiliarName()
   if not self:GetIsValid() or self.stats.cs_famil_name == nil then
      return "" 
   end

   return ffi.string(self.stats.cs_famil_name)
end

--- Gets the nth henchman of a PC.
function Creature:GetHenchman(nth)
   nwn.engine.StackPushInteger(nth or 1)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(354, 2)
   return nwn.engine.StackPopObject()
end

--- Retrieves the controller status of a familiar.
function Creature:GetIsPossessedFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(714, 1)
   return nwn.engine.StackPopBoolean()
end

--- Determines who controls a creature.
function Creature:GetMaster()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(319, 1)
   return nwn.engine.StackPopObject()
end

--- Get the last command issued to a given associate.
-- @return nwn.ASSOCIATE_COMMAND_*
function Creature:GetLastAssociateCommand()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(321, 1)
   return nwn.engine.StackPopInteger()
end

--- Levels up a creature using the default settings.
-- @param class nwn.CLASS_TYPE_* (Default: nwn.CLASS_TYPE_INVALID)
-- @param ready_spells Determines if all memorizable spell slots will be 
--    filled without requiring rest. (Default: false)
-- @param package nwn.PACKAGE_* (Default: nwn.PACKAGE_INVALID) 
function Creature:LevelUpHenchman(class, ready_spells, package)
   class = class or nwn.CLASS_TYPE_INVALID
   package = package or nwn.PACKAGE_INVALID

   nwn.engine.StackPushInteger(package)
   nwn.engine.StackPushBoolean(ready_spells)
   nwn.engine.StackPushInteger(class)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(704, 4)
   return nwn.engine.StackPopInteger()
end

--- Removes the henchmen from the employ of a PC.
-- @param master Henchman's master
function Creature:RemoveHenchman(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(366, 2)
end

--- Removes an associate NPC from the service of a PC.
-- @param master Creature's master.
function Creature:RemoveSummonedAssociate(master)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(master)
   nwn.engine.ExecuteCommand(503, 2)
end

--- Prepares an associate (henchman, summoned, familiar) to be commanded.
function Creature:SetAssociateListenPatterns()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(327, 1);
end

--- Summons creature's animal companion
function Creature:SummonAnimalCompanion()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(334, 1)
end

--- Summons creature's familiar
function Creature:SummonFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(335, 1)
end

--- Unpossesses a familiar from its controller.
function Creature:UnpossessFamiliar()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(715, 1)
end
