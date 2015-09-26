Game
====

2DA
----

.. function:: Get2daColumnCount(twoda)

.. function:: Get2daFloat(twoda, col, row)

.. function:: Get2daInt(twoda, col, row)

.. function:: Get2daRowCount(twoda)

.. function:: Get2daString(twoda, col, row)

.. function:: GetCached2da(twoda)

Events
------

.. function:: EventActivateItem(item, location, target)

.. function:: EventConversation()

.. function:: EventSpellCastAt(caster, spell, is_harmful)

.. function:: EventUserDefined(event)

.. function:: GetClickingObject()

.. function:: GetEnteringObject()

.. function:: GetExitingObject()

.. function:: GetItemActivated()

.. function:: GetItemActivatedTarget()

.. function:: GetItemActivatedTargetLocation()

.. function:: GetItemActivator()

.. function:: GetLastPCToCancelCutscene()

.. function:: GetLastPlayerDied()

.. function:: GetLastPlayerDying()

.. function:: GetLastUsedBy()

.. function:: GetPCChatSpeaker()

.. function:: GetPCLevellingUp()

.. function:: GetPlaceableLastClickedBy()

.. function:: GetUserDefinedEventNumber()

.. function:: GetUserDefinedItemEventNumber(obj)

.. function:: SetUserDefinedItemEventNumber(obj, event)

.. function:: SignalEvent(object, event)

Objects
-------

.. function:: ClearCacheData(obj)

.. function:: CreateObject(object_type, template, loc, appear, newtag)

.. function:: ExportSingleCharacter(player)

.. function:: GetCanonicalID(cre)

.. function:: GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)

.. function:: GetFirstPC()

.. function:: GetModule()

.. function:: GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)

.. function:: GetNextPC()

.. function:: GetObjectByID(id)

.. function:: GetObjectByTag(tag, nth)

.. function:: GetPCSpeaker()

.. function:: GetWaypointByTag(tag)

.. function:: ObjectsByTag(tag)

.. function:: ObjectsInShape(shape, size, location, line_of_sight, mask, origin)

.. function:: PCs()

.. function:: RemoveObjectFromCache(obj)

Plugins
-------

The plugin in system allows registering plugins by a string identifier
and optionally enforcing a particular interface.

.. note::

  Only one plugin can be registered to a plugin interface.

.. function:: RegisterPlugin(name, enforcer)

  Registers a plugin interface.

  :param string name: Plugin interface name.
  :param function enforcer: Function that is called when a plugin attempts to load.  This is to allow eforcing a particular interface.

.. function:: LoadPlugin(name, interface)

  Loads a plugin for a given plugin interface.  If the plugin is successfully
  loaded the plugin system will attempt to call ``plugin.OnLoad`` if it exists.

  :param string name: Plugin interface name.
  :param table interface: A table of functions that satisfy the plugin interface.

.. function:: GetPlugin(name)

  Gets a plugin by name.

  :param string name: Plugin interface name.

.. function:: UnloadPlugin(name)

  Unloads a plugin for a given plugin interface.  Rhe plugin system will attempt to
  call ``plugin.OnUnload`` if it exists.

  :param string name: Plugin interface name.

.. function:: IsPluginLoaded(name)

  Determines if a plugin is loaded.

  :param string name: Plugin interface name.

Signals
-------

.. data:: OnPreExportCharacter

.. data:: OnPostExportCharacter

.. data:: OnObjectClearCacheData

  This signal is called when an object has its data cleared from the cache.  This is typically for PCs only as they are not removed from the cache, but need some data reset for when the log in again.

.. data:: OnObjectRemovedFromCache

  This signal is called when an object is removed fromt the cache.  Note that PCs are never removed from the cache.

Scripts
-------

.. function:: DumpScriptEnvironment()

.. function:: ExecuteItemEvent(obj, item, event)

.. function:: ExecuteScript(script, target)

.. function:: GetItemEventName(item)

.. function:: GetItemEventType(obj)

.. function:: LoadScript(fname)

.. function:: LockScriptEnvironment()

.. function:: RunScript(script, target)

.. function:: SetItemEventPrefix(prefix)

.. function:: SetItemEventType(obj, event)

.. function:: SetScriptReturnValue(object, value)

.. function:: UnlockScriptEnvironment()

Time
----

.. function:: ExportSingleCharacter(player)

.. function:: GetDay()

.. function:: GetHour()

.. function:: GetIsDawn()

.. function:: GetIsDay()

.. function:: GetIsDusk()

.. function:: GetIsNight()

.. function:: GetMillisecond()

.. function:: GetMinute()

.. function:: GetMonth()

.. function:: GetSecond()

.. function:: GetYear()

.. function:: HoursToSeconds(hours)

.. function:: RoundsToSeconds(rounds)

.. function:: SetCalendar(year, month, day)

.. function:: SetTime(hour, minute, second, millisecond)

.. function:: TurnsToSeconds(turns)

.. function:: UpdateTime()

TLK
---

.. function:: GetTlkString(strref)
