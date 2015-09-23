.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Attack Bonus
============

.. function:: GetAttackBonusVs(cre, atype[, target])

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int atype: ATTACK_TYPE_*
  :param target: Object instance.
  :type target: :class:`Object`
  :rtype: Total attack bonus.

.. function:: GetBaseAttackBonus(cre, [pre_epic=false])

  Determines base attack bonus.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param boolean pre_epic: If ``true`` only calculate pre-epic BAB.

.. function:: GetEffectAttackModifier(cre[, atype[, target]])

  Determines the attack bonus from effects.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int atype: ATTACK_TYPE_*
  :param target: Object instance.
  :type target: :class:`Object`
  :rtype: If ``atype`` is passed to the function the unclamped attack bonus is returned, if not an ``lds.Array`` of all ATTACK_TYPE_* bonuses is returned.

.. function:: GetEffectAttackLimits(cre)

  Determines the minimum and maximum attack bonus can be modified by effects.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: -20, 20

.. function:: GetRangedAttackMod(cre, target, distance)

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param target: Object instance.
  :type target: :class:`Object`
  :param float distance: Distance to ``target``
  :rtype: ``int``
