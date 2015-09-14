.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Modes
-----

.. function:: RegisterMode(mode, f)

  Register a combat mode.

.. function:: ResolveMode(mode, cre, off)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: ToAction(mode)

  Convert mode to ACTION_* constant