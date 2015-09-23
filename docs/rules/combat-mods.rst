.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Combat Modifiers
----------------

.. function:: GetCombatModifier(type, modifier, cre)

  :param int type: COMBAT_MOD_*
  :param int modifier: ATTACK_MODIFIER_*
  :param cre: Creature.
  :type cre: :class:`Creature`


.. function:: RegisterComabtModifier(type, func)

  :param int type: COMBAT_MOD_*
  :param function func: A function taking two parameters: an ATTACK_MODIFIER_* constant and a :class:`Creature` instance.
