.. highlight:: lua
.. default-domain:: lua


class Area
==========

.. class:: Area

Signals
-------

.. data:: Area.signals

  A Lua table containing signals for area events.

  .. note::

    These signals are shared by **all** :class:`Area` instances.  If special behavior
    is required for a specific area it must be filtered by a signal handler.

  .. data:: Area.signals.OnEnter

    **Signal Arguments**

    area : :class:`Area`
      Area being entered.
    obj : :class:`Object`
      Object entering the area.

  .. data:: Area.signals.OnExit

    **Signal Arguments**

    area : :class:`Area`
      Area being exited.
    obj : :class:`Object`
      Object exiting the area.

  .. data:: Area.signals.OnHeartbeat

    **Signal Arguments**

    area : :class:`Area`
      Area object.

  .. data:: Area.signals.OnUserDefined

    **Signal Arguments**

    area : :class:`Area`
      Area object.

  .. data:: Area.signals.OnInitialize

    **Signal Arguments**

    area : :class:`Area`
      Area object.

Methods
-------

  .. method:: Area:ClearLineOfSight(loc1, loc2)

    Determines if there is a clear line of sight between two objects

    **Arguments**

    loc1 : :class:`Location`
      Location A
    loc2 : :class:`Location`
      Location B

  .. method:: Area:GetType()

    Get area type.

  .. method:: Area:GetPlayerCount()

    Get area player count.

  .. method:: Area:GetSkyBox()

    Gets the sky that is displayed in the specified area.

  .. method:: Area:GetTilesetResRef()

    Gets the Tileset Resref for the specified area.

  .. method:: Area:RecomputeStaticLighting()

    Recomputes the lighting in an area based on current static lighting conditions.

  .. method:: Area:GetObjectIndex(object)

    Gets the position of specified object in the areas object list.

    **Arguments**

    object : :class:`Object`
      Object to search.

  .. method:: Area:GetObjectAtIndex(idx)

    Returns the object at specifed index of the area's object array.

    **Arguments**

    idx : ``int``
      Index of the object desired.

  .. method:: Area:Objects()

    Iterator returning all objects in a specified area.

  .. method:: Area:AmbientSoundChange([day[, night])

    Changes the ambient soundtracks of an area.

    **Arguments**

    day : ``int``, optional
      Day track number to change to.  If nil the track is unchanged
    night : ``int``, optional
      Night track number to change to.  If nil the track is unchanged

  .. method:: Area:AmbientSoundPlay()

    Starts ambient sounds playing in an area.

  .. method:: Area:AmbientSoundStop()

    Stops ambient sounds playing in an area.

  .. method:: Area:AmbientSoundSetVolume(day, night)

    Changes the ambient sound volumes of an area.

    **Arguments**

    day : ``int``, optional
      Day track number to change to.  If nil the track is unchanged
    night : ``int``, optional
      Night track number to change to.  If nil the track is unchanged

  .. method:: Area:MusicBackgroundChange(day, night)

    Changes the background music for the area specified.

    **Arguments**

    day : ``int``, optional
      Day track number to change to.  If nil the track is unchanged
    night : ``int``, optional
      Night track number to change to.  If nil the track is unchanged

  .. method:: Area:MusicBackgroundGetBattleTrack()

    Gets the background battle track for an area.

  .. method:: Area:MusicBackgroundGetTrack([is_night])

    Gets the background track for an area.

    **Arguments**

    is_night : ``bool``, optional
      If true returns the night track.  (Default: False)

  .. method:: Area:MusicBackgroundPlay()

    Starts the currently selected background track playing.

  .. method:: Area:MusicBackgroundSetDelay(delay)

    Changes the delay (in milliseconds) of the background music.

    **Arguments**

    delay : ``number``
      Time in milliseconds.

  .. method:: Area:MusicBackgroundStop()

    Stops the currently selected background track playing.

  .. method:: Area:MusicBattleChange(track)

    Stops the currently selected background track playing.

    **Arguments**

    track
      Music track number.

  .. method:: Area:MusicBattlePlay()

    Starts the currently selected battle track playing

  .. method:: Area:MusicBattleStop()

    Stops the currently selected battle track playing

  .. method:: Area:SetAreaTransitionBMP(predef[, custom])

    Sets the graphic shown when a PC moves between two different areas in a module.

    **Arguments**

    predef : ``int``
      A predifined AREA_TRANSITION_* constant.
    custom : ``string``
      File name of an area transition bitmap.  (Default: "")

  .. method:: Area:SetSkyBox(skybox)

    Sets the sky that is displayed in the specified area.

    **Arguments**

    skybox
      A SKYBOX_* constant (associated with skyboxes.2da)

  .. method:: Area:SetWeather(weather)

    Sets the weather in the specified area.

    **Arguments**

    weather
      AREA_WEATHER_*
