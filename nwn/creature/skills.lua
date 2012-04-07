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

---
-- @param skill
function Creature:GetHasSkill(skill)
   ne.StackPushObject(self)
   ne.StackPushInteger(skill)
   ne.ExecuteCommand(286, 2)
   return ne.StackPopBoolean()
end

---
-- @param skill
-- @param dc
function Creature:GetIsSkillSuccessful(skill, dc)
   return self:GetSkillCheckResult(skill, dc) > 0
end

---
-- Source: FunkySwerve on NWN bioboards
-- @param skill
-- @param dc
-- @param vs
-- @param feedback
-- @param auto
-- @param delay
-- @param take
-- @param bonus
function Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)
   vs = vs or nwn.OBJECT_INVALID
   if feedback == nil then feedback = true end
   auto = auto or 0
   delay = delay or 0
   take = take or 0
   bonus = bonus or 0

   local ret
   local rank = self:GetSkillRank(skill) + bonus
   local roll = take > 0 and take or nwn.d20()
   local sign = rank >= 0 and " + " or " - "

   local success
   if rank + 20 < dc and auto <= 0 then
      success = "*success not possible*"
      ret = 0
   elseif auto == 1 and roll == 20 then
      success = "*automatic success*"
      ret = 2
   elseif auto == 2 and roll == 1 and rank - bonus < dc - 1 then
      success = "*automatic failure"
      ret = 0
   elseif auto == 1 and roll == 1 then
      success = "*critical failure*"
      ret = -1
   elseif rank + roll < dc then
     success = "*failure*"
     ret = 0
   else
      success = "*success*";
      ret = 1
   end

   if auto < 0 and ret > 0 then
      ret = 1 + ((rank + roll) - dc)
   end

   if feedback and (self:GetIsPC() or vs:GetIsPC()) then
      local msg = string.format("<> %s <> : %s : %s : (%d %s %d = %d vs. DC: %d)</c>", self:GetName(),
                                nwn.GetSkillName(skill), success, roll, sign, math.abs(rank), roll + rank, dc)
      
      if vs:GetIsValid() and self.id ~= vs.id then
         vs:DelayCommand(delay, function () vs:SendMessage(msg) end)
      end
      self:DelayCommand(delay, function () self:SendMessage(msg) end)
   end

   local dbg = "Skill Check: User: %s, Versus: %s, Skill: %s, Rank: %d, Roll: %d, DC: %d, Auto: %d"
   self:Log("DebugChecks", nwn.LOGLEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), nwn.GetSkillName(skill),
            rank, roll, dc, auto)
   vs:Log("DebugChecks", nwn.LOGLEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), nwn.GetSkillName(skill),
          rank, roll, dc, auto)
   
   return ret
end

--- Gets the amount a skill was increased at a level.
-- @param level Level to check
-- @param skill nwn.SKILL_*
-- @return -1 on error.
function Creature:GetSkillIncreaseByLevel(level, skill)
   if not self:GetIsValid()
      or skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end
   
   local ls = ffi.C.nl_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_skilllist[skill]
end

--- Returns a creatures unused skillpoints.
function Creature:GetSkillPoints()
   if not self:GetIsValid() then return 0 end

   return self.stats.cs_skill_points
end

---
--
function Creature:GetSkillRank(skill, base)
   ne.StackPushBoolean(base)
   ne.StackPushObject(self)
   ne.StackPushInteger(skill)
   ne.ExecuteCommand(315, 3)
   return ne.StackPopInteger()
end

---
function Creature:ModifySkillRank(skill, amount, level)
   if not self:GetIsValid() or
      skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end

   amount = self.stats.cs_skills[skill] + amount

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   if level then
      local ls = ffi.C.nl_GetLevelStats(level)
      if ls == nil then return -1 end
      local cur = ls.ls_skilllist[skill]
      ls.ls_skilllist[skill] = cur + amount
   end

   self.stats.cs_skills[skill] = amount

   return self.stats.cs_skills[skill]
end

---
--
function Creature:SetSkillPoints(amount)
   if not self:GetIsValid() then return 0 end

   self.stats.cs_skill_points = amount
   return self.stats.cs_skill_points
end

---
function Creature:SetSkillRank(skill, amount)
   if not self:GetIsValid() or
      skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   self.stats.cs_skills[skill] = amount
   return self.stats.cs_skills[skill]
end