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

local ne = nwn.engine

--- Determines whether a creature has a specific talent.
-- @param talent The talent which will be checked for on the given creature.
function Creature:GetHasTalent(talent)
   ne.StackPushObject(self)
   ne.StackPushEngineStructure(ENGINE_STRUCTURE_TALENT, talent)
   ne.ExecuteCommand(306, 2)
   return ne.StackPopBoolean()
end

--- Determines the best talent of a creature from a group of talents.
-- @param category nwn.TALENT_CATEGORY_*
-- @param cr_max The maximum Challenge Rating of the talent.
function Creature:GetTalentBest(category, cr_max)
   ne.StackPushObject(self)
   ne.StackPushInteger(cr_max)
   ne.StackPushInteger(category)
   ne.ExecuteCommand(308, 3)
   return ne.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

--- Retrieves a random talent from a group of talents that a creature possesses.
-- @param category nwn.TALENT_CATEGORY_*
function Creature:GetTalentRandom(category)
   ne.StackPushObject(self)
   ne.StackPushInteger(category)
   ne.ExecuteCommand(307, 2)
   return ne.StackPopEngineStructure(ENGINE_STRUCTURE_TALENT)
end

