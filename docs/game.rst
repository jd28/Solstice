.. highlight:: lua
.. default-domain:: lua

.. module:: game

Game
====

This module provides defines an interface for game related state.

2DA
----

.. function:: Get2daColumnCount(twoda)

  Get number of columns in 2da.

  :param twoda: 2da file.

.. function:: Get2daFloat(twoda, col, row)

  Get float value.

  :param string twoda: 2da file.
  :param col: Column label or index.
  :type col: *int* or *string*
  :param int row: Row index.

.. function:: Get2daInt(twoda, col, row)

  Get int value.

  :param string twoda: 2da file.
  :param col: Column label or index.
  :type col: *int* or *string*
  :param int row: Row index.

.. function:: Get2daRowCount(twoda)

  Get number of rows in 2da.

  :param string twoda: 2da file.

.. function:: Get2daString(twoda, col, row)

  Get string value.

  :param string twoda: 2da file.
  :param col: Column label or index.
  :type col: *int* or *string*
  :param int row: Row index.

Events
------

.. function:: EventActivateItem(item, location, target)

  Create activate item even.

  :param item: Item.
  :param location: Target location.
  :param target: Target object.

.. function:: EventConversation()

  Create conversation event.

.. function:: EventSpellCastAt(caster, spell, is_harmful)

  Creature spell cast at event.

  :param caster: Spell caster.
  :param int spell: SPELL_* constant.
  :param bool is_harmful: Is spell harmful to target.

.. function:: EventUserDefined(event)

  Create user defined event.

  :param event: An integer id.

.. function:: GetClickingObject()

  Get last clicking object.

.. function:: GetEnteringObject()

  Get last object to enter.

.. function:: GetExitingObject()

  Get last object to exit.

.. function:: GetItemActivated()

  Gets the item activated.

.. function:: GetItemActivatedTarget()

  Gets item activated event target.

.. function:: GetItemActivatedTargetLocation()

  Gets item activated event location.

.. function:: GetItemActivator()

  Gets object that activated item.

.. function:: GetLastPCToCancelCutscene()

  Gets last PC to cancel cutscene.

.. function:: GetLastPlayerDied()

  Gets last player died.

.. function:: GetLastPlayerDying()

  Gets last player dying.

.. function:: GetLastUsedBy()

  Gets last object to use something.

.. function:: GetPCLevellingUp()

  Gets last PC that leveled up.

.. function:: GetPlaceableLastClickedBy()

  Get last object to click a placeable.

.. function:: GetUserDefinedEventNumber()

  Get user defined event number.

.. function:: GetUserDefinedItemEventNumber(obj)

  Get the current UserDefined Item Event Number
  :param obj: Item object
  :type obj: :class:`Item`
  :rtype: ITEM_EVENT_* (see itemevents.2da)

.. function:: SetUserDefinedItemEventNumber(obj, event)

  Set the current UserDefined Item Event Number

  :param obj: Item object
  :type obj: :class:`Item`
  :param event: ITEM_EVENT_* (see itemevents.2da)

.. function:: SignalEvent(obj, event)

  Signal an event.

  :param obj: Object to signal.
  :type obj: :class:`Object`
  :param event: Event object.

Objects
-------

.. function:: ClearCacheData(obj)

  Clear the effect cache.

.. function:: CreateObject(object_type, template, loc[, appear=false[, newtag=""]])

  Create an object of a specified type at a given location

  :param int object_type: OBJECT_TYPE_*
  :param string template: The resref of the object to create from the pallet.
  :param loc: The location to create the object at.
  :type loc: :class:`Location`
  :param bool appear: If ``true``, the object will play its spawn in animation.
  :param string newtag: If this string is not empty, it will replace the default tag from the template.
  :rtype: New object or OBJECT_INVALID

.. function:: ExportSingleCharacter(player)

  Export single character.

  :param player: Object to export.
  :type player: :class:`Creature`

.. function:: GetCanonicalID(cre)

  Get canonical ID

  :param cre: Player character
  :type cre: :class:`Creature`

.. function:: GetModule()

  Get Module.

.. function:: GetObjectByID(id)

  Get object by ID.

  :param int id: Object ID.
  :rtype: An object or ``OBJECT_INVALID``


.. function:: GetObjectByTag(tag[, nth=1])

  Gets an object by tag

  :param string tag: Tag of object
  :param int nth: Nth object.

.. function:: GetPCSpeaker()

  Gets the PC speaker.

  :rtype: :class:`Creature` or ``OBJECT_INVALID``

.. function:: GetWaypointByTag(tag)

  Finds a waypiont by tag

  :param string tag: Tag of waypoint.
  :rtype: :class:`Waypoint` or ``OBJECT_INVALID``

.. function:: ObjectsByTag(tag)

  Iterator over objects by tag

  :param string tag: Tag of object

.. function:: ObjectsInShape(shape, size, location[, line_of_sight[, mask[, origin]]])

  Iterator over objects in a shape.

  :param int shape: SHAPE_*
  :param int size: The size of the shape. Dependent on shape or RADIUS_SIZE_*.
  :param location: Shapes location
  :param bool line_of_sight: This can be used to ensure that spell effects do nt go through walls.
  :param int mask: Object type mask.
  :param vector origin: Normally the spell-caster's position.

.. function:: PCs()

  Iterator over all PCs

.. function:: RemoveObjectFromCache(obj)

  Remove object from Solstice object cache.
  :param obj: Any object.
  :type obj: :class:`Object`

Plugins
-------

The plugin in system allows registering plugins by a string identifier
and optionally enforcing a particular interface.

.. note::

  Only one plugin can be registered to a plugin interface.

.. function:: RegisterPlugin(name, enforcer)

  Registers a plugin interface.

  :param string name: Plugin interface name.
  :param function enforcer: Function that is called when a plugin attempts to load.  This is to allow enforcing a particular interface.

.. function:: LoadPlugin(name, interface)

  Loads a plugin for a given plugin interface.  If the plugin is successfully
  loaded the plugin system will attempt to call ``plugin.OnLoad`` if it exists.

  :param string name: Plugin interface name.
  :param table interface: A table of functions that satisfy the plugin interface.

.. function:: GetPlugin(name)

  Gets a plugin by name.

  :param string name: Plugin interface name.

.. function:: UnloadPlugin(name)

  Unloads a plugin for a given plugin interface.  The plugin system will attempt to
  call ``plugin.OnUnload`` if it exists.

  :param string name: Plugin interface name.

.. function:: IsPluginLoaded(name)

  Determines if a plugin is loaded.

  :param string name: Plugin interface name.

Signals
-------

.. data:: OnPreExportCharacter

  This event is fired before saving a character.

.. data:: OnPostExportCharacter

  This event is fired after saving a character.

.. data:: OnObjectClearCacheData

  This signal is called when an object has its data cleared from the cache.  This is typically for PCs only as they are not removed from the cache, but need some data reset for when the log in again.

.. data:: OnObjectRemovedFromCache

  This signal is called when an object is removed from the cache.  Note that PCs are never removed from the cache.

.. data:: OnUpdateEffect

  This is called whenever an effect is applied or removed from a creature.  Two parameters are passed: a :class:`Creature` instant and a :class:`Effect`.  Note: there is no way to determine if the effect was applied or removed, so it's only useful in cases of updating/invalidating cached information.

Scripts
-------

.. function:: DumpScriptEnvironment()

  Gets a string representation of the script environment.

.. function:: ExecuteItemEvent(obj, item, event)

  Executes item event.  This is compatible with NWN tag based scripting.  It will only work if that feature has been enabled.

  :param obj: Object
  :param item: Item
  :param event: ITEM_EVENT_* See itemevents.2da
  :rtype: SCRIPT_RETURN_*

.. function:: ExecuteScript(script, target)

  Executes a script on a specified target.  This operates like the NWScript ``ExecuteScriptAndReturnInt`` rather than ``ExecuteScript``.

  :param script: Script to call.
  :param target: Object to run the script on.
  :rtype: SCRIPT_RETURN_* constant.

.. function:: GetItemEventName(item)

  Gets the item event script name. This function is compatible with NWN tag based scripting.

  :param item: Item that caused the event.
  :type item: :class:`Item`

.. function:: GetItemEventType(obj)

  Get last item event type.

  :param obj: Object script is being run on.
  :rtype: ITEM_EVENT_* See itemevents.2da

.. function:: LoadScript(fname)

  Load script file.

  :param string fname: Script file name.

.. function:: LockScriptEnvironment()

  Locks the script environment. After this is called no variables can be set globally in the script environment

.. function:: RunScript(script, target)

  Run script.

  :param string script: Script to call.
  :param target: Object to run the script on.

.. function:: SetItemEventPrefix([prefix=""])

  Set item event prefix. This function is compatible with NWN tag based scripting.

  :param string prefix: Prefix to add to script calls.

.. function:: SetItemEventType(obj, event)

  Sets item event type on object.

  :param obj: Object script is being run on.
  :param int event: ITEM_EVENT_* See itemevents.2da


.. function:: SetScriptReturnValue(object[, value=SCRIPT_RETURN_CONTINUE])

  Set script return value.

  :param object: Object script is being run on.
  :param int value: SCRIPT_RETURN_* constnat.

.. function:: UnlockScriptEnvironment()

  Unlocks the script environment. After this is called variables can be set globally in the script environment

Time
----

.. function:: GetDay()

  Determine the current in-game calendar day.

.. function:: GetHour()

  Gets the current hour.

.. function:: GetIsDawn()

  Get if it's dawn.

  :rtype: ``bool``

.. function:: GetIsDay()

  Get if it's day.

  :rtype: ``bool``

.. function:: GetIsDusk()

  Get if it's dusk

  :rtype: ``bool``

.. function:: GetIsNight()

  Get if it's night

  :rtype: ``bool``

.. function:: GetMillisecond()

  Gets the current millisecond.

.. function:: GetMinute()

  Gets the current minute.

.. function:: GetMonth()

  Determine the current in-game calendar month.

.. function:: GetSecond()

  Gets the current second

.. function:: GetYear()

  Determine the current in-game calendar year.

.. function:: HoursToSeconds(hours)

  Converts hours to seconds

  :param int hours: Number of hours

.. function:: RoundsToSeconds(rounds)

  Converts rounds to seconds

  :param int rounds: Number of rounds

.. function:: SetCalendar(year, month, day)

  Set calendar

  :param int year: Specific year to set calendar to from 1340 to 32001.
  :param int month: Specific month to set calendar from 1 to 12.
  :param int day: Specific day to set calendar to from 1 to 28.


.. function:: SetTime(hour, minute, second, millisecond)

  Sets the game's current time.

  :param int hour: The new hour value, from 0 to 23.
  :param int minute: The new minute value from 0 to 1 (or 0 to a higher value if the module properties for time were changed).
  :param int second: The new second value, from 0 to 59.
  :param int millisecond: The new millisecond value, from 0 to 999.


.. function:: TurnsToSeconds(turns)

  Converts turns to seconds

  :param int turns: Number of turns

.. function:: UpdateTime()

  Force update time.

TLK
---

.. function:: GetTlkString(strref)

  Get string by TLK table reference.

  :param int strref: TLK table reference.
  :rtype: ``string``
