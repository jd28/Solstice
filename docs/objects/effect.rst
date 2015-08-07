.. highlight:: lua
.. default-domain:: lua

class Effect
============

.. class:: Effect

Methods
-------

  .. method:: Effect:ToString()

    Converts an effect to a formatted string.

  .. method:: Effect:GetCreator()

    **Returns**

      Effect's creator.

  .. method:: Effect:GetDuration ()

    Gets the duration of an effect.

    **Returns**

      The duration specified when applied for
      the effect. The value of this is undefined for effects which are
      not of DURATION_TYPE_TEMPORARY.

  .. method:: Effect:GetDurationRemaining ()

    Gets the remaing duration of an effect

    **Returns**

      The remaining duration of the specified effect. The value
      of this is undefined for effects which are not of
      DURATION_TYPE_TEMPORARY.

  .. method:: Effect:GetDurationType()

    Get duration type

    **Returns**

      DURATION_TYPE_*

  .. method:: Effect:GetFloat(index)

    Get effect float value.

    **Arguments**

    index : ``int``
      Index

  .. method:: Effect:GetId()

    Gets the specifed effects Id

  .. method:: Effect:GetIsValid()

    Determines whether an effect is valid.

  .. method:: Effect:GetInt(index)

    Get effect integer value at the index specified.

    **Arguments**

      index : ``int``
        Index

  .. method:: Effect:GetObject(index)

    Get effect object value.

    **Arguments**

      index : ``int``
        Index


  .. method:: Effect:GetSpellId()

    Gets Spell Id associated with effect

    **Returns**

      SPELL_* constant.

  .. method:: Effect:GetString(index)

    Gets a string on an effect.

    **Arguments**

      index : ``int``
        Index to store the string.  [0, 5]

  .. method:: Effect:GetSubType()

    Get the subtype of the effect.

    **Returns**

      SUBTYPE_* constant.

  .. method:: Effect:GetType()

    Gets effects internal 'true' type.

  .. method:: Effect:SetAllInts(val)

    Set all integers to a specified value

  .. method:: Effect:SetCreator(object)

    Sets the effects creator

    **Arguments**

      object : :class:`Object`

  .. method:: Effect:SetDuration(dur)

  .. method:: Effect:SetDurationType(dur)

  .. method:: Effect:SetFloat(index, float)

    Set effect float

    **Arguments**

      index : ``int``
        Index. [0, 3]
      float : ``number``
        Float

  .. method:: Effect:SetInt(index, value)

    Sets the internal effect integer at the specified index to the
    value specified. Source: nwnx_structs by Acaos

  .. method:: Effect:SetNumIntegers(num)

    Set number of integers stored on an effect.
    Calling this on an effect will erase any integers already stored on the effect.

    **Arguments**

      num : ``int``
        Number of integers.

  .. method:: Effect:SetObject(index, object)

    Set effect object

    **Arguments**

      index : ``int``
        Index. [0, 3]
      object : :class:`Object`
        Object

  .. method:: Effect:SetSpellId (spellid)

    Sets the effect's spell id as specified, which will later be returned
    with Effect:GetSpellId().

    **Arguments**

      spellid : ``int``
        SPELL_* constant.

  .. method:: Effect:SetString(index, str)

    Sets a string on an effect.

    **Arguments**

      index : ``int``
        Index to store the string.  [0, 5]
      str : ``string``
        String to store.

  .. method:: Effect:SetSubType(value)

    Set the subtype of the effect.

    **Arguments**

      value : ``int``
        SUBTYPE_*

  .. method:: Effect:SetType(value)

    Sets effects type.

    **Arguments**

      value : ``int``
        EFFECT_TYPE_*

  .. method:: Effect:SetExposed(val)

    Set exposed.

    **Arguments**

      val : ``bool``
        Value

  .. method:: Effect:SetIconShown(val)

    Set icon shown.

    **Arguments**

      val : ``bool``
        Value
