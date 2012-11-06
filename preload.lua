package.path = package.path .. ";./lua/?.lua;Solstice/?.lua"

local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

-- Needed for C.Local_NWNXLog below.
require 'nwn.funcs'

--- Safe wrapper for require.
--    Allows for better catching errors and logging.
-- @param file File/module/etc to be passed to require
function safe_require(file)
   local ret
   local function req ()
      ret = require(file)
   end

   C.Local_NWNXLog(0, "Requiring: " .. file .. "\n")

   local result, error = pcall(req)
   if not result then
      C.Local_NWNXLog(0, fmt("ERROR Requiring: %s : %s \n", file, error))
      return ret
   end

   return ret
end

NS_SETTINGS = safe_require 'settings'
if not NS_SETTINGS then
   error "Missing Solstice/settings.lua"
   return
end

if NS_OPT_USING_CEP then
   safe_require 'cep.preload'
end

safe_require "lua.lua_preload"
safe_require "nwn.preload"

if NS_OPT_SERVER_PRELOAD then
   safe_require(NS_OPT_SERVER_PRELOAD)
end

for f in lfs.dir("./Solstice") do
   if f ~= "preload.lua" and
      string.find(f:lower(), ".lua", -4) then
      local file = lfs.currentdir() .. "/Solstice/" .. f

      C.Local_NWNXLog(0, "Loading: " .. file .. "\n")

      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      result, error = pcall(function() dofile(file) end)
      if not result then
	 C.Local_NWNXLog(0, fmt("ERROR Loading: %s : %s \n", file, error))
      end
   end
end
