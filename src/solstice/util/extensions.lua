--- Lua Extensions
-- @module util.extensions

local ffi = require 'ffi'
local C = ffi.C
local Color = require 'solstice.color'

function string:index(n)
   return string.sub(self, n, n)
end

--- String split.
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

function string:rtrim()
   return ffi.string(C.str_rtrim(self))
end

function string:ltrim()
   return ffi.string(C.str_ltrim(self))
end

function string:trim()
   return ffi.string(C.str_trim(self))
end


--- String starts
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
