--- Associate
-- @module creature

local ffi   = require 'ffi'
local NWE   = require 'solstice.nwn.engine'

local M     = require 'solstice.objects.init'
local Creature = M.Creature

--- Associates
-- @section

function Creature:AddHenchman(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(365, 2)
end

function Creature:GetAnimalCompanionType()
   if not self:GetIsValid() then return FAMILIAR_NONE end
   return self.obj.cre_stats.cs_acomp_type
end

function Creature:GetAnimalCompanionName()
   if not self:GetIsValid() or self.obj.cre_stats.cs_acomp_name == nil then
      return ""
   end

   return ffi.string(self.obj.cre_stats.cs_acomp_name)
end

function Creature:GetAssociate(assoc_type, nth)
   NWE.StackPushInteger(nth or 1)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(assoc_type)
   NWE.ExecuteCommand(364, 3)

   return NWE.StackPopObject()
end

function Creature:GetAssociateType()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return self.obj.cre_associate_type
end

function Creature:GetFamiliarType()
   if not self:GetIsValid() then
      return FAMILIAR_NONE
   end

   return self.obj.cre_stats.cs_famil_type
end

function Creature:GetFamiliarName()
   if not self:GetIsValid() or self.obj.cre_stats.cs_famil_name == nil then
      return ""
   end

   return ffi.string(self.obj.cre_stats.cs_famil_name)
end

function Creature:GetHenchman(nth)
   NWE.StackPushInteger(nth or 1)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(354, 2)
   return NWE.StackPopObject()
end

function Creature:GetIsPossessedFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(714, 1)
   return NWE.StackPopBoolean()
end

function Creature:GetMaster()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return Game.GetObjectByID(self.obj.cre_master_id)
end

function Creature:GetLastAssociateCommand()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(321, 1)
   return NWE.StackPopInteger()
end

function Creature:LevelUpHenchman(class, ready_spells, package)
   class = class or CLASS_TYPE_INVALID
   package = package or PACKAGE_INVALID

   NWE.StackPushInteger(package)
   NWE.StackPushBoolean(ready_spells)
   NWE.StackPushInteger(class)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(704, 4)
   return NWE.StackPopInteger()
end

function Creature:RemoveHenchman(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(366, 2)
end

function Creature:RemoveSummonedAssociate(master)
   NWE.StackPushObject(self)
   NWE.StackPushObject(master)
   NWE.ExecuteCommand(503, 2)
end

function Creature:SetAssociateListenPatterns()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(327, 1);
end

function Creature:SummonAnimalCompanion()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(334, 1)
end

function Creature:SummonFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(335, 1)
end

function Creature:UnpossessFamiliar()
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(715, 1)
end
