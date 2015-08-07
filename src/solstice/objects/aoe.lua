----
-- This module defines the AoE area of effect class.
-- @module aoe

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local GetObjectByID = Game.GetObjectByID

local M = require 'solstice.objects.init'

local AoE = inheritsFrom({}, M.Object)
M.AoE = AoE
M.aoe_t = ffi.metatype("AoE", { __index = AoE })

--- Class AoE
-- @section

-- Gets the first object in an AoE.
-- Perfer the AoE:ObjectsInEffect iterator.
-- @param[opt=OBJECT_TYPE_CREATURE] object_mask OBJECT_TYPE_* mask.
-- @return Next object in AoE and finally OBJECT_INVALID
function AoE:GetFirstInPersistentObject(object_mask)
   object_mask = object_mask or OBJECT_TYPE_CREATURE

   NWE.StackPushInteger(0)
   NWE.StackPushInteger(object_mask)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(262, 3)
   return NWE.StackPopObject()
end

-- Gets the next object in an AoE.
-- Perfer the AoE:ObjectsInEffect iterator.
-- @param[opt=OBJECT_TYPE_CREATURE] object_mask OBJECT_TYPE_* mask.
-- @return Next object in AoE and finally OBJECT_INVALID
function AoE:GetNextInPersistentObject(object_mask)
   object_mask = object_mask or OBJECT_TYPE_CREATURE

   NWE.StackPushInteger(0)
   NWE.StackPushInteger(object_mask)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(263, 3)
   return NWE.StackPopObject()
end

--- An iterator over all objects in an AoE
-- @param[opt=OBJECT_TYPE_CREATURE] object_mask OBJECT_TYPE_* mask.
-- @return Iterator of objects satisfying the object mask.
function AoE:ObjectsInEffect(object_mask)
   object_mask = object_mask or OBJECT_TYPE_CREATURE

   return function ()
      local obj, _obj = self:GetFirstInPersistentObject(object_mask)
      while obj:GetIsValid() do
         _obj, obj = obj, self:GetNextInPersistentObject(object_mask)
         return _obj
      end
   end
end

--- Get's the creator of the AoE
-- @return The creator or OBJECT_INVALID.
function AoE:GetCreator()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return GetObjectByID(self.obj.aoe_creator)
end

--- Sets AoEs spell DC.
-- @param dc Sets spell DC
function AoE:SetSpellDC(dc)
   if not self:GetIsValid() then return -1 end
   self.obj.aoe_spell_dc = dc
   return self.obj.aoe_spell_dc
end

--- Sets AoEs spell level.
-- @param level Spell level.
function AoE:SetSpellLevel(level)
   if not self:GetIsValid() then return -1 end
   self.obj.aoe_spell_level = level
   return self.obj.aoe_spell_level
end

--- Get Spell DC.
function AoE:GetSpellDC()
   if not self:GetIsValid() then return -1 end
   return self.obj.aoe_spell_dc
end

--- Gets AoEs spell level.
function AoE:GetSpellLevel(level)
   if not self:GetIsValid() then return -1 end
   return self.obj.aoe_spell_level
end
