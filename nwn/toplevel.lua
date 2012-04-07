--------------------------------------------------------------------------------
-- This file contains essentially all non-member functions...
--------------------------------------------------------------------------------

--- Create an object of a specified type at a given location 
-- NWScript: CreateObject
-- @param object_type OBJECT_TYPE_ITEM, OBJECT_TYPE_CREATURE, OBJECT_TYPE_PLACEABLE, OBJECT_TYPE_STORE, OBJECT_TYPE_WAYPOINT.
-- @param template The resref of the object to create from the pallet.
-- @param loc The location to create the object at.
-- @param appear (optional: <em>false</em>) If <em>true</em>, the object will play its spawn in animation. (Default) 
-- @param newtag (optional: <em>""</em> If this string is not empty, it will replace the default tag from the template.
-- @return New object.
function nwn.CreateObject(object_type, template, loc, appear, newtag)
   if appear == nil then appear = false end
   newtag = newtag or ""
   print (object_type, template, loc, appear, newtag)
   nwn.engine.StackPushString(newtag)
   nwn.engine.StackPushInteger(appear)
   nwn.engine.StackPushEngineStructure(ENGINE_STRUCTURE_LOCATION, loc)
   nwn.engine.StackPushString(template)
   nwn.engine.StackPushInteger(object_type)
   nwn.engine.ExecuteCommand(243, 5)

   return nwn.engine.StackPopObject()
end

function nwn.Location(position, orientation, area)
   nwn.engine.StackPushFloat(orientation)
   nwn.engine.StackPushVector(position)
   nwn.engine.StackPushObject(area)
   nwn.engine.ExecuteCommand(215, 3)
   return nwn.engine.StackPopEngineStructure(ENGINE_STRUCTURE_LOCATION)
end

--- Rolls a d2
-- 
-- @param count number of dice to roll
function nwn.d2(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(2)
   end
   return result
end

--- Rolls a d3
-- @param count number of dice to roll
function nwn.d3(count)
   count = count or 1
   local result = 0    

   for i = 1, count do
      result = result + math.random(3)
   end
   return result
end

--- Rolls a d4
-- @param count number of dice to roll
function nwn.d4(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(4)
   end
   return result
end

--- Rolls a d6
-- @param count number of dice to roll
function nwn.d6(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(6)
   end
   return result
end

--- Rolls a d8
-- @param count number of dice to roll
function nwn.d8(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(8)
   end
end

--- Rolls a d10
-- @param count number of dice to roll
function nwn.d10(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(10)
   end
   return result
end

--- Rolls a d12
-- @param count number of dice to roll
function nwn.d12(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(12)
   end
end

--- Rolls a d20
-- @param count number of dice to roll
function nwn.d20(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(20)
   end
   return result
end

--- Rolls a d100
-- @param count number of dice to roll
function nwn.d100(count)
   count = count or 1
   local result = 0
   
   for i = 1, count do
      result = result + math.random(100)
   end
   return result
end

--- Executes a script on a specified target
-- @param script Script to call... Note if this a lua script/function
--    it is identical to a function call
-- @param target Object to run the script on.
function nwn.ExecuteScript(script, target)
   nwn.engine.StackPushObject(oTarget)
   nwn.engine.StackPushString(sScript)
   nwn.engine.ExecuteCommand(8, 2)
end

function nwn.ExportAllCharacters()
   nwn.engine.ExecuteCommand(557, 0)
end


function nwn.ExportSingleCharacter(player)
   nwn.engine.StackPushObject(player)
   nwn.engine.ExecuteCommand(719, 1)
end

--- Gets a column-row entry in a 2da file.
function nwn.Get2DAString(twoda, column, row)
   nwn.engine.StackPushInteger(row)
   nwn.engine.StackPushString(column)
   nwn.engine.StackPushString(twoda)
   nwn.engine.ExecuteCommand(710, 3)
   return nwn.engine.StackPopString()
end

--- Get module
function nwn.GetModule()
   nwn.engine.ExecuteCommand(242, 0)
   return nwn.engine.StackPopObject()
end

function nwn.GetFirstObjectInShape(e)
end

---
-- @return nwn.OBJECT_INVALID if no PCs are logged into the server.
function nwn.GetFirstPC()
   nwn.engine.ExecuteCommand(548, 0)
   return nwn.engine.StackPopObject()
end

function nwn.GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)
   origin = origin or vector_t(0, 0, 0)
   mask = mask or OBJECT_TYPE_CREATURE

   nwn.engine.StackPushVector(origin)
   nwn.engine.StackPushInteger(mask)
   nwn.engine.StackPushBoolean(line_of_sight)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, location)
   nwn.engine.StackPushFloat(size)
   nwn.engine.StackPushInteger(shape)

   nwn.engine.ExecuteCommand(128, 6)

   return nwn.engine.StackPopObject()
end

function nwn.GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)
   origin = origin or vector_t(0, 0, 0)
   mask = mask or OBJECT_TYPE_CREATURE

   nwn.engine.StackPushVector(origin)
   nwn.engine.StackPushInteger(mask)
   nwn.engine.StackPushBoolean(line_of_sight)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, location)
   nwn.engine.StackPushFloat(size)
   nwn.engine.StackPushInteger(shape)

   nwn.engine.ExecuteCommand(129, 6)

   return nwn.engine.StackPopObject()
end

function nwn.ObjectsInShape(shape, size, location, line_of_sight, mask, origin)
   origin = origin or vector_t(0, 0, 0)
   mask = mask or OBJECT_TYPE_CREATURE

   local obj, _obj = nwn.GetFirstObjectInShape(shape, size, location, line_of_sight, mask, origin)
   return function ()
      while obj and obj:GetIsValid() do
         _obj, obj = obj, nwn.GetNextObjectInShape(shape, size, location, line_of_sight, mask, origin)
         return _obj
      end
   end
end

--- Get next PC
-- @return nwn.INVALID_OBJECT if there are no furter PC
function nwn.GetNextPC()
   nwn.engine.ExecuteCommand(549, 0)
   return nwn.engine.StackPopObject()
end

nwn.PCs = iter_first_next_notnull(nwn.GetFirstPC, nwn.GetNextPC)

--- Gets an object by tag
-- @param tag Tag of object
-- @param nth 
function nwn.GetObjectByTag(tag, nth)
   nNth = nNth or 1
   
   nwn.engine.StackPushInteger(nNth)
   nwn.engine.StackPushString(sTag)
   nwn.engine.ExecuteCommand(200, 2)
   return nwn.engine.StackPopObject()
end

---
function nwn.GetPCSpeaker()
   nwn.engine.ExecuteCommand(238, 0)
   return nwn.engine.StackPopObject()
end

function nwn.GetStrRefSoundDuration(strref)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(571, 1);
   return nwn.engine.StackPopFloat()
end

--- Finds a waypiont by tag
-- @param tag 
-- @return waypoint or nwn.OBJECT_INVALID
function nwn.GetWaypointByTag(tag)
   nwn.engine.StackPushString(tag)
   return nwn.engine.StackPopObject()
end 


--- Generates a random name
-- @param name_type NAME_*
-- @return Random Name
function nwn.RandomName(name_type)
   name_type = name_type or NAME_FIRST_GENERIC_MALE

   nwn.engine.StackPushInteger(name_type);
   nwn.engine.ExecuteCommand(249, 1);
   return nwn.engine.StackPopString();
end

--- Converts hours to seconds
-- @param hours Number of hours
function nwn.HoursToSeconds(hours)
   return hours * 60 * 60
end

--- Converts rounds to seconds
-- @param rounds Number of rounds
function nwn.RoundsToSeconds(rounds)
   return 6 * rounds
end

--- Converts turns to seconds
-- @param turns Number of turns
function nwn.TurnsToSeconds(turns)
   return 60 * turns 
end

--- Gets dialog sound length of a strref
function nwn.GetDialogSoundLength(strref)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(694, 1)
   return nwn.engine.StackPopFloat()
end

--- Get if it's day
function nwn.GetIsDay()
   nwn.engine.ExecuteCommand(405, 0)
   return nwn.engine.StackPopBoolean()
end

--- Get if it's night
function nwn.GetIsNight()
   nwn.engine.ExecuteCommand(406, 0)
   return nwn.engine.StackPopBoolean()
end

--- Get if it's dawn
function nwn.GetIsDawn()
   nwn.engine.ExecuteCommand(407, 0)
   return nwn.engine.StackPopBoolean()
end

--- Get if it's dusk
function nwn.GetIsDusk()
   nwn.engine.ExecuteCommand(408, 0)
   return nwn.engine.StackPopBoolean()
end

---
-- @param year Specific year to set calendar to from 1340 to 32001.
-- @param month Specific month to set calendar from 1 to 12.
-- @param day Specific day to set calendar to from 1 to 28.
function nwn.SetCalendar(year, month, day)
   nwn.engine.StackPushInteger(day)
   nwn.engine.StackPushInteger(month)
   nwn.engine.StackPushInteger(year)
   nwn.engine.ExecuteCommand(11, 3)
end

--- Sets the game's current time.
-- @param hour The new hour value, from 0 to 23.
-- @param minute The new minute value from 0 to 1 (or 0 to a higher value if the module properties for time were changed).
-- @param second The new second value, from 0 to 59.
-- @param millisecond The new millisecond value, from 0 to 999.
function nwn.SetTime(hour, minute, second, millisecond)
   nwn.engine.StackPushInteger(millisecond)
   nwn.engine.StackPushInteger(second)
   nwn.engine.StackPushInteger(minute)
   nwn.engine.StackPushInteger(hour)
   nwn.engine.ExecuteCommand(12, 4)
end

--- Determine the current in-game calendar year.
function nwn.GetCalendarYear()
   nwn.engine.ExecuteCommand(13, 0)
   return nwn.engine.StackPopInteger()
end

--- Determine the current in-game calendar month.
function nwn.GetCalendarMonth()
   nwn.engine.ExecuteCommand(14, 0)
   return nwn.engine.StackPopInteger()
end

--- Determine the current in-game calendar day.
function nwn.GetCalendarDay()
   nwn.engine.ExecuteCommand(15, 0)
   return nwn.engine.StackPopInteger()
end

--- Gets the current hour.
function nwn.GetTimeHour()
   nwn.engine.ExecuteCommand(16, 0)
   return nwn.engine.StackPopInteger()
end

--- Gets the current minute.
function nwn.GetTimeMinute()
   nwn.engine.ExecuteCommand(17, 0)
   return nwn.engine.StackPopInteger()
end

--- Gets the current second
function nwn.GetTimeSecond()
   nwn.engine.ExecuteCommand(18, 0)
   return nwn.engine.StackPopInteger()
end

--- Gets the current millisecond.
function nwn.GetTimeMillisecond()
   nwn.engine.ExecuteCommand(19, 0)
   return nwn.engine.StackPopInteger()
end
