.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.core

nwnx.core
=========

Functions
---------

.. function:: HookEvent(name, func)

  .. danger::

    This is an advanced function.  Only use it if you're sure you know what you're doing.

  :param string name: Event name.
  :param function func: Event handler function.  This **must** be castable to and satisfy ``int (*NWNXHOOK)(uintptr_t);``
  :rtype: boolean
