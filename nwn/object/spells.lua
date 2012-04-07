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

require 'nwn.creature'

local ffi = require 'ffi'

ffi.cdef [[
uint32_t nl_CalculateSpellDC(Creature *cre, uint32_t spellid);
]]

---
function Object:GetCasterLevel()
   if not self:GetIsValid() then return 0 end
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(84, 1)
   return nwn.engine.StackPopInteger()
end

---
function Object:GetSpellCastAtCaster()
   if not self:GetIsValid() then return nwn.OBJECT_INVALID end
   local o = self.obj.obj.obj_last_spell_castat_caster
   return _NL_GET_CACHED_OBJECT(o)
end

---
function Object:GetSpellCastAtHarmful()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_harmful == 1
end

---
function Object:GetSpellCastAtId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_castat_id
end

---
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

---
function Object:GetSpellId()
   if not self:GetIsValid() then return -1 end
   return self.obj.obj.obj_last_spell_id
end

---
function Object:GetSpellCastItem()
   if not self:GetIsValid() then return nil end
   if not self.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return nil
   end
   local o = self.obj.cre_item_spell_item
   return _NL_GET_CACHED_OBJECT(o)
end

---
function Object:GetSpellResistance()
   return self:GetLocalInt("SR")
end

---
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

---
function Object:GetSpellTargetLocation()
   if not self:GetIsValid() then return -1 end
   local area = self:GetArea()
   local loc = self.obj.obj.obj_last_spell_location

   return location_t(loc, vector_t(0,0,0), area.id)
end

---
function Object:GetSpellTargetObject()
   if not self:GetIsValid() then return -1 end
   local o = self.obj.obj.obj_last_spell_target
   return _NL_GET_CACHED_OBJECT(o)
end


function Object:ResistSpell2(versus)
   if not self:GetIsValid() or not versus:GetIsValid()
      or self.type <= nwn.GAME_OBJECT_TYPE_AREA
   then
      return 0
   end
end