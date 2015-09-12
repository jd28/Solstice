.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Combat Modifiers
----------------

.. function:: ZeroCombatModifier(cre, mod)

  :param cre: Creture instance.
  :type cre: :class:`Creature`
  :param int mod: COMBAT_MOD_*

.. function:: GetAreaCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetClassCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetFeatCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetRaceCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetSizeCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetSkillCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetTrainingVsCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetFavoredEnemyCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: GetAbilityCombatModifier(cre)

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: ResolveCombatModifier(type, cre)

  Resolves combat modifier.

  :param int type: COMBAT_MOD\_*
  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: ResolveCombatModifiers(cre)

  Resolves all combat modifiers

  :param cre: Creture instance.
  :type cre: :class:`Creature`

.. function:: SetCombatModifierOverride(type, func)

  Sets combat modifier override.

  :param int type: COMBAT_MOD_*
  :param function func: (:class:`Creature`) -> ``nil``