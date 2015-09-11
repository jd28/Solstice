.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Weapons
-------

.. function:: BaseitemToWeapon(base)

.. function:: GetWeaponFeat(masterfeat, basetype)

.. function:: SetWeaponFeat(masterfeat, basetype, feat)

.. function:: GetWeaponType(item)

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetIsMonkWeapon(item, cre)

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsRangedWeapon(item)

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetIsWeaponLight(item, cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsWeaponSimple(item, cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsWeaponFinessable(item, cre)

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponIteration(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponAttackAbility(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponDamageAbility(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: SetWeaponAttackAbilityOverride(ability, func)

  **Arguments**

  ability : ``int``
    ABILITY_*

.. function:: SetWeaponDamageAbilityOverride(ability, func)

  **Arguments**

  ability : ``int``
    ABILITY_*

.. function:: GetWeaponAttackBonus(cre, weap)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponPower(cre, item)

  Determine weapons damage power.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponBaseDamageType(item)

  Determine weapons base damage type.

  .. note::

    This does not support multiple weapon damage types and most likely never will.

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetWeaponBaseDamage(item, cre)

  Determine weapons base damage roll.

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetUnarmedDamageBonus(cre)

  Determine unarmed damage bonus.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponCritRange(cre, item)

  Determine weapons critical hit range.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponCritMultiplier(cre, item)

  Determine weapons critical hit multiplier.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetDualWieldPenalty(cre)

  Get dual wielding penalty.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: AttackTypeToEquipType(atype)

  **Arguments**

  atype : ``int``
    ATTACK_TYPE\_*

  **Returns**

  EQUIP_TYPE\_*

.. function:: EquipTypeToAttackType(atype)

  **Arguments**

  atype : ``int``
    EQUIP_TYPE\_*

  **Returns**

  ATTACK_TYPE\_*

.. function:: InventorySlotToAttackType(atype)

  **Arguments**

  atype : ``int``
    Inventory slot constant.

  **Returns**

  ATTACK_TYPE\_*

.. function:: GetOnhandAttacks(cre)

  Determine number of onhand attacks.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetOffhandAttacks(cre)

  Determine number of offhand attacks.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: InitializeNumberOfAttacks(cre)

  Initialize combat rounds attack counts.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetCreatureDamageBonus(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.
