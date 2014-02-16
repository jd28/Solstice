--- Associate
-- @module creature

local ffi   = require 'ffi'
local NWE   = require 'solstice.nwn.engine'

local M     = require 'solstice.creature.init'

--- Associates
-- @section

--- Adds a henchman NPC to a PC.
-- @param master NPCs new master.
function M.Creature:AddHenchman(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(365, 2)
end

--- Get a creature's familiar creature type.
-- @return FAMILIAR_*
function M.Creature:GetAnimalCompanionType()
   if not self:GetIsValid() then return Assoc.FAMILIAR_NONE end
   return self.stats.cs_acomp_type
end

--- Gets a creature's familiar name.
function M.Creature:GetAnimalCompanionName()
   if not self:GetIsValid() or self.stats.cs_acomp_name == nil then
      return ""
   end

   return ffi.string(self.stats.cs_acomp_name)
end

--- Returns an object's associate.
-- @param assoc_type solstice.associate type constant.
-- @param nth Which associate to return. (Default: 1)
function M.Creature:GetAssociate(assoc_type, nth)
   NWE.StackPushInteger(nth or 1)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(assoc_type)
   NWE.ExecuteCommand(364, 3)

   return NWE.StackPopObject()
end

--- Returns the associate type of the specified creature
-- @return solstice.associate type constant.
function M.Creature:GetAssociateType()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return self.obj.cre_associate_type
end

--- Gets the creature's familiar creature type.
-- @return FAMILIAR_*
function M.Creature:GetFamiliarType()
   if not self:GetIsValid() then
      return Assoc.FAMILIAR_NONE
   end

   return self.stats.cs_famil_type
end

--- Gets the creature's familiar creature name.
function M.Creature:GetFamiliarName()
   if not self:GetIsValid() or self.stats.cs_famil_name == nil then
      return ""
   end

   return ffi.string(self.stats.cs_famil_name)
end

--- Gets the nth henchman of a PC.
function M.Creature:GetHenchman(nth)
   NWE.StackPushInteger(nth or 1)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(354, 2)
   return NWE.StackPopObject()
end

--- Retrieves the controller status of a familiar.
function M.Creature:GetIsPossessedFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(714, 1)
   return NWE.StackPopBoolean()
end

--- Determines who controls a creature.
function M.Creature:GetMaster()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(319, 1)
   return NWE.StackPopObject()
end

--- Get the last command issued to a given associate.
-- @return COMMAND_*
function M.Creature:GetLastAssociateCommand()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(321, 1)
   return NWE.StackPopInteger()
end

--- Levels up a creature using the default settings.
-- @param[opt=CLASS_TYPE_INVALID] class CLASS\_TYPE\_*
-- @param[opt=false] ready_spells Determines if all memorizable spell slots will be
-- filled without requiring rest.
-- @param[opt=PACKAGE_INVALID] package PACKAGE\_*
function M.Creature:LevelUpHenchman(class, ready_spells, package)
   class = class or CLASS_TYPE_INVALID
   package = package or PACKAGE_INVALID

   NWE.StackPushInteger(package)
   NWE.StackPushBoolean(ready_spells)
   NWE.StackPushInteger(class)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(704, 4)
   return NWE.StackPopInteger()
end

--- Removes the henchmen from the employ of a PC.
-- @param master Henchman's master
function M.Creature:RemoveHenchman(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(366, 2)
end

--- Removes an associate NPC from the service of a PC.
-- @param master Creature's master.
function M.Creature:RemoveSummonedAssociate(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(503, 2)
end

--- Prepares an associate (henchman, summoned, familiar) to be commanded.
function M.Creature:SetAssociateListenPatterns()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(327, 1);
end

--- Summons creature's animal companion
function M.Creature:SummonAnimalCompanion()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(334, 1)
end

--- Summons creature's familiar
function M.Creature:SummonFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(335, 1)
end

--- Unpossesses a familiar from its controller.
function M.Creature:UnpossessFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(715, 1)
end
