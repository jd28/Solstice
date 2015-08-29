--- Game module.
-- This module deals predominatedly with game related things that exist only during a single
-- server reset.
-- @module game

local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.game.init'
safe_require 'solstice.game.2da'
safe_require 'solstice.game.objects'
safe_require 'solstice.game.events'
safe_require 'solstice.game.plugins'
safe_require 'solstice.game.script'
safe_require 'solstice.game.properties'
safe_require 'solstice.game.tlk'

--- Export single character.
-- @param player Object to export.
function M.ExportSingleCharacter(player)
   NWE.StackPushObject(player)
   NWE.ExecuteCommand(719, 1)
end

--- Get if it's day
function M.GetIsDay()
   NWE.ExecuteCommand(405, 0)
   return NWE.StackPopBoolean()
end

--- Get if it's night
function M.GetIsNight()
   NWE.ExecuteCommand(406, 0)
   return NWE.StackPopBoolean()
end

--- Get if it's dawn
function M.GetIsDawn()
   NWE.ExecuteCommand(407, 0)
   return NWE.StackPopBoolean()
end

--- Get if it's dusk
function M.GetIsDusk()
   NWE.ExecuteCommand(408, 0)
   return NWE.StackPopBoolean()
end

--- Set calendar
-- @param year Specific year to set calendar to from 1340 to 32001.
-- @param month Specific month to set calendar from 1 to 12.
-- @param day Specific day to set calendar to from 1 to 28.
function M.SetCalendar(year, month, day)
   NWE.StackPushInteger(day)
   NWE.StackPushInteger(month)
   NWE.StackPushInteger(year)
   NWE.ExecuteCommand(11, 3)
end

--- Sets the game's current time.
-- @param hour The new hour value, from 0 to 23.
-- @param minute The new minute value from 0 to 1 (or 0 to a higher value if the module properties for time were changed).
-- @param second The new second value, from 0 to 59.
-- @param millisecond The new millisecond value, from 0 to 999.
function M.SetTime(hour, minute, second, millisecond)
   NWE.StackPushInteger(millisecond)
   NWE.StackPushInteger(second)
   NWE.StackPushInteger(minute)
   NWE.StackPushInteger(hour)
   NWE.ExecuteCommand(12, 4)
end

--- Determine the current in-game calendar year.
function M.GetYear()
   NWE.ExecuteCommand(13, 0)
   return NWE.StackPopInteger()
end

--- Determine the current in-game calendar month.
function M.GetMonth()
   NWE.ExecuteCommand(14, 0)
   return NWE.StackPopInteger()
end

--- Determine the current in-game calendar day.
function M.GetDay()
   NWE.ExecuteCommand(15, 0)
   return NWE.StackPopInteger()
end

--- Gets the current hour.
function M.GetHour()
   NWE.ExecuteCommand(16, 0)
   return NWE.StackPopInteger()
end

--- Gets the current minute.
function M.GetMinute()
   NWE.ExecuteCommand(17, 0)
   return NWE.StackPopInteger()
end

--- Gets the current second
function M.GetSecond()
   NWE.ExecuteCommand(18, 0)
   return NWE.StackPopInteger()
end

--- Gets the current millisecond.
function M.GetMillisecond()
   NWE.ExecuteCommand(19, 0)
   return NWE.StackPopInteger()
end

--- Force update time.
function M.UpdateTime()
   M.SetTime(M.GetTimeHour(),
	     M.GetTimeMinute(),
	     M.GetTimeSecond(),
	     M.GetTimeMillisecond())
end

--- Converts hours to seconds
-- @param hours Number of hours
function M.HoursToSeconds(hours)
   return hours * 60 * 60
end

--- Converts rounds to seconds
-- @param rounds Number of rounds
function M.RoundsToSeconds(rounds)
   return 6 * rounds
end

--- Converts turns to seconds
-- @param turns Number of turns
function M.TurnsToSeconds(turns)
   return 60 * turns
end

return M
