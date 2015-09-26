.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Armor Class
===========

.. function:: DebugArmorClass(cre)

  Generates a string with armor class related information.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: ``string``

.. function:: GetACVersus(cre, vs, touch, is_ranged, attack, state)

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param vs: Object instance.
  :type vs: :class:`Object`
  :param bool touch: Versus touch attack.
  :param bool is_ranged: Versus ranged attack.
  :param attack: Attack info.
  :param int state: Combat state.
  :rtype: ``int``

.. function:: GetArmorCheckPenalty(cre)

  Determines armor check penalty.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: ``int``

.. function:: GetArmorClassModifierLimits(cre)

  Limits of armor class modifiers.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: -20, 20
