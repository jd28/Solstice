.. highlight:: lua
.. default-domain:: lua

.. module:: dice

Dice
====

Functions
---------

.. function:: Roll(dice, sides, bonus, times)

  Rolls arbitrary dice.

  **Arguments**

  dice : ``int``
    Number of dice to roll
  sides : ``int``
    Number of sides the dice have
  bonus : ``int``
    Bonus added to roll
  times : ``int``
    Number of times to do roll.

.. function:: DetermineBestDiceRoll(roll1, roll2)

  Determines the highest maximum roll.  This selects based on the
  maximum value of the dice roll.

  **Arguments**

  roll1
    DiceRoll ctype
  roll2
    DiceRoll ctype


.. function:: IsValid(roll)

  Determines if roll is valid.

  A roll is considered valid if dice and sides are greater than
  zero or the bonus is.

  **Arguments**

  roll
    DiceRoll ctype

.. function:: DoRoll(roll, times)

  Do a dice roll.

  **Arguments**

  roll
    DiceRoll ctype
  times
    Number of times to do roll.

.. function:: DiceRollToString(roll)

  Converts a dice roll to formatted string.

  **Arguments**

  roll
    DiceRoll ctype

.. function:: d2(count)

  Rolls a d2

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d3(count)

  Rolls a d3

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d4(count)

  Rolls a d4

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d6(count)

  Rolls a d6

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d8(count)

  Rolls a d8

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d10(count)

  Rolls a d10

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d12(count)

  Rolls a d12

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d20(count)

  Rolls a d20

  **Arguments**

  count : ``int``
    number of dice to roll

.. function:: d100(count)

  Rolls a d100

  **Arguments**

  count : ``int``
    number of dice to roll
