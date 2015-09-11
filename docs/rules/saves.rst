.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Saves
-----

.. function:: GetSaveEffectLimits(cre, save, save_vs)

  Get save effect limits.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  save
    SAVING_THROW\_* constant.
  save_vs
    SAVING_THROW_VS\_* constant.

  **Returns**

  - -20
  - 20

.. function:: GetSaveEffectBonus(cre, save, save_vs)

  Get save effect bonus unclamped.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.