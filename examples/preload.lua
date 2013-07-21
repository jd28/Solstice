package.path = package.path .. ";./lua/?.lua;"

local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

-- Needed for C.Local_NWNXLog below.
require 'solstice.nwn.funcs'

--- Safe wrapper for require.
-- Allows for better catching errors and logging.
-- @param file File/module/etc to be passed to require
function safe_require(file)
   local ret
   local function req ()
      ret = require(file)
   end

   C.Local_NWNXLog(0, "Requiring: " .. file .. "\n")

   local result, err = pcall(req)
   if not result then
      C.Local_NWNXLog(0, fmt("ERROR Requiring: %s : %s \n", file, err))
      return ret
   end

   return ret
end

safe_require "solstice.util.lua_preload"

OPT = runfile('./lua/settings.lua')

for k, v in pairs(OPT) do
   print(k,v)
end

if OPT.USING_CEP then
   safe_require 'solstice.cep.preload'
end

safe_require "solstice.preload"

if OPT.PRELOAD then
   safe_require(OPT.PRELOAD)
end

for f in lfs.dir("./lua") do
   if f ~= "preload.lua" and 
      f ~= "settings.lua" and
      string.find(f:lower(), ".lua", -4) 
   then
      local file = lfs.currentdir() .. "/lua/" .. f

      C.Local_NWNXLog(0, "Loading: " .. file .. "\n")

      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      local result, err = pcall(function() dofile(file) end)
      if not result then
         C.Local_NWNXLog(0, fmt("ERROR Loading: %s : %s \n", file, err))
      end
   end
end
