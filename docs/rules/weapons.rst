.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Weapons
-------

.. function:: BaseitemToWeapon(base)

.. function:: GetWeaponFeat(masterfeat, basetype)

.. function:: SetWeaponFeat(masterfeat, basetype, feat)

.. function:: GetWeaponType(item)

  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetIsMonkWeapon(item, cre)

  :parm item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsRangedWeapon(item)

  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetIsWeaponLight(item, cre)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsWeaponSimple(item, cre)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsWeaponFinessable(item, cre)

  :parm item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponIteration(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponAttackAbility(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponDamageAbility(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: SetWeaponAttackAbilityOverride(ability, func)

  :param int ability: ABILITY_*

.. function:: SetWeaponDamageAbilityOverride(ability, func)

  :param int ability: ABILITY_*

.. function:: GetWeaponAttackBonus(cre, weap)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponPower(cre, item)

  Determine weapons damage power.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponBaseDamageType(item)

  Determine weapons base damage type.

  .. note::

    This does not support multiple weapon damage types and most likely never will.

  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponBaseDamage(item, cre)

  Determine weapons base damage roll.

  :parm item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetUnarmedDamageBonus(cre)

  Determine unarmed damage bonus.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponCritRange(cre, item)

  Determine weapons critical hit range.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponCritMultiplier(cre, item)

  Determine weapons critical hit multiplier.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`

.. function:: GetDualWieldPenalty(cre)

  Get dual wielding penalty.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: AttackTypeToEquipType(atype)

  :param int atype: ATTACK_TYPE\_*

  :rtype: EQUIP_TYPE_*

.. function:: EquipTypeToAttackType(atype)

  :param int atype: EQUIP_TYPE\_*

  :rtype: ATTACK_TYPE_*

.. function:: InventorySlotToAttackType(atype)

  :param int atype: Inventory slot constant.

  :rtype: ATTACK_TYPE_*

.. function:: GetOnhandAttacks(cre)

  Determine number of onhand attacks.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetOffhandAttacks(cre)

  Determine number of offhand attacks.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: InitializeNumberOfAttacks(cre)

  Initialize combat rounds attack counts.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetCreatureDamageBonus(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :parm item: Item instance.
  :type item: :class:`Item`
