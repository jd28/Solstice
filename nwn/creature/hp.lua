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

require 'nwn.funcs'
local ffi = require 'ffi'
local C = ffi.C

--- Determines adjustment to maximum hitpoints by area
function Creature:GetAreaHitPointAdj()
   return 0
end

--- Determines adjustment to maximum hitpoints by class
function Creature:GetClassHitPointAdj()
   local pm = 0
   -- Pale Master
   if self:GetHasFeat(nwn.FEAT_DEATHLESS_VIGOR) then
      local pmlevel = self:GetLevelByClass(nwn.CLASS_TYPE_PALEMASTER)
      if level >= 25 then
	 pm = 18 + (pmlevel / 5) * 20
      elseif pmlevel >= 15 then
	 pm = 18 + (pmlevel / 5) * 10
      elseif pmlevel > 10 then
	 pm = 18 + (pmlevel - 10) / 5;
      elseif pmlevel - 5 > 0 then
	 pm = (pmlevel - 5) * 3
      end
   end

   return pm
end

--- Determines adjustment to maximum hitpoints by feat.
function Creature:GetFeatHitPointAdj()
   local epictough = 0
   local conmod = self:GetAbilityModifier(nwn.ABILITY_CONSTITUTION)
   local level = self:GetHitDice()
   local hp = 0
   
   -- Toughness grants + 1 HP per level
   if self:GetHasFeat(nwn.FEAT_TOUGHNESS) then
      hp = hp + level
   end
    
   -- Epic toughness
   local feat = self:GetHighestFeatInRange(nwn.FEAT_EPIC_TOUGHNESS_1, nwn.FEAT_EPIC_TOUGHNESS_10)
   if feat ~= -1 then
      epictough = 20 * (feat - nwn.FEAT_EPIC_TOUGHNESS_1 + 1) 
   end

   hp = hp + epictough
   
   return hp
end

--- Determines adjustment to maximum hitpoints by combat mode
function Creature:GetModeHitPointAdj()
   return 0
end

--- Determines adjustment to maximum hitpoints by racial type
function Creature:GetRaceHitPointAdj()
   return 0
end

--- Determines adjustment to maximum hitpoints by creature size
function Creature:GetSizeHitPointAdj()
   return 0
end

-- Determines adjustment to maximum hitpoints by skill points
function Creature:GetSkillHitPointAdj()
   return 0
end

--- Determines creature's maximum hitpoints.
function Creature:GetMaxHitPoints()
   print("NSGetMaxHitPoints", self:GetName(), dunno)
   if not self:GetIsValid() then return 0 end
   local hp = 0
   local level = self:GetHitDice()
   local conmod = self.stats.cs_con_mod

   -- Constitution bonus
   hp = hp + (conmod * level)

   -- Effect hitpoints
   hp = hp + self:GetEffectHitpointBonus()

   -- Hit point adjustments.
   -- Note there is no Favored Enemy or situational bonuses for 
   -- HP as the value can't be determined VS some other creature.
   hp = hp + self.ci.area.hp
   hp = hp + self.ci.class.hp
   hp = hp + self.ci.feat.hp
   hp = hp + self.ci.mode.hp
   hp = hp + self.ci.size.hp
   hp = hp + self.ci.skill.hp

   -- Base Hit points
   if self.stats.cs_is_pc == 1 and not self:GetIsPossessedFamiliar() then
      local ls
      for i = 0, level do
	 ls = self:GetLevelStats(i)
	 if ls ~= nil then
	    hp = hp + ls.ls_hp
	 end
      end
      -- Set the objects new max HP
      self.obj.obj.obj_hp_max = hp
   else
      -- Maximum HP of creatures from levels is not determined 
      -- by Level stats but by a value stored on the creature.
      hp = hp + self.obj.obj.obj_hp_max;
   end

   -- Minimum Max Hitpoints.  This is solely to project against crashes
   -- Caused by DMs that have 0 or less max HP
   if hp <= 0 then hp = 10 end

   return hp
end

--- Get max hit points by level
-- @param level The level in question.
function Creature:GetMaxHitPointsByLevel(level)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   return ls.ls_hp
end

--- Set max hitpoints by level.
-- @param level The level in question.
-- @param hp Amount of hitpoints.
function Creature:SetMaxHitPointsByLevel(level, hp)
   if not self:GetIsValid() then return 0 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return 0 end

   ls.ls_hp = hp

   return ls.ls_hp
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Get Maximum Hit Points
-- @param cre Creature object ID.
-- @param dunno A value that always seems to be 1.
function NSGetMaxHitPoints(cre, dunno)
   cre = _NL_GET_CACHED_OBJECT(cre)
   return cre:GetMaxHitPoints()
end
