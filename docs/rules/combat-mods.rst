.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Combat Modifiers
----------------

.. function:: ZeroCombatModifier(cre, mod)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  mod : ``int``
    COMBAT_MOD_*

.. function:: GetAreaCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetClassCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetFeatCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetRaceCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetSizeCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetSkillCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetTrainingVsCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetFavoredEnemyCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetAbilityCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: ResolveCombatModifier(type, cre)

  Resolves combat modifier.

  **Arguments**

  type : ``int``
    COMBAT_MOD\_*
  cre : :class:`Creature`
    Creature instance.

.. function:: ResolveCombatModifiers(cre)

  Resolves all combat modifiers

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: SetCombatModifierOverride(type, func)

  Sets combat modifier override.

  **Arguments**

  type : ``int``
    COMBAT_MOD\_*
  func : ``function``
    (:class:`Creature`) -> ``nil``