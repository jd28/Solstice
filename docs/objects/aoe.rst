.. highlight:: lua
.. default-domain:: lua

.. class:: AoE

class AoE
=========

Signals
-------

.. data:: AoE.signals

  A Lua table containing signals for area of effect events.

  .. note::

    These signals are shared by **all** :class:`AoE` instances.  Due to this fact these
    signals would likely only be useful for generic global behavior.  However, one could
    use them and dispatch on the type of the AoE.

  .. data:: AoE.signals.OnEnter

  .. data:: AoE.signals.OnExit

  .. data:: AoE.signals.OnHeartbeat

Methods
-------

  .. method:: AoE:GetCreator()

    Get's the creator of the AoE

  .. method:: AoE:GetFirstInPersistentObject(object_mask)

    Gets the first object in an AoE. Perfer the :meth:`AoE:ObjectsInEffect` iterator.

    **Arguments**

    object_mask : ``int``
      OBJECT_TYPE_* mask.

    **Returns**

     First object in AOE or OBJECT_INVALID

  .. method:: AoE:GetNextInPersistentObject(object_mask)

    Gets the next object in an AoE. Perfer the :meth:`AoE:ObjectsInEffect` iterator.

    **Arguments**

    object_mask : ``int``
      OBJECT_TYPE_* mask.

    **Returns**

    Next object in AOE or OBJECT_INVALID

  .. method:: AoE:GetSpellDC()

    Get Spell DC.

  .. method:: AoE:GetSpellLevel()

    Gets AoEs spell level.

  .. method:: AoE:ObjectsInEffect(object_mask)

    An iterator over all objects in an AoE

    **Arguments**

    object_mask : ``int``
      OBJECT_TYPE_* mask.

    **Returns**

    Iterator of objects satisfying the object mask.

  .. method:: AoE:SetSpellDC(dc)

      Sets AoEs spell DC.

      **Arguments**

      dc : ``int``
        Sets spell DC.

  .. method:: AoE:SetSpellLevel(level)

    Sets AoEs spell level.

    **Arguments**

    level : ``int``
      New caster level.

