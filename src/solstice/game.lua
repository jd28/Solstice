--- Game module.
-- This module deals predominatedly with game related things that exist only during a single
-- server reset.
-- @module game

local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.game.init'
safe_require 'solstice.game.2da'
safe_require 'solstice.game.events'
safe_require 'solstice.game.objects'
safe_require 'solstice.game.plugins'
safe_require 'solstice.game.script'
safe_require 'solstice.game.signals'
safe_require 'solstice.game.tlk'

function M.GetIsDay()
   local mod = M.GetModule()
   if not mod:GetIsValid() then return false end
   return mod.obj.mod_time_of_day == 1
end

function M.GetIsNight()
   local mod = M.GetModule()
   if not mod:GetIsValid() then return false end
   return mod.obj.mod_time_of_day == 2

end

function M.GetIsDawn()
   local mod = M.GetModule()
   if not mod:GetIsValid() then return false end
   return mod.obj.mod_time_of_day == 3
end

function M.GetIsDusk()
   local mod = M.GetModule()
   if not mod:GetIsValid() then return false end
   return mod.obj.mod_time_of_day == 4
end

function M.SetCalendar(year, month, day)
   NWE.StackPushInteger(day)
   NWE.StackPushInteger(month)
   NWE.StackPushInteger(year)
   NWE.ExecuteCommand(11, 3)
end

function M.SetTime(hour, minute, second, millisecond)
   NWE.StackPushInteger(millisecond)
   NWE.StackPushInteger(second)
   NWE.StackPushInteger(minute)
   NWE.StackPushInteger(hour)
   NWE.ExecuteCommand(12, 4)
end

function M.GetYear()
   NWE.ExecuteCommand(13, 0)
   return NWE.StackPopInteger()
end

function M.GetMonth()
   NWE.ExecuteCommand(14, 0)
   return NWE.StackPopInteger()
end

function M.GetDay()
   NWE.ExecuteCommand(15, 0)
   return NWE.StackPopInteger()
end

function M.GetHour()
   NWE.ExecuteCommand(16, 0)
   return NWE.StackPopInteger()
end

function M.GetMinute()
   NWE.ExecuteCommand(17, 0)
   return NWE.StackPopInteger()
end

function M.GetSecond()
   NWE.ExecuteCommand(18, 0)
   return NWE.StackPopInteger()
end

function M.GetMillisecond()
   NWE.ExecuteCommand(19, 0)
   return NWE.StackPopInteger()
end

function M.UpdateTime()
   M.SetTime(M.GetTimeHour(),
	     M.GetTimeMinute(),
	     M.GetTimeSecond(),
	     M.GetTimeMillisecond())
end

function M.HoursToSeconds(hours)
   return hours * 60 * 60
end

function M.RoundsToSeconds(rounds)
   return 6 * rounds
end

function M.TurnsToSeconds(turns)
   return 60 * turns
end

return M
