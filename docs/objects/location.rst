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

    :param position: Location's position
    :type position: :class:`Vector`
    :param orientation: Location's orientation
    :type orientation: :class:`Vector`
    :param area: Location's area
    :type area: :class:`Area`
    :rtype: :class:`Location` instance.

  .. function:: Location.FromString(str)

    Convert string to location.

    :param string str: String representation of a location.  Format: "area_tag (x, y, z) orientation"
    :rtype: :class:`Location` instance.

Methods
-------

  .. method:: Location:ApplyEffect(durtype, eff, duration)

    Applies an effect to a location.

    :param int durtype: DURATION_TYPE_*
    :param eff: Effect to apply.
    :type eff: :class:`Effect`
    :param float duration: Duration in seconds.  If not passed the visual will be applied as   DURATION_TYPE_INSTANT.

  .. method:: Location:ApplyVisual(vfx, duration)

    Applies a visual effect to a location

    :param int vfx: VFX_*
    :param float duration: Duration in seconds.  If not passed the visual will be applied as   DURATION_TYPE_INSTANT.

  .. method:: Location:GetNearestObject(mask, nth)

    Gets nearest object to location

    :param int mask: OBJECT_TYPE_*
    :param int nth: Which object to find.

  .. method:: Location:GetNearestCreature(type1, value1, nth, ...)

    Gets nearest creature to location.

    :param int type1: First criteria type
    :param int value1: First crieria value
    :param int nth: Nth nearest.
    :param int type2: Second criteria type.  (Default: -1)
    :param int value2: Second criteria value.  (Default: -1)
    :param int type3: Third criteria type.  (Default: -1)
    :param int value3: Third criteria value.  (Default: -1)

  .. method:: Location:ToString()

    Convert location to string

  .. method:: Location:Trap(type, size, tag, faction, on_disarm, on_trigger)

    Create square trap at location.

    :param int type: TRAP_BASE_TYPE_*
    :param float size: (Default 2.0)
    :param string tag: Trap tag.  (Default: "")
    :param int faction: Trap faction.  (Default: STANDARD_FACTION_HOSTILE)
    :param string on_disarm: OnDisarm script.  (Default: "")
    :param string on_trigger: OnTriggered script.  (Default: "")

  .. method:: Location:SetTileMainLightColor(color1, color2)

    Sets the main light colors for a tile.

    :param int color1: AREA_TILE_SOURCE_LIGHT_COLOR_*
    :param int color2: AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:SetTileSourceLightColor(color1, color2)

    Sets the source light color for a tile.

    :param int color1: AREA_TILE_SOURCE_LIGHT_COLOR_*
    :param int color2: AREA_TILE_SOURCE_LIGHT_COLOR_*


  .. method:: Location:GetTileMainLight1Color()

    Determines the color of the first main light of a tile.

    :rtype: AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetTileMainLight2Color()

    Determines the color of the second main light of a tile.

    :rtype: AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetTileSourceLight1Color()

    Determines the color of the first source light of a tile.

    :rtype: AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetTileSourceLight2Color()

    Determines the color of the second source light of a tile.

    :rtype: AREA_TILE_SOURCE_LIGHT_COLOR_*

  .. method:: Location:GetArea()

    Get area from location.

  .. method:: Location:GetDistanceBetween(to)

    Gets distance between two locations.

    :param to: The location to get the distance from.
    :type to: :class:`Location`

  .. method:: Location:GetFacing()

    Gets orientation of a location

  .. method:: Location:GetPosition()

    Gets position vector of a location
