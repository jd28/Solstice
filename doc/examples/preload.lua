-- The preload.lua file serves to intialize constants, Solstice,
-- and whatever you'd want.
-- The following preload is from my PW.  Note that some things are
-- are required for all preloads.

local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format
local inih = require 'inih'

-- Some sane defaults, can be overwritten in nwnx2.ini.
local script_dir = 'lua'
local log_dir = "logs.0"

-- Required: loads Lua extensions and utility functions required for
-- loading Solstice.
require "solstice.util"

-- Read pertinent settings from nwnx2.ini
print(inih.parse('nwnx2.ini',
           function(section, name, value)
              if section == "SOLSTICE" and name == "script_dir" then
                 script_dir = (script_dir or value:trim())
              end
              if section == "LogDir" and name == 'logdir' then
                 log_dir = lfs.currentdir() .. '/' .. (log_dir or value:trim())
              end
              return true
           end))

-- Required: package path so Lua can find your scripts and libraries.
package.path = package.path .. ";./"..script_dir.."/?.lua;"

-- Required: Load your settings into global table `OPT`.
OPT = runfile(fmt('./%s/settings.lua', script_dir))
OPT.LOG_DIR = log_dir
OPT.SCRIPT_DIR = script_dir

-- Required: Initialize the Logger.  If you'd change default logging
-- behavior or add additional loggers, you could do that here.  LuaLogging
-- can be made to support anything.  Logging to databases, files, sending
-- emails (if you have an SMTP server).
local Sys = require 'solstice.system'
local log = Sys.FileLogger(OPT.LOG_DIR .. '/' .. OPT.LOG_FILE, OPT.LOG_DATE_PATTERN)
Sys.SetLogger(log)

-- Required: Constants MUST be loaded before solstice.
require(OPT.CONSTANTS)
require('solstice.preload')

-- If you want to use a combat engine then best to place it here.
-- e,g. `require 'ta.core_combat_engine'`

-- Optional: If you don't want to use the database or if you want to
-- do it yourself.
if OPT.DATABASE_TYPE
   and OPT.DATABASE_HOSTNAME
   and OPT.DATABASE_PASSWORD
   and OPT.DATABASE_NAME
   and OPT.DATABASE_USER
then
   local DBI = require 'DBI'
   local dbh = System.ConnectDatabase(OPT.DATABASE_TYPE,
                                      OPT.DATABASE_NAME,
                                      OPT.DATABASE_USER,
                                      OPT.DATABASE_PASSWORD,
                                      OPT.DATABASE_HOSTNAME,
                                      OPT.DATABASE_PORT)
   if dbh then
      -- You could change any DB settings here.  Turning autocommit off
      -- or whatever.
   end

end

-- Required: Load all the top level scripts.
for f in lfs.dir("./"..script_dir) do
   if f ~= "preload.lua" and
      f ~= "settings.lua" and
      f ~= OPT.CONSTANTS .. '.lua' and
      string.find(f:lower(), ".lua", -4)
   then
      local file = fmt('%s/%s/%s', lfs.currentdir(), script_dir, f)
      log:info("Loading: " .. file)

      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      local result, err = pcall(function() dofile(file) end)
      if not result then
         log:error("ERROR Loading: %s : %s", file, err)
      end
   end
end
