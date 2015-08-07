.. highlight:: lua
.. default-domain:: lua

class Item
==========

.. class:: Item

Appearance
----------

  .. method:: Item:GetEntireAppearance()

    Encodes an items appearance.  Source: nwnx_funcs by Acaos

    **Returns**

    A string encoding the appearance

  .. method:: Item:GetItemAppearance(appearance_type, index)

    Returns the appearance of an item

    **Arguments**

    appearance_type
      ITEM_APPR_TYPE_*
    index
      ITEM_APPR_WEAPON_* or ITEM_APPR_ARMOR_*

  .. method:: Item:RestoreAppearance(appearance)

    Restores an items appearance.

    **Arguments**

    appearance : ``string``
      An encoding from :meth:`Item:GetEntireAppearance`

  .. method:: Item:SetAppearance(index, value)

    Set item appearance

    **Arguments**

    index
      index
    value
      value

  .. method:: Item:SetColor(index, value)

    Set item color

    **Arguments**

    index
      index
    value
      value

Armor Class
-----------

  .. method:: Item:GetACValue()

    Get the armor class of an item.

  .. method:: Item:ComputeArmorClass()

    Compute armor class.

  .. method:: Item:GetBaseArmorACBonus()

    Gets Armor's Base AC bonus.

    .. note::

      Note this is currently hardcoded to the typical vanilla NWN values.

    **Returns**

    -1 if item is not armor.

Copying
-------

  .. method:: Item:Copy([target, copy_vars]])

    Duplicates an item.

    **Arguments**

    target : :class:`Object`
      Create the item within this object's inventory.  (Default: ``OBJECT_INVALID``)
    copy_vars : ``bool``
      If true, local variables on item are copied.  (Default: ``false``)

  .. method:: Item:CopyAndModify(modtype, index, value, copy_vars)

    Copies an item, making a single modification to it

    **Arguments**

    modtype
      Type of modification to make.
    index
      Index of the modification to make.
    value
      New value of the modified index
    copy_vars : ``bool``
      If true, local variables on item are copied.  (Default: ``false``)

Type
----

  .. method:: Item:GetBaseType()

    Get the base item type.

    **Returns**

    BASE_ITEM_INVALID if invalid item.

  .. method:: Item:SetBaseType(value)

    Sets an items base type

    **Arguments**

    value
      BASE_ITEM_*

Info
----

  .. method:: Item:GetGoldValue()

    Determines the value of an item in gold pieces.

  .. method:: Item:SetGoldValue(value)

    Sets an items gold piece value when IDed
    Source: nwnx_funcs by Acaos

    **Arguments**

    value
      New gold value.

  .. method:: Item:GetStackSize()

    Get item's stack size.

  .. method:: Item:SetStackSize(value)

    Set item's stack size.

    **Arguments**

    value
      New stack size.

  .. method:: Item:GetPossesor()

    Get item possessor.

Properties
----------

  .. method:: Item:AddItemProperty(dur_type, ip, duration)

    Add an itemproperty to an item

    **Arguments**

    dur_type : ``int``
      DURATION_TYPE_*
    ip : :class:`Itemprop`
      Itemproperty to add.
    duration : ``number``
      Duration Duration in seconds in added temporarily.  (Default: 0.0)

  .. method:: Item:GetHasItemProperty(ip_type)

    Check whether an item has a given property.

    ip_type
      ITEM_PROPERTY_*

  .. method:: Item:ItemProperties()

    Iterator over items properties

  .. method:: Item:RemoveItemProperty(ip)

    Removes an item property

    **Arguments**

    ip : :class:`Itemprop`
      Item property to remove.

Flags
-----

  .. method:: Item:GetDroppable()

    Determines if an item can be dropped.

  .. method:: Item:SetDroppable(flag)

    Set droppable flag.

    **Arguments**

    flag
      New value.


  .. method:: Item:GetIdentified()

    Determines whether an object has been identified.

  .. method:: Item:GetInfiniteFlag()

    Gets if there is an infinite quantity of any item in a store.

  .. method:: Item:SetIdentified([is_ided])

    Sets an item identified

    **Arguments**

    is_ided : ``bool``
      (Default: ``false``)

  .. method:: Item:SetInfiniteFlag([infinite])

    Sets and items infinite quantity flag.

    **Arguments**

    infinite
      (Defaut: ``false``)


  .. method:: Item:GetCursedFlag()

    Get item cursed flag.

  .. method:: Item:SetCursedFlag(flag)

    Set item cursed flag.

    **Arguments**

    flag : ``bool``
      New flag.

Weight
------
  .. method:: Item:GetWeight()

    Gets item weight.

  .. method:: Item:SetWeight(weight)

    Sets item's weight.

    **Arguments**

    weight : ``int``
      New weight.
