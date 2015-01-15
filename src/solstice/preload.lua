local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

--- Safe wrapper for require.
-- Allows for better catching errors and logging.
-- @param file File/module/etc to be passed to require
function safe_require(file)
   local Log = System.GetLogger()
   local ret
   local function req ()
      ret = require(file)
   end

   Log:info("Requiring: " .. file)

   local result, err = pcall(req)
   if not result then
      Log:error("ERROR Requiring: %s : %s \n", file, err)
      return ret
   end

   return ret
end

require 'solstice.util.extensions'
require 'solstice.global'
require 'solstice.combat'

-- Seed random number generator.
math.randomseed(os.time())
math.random(100)

if OPT.JIT_DUMP then
   local dump = require 'jit.dump'
   dump.on(nil, "luajit.dump")
end
