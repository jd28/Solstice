.. highlight:: lua
.. default-domain:: lua

.. module:: dice

Dice
====

.. function:: Roll(dice, sides, bonus, times)

  Rolls arbitrary dice.

  :param int dice: Number of dice to roll
  :param int sides: Number of sides the dice have
  :param int bonus: Bonus added to roll
  :param int times: Number of times to do roll.

.. function:: DetermineBestDiceRoll(roll1, roll2)

  Determines the highest maximum roll.  This selects based on the
  maximum value of the dice roll.

  :param roll1: Dice roll.
  :type roll1: :class:`DiceRoll`
  :param roll2: Dice roll.
  :type roll2: :class:`DiceRoll`

.. function:: IsValid(roll)

  Determines if roll is valid.

  A roll is considered valid if dice and sides are greater than
  zero or the bonus is.

  :param roll: Dice roll.
  :type roll: :class:`DiceRoll`

.. function:: DoRoll(roll, times)

  Do a dice roll.

  :param roll: Dice roll.
  :type roll: :class:`DiceRoll`
  :param int times: Number of times to do roll.

.. function:: DiceRollToString(roll)

  Converts a dice roll to formatted string.

  :param roll: Dice roll.
  :type roll: :class:`DiceRoll`

.. function:: d2(count)

  Rolls a d2

  :param int count: Number of dice to roll.

.. function:: d3(count)

  Rolls a d3

  :param int count: Number of dice to roll.

.. function:: d4(count)

  Rolls a d4

  :param int count: Number of dice to roll.

.. function:: d6(count)

  Rolls a d6

  :param int count: Number of dice to roll.

.. function:: d8(count)

  Rolls a d8

  :param int count: Number of dice to roll.

.. function:: d10(count)

  Rolls a d10

  :param int count: Number of dice to roll.

.. function:: d12(count)

  Rolls a d12

  :param int count: Number of dice to roll.

.. function:: d20(count)

  Rolls a d20

  :param int count: Number of dice to roll.

.. function:: d100(count)

  Rolls a d100

  :param int count: Number of dice to roll.
