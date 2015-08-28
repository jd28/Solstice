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

.. function:: ClearCache(obj)

.. function:: CreateObject(object_type, template, loc, appear, newtag)

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

.. function:: RemoveObject(obj)

Plugins
-------

The plugin in system allows registering plugins by a string identifier
and optionally enforcing a particular interface.

.. note::

  Only one plugin can be registered to a plugin interface.

.. function:: RegisterPlugin(name, enforcer)

  Registers a plugin interface.

  **Arguments:**

  name : ``string``
    Plugin interface name.
  enforcer : ``function``
    Function that is called when a plugin attempts to load.  This is to allow
    eforcing a particular interface.

.. function:: LoadPlugin(name, interface)

  Loads a plugin for a given plugin interface.  If the plugin is successfully
  loaded the plugin system will attempt to call ``plugin.OnLoad`` if it exists.

  **Arguments:**

  name : ``string``
    Plugin interface name.
  interface : ``table``
    A table of functions that satisfy the plugin interface.

.. function:: GetPlugin(name)

  Gets a plugin by name.

  name : ``string``
    Plugin interface name.

.. function:: UnloadPlugin(name)

  Unloads a plugin for a given plugin interface.  Rhe plugin system will attempt to
  call ``plugin.OnUnload`` if it exists.

  **Arguments:**

  name : ``string``
    Plugin interface name.

.. function:: IsPluginLoaded(name)

  Determines if a plugin is loaded.

  name : ``string``
    Plugin interface name.


Properties
----------

.. function:: DeleteAllProperties(obj)

.. function:: DeleteProperty(obj, prop)

.. function:: GetAllProperties(obj)

.. function:: GetGlobalProperties()

.. function:: GetProperty(obj, prop)

.. function:: SetProperty(obj, prop, value)

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

.. function:: ExportAllCharacters()

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

.. function:: GetTlkSoundDuration(strref)

.. function:: GetTlkSoundLength(strref)

.. function:: GetTlkString(strref, female)