.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Levels
------

.. function:: GetGainsStatOnLevelUp(level)

  Determine if an ability score is gained on level up.

  :param level: Class level.
  :rtype: ``boolean``

.. function:: GainsFeatAtLevel(level)

  Determine if a feat is gained on level up.

  :param level: Class level.
  :rtype: ``boolean``

.. function:: GetXPLevelRequirement(level)

  Determine XP requirements for level.

  :param level: Class level.
  :rtype: ``int``
