--- System
-- @module system
-- @alias M

local M = require 'solstice.system.init'
local _DATABASE = nil

--- Database
-- @section database

--- Connect to a database.
-- @param driver_name 'MySQL', 'PostgreSQL', or 'SQLite3' depending on
-- which database you use.
-- @param dbname Name.
-- @param dbuser User.
-- @param dbpassword Password.
-- @param dbhost Host.
-- @param dbport Port.
local function ConnectDatabase(driver_name, dbname, dbuser,
                               dbpassword, dbhost, dbport)
   -- Apparently this library declares globals...
   GLOBAL_unlock(_G)
   local DBI = require 'DBI'
   local dbh, err = DBI.Connect(driver_name, dbname, dbuser,
                                dbpassword, dbhost, dbport)
   GLOBAL_lock(_G)
   if not dbh then
      local Log = M.GetLogger()
      Log:error("Cannot connect to database: %s\n", err)
   else
      dbh:autocommit(true)
      _DATABASE = dbh
   end
   return _DATABASE
end

local function GetDatabase()
   return assert(_DATABASE, "ERROR: No database!")
end

M.ConnectDatabase = ConnectDatabase
M.GetDatabase = GetDatabase
