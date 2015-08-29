.. highlight:: lua
.. default-domain:: lua

class Placeable
===============

.. class:: Placeable

Signals
-------

.. data:: Placeable.signals

  A Lua table containing signals for placeable events.

  .. note::

    These signals are shared by **all** :class:`Placeable` instances.  If special behavior
    is required for a specific placeable it must be filtered by a signal handler.

  .. data:: Placeable.signals.OnClose

  .. data:: Placeable.signals.OnOpen

  .. data:: Placeable.signals.OnDisturbed

  .. data:: Placeable.signals.OnPhysicalAttacked

  .. data:: Placeable.signals.OnSpellCastAt

  .. data:: Placeable.signals.OnUsed

  .. data:: Placeable.signals.OnDamaged

  .. data:: Placeable.signals.OnDeath

  .. data:: Placeable.signals.OnHeartbeat

  .. data:: Placeable.signals.OnUserDefined

  .. data:: Placeable.signals.OnLock

  .. data:: Placeable.signals.OnUnlock

  .. data:: Placeable.signals.OnFailToOpen

  .. data:: Placeable.signals.OnDisarm

  .. data:: Placeable.signals.OnTrapTriggered


Methods
-------

  .. method:: Placeable:DoAction(action)

  .. method:: Placeable:GetIsActionPossible(action)

  .. method:: Placeable:GetIsStatic()

  .. method:: Placeable:GetIllumination()

  .. method:: Placeable:GetSittingCreature()

  .. method:: Placeable:GetUseable()

  .. method:: Placeable:SetAppearance(value)

  .. method:: Placeable:SetIllumination(illuminate)

  .. method:: Placeable:SetUseable(useable)