require 'nwn.effects'

local ffi = require 'ffi'
local color = require 'nwn.color'

--- Determines if a creature has a skill
-- @param skill nwn.SKILL_*
function Creature:GetHasSkill(skill)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(skill)
   nwn.engine.ExecuteCommand(286, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determines if skill check is successful
-- @param skill nwn.SKILL_*
-- @param dc Difficult Class
function Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)
   return self:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus) > 0
end

--- Determine's a skill check.
-- Source: FunkySwerve on NWN bioboards
-- @param skill nwn.SKILL_*
-- @param dc Difficult Class
-- @param vs Versus a target
-- @param feedback If true sends feedback to participants.
-- @param auto If true a roll of 20 is automatic success, 1 an automatic failure
-- @param delay Delay in seconds.
-- @param take Replaces dice roll.
-- @param bonus And bonus.
function Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)
   vs = vs or nwn.OBJECT_INVALID
   if feedback == nil then feedback = true end
   auto = auto or 0
   delay = delay or 0
   take = take or 0
   bonus = bonus or 0

   local ret
   local rank = self:GetSkillRank(skill, vs) + bonus
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
      local msg = string.format("%s%s%s : %s : %s : (%d %s %d = %d vs. DC: %d)</c>", color.LIGHT_BLUE,
				self:GetName(), color.BLUE, nwn.GetSkillName(skill), success, roll, 
				sign, math.abs(rank), roll + rank, dc)
      
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
   
   local ls = self:GetLevelStats(level)
   if ls == nil then return -1 end

   return ls.ls_skilllist[skill]
end

--- Returns a creatures unused skillpoints.
function Creature:GetSkillPoints()
   if not self:GetIsValid() then return 0 end

   return self.stats.cs_skill_points
end

--- Gets creature's skill rank.
-- @param skill nwn.SKILL_*
-- TODO replace with call to NWNXCombat
-- [[
function Creature:GetSkillRank(skill, vs, base, no_scale)
   if skill < 0 or skill > nwn.SKILL_LAST then
      error(string.format("ERROR: Creature:GetSkillRank invalid skill: %d", skill))
   end

   vs = vs or nwn.OBJECT_INVALID

   local base_sk = self.stats.cs_skills[skill]
   if base then return base_sk end

   local eff_sk = self:GetTotalEffectSkillBonus(vs, skill)
   local feat_sk = nwn.GetSkillFeatBonus(skill, self)
   local abil_sk = self:GetAbilityModifier(nwn.GetSkillAbility(skill))

   if self:GetIsBlind() then
      base_sk = base_sk - 4
   end

   -- ArmorCheck PENALTY
   if nwn.GetSkillHasArmorCheckPenalty(skill) then
      base_sk = base_sk + self:GetArmorCheckPenalty()
   end

   -- Negative Levels.
   base_sk = base_sk - self:GetTotalNegativeLevels()

   local total = base_sk + eff_sk + feat_sk + abil_sk

   -- TODO: Scale by Effective Level

   return math.clamp(total, -127, 127)
end
--]]

--- Modifies skill rank.
-- @param skill nwn.SKILL_*
-- @param amount Amount to modify skill rank.
-- @param level If a level is specified the modification will occur at that level.
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
function Creature:SetSkillPoints(amount)
   if not self:GetIsValid() then return 0 end

   self.stats.cs_skill_points = amount
   return self.stats.cs_skill_points
end

--- Sets a creatures skill rank
-- @param skill nwn.SKILL_*
-- @param amount New skill rank
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
