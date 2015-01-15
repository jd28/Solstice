-- The preload.lua file serves to intialize constants, Solstice,
-- and whatever you'd want.
-- The following preload is from my PW.  Note that some things are
-- are required for all preloads.

local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

-- Must be the same as in nwnx2.ini
local script_dir = 'lua'

-- Required: package path so Lua can find your scripts and libraries.
package.path = package.path .. ";./"..script_dir.."/?.lua;"

-- Required: loads Lua extensions require for loading Solstice.
require "solstice.util.lua_preload"

-- Required: Load your settings into global table `OPT`.
OPT = runfile(fmt('./%s/settings.lua', script_dir))

-- Required: Initialize the Logger.  If you'd change default logging
-- behavior or add additional loggers, you could do that here.  LuaLogging
-- can be made to support anything.  Logging to databases, files, sending
-- emails (if you have an SMTP server).
local log = require('solstice.system').GetLogger()

-- Required: Constants MUST be loaded before solstice.
require(OPT.CONSTANTS)
require('solstice.preload')

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
