----
-- @module object

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'
local Vec = require 'solstice.vector'
local Object = M.Object
local GetObjectByID = Game.GetObjectByID

--- Class Object: Spells
-- @section spells

function Object:GetCasterLevel()
   if not self:GetIsValid() then return 0 end
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(84, 1)
   return NWE.StackPopInteger()
end

function Object:GetSpellCastAtCaster()
   if not self:GetIsValid() then return M.INVALID end
   local o = self.obj.obj.obj_last_spell_castat_caster
   return GetObjectByID(o)
end

function Object:GetSpellCastAtHarmful()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_harmful == 1
end

function Object:GetSpellCastAtId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_id
end

function Object:GetSpellCastClass()
   if not self:GetIsValid() then return -1 end

   local pos = self.obj.obj.obj_last_spell_multiclass
   if self:GetType() == OBJECT_TYPE_CREATURE
      and self.obj.cre_stats.cs_class_len > pos
   then
      return self.obj.cre_stats.cs_classes[pos].cl_class
   end

   return -1
end

function Object:GetSpellId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_id
end

function Object:GetSpellCastItem()
   if not self:GetIsValid() then return nil end
   if not self:GetType() == OBJECT_TYPE_CREATURE then
      return M.INVALID
   end
   local o = self.obj.cre_item_spell_item
   return GetObjectByID(o)
end

function Object:GetSpellResistance()
   return self:GetLocalInt("SR")
end

function Object:GetSpellSaveDC(spell)
   local dc = 14

   if not self:GetIsValid() then return dc end

   if self:GetType() == OBJECT_TYPE_CREATURE then
      dc = ffi.C.nl_CalculateSpellDC(self, spell)
   elseif self:GetType() == OBJECT_TYPE_AREA_OF_EFFECT then
      dc = self:GetSpellDC()
   end

   return dc
end

function Object:GetSpellTargetLocation()
   if not self:GetIsValid() then return -1 end
   local area = self:GetArea()
   local loc = self.obj.obj.obj_last_spell_location

   return location_t(loc, Vec.vector_t(0,0,0), area.id)
end

function Object:GetSpellTargetObject()
   if not self:GetIsValid() then return M.INVALID end
   local o = self.obj.obj.obj_last_spell_target
   return GetObjectByID(o)
end
