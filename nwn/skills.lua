local SKILLS = {}

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

function nwn.GetSkillName(skill, abbrv)
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillName - Invalid Skill: %d\n", skill))
      return "Invalid Skill"
   end

   return abbrv and sk.abbrv or sk.name
end


function nwn.GetSkillFeatBonus(skill)
   sk = SKILLS[skill]
   if not sk then
      error(string.format("ERROR: nwn.GetSkillFeatBonus - Invalid Skill: %d\n", skill))
      return 0
   end

   local bonus = 0

   -- Focus Feats
   local foc, efoc = false, false
   efoc = sk.epic_focus and self:GetHasFeat(sk.epic_focus)
   if not efoc then
      foc = sk.focus and self:GetHasFeat(sk.focus)
   end

   if efoc then
      bonus = 13
   elseif foc then
      bonus = 3
   end

   if sk.affinity and self:GetHasFeat(sk.affinity) then
      bonus = bonus + 2
   end

   if sk.partial_affinity and self:GetHasFeat(sk.partial_affinity) then
      bonus = bonus + 1
   end


   -- TODO Other skill specific feats

   return bonus
end
