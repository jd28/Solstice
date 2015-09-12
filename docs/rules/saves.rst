.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Saves
-----

.. function:: GetSaveEffectLimits(cre, save, save_vs)

  Get save effect limits.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param int save: SAVING_THROW_* constant.
  :param int save_vs: SAVING_THROW_VS_* constant.
  :rtype: -20, 20

.. function:: GetSaveEffectBonus(cre, save, save_vs)

  Get save effect bonus unclamped.

  :param cre: Creature.
  :type cre: :class:`Creature`