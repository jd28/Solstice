.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Immunities
----------

.. note::

  Immunities versus alignements, races, etc have not been implemented.

.. function:: DebugEffectImmunities(cre)

  Generate a debug string with effect immunity info.

  :param vs: Creature.
  :type vs: :class:`Creature`
  :rtype: ``string``


.. function:: GetEffectImmunity(cre, imm, vs)

  Determines total effect immunity.  This is the maximum of creatures innate immunity and their innate immunity plus immunity effect modifiers.  The result is not clamped by :func:`GetEffectImmunityLimits`.

  .. note::

    This function is not limited to default NWN behavior.  It was modified to facilitate a percentate immunity to an IMMUNITY_TYPE_*.  However, this doesn't modify the default behavior of item properties or :func:`effect.Immunity` so it stills work as expected.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int imm: IMMUNITY_TYPE_* constant.
  :param vs: Creature.
  :type vs: :class:`Creature`
  :rtype: ``int``

.. function:: GetEffectImmunityLimits(cre)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :rtype: 0, 100

.. function:: GetEffectImmunityModifier(cre, imm, vs)

  Determines the amount the modifier from effects.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int imm: IMMUNITY_TYPE_* constant.
  :param vs: Creature.
  :type vs: :class:`Creature`

.. function:: GetInnateImmunity(cre, imm)

  Get innate immunity.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int imm: IMMUNITY_TYPE_* constant.
  :rtype: ``int``

.. function:: SetInnateImmunityOverride(func, ...)

  :param func: Function taking a creature parameter and returning a percent immunity.
  :param ...: List of IMMUNITY_TYPE_* constants.

