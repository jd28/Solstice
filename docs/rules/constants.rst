.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Constants
---------

.. function:: ConvertSaveToItempropConstant(const)

  :param int const: SAVING_THROW_*

.. function:: ConvertSaveVsToItempropConstant(const)

  :param int const: SAVING_THROW_VS_*

.. function:: ConvertImmunityToIPConstant(const)

  :param int const: IMMUNITY_TYPE_*

.. function:: RegisterConstants(tda, column_label[, extract[, value_label[, value_type]]])

  Register constant loader.

  :param string tda: 2da name (without .2da)
  :param string column_label: Label of the 2da column that contains constant names.
  :param string extract: A lua ``string.match`` pattern for extracting a constant name.
  :param string value_label: Label of the 2da column that contains the constants value.  If not passed constant value will be the 2da row number.
  :param string value_type: Constant type.  Only used when ``value_label`` is passed. Legal values: "int", "string", "float"

.. function:: RegisterConstant(name, value)

  Register constant in global constant table.

  :param string name: Constant's name.
  :param value: Consants's value.  Can be any Lua object.
