.. highlight:: lua
.. default-domain:: lua

class Trigger
=============

.. class:: Trigger

Signals
-------

.. data:: Trigger.signals

  A Lua table containing signals for trigger events.

  .. note::

    These signals are shared by **all** :class:`Trigger` instances.  If special behavior
    is required for a specific trigger it must be filtered by a signal handler.

  .. data:: Trigger.signals.OnClick

  .. data:: Trigger.signals.OnEnter

  .. data:: Trigger.signals.OnExit

  .. data:: Trigger.signals.OnHeartbeat

  .. data:: Trigger.signals.OnUserDefined
