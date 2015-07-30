--- Game
-- @module game

--- TLK
-- @section tlk

local NWE = require 'solstice.nwn.engine'

--- Get duration of a strref sound
-- @param strref TLK reference.
local function GetTlkSoundDuration(strref)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(571, 1);
   return NWE.StackPopFloat()
end

--- Gets dialog sound length of a strref
-- @param strref TLK table reference.
local function GetTlkSoundLength(strref)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(694, 1)
   return NWE.StackPopFloat()
end

--- Get string by TLK table reference.
-- @param strref TLK table reference.
-- @bool[opt=false] female If true gets string from 'female'
-- TLK table, else 'male'.
local function GetTlkString(strref, female)
   NWE.StackPushBoolean(female)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(239, 2)
   return NWE.StackPopString()
end

-- Exports
local M = require 'solstice.game.init'
M.GetTlkSoundDuration = GetTlkSoundDuration
M.GetTlkSoundLength = GetTlkSoundLength
M.GetTlkString = GetTlkString
