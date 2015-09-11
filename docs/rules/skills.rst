.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Skills
------

.. function:: GetSkillAbility(skill)

  Get skill's associated ability.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillAllCanUse(skill)

  Check if skill requires training.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillHasArmorCheckPenalty(skill)

  Check if skill has armor check penalty.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillIsUntrained(skill)

  Check if skill requires training.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillName(skill)

  Get Skill name.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillArmorCheckPenalty(cre, skill)

  Determine penalty from armor/shield.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: GetSkillFeatBonus(cre, skill)

  Get Skill Bonuses from feats.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: GetSkillEffectLimits(cre, skill)

  Get the limits of skill effects

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

  **Returns**

  - -50
  - 50

.. function:: GetSkillEffectModifier(cre, skill)

  Get skill modification from effects.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: CanUseSkill(skill, cre)

  Determines if a creature can use a skill.

  **Arguments**

  skill : ``int``
    SKILL_*
  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsClassSkill(skill, class)

  Determines if a skill is a class skill.

  **Arguments**

  skill : ``int``
    SKILL_*
  class : ``int``
    CLASS_TYPE_*
