.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Modes
-----

.. data:: CombatMode

  Table defining a combat mode.

  **Fields**

  **use** : ``function`` or ``true``
    Determines if combat mode is usable.  If this field is ``true`` the mode is always usable if the feat used to apply it is usable.
  **modifier** : ``function``
    Determines what the attack modifier is for a particular ATTACK_MODIFIER_* type.  The function must accept two parameters an ATTACK_MODIFIER_* and a :class:`Creature` instance.  Returning ``nil`` indicates the ATTACK_MODIFIER_* is not applicable to the given mode.

.. function:: GetCanUseMode(mode, cre)

  :param int mode: COMBAT_MODE_*
  :param cre: Creature.
  :type cre: :class:`Creature`
  :rtype: ``boolean``

.. function:: GetModeModifier(mode, modifier, cre)

  :param int mode: COMBAT_MODE_*
  :param int modifier: ATTACK_MODIFIER_*
  :param cre: Creature.
  :type cre: :class:`Creature`
  :rtype: Dependent on modifier type.

.. function:: RegisterMode(mode, ...)

  :param mode: Combat mode interface.
  :type mode: :data:`CombatMode`
  :param ...: COMBAT_MODE_* constant(s).