.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Constants
---------

.. function:: RegisterConstants(tda, column_label[, extract[, value_label[, value_type]]])

  Register constant loader.

  tda : ``string``
    2da name (without .2da)
  column_label : ``string``
    Label of the 2da column that contains constant names.
  extract : ``string``
    A lua string.match pattern for extracting a constant name.
    E,g: `"FEAT_([%w_]+)"` to strip off 'FEAT\_'
  value_label : ``string``
    Label of the 2da column that contains the constants value.  If not passed constant
    value will be the 2da row number.
  value_type : ``string``
    Constant type.  Only used when ``value_label`` is passed. Legal values: "int", "string", "float"

.. function:: RegisterConstant(name, value)

  Register constant in global constant table.

  **Arguments**

  name : ``string``
    Constant's name.
  value
    Consants's value.  Can be any Lua object.

.. function:: ConvertSaveToItempropConstant(const)

  **Arguments**

  const : ``int``
    SAVING_THROW\_*

.. function:: ConvertSaveVsToItempropConstant(const)

  **Arguments**

  const : ``int``
    SAVING_THROW_VS\_*

.. function:: ConvertImmunityToIPConstant(const)

  **Arguments**

  const : ``int``
    IMMUNITY_TYPE\_*

