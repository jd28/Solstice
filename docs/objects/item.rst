.. highlight:: lua
.. default-domain:: lua

class Item
==========

.. class:: Item

  .. method:: Item:GetEntireAppearance()

    Encodes an items appearance.  Source: nwnx_funcs by Acaos

    :rtype: A string encoding the appearance

  .. method:: Item:GetItemAppearance(appearance_type, index)

    Returns the appearance of an item

    :param int appearance_type: ITEM_APPR_TYPE_*
    :param int index: ITEM_APPR_WEAPON_* or ITEM_APPR_ARMOR_*

  .. method:: Item:RestoreAppearance(appearance)

    Restores an items appearance.

    :param string appearance: An encoding from :meth:`Item:GetEntireAppearance`

  .. method:: Item:SetAppearance(index, value)

    Set item appearance

    :param int index: index
    :param int value: value

  .. method:: Item:SetColor(index, value)

    Set item color

    :param int index: index
    :param int value: value

  .. method:: Item:GetACValue()

    Get the armor class of an item.

  .. method:: Item:ComputeArmorClass()

    Compute armor class.

  .. method:: Item:GetBaseArmorACBonus()

    Gets Armor's Base AC bonus.

    .. note::

      Note this is currently hardcoded to the typical vanilla NWN values.

    :rtype: -1 if item is not armor.

  .. method:: Item:Copy([target, copy_vars]])

    Duplicates an item.

    :param target: Create the item within this object's inventory.  (Default: ``OBJECT_INVALID``)
    :type target: :class:`Object`
    :param boolean copy_vars: If true, local variables on item are copied.  (Default: ``false``)

  .. method:: Item:CopyAndModify(modtype, index, value, copy_vars)

    Copies an item, making a single modification to it

    :param modtype: Type of modification to make.
    :param int index: Index of the modification to make.
    :param int value: New value of the modified index
    :param boolean copy_vars: If true, local variables on item are copied.  (Default: ``false``)

  .. method:: Item:GetBaseType()

    Get the base item type.

    :rtype: BASE_ITEM_INVALID if invalid item.

  .. method:: Item:SetBaseType(value)

    Sets an items base type

    :param int value: BASE_ITEM_*

  .. method:: Item:GetGoldValue()

    Determines the value of an item in gold pieces.

  .. method:: Item:SetGoldValue(value)

    Sets an items gold piece value when IDed
    Source: nwnx_funcs by Acaos

    :param int value: New gold value.

  .. method:: Item:GetStackSize()

    Get item's stack size.

  .. method:: Item:SetStackSize(value)

    Set item's stack size.

    :param int value: New stack size.

  .. method:: Item:GetPossesor()

    Get item possessor.

  .. method:: Item:AddItemProperty(dur_type, ip, duration)

    Add an itemproperty to an item

    :param int dur_type: DURATION_TYPE_*
    :param ip: Itemproperty to add.
    :type ip: :class:`Itemprop`
    :param float duration: Duration Duration in seconds in added temporarily.  (Default: 0.0)

  .. method:: Item:GetHasItemProperty(ip_type)

    Check whether an item has a given property.

    :param int ip_type: ITEM_PROPERTY_*

  .. method:: Item:ItemProperties()

    Iterator over items properties

  .. method:: Item:RemoveItemProperty(ip)

    Removes an item property

    :param ip: Item property to remove.
    :type ip: :class:`Itemprop`

  .. method:: Item:GetDroppable()

    Determines if an item can be dropped.

  .. method:: Item:SetDroppable(flag)

    Set droppable flag.

    :param boolean flag: New value.

  .. method:: Item:GetIdentified()

    Determines whether an object has been identified.

  .. method:: Item:GetInfiniteFlag()

    Gets if there is an infinite quantity of any item in a store.

  .. method:: Item:SetIdentified([is_ided])

    Sets an item identified

    :param boolean is_ided: (Default: ``false``)

  .. method:: Item:SetInfiniteFlag([infinite])

    Sets and items infinite quantity flag.

    :param boolean infinite: (Defaut: ``false``)

  .. method:: Item:GetCursedFlag()

    Get item cursed flag.

  .. method:: Item:SetCursedFlag(flag)

    Set item cursed flag.

    :param boolean flag: New flag.

  .. method:: Item:GetWeight()

    Gets item weight.

  .. method:: Item:SetWeight(weight)

    Sets item's weight.

    :param int weight: New weight.
