.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Concealment
-----------

.. function:: GetConcealment(cre, vs, is_ranged)

  Determine concealment.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  vs : :class:`Creature`
    Creature instance.
  is_ranged : ``bool``
    Check versus ranged attack.