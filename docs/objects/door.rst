.. highlight:: lua
.. default-domain:: lua

.. class:: Door

class Door
==========

Signals
-------

.. data:: Door.signals

  A Lua table containing signals for door events.

  .. note::

    These signals are shared by **all** :class:`Door` instances.  If special behavior
    is required for a specific door it must be filtered by a signal handler.

  .. data:: Door.signals.OnAreaTransitionClick

  .. data:: Door.signals.OnClose

  .. data:: Door.signals.OnOpen

  .. data:: Door.signals.OnDamaged

  .. data:: Door.signals.OnDeath

  .. data:: Door.signals.OnHeartbeat

  .. data:: Door.signals.OnPhysicalAttacked

  .. data:: Door.signals.OnSpellCastAt

  .. data:: Door.signals.OnUserDefined

  .. data:: Door.signals.OnFailToOpen

  .. data:: Door.signals.OnLock

  .. data:: Door.signals.OnUnlock

  .. data:: Door.signals.OnDisarm

  .. data:: Door.signals.OnTrapTriggered


Methods
-------

  .. method:: Door:GetIsActionPossible(action)

    Determines whether an action can be used on a door.

    **Arguments**

    action
      DOOR_ACTION_*

  .. method:: Door:DoAction(action)

    Does specific action to target door.

    **Arguments**

    action
      DOOR_ACTION_*
