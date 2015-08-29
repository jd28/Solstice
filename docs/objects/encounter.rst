.. highlight:: lua
.. default-domain:: lua

.. class:: Encounter

class Encounter
===============

Signals
-------

.. data:: Encounter.signals

  A Lua table containing signals for encounter events.

  .. note::

    These signals are shared by **all** :class:`Encounter` instances.  If special
    behavior is required for a specific encounter it must be filtered by a signal handler.

  .. data:: Encounter.signals.OnEnter

  .. data:: Encounter.signals.OnExit

  .. data:: Encounter.signals.OnExhausted

  .. data:: Encounter.signals.OnHeartbeat

  .. data:: Encounter.signals.OnUserDefined


Methods
-------

  .. method:: Encounter:GetActive()

    Gets whether an encounter has spawned as is active.

  .. method:: Encounter:GetDifficulty()

    Get the difficulty level of the encounter.

    **Returns**

    ENCOUNTER_DIFFICULTY_*

  .. method:: Encounter:GetNumberSpawned()

    Get number of creatures spawned

  .. method:: Encounter:GetSpawnsCurrent()

    Get the number of times that the encounter has spawned so far.

  .. method:: Encounter:GetSpawnsMax()

    Get the maximum number of times that an encounter will spawn.

  .. method:: Encounter:GetSpawnPointCount()

    Gets the number of spawn points

  .. method:: Encounter:GetSpawnPointByIndex(idx)

    Gets a spawn point location.

    **Arguments**

    idx : ``int``
      Index in the spawn poing list.

    **Returns**

    :class:`Location`

  .. method:: Encounter:SetActive(value)

    Sets an encounter to active or inactive.

    **Arguments**

    value : ``bool``
      new value

  .. method:: Encounter:SetDifficulty(value)

    Sets the difficulty level of an encounter.

    **Arguments**

    value
      ENCOUNTER_DIFFICULTY_*

  .. method:: Encounter:SetSpawnsMax(value)

    Sets the maximum number of times that an encounter can spawn.

    **Arguments**

    value
      The new maximum spawn value.


  .. method:: Encounter:SetSpawnsCurrent(value)

    Sets the number of times that an encounter has spawned.

    **Arguments**

    value
      The new number of times the encounter has spawned.
