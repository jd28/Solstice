--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

--- Skills
-- @section skills

local M = require 'solstice.creature.init'

local ffi   = require 'ffi'
local NWE   = require 'solstice.nwn.engine'
local color = require 'solstice.color'
local Sk    = require 'solstice.skill'
local Obj   = require 'solstice.object'
local D     = require 'solstice.dice'
local LOG   = require 'solstice.log'

--- Determines if a creature has a skill
-- @param skill solstice.skill constant.
function M.Creature:GetHasSkill(skill)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(skill)
   NWE.ExecuteCommand(286, 2)
   return NWE.StackPopBoolean()
end

--- Determines if skill check is successful
-- @param skill solstice.skill constant
-- @param dc Difficulty Class
-- @param vs Versus a target
-- @param feedback If true sends feedback to participants.
-- @param auto If true a roll of 20 is automatic success, 1 an automatic failure
-- @param delay Delay in seconds.
-- @param take Replaces dice roll.
-- @param bonus And bonus.
function M.Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)
   return self:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus) > 0
end

--- Determine's a skill check.
-- Source: FunkySwerve on NWN bioboards
-- @param skill solstice.skill constant
-- @param dc Difficulty Class
-- @param vs Versus a target
-- @param feedback If true sends feedback to participants.
-- @param auto If true a roll of 20 is automatic success, 1 an automatic failure
-- @param delay Delay in seconds.
-- @param take Replaces dice roll.
-- @param bonus And bonus.
function M.Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)
   vs = vs or Obj.INVALID
   if feedback == nil then feedback = true end
   auto = auto or 0
   delay = delay or 0
   take = take or 0
   bonus = bonus or 0

   local ret
   local rank = self:GetSkillRank(skill, vs) + bonus
   local roll = take > 0 and take or D.d20()
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
      local msg = string.format("%s%s%s : %s : %s : (%d %s %d = %d vs. DC: %d)</c>", color.LIGHT_BLUE,
				self:GetName(), color.BLUE, Sk.GetName(skill), success, roll, 
				sign, math.abs(rank), roll + rank, dc)
      
      if vs:GetIsValid() and self.id ~= vs.id then
         vs:DelayCommand(delay, function () vs:SendMessage(msg) end)
      end
      self:DelayCommand(delay, function () self:SendMessage(msg) end)
   end

   local dbg = "Skill Check: User: %s, Versus: %s, Skill: %s, Rank: %d, Roll: %d, DC: %d, Auto: %d"
   self:Log("DebugChecks", LOG.LEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), Sk.GetName(skill),
            rank, roll, dc, auto)
   vs:Log("DebugChecks", LOG.LEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), Sk.GetName(skill),
          rank, roll, dc, auto)
   
   return ret
end

--- Gets the amount a skill was increased at a level.
-- @param level Level to check
-- @param skill solstice.skill constant
-- @return -1 on error.
function M.Creature:GetSkillIncreaseByLevel(level, skill)
   if not self:GetIsValid()
      or skill < 0 or skill > Sk.LAST
   then
      return -1
   end
   
   local ls = self:GetLevelStats(level)
   if ls == nil then return -1 end

   return ls.ls_skilllist[skill]
end

--- Returns a creatures unused skillpoints.
function M.Creature:GetSkillPoints()
   if not self:GetIsValid() then return 0 end

   return self.stats.cs_skill_points
end

-- Gets creature's skill rank.
-- @param skill solstice.skill constant
function M.Creature:GetSkillRank(skill, vs, base, no_scale)
   error "nwnxcombat"
end
--]]

--- Modifies skill rank.
-- @param skill solstice.skill constant
-- @param amount Amount to modify skill rank.
-- @param level If a level is specified the modification will occur at that level.
function M.Creature:ModifySkillRank(skill, amount, level)
   if not self:GetIsValid() or
      skill < 0 or skill > Sk.LAST
   then
      return -1
   end

   amount = self.stats.cs_skills[skill] + amount

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   if level then
      local ls = self:GetLevelStats(level)
      if ls == nil then return -1 end
      local cur = ls.ls_skilllist[skill]
      ls.ls_skilllist[skill] = cur + amount
   end

   self.stats.cs_skills[skill] = amount

   return self.stats.cs_skills[skill]
end

--- Sets a creatures skillpoints available.
-- @param amount New amount
function M.Creature:SetSkillPoints(amount)
   if not self:GetIsValid() then return 0 end

   self.stats.cs_skill_points = amount
   return self.stats.cs_skill_points
end

--- Sets a creatures skill rank
-- @param skill solstice.skill constant
-- @param amount New skill rank
function M.Creature:SetSkillRank(skill, amount)
   if not self:GetIsValid() or
      skill < 0 or skill > Sk.LAST
   then
      return -1
   end

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   self.stats.cs_skills[skill] = amount
   return self.stats.cs_skills[skill]
end
