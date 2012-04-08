package.path = package.path .. ";./lua/?.lua;Solstice/?.lua"

local lfs = require "lfs"
require "lua.lua_preload"
require "nwn.preload"

for f in lfs.dir("./Solstice") do
   if f ~= "preload.lua" and
      string.find(f:lower(), ".lua", -4) then
      local file = lfs.currentdir() .. "/Solstice/" .. f
      print("Loading: " .. file)
      dofile(file)
   end
end
