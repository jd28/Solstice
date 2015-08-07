.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.items

nwnx.items
==========

nwnx_items allows orrividing some aspects of items:

- Whether a creature can equip, use, unequip an item.
- The base cost and weight of item.
- The items minimum level required to equip. Note: this requires using the ILR setting on
  your server.

It also allows you to override or create new itemproperty add/
remove events.  E,g. if you added an item property to grant spell
DC increase, you could use this to directly modify some local int
that your spell system uses to calculate DC.  The alternative to
this is looping through all item properties when the item is
(un)equipped.

Constants
---------

.. data:: EVENT_ALL

.. data:: EVENT_CAN_EQUIP

  Can equip item event.  Note that using :func:`SetResult(true)`
  will essentially operate like if a DM was equipping the
  item.

.. data:: EVENT_CAN_UNEQUIP

  Can unequip item event.  Note only :func:`SetResult(false)` is respected.

.. data:: EVENT_MIN_LEVEL

  Minimum level required event.  This is used to determine ILR.

.. data:: EVENT_CAN_USE

  Can use item event.  Note that using :func:`SetResult(true)`
  will essentially operate like if a DM was equipping the
  item.  SetResult(false) will highlight the item in red.
  However, you'll still need to override the EVENT_CAN_EQUIP
  event to ensure a player cannot equip the item.

.. data:: EVENT_CALC_BASE_COST

  Calculate base cost event.  The value passed to :func:`SetResult` must be positive.

.. data:: EVENT_COMPUTE_WEIGHT

  Calculate item weight event.  The value passed to :func:`SetResult` must be positive.

.. data:: EVENT_NUM

Functions
---------

.. function:: RegisterItemEventHandler(ev_type, f)

.. function:: RegisterItempropHandler(f, ...)

.. function:: GetDefaultILR(item)

.. function:: SetHelmetHidden(pc, val)

.. function:: SetResult(result)