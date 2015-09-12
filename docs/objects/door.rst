.. highlight:: lua
.. default-domain:: lua

class Door
==========

.. class:: Door

  .. method:: Door:GetIsActionPossible(action)

    Determines whether an action can be used on a door.

    :param int action: DOOR_ACTION_*

  .. method:: Door:DoAction(action)

    Does specific action to target door.

    :param int action: DOOR_ACTION_*
