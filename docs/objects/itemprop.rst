.. highlight:: lua
.. default-domain:: lua

class Itemprop
==============

Itemprop inherits from :class:`Effect`

.. class:: Itemprop

Methods
-------

  .. method:: Itemprop:ToString()

    Convert itemprop effect to formatted string.  Overrides
    :meth:`Effect:ToString`

  .. method:: Itemprop:GetCostTable()

    Returns the cost table number of the itemproperty.
    See the 2DA files for value definitions.

  .. method:: Itemprop:GetCostTableValue()

    Returns the cost table value of an itemproperty.
    See the 2DA files for value definitions.

  .. method:: Itemprop:GetParam1()

    Returns the Param1 number of the item property.

  .. method:: Itemprop:GetParam1Value()

    Returns the Param1 value of the item property.

  .. method:: Itemprop:GetPropertySubType()

    Returns the subtype of the itemproperty

  .. method:: Itemprop:GetPropertyType()

    Returns the subtype of the itemproperty

  .. method:: Itemprop:SetValues(type, subtype, cost, cost_val, param1, param1_val, chance)

    Sets the item property effect values directly.
