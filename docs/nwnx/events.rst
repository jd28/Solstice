.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.events

nwnx.events
===========

Constants
---------

.. data:: NODE_TYPE_ENTRY_NODE

.. data:: NODE_TYPE_REPLY_NODE

.. data:: NODE_TYPE_STARTING_NODE

.. data:: LANGUAGE_CHINESE_SIMPLIFIED

.. data:: LANGUAGE_CHINESE_TRADITIONAL

.. data:: LANGUAGE_ENGLISH

.. data:: LANGUAGE_FRENCH

.. data:: LANGUAGE_GERMAN

.. data:: LANGUAGE_ITALIAN

.. data:: LANGUAGE_JAPANESE

.. data:: LANGUAGE_KOREAN

.. data:: LANGUAGE_POLISH

.. data:: LANGUAGE_SPANISH

Signals
-------

.. data:: SaveCharacter

.. data:: PickPocket

.. data:: Attack

.. data:: QuickChat

.. data:: Examine

.. data:: CastSpell

.. data:: TogglePause

.. data:: PossessFamiliar

.. data:: DestroyObject

Tables
------

.. data:: NWNXEventInfo

  Event Info Table

  **Fields**

  type
    Event type
  subtype
    Event subtype
  target
    Event target or OBJECT_INVALID
  item
    Event item or OBJECT_INVALID
  pos
    Event location vector

Functions
---------

.. function:: BypassEvent()

.. function:: GetCurrentAbsoluteNodeID()

.. function:: GetCurrentNodeID()

.. function:: GetCurrentNodeText(nLangID, nGender)

.. function:: GetCurrentNodeType()

.. function:: GetEventSignal(event)

  :param int event: EVENT_TYPE_*
  :rtype: A signal.

.. function:: GetSelectedAbsoluteNodeID()

.. function:: GetSelectedNodeID()

.. function:: GetSelectedNodeText(nLangID, nGender)

.. function:: SetCurrentNodeText(sText, nLangID, nGender)

.. function:: SetEventReturnValue(val)
