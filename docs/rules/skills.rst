.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Skills
------

.. function:: CanUseSkill(skill, cre)

  Determines if a creature can use a skill.

  :param int skill: SKILL_*
  :param cre: Creature.
  :type cre: :class:`Creature`
  :rtype: ``boolean``

.. function:: GetIsClassSkill(skill, class)

  Determines if a skill is a class skill.

  :param int skill: SKILL_*
  :param int class: CLASS_TYPE_*
  :rtype: ``boolean``

.. function:: GetSkillAbility(skill)

  Get skill's associated ability.

  :param int skill: SKILL_*
  :rtype: ABILITY_* or -1

.. function:: GetSkillAllCanUse(skill)

  Check if skill requires training.

  :param int skill: SKILL_*
  :rtype: ``boolean``

.. function:: GetSkillArmorCheckPenalty(cre, skill)

  Determine penalty from armor/shield.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*
  :rtype: ``int``

.. function:: GetSkillEffectLimits([cre[, skill]])

  Get the limits of skill effects.  Both parameters are optional, the are there merely to facilitate customizing effect limits by skill or creature, supposing someone wanted to do that.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*
  :rtype: -50, 50

.. function:: GetSkillEffectModifier(cre[, skill])

  Get skill modification from effects.  The return value is not clamped or modified by :func:`GetSkillEffectLimits`.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*
  :rtype: If the ``skill`` parameter is not passed an array of all skill effect modifiers of length ``SKILL_NUM`` is returned.  Note this array is static and should not be modified or stored by callers.  If the ``skill`` parameter is passed only that skill effect modifier is returned.

.. function:: GetSkillFeatBonus(cre, skill)

  Get Skill Bonuses from feats.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int skill: SKILL_*
  :rtype: ``int``

.. function:: GetSkillHasArmorCheckPenalty(skill)

  Check if skill has armor check penalty.

  :param int skill: SKILL_*
  :rtype: ``boolean``

.. function:: GetSkillIsUntrained(skill)

  Check if skill requires training.

  :param int skill: SKILL_*
  :rtype: ``boolean``

.. function:: GetSkillName(skill)

  Get Skill name.

  :param int skill: SKILL_*
  :rtype: ``string``
