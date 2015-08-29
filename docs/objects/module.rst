.. highlight:: lua
.. default-domain:: lua

.. class:: Module

class Module
============

Signals
-------

.. data:: Module.signals

  A Lua table containing signals for module events.

  .. data:: Module.signals.OnAcquireItem

  .. data:: Module.signals.OnUnAcquireItem

  .. data:: Module.signals.OnClientEnter

  .. data:: Module.signals.OnClientLeave

  .. data:: Module.signals.OnPlayerDeath

  .. data:: Module.signals.OnPlayerDying

  .. data:: Module.signals.OnPlayerEquipItem

  .. data:: Module.signals.OnPlayerUnEquipItem

  .. data:: Module.signals.OnPlayerLevelUp

  .. data:: Module.signals.OnPlayerRespawn

  .. data:: Module.signals.OnPlayerRes

  .. data:: Module.signals.OnActivateIte

  .. data:: Module.signals.OnHeartbeat

  .. data:: Module.signals.OnModuleLoa

  .. data:: Module.signals.OnUserDefined

  .. data:: Module.signals.OnCutsceneAbort


Methods
-------

  .. method:: Module:Areas()

  .. method:: Module:GetName()

  .. method:: Module:GetStartingLocation()

  .. method:: Module:GetGameDifficulty()

  .. method:: Module:GetMaxHenchmen()

  .. method:: Module:SetMaxHenchmen(max)

  .. method:: Module:SetModuleXPScale(scale)