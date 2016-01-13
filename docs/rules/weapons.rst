.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Weapons
-------

.. function:: AttackTypeToEquipType(atype)

  :param int atype: ATTACK_TYPE\_*

  :rtype: EQUIP_TYPE_*

.. function:: BaseitemToWeapon(base)

.. function:: EquipTypeToAttackType(atype)

  :param int atype: EQUIP_TYPE\_*

  :rtype: ATTACK_TYPE_*

.. function:: GetCreatureDamageBonus(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetDualWieldPenalty(cre)

  Get dual wielding penalty.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsMonkWeapon(item, cre)

  :param item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsRangedWeapon(item)

  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetIsUnarmedWeapon(item)

  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetIsWeaponFinessable(item, cre)

  :param item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsWeaponLight(item, cre)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetIsWeaponSimple(item, cre)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetOffhandAttacks(cre)

  Determine number of offhand attacks.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetOnhandAttacks(cre)

  Determine number of onhand attacks.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetUnarmedDamageBonus(cre)

  Determine unarmed damage bonus.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponAttackAbility(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`
  :rtype: ABILITY_*

.. function:: GetWeaponAttackBonus(cre, weap)

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponBaseDamageType(item)

  Determine weapons base damage type.

  .. note::

    This does not support multiple weapon damage types and most likely never will.

  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponBaseDamage(item, cre)

  Determine weapons base damage roll.

  :param item: Item instance.
  :type item: :class:`Item`
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: GetWeaponDamageAbility(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`
  :rtype: ABILITY_*

.. function:: GetWeaponIteration(cre, item)

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponFeat(masterfeat, basetype)

.. function:: GetWeaponPower(cre, item)

  Determine weapons damage power.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponType(item)

  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponCritRange(cre, item)

  Determine weapons critical hit range.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`

.. function:: GetWeaponCritMultiplier(cre, item)

  Determine weapons critical hit multiplier.

  :param cre: Creature.
  :type cre: :class:`Creature`
  :param item: Item instance.
  :type item: :class:`Item`

.. function:: InventorySlotToAttackType(atype)

  :param int atype: Inventory slot constant.

  :rtype: ATTACK_TYPE_*

.. function:: InitializeNumberOfAttacks(cre)

  Initialize combat rounds attack counts.

  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: SetWeaponAttackAbilityOverride(ability, func)

  :param int ability: ABILITY_*

.. function:: SetWeaponDamageAbilityOverride(ability, func)

  :param int ability: ABILITY_*

.. function:: SetWeaponFeat(masterfeat, basetype, feat)

