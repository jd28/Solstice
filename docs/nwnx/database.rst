.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.database

nwnx.database
=============

Constants
---------

.. data:: SQL_ERROR

.. data:: SQL_SUCCESS

Functions
---------

.. function:: SQLInit()

.. function:: SQLExecDirect(sql)

.. function:: SQLFetch()

.. function:: SQLGetData(column)

.. function:: SQLEncodeSpecialChars(text)

.. function:: SQLDecodeSpecialChars(text)

.. function:: GetString(object, varname, is_global, table)

.. function:: SetString(object, varname, value, expires, is_global, table)

.. function:: SetInt(object, varname, value, expires, is_global, table)

.. function:: GetInt(object, varname, is_global, table)

.. function:: SetFloat(object, varname, value, expires, is_global, table)

.. function:: GetFloat(object, varname, is_global, table)

.. function:: SetLocation(object, varname, value, expires, is_global, table)

.. function:: GetLocation(object, varname, is_global, table)

.. function:: SetVector(object, varname, value, expires, is_global, table)

.. function:: GetVector(object, varname, is_global, table)

.. function:: SetObject(object, varname, obj, expires, is_global, table)

.. function:: GetObject(object, varname, owner, is_global, table)

.. function:: DeleteVariable(object, varname, is_global, table)

.. function:: DeleteAllVariables(object, is_global, table)

