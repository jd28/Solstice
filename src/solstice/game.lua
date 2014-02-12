local M = {}

--- Get Module.
function M.GetModule()
   NWE.ExecuteCommand(242, 0)
   return NWE.StackPopObject()
end

--- Create an object of a specified type at a given location
-- NWScript: CreateObject
-- @param object_type solstice.object.ITEM, solstice.object.CREATURE,
-- solstice.object.PLACEABLE, solstice.object.STORE, solstice.object.WAYPOINT.
-- @param template The resref of the object to create from the pallet.
-- @param loc The location to create the object at.
-- @param[opt=false] appear If `true`, the object will play its spawn in animation.
-- @param[opt=""] newtag If this string is not empty, it will replace the default tag from the template.
-- @return New object or solstice.object.INVALID
function M.CreateObject(object_type, template, loc, appear, newtag)
   if appear == nil then appear = false end
   newtag = newtag or ""
   NWE.StackPushString(newtag)
   NWE.StackPushBoolean(appear)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_LOCATION, loc)
   NWE.StackPushString(template)
   NWE.StackPushInteger(object_type)
   NWE.ExecuteCommand(243, 5)

   return NWE.StackPopObject()
end

--- Gets an object by tag
-- @param tag Tag of object
-- @param[opt=1] nth Nth object.
function M.GetObjectByTag(tag, nth)
   nth = nth or 1

   NWE.StackPushInteger(nth)
   NWE.StackPushString(tag)
   NWE.ExecuteCommand(200, 2)
   return NWE.StackPopObject()
end

--- Export all characters.
function M.ExportAllCharacters()
   NWE.ExecuteCommand(557, 0)
end

--- Export single character.
-- @param player Object to export.
function M.ExportSingleCharacter(player)
   NWE.StackPushObject(player)
   NWE.ExecuteCommand(719, 1)
end

--- Gets first PC
--     This function should probably be passed over in favor
--     of the M.PCs iterator.
-- @return solstice.object.INVALID if no PCs are logged into the server.
-- @see solstice.pc.PCs
function M.GetFirstPC()
   NWE.ExecuteCommand(548, 0)
   return NWE.StackPopObject()
end

--- Get next PC
-- @return solstice.object.INVALID if there are no furter PC
-- @see solstice.pc.PCs
function M.GetNextPC()
   NWE.ExecuteCommand(549, 0)
   return NWE.StackPopObject()
end


--- Gets the PC speaker.
function M.GetPCSpeaker()
   NWE.ExecuteCommand(238, 0)
   return NWE.StackPopObject()
end

--- Iterator over all PCs
function M.PCs() end
M.PCs = iter_first_next_isvalid(M.GetFirstPC, M.GetNextPC)

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
