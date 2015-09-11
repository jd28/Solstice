.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Abilities
---------

.. function:: GetAbilityName(ability)

  Gets the name of an ability.

  :param int ability: ABILITY_*
  :rtype: string

.. function:: GetAbilityEffectLimits(cre, ability)

  Get the limits of ability effects

  :param cre: Creature instance
  :type cre: :class:`Creature`
  :param int ability: ABILITY_*
  :return: -12,  12
  :rtype: int


.. function:: GetAbilityEffectModifier(cre, ability)

  Get ability modification from effects.

  .. warning::
    This currently does not provide default behavior.  Everything stacks: items, spells, etc.

  :param cre: Creature instance
  :type cre: :class:`Creature`
  :param int ability: ABILITY_*
  :rtype: int
