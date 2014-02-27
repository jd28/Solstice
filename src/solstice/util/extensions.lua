--- Lua Extensions
-- @module util.extensions

local ffi = require 'ffi'
local C = ffi.C

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
