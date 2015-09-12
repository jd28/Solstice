.. highlight:: lua
.. default-domain:: lua


class Area
==========

.. class:: Area

  .. method:: Area:ClearLineOfSight(loc1, loc2)

    Determines if there is a clear line of sight between two objects

    :param loc1: Location A
    :type loc1: :class:`Location`
    :param loc2: Location B
    :type loc2: :class:`Location`

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

    :param object: Object to search.
    :type object: :class:`Object`

  .. method:: Area:GetObjectAtIndex(idx)

    Returns the object at specifed index of the area's object array.

    :param int idx: Index of the object desired.

  .. method:: Area:Objects()

    Iterator returning all objects in a specified area.

  .. method:: Area:AmbientSoundChange([day[, night])

    Changes the ambient soundtracks of an area.

    :param int day: Day track number to change to.  If nil the track is unchanged
    :param int night: Night track number to change to.  If nil the track is unchanged

  .. method:: Area:AmbientSoundPlay()

    Starts ambient sounds playing in an area.

  .. method:: Area:AmbientSoundStop()

    Stops ambient sounds playing in an area.

  .. method:: Area:AmbientSoundSetVolume(day, night)

    Changes the ambient sound volumes of an area.

    :param int day: Day track number to change to.  If nil the track is unchanged
    :param int night: Night track number to change to.  If nil the track is unchanged

  .. method:: Area:MusicBackgroundChange(day, night)

    Changes the background music for the area specified.

    :param int day: Day track number to change to.  If nil the track is unchanged
    :param int night: Night track number to change to.  If nil the track is unchanged

  .. method:: Area:MusicBackgroundGetBattleTrack()

    Gets the background battle track for an area.

  .. method:: Area:MusicBackgroundGetTrack([is_night])

    Gets the background track for an area.

    :param boolean is_night: If true returns the night track.  (Default: False)

  .. method:: Area:MusicBackgroundPlay()

    Starts the currently selected background track playing.

  .. method:: Area:MusicBackgroundSetDelay(delay)

    Changes the delay (in milliseconds) of the background music.

    :param float delay: Time in milliseconds.

  .. method:: Area:MusicBackgroundStop()

    Stops the currently selected background track playing.

  .. method:: Area:MusicBattleChange(track)

    Stops the currently selected background track playing.

    :param int track: Music track number.

  .. method:: Area:MusicBattlePlay()

    Starts the currently selected battle track playing

  .. method:: Area:MusicBattleStop()

    Stops the currently selected battle track playing

  .. method:: Area:SetAreaTransitionBMP(predef[, custom])

    Sets the graphic shown when a PC moves between two different areas in a module.

    :param int predef: A predifined AREA_TRANSITION_* constant.
    :param string custom: File name of an area transition bitmap.  (Default: "")

  .. method:: Area:SetSkyBox(skybox)

    Sets the sky that is displayed in the specified area.

    :param int skybox: A SKYBOX_* constant (associated with skyboxes.2da)

  .. method:: Area:SetWeather(weather)

    Sets the weather in the specified area.

    :param int weather: AREA_WEATHER_*
