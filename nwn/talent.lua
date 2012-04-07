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
function Talent:GetType()
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(362, 1)
   return nwn.engine.StackPopInteger()
end

---
function Talent:GetId()
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(363, 1)
   return nwn.engine.StackPopInteger()
end

---
function Talent:GetIsValid()
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, self)
   nwn.engine.ExecuteCommand(359, 1)
   return nwn.engine.StackPopBoolean()
end

--------------------------------------------------------------------

---
function nwn.TalentSpell(spell)
   nwn.engine.StackPushInteger(spell)
   nwn.engine.ExecuteCommand(301, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

---
function nwn.TalentFeat(feat)
   nwn.engine.StackPushInteger(feat)
   nwn.engine.ExecuteCommand(302, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

---
function nwn.TalentSkill(skill)
   nwn.engine.StackPushInteger(skill)
   nwn.engine.ExecuteCommand(303, 1)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end
