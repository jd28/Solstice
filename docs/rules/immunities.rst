.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Immunities
----------

.. function:: GetInnateImmunity(imm, cre)

  Get innate immunity.

  **Arguments**

  imm : ``int``
    IMMUNITY_TYPE\_* constant.
  cre : :class:`Creature`
    Creature instance.

.. function:: SetInnateImmunityOverride(func, ...)

  **Arguments**

  func : ``function``
    Function taking a creature parameter and returning a percent immunity.
  ... : ``int[]``
    List of IMMUNITY_TYPE\_* constants.

.. function:: GetEffectImmunity(cre, imm, vs)

  Determine if creature has an immunity.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  imm : ``int``
    IMMUNITY_TYPE\_* constant.
  vs : :class:`Creature`
    ``cre``'s attacker.