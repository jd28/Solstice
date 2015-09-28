--- Game
-- @module game

--- TLK
-- @section tlk

local ffi = require 'ffi'

local function GetTlkString(strref)
   local s = ffi.C.nwn_GetStringByStrref(strref)
   local ret = ""
   if s ~= nil then
      ret = ffi.string(s)
      ffi.C.free(s)
   end
   return ret
end

-- Exports
local M = require 'solstice.game.init'
M.GetTlkString = GetTlkString
