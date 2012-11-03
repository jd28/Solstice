local SKILLS = {}
local bit = require 'bit'

function nwn.RegisterSkill(skill, name, abbrv, ability, focus, epic_focus, affinity, partial_affinity, armor_check)
   SKILLS[skill] = { name = name,
		     abbrv = abbrv,
		     ability = ability,
		     focus = focus,
		     epic_focus = epic_focus,
		     affinity = affinity, 
		     partial_affinity = partial_affinity,
		     armor_check = armor_check
   }
end

function nwn.GetSkillAbility(skill)
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillAbility - Invalid Skill: %d\n", skill))
      return "Invalid Skill"
   end

   return sk.ability
end

function nwn.GetSkillHasArmorCheckPenalty(skill)
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillHasArmorCheckPenalty - Invalid Skill: %d\n", skill))
      return "Invalid Skill"
   end
   return sk.armor_check
end

function nwn.GetSkillName(skill, abbrv)
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillName - Invalid Skill: %d\n", skill))
      return "Invalid Skill"
   end

   return abbrv and sk.abbrv or sk.name
end


function nwn.GetSkillFeatBonus(skill, cre)
   if not cre:GetIsValid() then return 0 end
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillFeatBonus - Invalid Skill: %d\n", skill))
      return 0
   end

   local bonus = 0

   -- Focus Feats
   local foc, efoc = false, false
   efoc = sk.epic_focus and cre:GetHasFeat(sk.epic_focus)
   if not efoc then
      foc = sk.focus and cre:GetHasFeat(sk.focus)
   end

   if efoc then
      bonus = 13
   elseif foc then
      bonus = 3
   end

   if sk.affinity and cre:GetHasFeat(sk.affinity) then
      bonus = bonus + 2
   end

   if sk.partial_affinity and cre:GetHasFeat(sk.partial_affinity) then
      bonus = bonus + 1
   end

   if skill == nwn.SKILL_PERSUADE then
      if cre:GetHasFeat(nwn.FEAT_EPIC_REPUTATION) then
	 bonus = bonus + 4
      end
      if cre:GetHasFeat(nwn.FEAT_THUG) then
	 bonus = bonus + 2
      end
      if cre:GetHasFeat(nwn.FEAT_SILVER_PALM) then
	 bonus = bonus + 2
      end
   elseif skill == nwn.SKILL_MOVE_SILENTLY then
      local area = cre:GetArea()
      local area_type = area:GetType()
      if bit.band(area_type, 4) ~= 0
	 and bit.band(area_type, 1) == 0
	 and bit.band(area_type, 2) == 0
	 and cre:GetHasFeat(nwn.FEAT_TRACKLESS_STEP)
      then
	 bonus = bonus + 4
      end
   elseif skill == nwn.SKILL_SPOT then
      if cre:GetHasFeat(nwn.FEAT_BLOODED) then
	 bonus = bonus + 2
      end
   end

   return bonus
end
