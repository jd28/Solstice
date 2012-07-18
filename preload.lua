package.path = package.path .. ";./lua/?.lua;Solstice/?.lua"

local lfs = require 'lfs'
local ffi = require 'ffi'

NS_SETTINGS = require 'settings'

if not NS_SETTINGS then
   error "Missing Solstice/settings.lua"
   return
end

if NS_OPT_USING_CEP then
   require 'cep.preload'
end

require "lua.lua_preload"
require "nwn.preload"

for f in lfs.dir("./Solstice") do
   if f ~= "preload.lua" and
      string.find(f:lower(), ".lua", -4) then
      local file = lfs.currentdir() .. "/Solstice/" .. f
      ffi.C.Local_NWNXLog(0, "Loading: " .. file .. "\n")
      dofile(file)
   end
end
