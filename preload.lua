package.path = package.path .. ";./lua/?.lua"

local lfs = require "lfs"
require "lua.lua_preload"
require "nwn.preload"

for f in lfs.dir("./lua") do
   if f ~= "preload.lua" and
      string.find(f:lower(), ".lua", -4) then
      local file = lfs.currentdir() .. "/lua/" .. f
      print("Loading: " .. file)
      dofile(file)
   end
end
