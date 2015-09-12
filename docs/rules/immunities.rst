.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Immunities
----------

.. function:: GetInnateImmunity(imm, cre)

  Get innate immunity.

  :param int imm: IMMUNITY_TYPE_* constant.
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: SetInnateImmunityOverride(func, ...)

  :param func: Function taking a creature parameter and returning a percent immunity.
  :param ...: List of IMMUNITY_TYPE_* constants.

.. function:: GetEffectImmunity(cre, imm, vs)

  Determine if creature has an immunity.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int imm: IMMUNITY_TYPE_* constant.
  :param vs: Creature.
  :type vs: :class:`Creature`
