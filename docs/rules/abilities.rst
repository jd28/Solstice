.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Abilities
---------

.. function:: GetAbilityName(ability)

  Gets the name of an ability.

  :param int ability: ABILITY_*
  :rtype: string

.. function:: GetAbilityEffectLimits([cre[, ability]])

  Get the limits of ability effects.  Both parameters are optional, the are there merely to facilitate customizing effect limits by ability or creature, supposing someone wanted to do that.

  :param cre: Creature instance
  :type cre: :class:`Creature`
  :param int ability: ABILITY_*
  :return: -12,  12
  :rtype: int


.. function:: GetAbilityEffectModifier(cre[, ability])

  Get ability modification from effects.  The return value is not clamped or modified by :func:`GetAbilityEffectLimits`.

  .. warning::

    This currently does not provide default behavior.  Everything stacks: items, spells, etc.

  :param cre: Creature instance
  :type cre: :class:`Creature`
  :param int ability: ABILITY_*
  :rtype: If the ``ability`` parameter is not passed an array of all ability effect modifiers of length ``ABILITY_NUM`` is returned.  Note this array is static and should not be modified or stored by callers.  If the ``ability`` parameter is passed only that ability effect modifier is returned.
