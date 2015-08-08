.. highlight:: lua
.. default-domain:: lua

class Location
==============

.. class:: Location

Constants
---------

  .. data:: INVALID

    Invalid location.  Aliased globally as ``LOCATION_INVALID``.

Functions
---------

  .. function:: Location.Create(position, orientation, area)

    Create a new location

    **Arguments**

    position : :class:`Vector`
      Location's position
    orientation : :class:`Vector`
      Location's orientation
    area : :class:`Area`
      Location's area

    **Returns**

    :class:`Location` instance.


  .. function:: Location.FromString(str)

    Convert string to location.

    **Arguments**

    str : ``string``
      String representation of a location.  Format: "area_tag (x, y, z) orientation"

    **Returns**

    :class:`Location` instance.

Methods
-------

  .. method:: Location:ApplyEffect(durtype, eff, duration)

    Applies an effect to a location.

    **Arguments**

    durtype : ``int``
      DURATION_TYPE_*
    eff : :class:`Effect`
      Effect to apply.
    duration : ``number``
      Duration in seconds.  If not passed the visual will be applied as   DURATION_TYPE_INSTANT.

  .. method:: Location:ApplyVisual(vfx, duration)

    Applies a visual effect to a location

    **Arguments**

    vfx : ``int``
      VFX_*
    duration : ``number``
      Duration in seconds.  If not passed the visual will be applied as   DURATION_TYPE_INSTANT.

  .. method:: Location:GetNearestObject(mask, nth)

    Gets nearest object to location

    **Arguments**

    mask : ``int``
      OBJECT_TYPE_*
    nth : ``int``
      Which object to find.


  .. method:: Location:GetNearestCreature(type1, value1, nth, ...)

    Gets nearest creature to location.

    **Arguments**

    type1 : ``int``
      First criteria type
    value1
      First crieria value
    nth : ``int``
      Nth nearest.
    type2 : ``int``
      Second criteria type.  (Default: -1)
    value2 : ``int``
      Second criteria value.  (Default: -1)
    type3 : ``int``
      Third criteria type.  (Default: -1)
    value3 : ``int``
      Third criteria value.  (Default: -1)

  .. method:: Location:ToString()

    Convert location to string

  .. method:: Location:Trap(type, size, tag, faction, on_disarm, on_trigger)

    Create square trap at location.

    type : ``int``
      TRAP_BASE_TYPE_*
    size : ``number``
      (Default 2.0)
    tag : ``string``
      Trap tag.  (Default: "")
    faction : ``int``
      Trap faction.  (Default: STANDARD_FACTION_HOSTILE)
    on_disarm : ``string``
      OnDisarm script.  (Default: "")
    on_trigger : ``string``
      OnTriggered script.  (Default: "")

  .. method:: Location:SetTileMainLightColor(color1, color2)

    Sets the main light colors for a tile.

    **Arguments**

    color1 : ``int``
      AREA_TILE_SOURCE_LIGHT_COLOR_*
    color2 : ``int``
      AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:SetTileSourceLightColor(color1, color2)

    Sets the source light color for a tile.

    **Arguments**

    color1 : ``int``
      AREA_TILE_SOURCE_LIGHT_COLOR_*
    color2 : ``int``
      AREA_TILE_SOURCE_LIGHT_COLOR_*


  .. method:: Location:GetTileMainLight1Color()

    Determines the color of the first main light of a tile.

    **Returns**

    AREA_TILE_SOURCE_LIGHT_COLOR_*


  .. method:: Location:GetTileMainLight2Color()

    Determines the color of the second main light of a tile.

    **Returns**

    AREA_TILE_SOURCE_LIGHT_COLOR_*


  .. method:: Location:GetTileSourceLight1Color()

    Determines the color of the first source light of a tile.

    **Returns**

    AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetTileSourceLight2Color()

    Determines the color of the second source light of a tile.

    **Returns**

    AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetArea()

    Get area from location.

  .. method:: Location:GetDistanceBetween(to)

    Gets distance between two locations.

    **Arguments**

    to : :class:`Location`
      The location to get the distance from.

  .. method:: Location:GetFacing()

    Gets orientation of a location

  .. method:: Location:GetPosition()

    Gets position vector of a location
