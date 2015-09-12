.. highlight:: lua
.. default-domain:: lua

class Encounter
===============

.. class:: Encounter

  .. method:: Encounter:GetActive()

    Gets whether an encounter has spawned as is active.

  .. method:: Encounter:GetDifficulty()

    Get the difficulty level of the encounter.

    :rtype: ENCOUNTER_DIFFICULTY_*

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

    :param int idx: Index in the spawn poing list.

    :rtype: :class:`Location`

  .. method:: Encounter:SetActive(value)

    Sets an encounter to active or inactive.

    :param boolean value: new value

  .. method:: Encounter:SetDifficulty(value)

    Sets the difficulty level of an encounter.

    :param int value: ENCOUNTER_DIFFICULTY_*

  .. method:: Encounter:SetSpawnsMax(value)

    Sets the maximum number of times that an encounter can spawn.

    :param int value: The new maximum spawn value.


  .. method:: Encounter:SetSpawnsCurrent(value)

    Sets the number of times that an encounter has spawned.

    :param int value: The new number of times the encounter has spawned.
