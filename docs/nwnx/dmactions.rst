.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.dmactions

nwnx.dmactions
==============

Constant
--------

.. data:: DM_ACTION_MESSAGE_TYPE

.. data:: DM_ACTION_GIVE_XP

.. data:: DM_ACTION_GIVE_LEVEL

.. data:: DM_ACTION_GIVE_GOLD

.. data:: DM_ACTION_CREATE_ITEM_ON_OBJECT

.. data:: DM_ACTION_CREATE_ITEM_ON_AREA

.. data:: DM_ACTION_HEAL_CREATURE

.. data:: DM_ACTION_REST_CREATURE

.. data:: DM_ACTION_RUNSCRIPT

.. data:: DM_ACTION_CREATE_PLACEABLE

.. data:: DM_ACTION_SPAWN_CREATURE

.. data:: DM_ACTION_TOGGLE_INVULNERABILITY

.. data:: DM_ACTION_TOGGLE_IMMORTALITY


Functions
---------

.. function:: SetScript(nAction, sScript)

.. function:: GetID(dm)

.. function:: Prevent(dm)

.. function:: nGetDMAction_Param(dm, second)

.. function:: GetDMAction_Param(dm)

.. function:: GetTarget(dm, second)

.. function:: GetPosition(dm)

.. function:: GetTargetsCount(dm)

.. function:: GetTargetsCurrent(dm)