.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.events

nwnx.events
===========

Constants
---------

.. data:: EVENT_TYPE_ALL

.. data:: EVENT_TYPE_SAVE_CHAR

.. data:: EVENT_TYPE_PICKPOCKET

.. data:: EVENT_TYPE_ATTACK

.. data:: EVENT_TYPE_USE_ITEM

.. data:: EVENT_TYPE_QUICKCHAT

.. data:: EVENT_TYPE_EXAMINE

.. data:: EVENT_TYPE_USE_SKILL

.. data:: EVENT_TYPE_USE_FEAT

.. data:: EVENT_TYPE_TOGGLE_MODE

.. data:: EVENT_TYPE_CAST_SPELL

.. data:: EVENT_TYPE_TOGGLE_PAUSE

.. data:: EVENT_TYPE_POSSESS_FAMILIAR

.. data:: EVENT_TYPE_DESTROY_OBJECT


.. data:: NODE_TYPE_STARTING_NODE

.. data:: NODE_TYPE_ENTRY_NODE

.. data:: NODE_TYPE_REPLY_NODE


.. data:: LANGUAGE_ENGLISH

.. data:: LANGUAGE_FRENCH

.. data:: LANGUAGE_GERMAN

.. data:: LANGUAGE_ITALIAN

.. data:: LANGUAGE_SPANISH

.. data:: LANGUAGE_POLISH

.. data:: LANGUAGE_KOREAN

.. data:: LANGUAGE_CHINESE_TRADITIONAL

.. data:: LANGUAGE_CHINESE_SIMPLIFIED

.. data:: LANGUAGE_JAPANESE

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

.. function:: GetEventInfo()

.. function:: BypassEvent()

.. function:: RegisterEventHandler(event_type, f)

.. function:: SetEventReturnValue(val)

.. function:: GetCurrentNodeType()

.. function:: GetCurrentNodeID()

.. function:: GetCurrentAbsoluteNodeID()

.. function:: GetSelectedNodeID()

.. function:: GetSelectedAbsoluteNodeID()

.. function:: GetSelectedNodeText(nLangID, nGender)

.. function:: GetCurrentNodeText(nLangID, nGender)

.. function:: SetCurrentNodeText(sText, nLangID, nGender)
