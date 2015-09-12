.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Skills
------

.. function:: GetSkillAbility(skill)

  Get skill's associated ability.

  :param int skill: SKILL_*

.. function:: GetSkillAllCanUse(skill)

  Check if skill requires training.

  :param int skill: SKILL_*

.. function:: GetSkillHasArmorCheckPenalty(skill)

  Check if skill has armor check penalty.

  :param int skill: SKILL_*

.. function:: GetSkillIsUntrained(skill)

  Check if skill requires training.

  :param int skill: SKILL_*

.. function:: GetSkillName(skill)

  Get Skill name.

  :param int skill: SKILL_*

.. function:: GetSkillArmorCheckPenalty(cre, skill)

  Determine penalty from armor/shield.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*

.. function:: GetSkillFeatBonus(cre, skill)

  Get Skill Bonuses from feats.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*

.. function:: GetSkillEffectLimits(cre, skill)

  Get the limits of skill effects

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*
  :rtype: -50, 50

.. function:: GetSkillEffectModifier(cre, skill)

  Get skill modification from effects.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*

.. function:: CanUseSkill(skill, cre)

  Determines if a creature can use a skill.

  :param int skill: SKILL_*
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsClassSkill(skill, class)

  Determines if a skill is a class skill.

  :param int skill: SKILL_*
  :param int class: CLASS_TYPE_*
