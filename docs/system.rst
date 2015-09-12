.. default-domain:: lua

System
======

Campaign Database
-----------------

.. function:: DeleteCampaignVariable(name, var, player)

.. function:: DestroyCampaignDatabase(name)

.. function:: GetCampaignFloat(name, var, player)

.. function:: GetCampaignInt(name, var, player)

.. function:: GetCampaignLocation(name, var, player)

.. function:: GetCampaignString(name, var, player)

.. function:: GetCampaignVector(name, var, player)

.. function:: RetrieveCampaignObject(name, var, loc, owner, player)

.. function:: SetCampaignFloat(name, var, value, player)

.. function:: SetCampaignInt(name, var, value, player)

.. function:: SetCampaignLocation(name, var, value, player)

.. function:: SetCampaignString(name, var, value, player)

.. function:: SetCampaignVector(name, var, value, player)

.. function:: StoreCampaignObject(name, var, value, player)

Database
--------

.. function:: ConnectDatabase(driver_name, dbname, dbuser, dbpassword, dbhost, dbport)

  Connect to a database.

  :param driver_name: 'MySQL', 'PostgreSQL', or 'SQLite3' depending on which database you use.
  :param dbname: Name.
  :param dbuser: User.
  :param dbpassword: Password.
  :param dbhost: Host.
  :param dbport: Port.

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