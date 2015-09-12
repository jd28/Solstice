.. highlight:: lua
.. default-domain:: lua

class AoE
=========

.. class:: AoE

  .. method:: AoE:GetCreator()

    Get's the creator of the AoE

  .. method:: AoE:GetFirstInPersistentObject(object_mask)

    Gets the first object in an AoE. Perfer the :meth:`AoE:ObjectsInEffect` iterator.

    :param int object_mask: OBJECT_TYPE_* mask.
    :rtype: First object in AOE or OBJECT_INVALID

  .. method:: AoE:GetNextInPersistentObject(object_mask)

    Gets the next object in an AoE. Perfer the :meth:`AoE:ObjectsInEffect` iterator.

    :param int object_mask: OBJECT_TYPE_* mask.
    :rtype: Next object in AOE or OBJECT_INVALID

  .. method:: AoE:GetSpellDC()

    Get Spell DC.

  .. method:: AoE:GetSpellLevel()

    Gets AoEs spell level.

  .. method:: AoE:ObjectsInEffect(object_mask)

    An iterator over all objects in an AoE

    :param int object_mask: OBJECT_TYPE_* mask.
    :rtype: Iterator of objects satisfying the object mask.

  .. method:: AoE:SetSpellDC(dc)

    Sets AoEs spell DC.

    :param int dc: Sets spell DC.

  .. method:: AoE:SetSpellLevel(level)

    Sets AoEs spell level.

    :param int level: New caster level.

