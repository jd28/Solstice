.. default-domain:: lua

System
======

Database
--------

.. function:: ConnectDatabase(driver_name, dbname, dbuser, dbpassword, dbhost, dbport)

  Connect to a database.

  :param string driver_name: 'MySQL', 'PostgreSQL', or 'SQLite3' depending on which database you use.
  :param string dbname: Name.
  :param string dbuser: User.
  :param string dbpassword: Password.
  :param string dbhost: Host.
  :param int dbport: Port.

.. function:: GetDatabase()

  Get the active database connection.

Logging
-------

.. function:: SetLogger(logger)

  Sets the default logging function.

  :param logger: See `LuaLogging`_.

.. function:: GetLogger()

  Get current logger.

.. function:: FileLogger(filename, date_time)

  Create a file logger.

  :param string filename: File name.
  :param string date_time: Date/time format see os.date

Lua
---

.. function:: CollectGarbage()

  Run Lua garbage collector.

  :rtype: The amount in KB freed.

.. function:: LogGlobalTable()

  Log the global Lua table

.. _LuaLogging: http://neopallium.github.io/lualogging/