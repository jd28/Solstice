--- TLK
-- @module tlk

local NWE = require 'solstice.nwn.engine'

local M = {}

--- Get duration of a strref sound
-- @param strref TLK reference.
function M.GetSoundDuration(strref)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(571, 1);
   return NWE.StackPopFloat()
end

--- Gets dialog sound length of a strref
-- @param strref TLK table reference.
function M.GetSoundLength(strref)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(694, 1)
   return NWE.StackPopFloat()
end

--- Get string by TLK table reference.
-- @param strref TLK table reference.
-- @bool[opt=false] gender If true gets string from 'female'
-- TLK table, else 'male'.
function M.GetString(strref, female)
   NWE.StackPushBoolean(gender)
   NWE.StackPushInteger(strref)
   NWE.ExecuteCommand(239, 2)
   return NWE.StackPopString()
end

return M
