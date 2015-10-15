.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Concealment
-----------

.. function:: GetConcealment(cre, vs, is_ranged)

  Determine concealment.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param vs: Creature instance.
  :type vs: :class:`Creature`
  :param bool is_ranged: Check versus ranged attack.

.. function:: GetMissChance(cre, is_ranged)

  Determine miss chance.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param bool is_ranged: Check versus ranged attack.
