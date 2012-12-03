--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.creature'

local ffi = require 'ffi'

ffi.cdef [[
uint32_t nl_CalculateSpellDC(Creature *cre, uint32_t spellid);
]]

--- Determines caster level
function Object:GetCasterLevel()
   if not self:GetIsValid() then return 0 end
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(84, 1)
   return nwn.engine.StackPopInteger()
end

--- Gets the caster of the last spell
function Object:GetSpellCastAtCaster()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local o = self.obj.obj.obj_last_spell_castat_caster
   return _NL_GET_CACHED_OBJECT(o)
end

--- Determine if the last spell cast at object is harmful
function Object:GetSpellCastAtHarmful()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_harmful == 1
end

--- Determine spell id of the last spell cast at object
function Object:GetSpellCastAtId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_id
end

--- Determine class of the last spell cast at object
function Object:GetSpellCastClass()
   if not self:GetIsValid() then return -1 end

   local pos = self.obj.obj.obj_last_spell_multiclass
   if self.type == GAME_OBJECT_TYPE_CREATURE 
      and self.obj.cre_stats.cs_class_len > pos
   then
      return self.obj.cre_stats.cs_classes[pos].cl_class
   end

   return -1
end

--- Get spell id of that last spell cast
function Object:GetSpellId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_id
end

--- Get item of that last spell cast
function Object:GetSpellCastItem()
   if not self:GetIsValid() then return nil end
   if not self.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return nwn.OBJECT_INVALID
   end
   local o = self.obj.cre_item_spell_item
   return _NL_GET_CACHED_OBJECT(o)
end

--- Get spell resitance.
function Object:GetSpellResistance()
   return self:GetLocalInt("SR")
end

--- Determine spell save DC.
function Object:GetSpellSaveDC(spell)
   local dc = 14

   if not self:GetIsValid() then return dc end

   if self.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      dc = ffi.C.nl_CalculateSpellDC(self, spell)
   elseif self.type == nwn.GAME_OBJECT_TYPE_AOE then
      dc = 1
   end

   return dc
end

--- Get spell target location
function Object:GetSpellTargetLocation()
   if not self:GetIsValid() then return -1 end
   local area = self:GetArea()
   local loc = self.obj.obj.obj_last_spell_location

   return location_t(loc, vector_t(0,0,0), area.id)
end

--- Get last spell target
function Object:GetSpellTargetObject()
   if not self:GetIsValid() then return -1 end
   local o = self.obj.obj.obj_last_spell_target
   return _NL_GET_CACHED_OBJECT(o)
end

