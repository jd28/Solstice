require 'nwn.funcs'
local ffi = require 'ffi'
local C = ffi.C


--[[
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
   --]]


--- Determines creature's maximum hitpoints.
-- TODO replace with call to NWNXCombat
--[[
function Creature:GetMaxHitPoints()
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
   --]]

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
