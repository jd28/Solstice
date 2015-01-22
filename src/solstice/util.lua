----
-- This module defines some extensions to Lua builtins and some utility
-- functions into the global namespace.  It only ever needs to be
-- required in your `preload.lua`.
-- @module util

local ffi = require 'ffi'
local C = ffi.C
local Color = require 'solstice.color'

--- Utility Funcions
-- @section util

function make_iter_valid(f1, f2)
   local i = 0

   local function it()
      local obj = i == 0 and f1() or f2()
      if obj:GetIsValid() then
         i = i + 1
         return obj
      end
   end

   return it
end

--- Creates a function with the first parameter bound.
-- @param f Function.
-- @param val Value to bind.
function bind1st(f, val)
   return function (second) return f(val, second) end
end

--- Creates a function with the second parameter bound.
-- @param f Function.
-- @param val Value to bind.
function bind2nd(f, val)
   return function (first) return f(first, val) end
end

--- Runs a file in specified environment.
-- load and run a script in the provided environment
-- returns the modified environment table.
-- @param scriptfile File to load.
-- @param[opt] env Environment to run file in.  If not passed
-- `env = setmetatable({}, {__index=_G})`
function runfile(scriptfile, env)
   env = env or setmetatable({}, {__index=_G})
   assert(pcall(setfenv(assert(loadfile(scriptfile)), env)))
   setmetatable(env, nil)
   return env
end

--- Debug function
-- @param f A function.
-- @return A function that wraps f that when calls prints all
-- parameters.
function DebugFunction (f)
   assert (type (f) == "string" and type (_G [f]) == "function",
           "DebugFunction must be called with a function name")
   local old_f = _G [f]  -- save original one for later
   local calls = 1
   _G [f] = function (...)  -- make new function
      print(string.format("Function %s called %d times.", f, calls))  -- show name
      calls = calls + 1
      local n = select ("#", ...)  -- number of arguments
      if n == 0 then
         print ("No arguments.")
      else
         for i = 1, n do  -- show each argument
            print ("Argument ", i, " = ", tostring ((select (i, ...))))
         end -- for each argument
      end -- have some arguments
      local result = old_f (...)  -- call original function now
      print("Function ".. f .. " result: " .. tostring(result))
      return result
   end -- debug version of the function
end -- DebugFunction

--- Safe wrapper for require.
-- Allows for better catching errors and logging.
-- @param file File/module/etc to be passed to require
function safe_require(file)
   local Log = System.GetLogger()
   local ret
   local function req ()
      ret = require(file)
   end

   Log:info("Requiring: " .. file)

   local result, err = pcall(req)
   if not result then
      Log:error("ERROR Requiring: %s : %s \n", file, err)
      return ret
   end

   return ret
end

--- Inheritance function.
-- This VERY crude.  For some reason I'm not altogther sure why,
-- luajit trace will abort with a bad argument error if there are
-- nested metatables???  So this simply copies all function values.
-- Thus: It should be used before any other functions are added to
-- the class.
-- @param class New class type.
-- @param base Base class type.
function inheritsFrom( class, base )
   for k, v in pairs(base) do
      if type(v) == "function" then
         class[k] = v
      end
   end
   return class
end

--- Extensions
-- @section ext

--- Gets character from string.
function string:index(n)
   return string.sub(self, n, n)
end

--- String split.
-- @string[opt=" "] sep Seperator.
-- @string[opt=false] isany If true seperates string
-- on any character in sep.
function string:split(sep, isany)
   sep = sep or " "
   isany = isany and true or false

   local array = C.str_split(self, sep, isany);
   local res = {}

   local i = 0
   while array[i] ~= nil do
      local s = ffi.string(array[i])
      table.insert(res, s)
      i = i + 1
   end
   C.free(array)
   return res
end


--- Trim string right.
function string:rtrim()
   return ffi.string(C.str_rtrim(self))
end

--- Trim string left.
function string:ltrim()
   return ffi.string(C.str_ltrim(self))
end

--- Trim string.
function string:trim()
   return ffi.string(C.str_trim(self))
end

--- String starts
-- @string start Prefix to check for.
function string:starts(start)
   if #self < #start then return false end

   for i=1, #start do
      if self:byte(i) ~= start:byte(i) then
         return false
      end
   end
   return true
end

--- String strip margins.
-- Leading whitespace and the header are removed
-- from string at the start of a new line.
-- @string header[opt='|'] Header string.
function string:strip_margin (header)
   local pat = "\n%s+|"
   if header then
      pat = string.format("\n%%s+%s", header)
   end
   return string.gsub(self, pat, "\n")
end

--- String trim
function string:trim()
  return self:match "^%s*(.-)%s*$"
end

--- Chain table lookups
-- @param ... Any number of tables.
function table.chain(...)
   local chain = {...}
   local function lookup(tbl, key)
      for _, v in ipairs(chain) do
         if v[key] then
            return v[key]
         end
      end
   end
   return setmetatable({}, { __index = lookup })
end

--- Clamp function
-- @param number Number to clamp.
-- @param low Minimum.
-- @param high Maximum
function math.clamp(number, low, high)
   if number < low then
      number = low
   elseif number > high then
      number = high
   end

   return number
end

--- Returns the Levenshtein distance between the two given strings
-- @param str1 String
-- @param str2 String
function string.levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0

        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end

        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end

        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end

        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

--- Color a string.
-- @param color See solstice.color
function string:color(color)
   return color..self..Color.END
end

--- Sort table on a key.
-- @param key Key to sort on.
function table:ksort(key)
   table.sort(self, function (a, b) return a[key] < b[key] end)
end

--- Packs a vararg into a table.
-- @param ... args.
function table.pack(...)
  return { n = select("#", ...), ... }
end
