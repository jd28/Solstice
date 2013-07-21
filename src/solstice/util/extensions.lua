--- Lua Extensions
-- @module util.extensions

--- String split.
function string:split(sep)
  local sep, fields = sep or " ", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

--- String starts
function string:starts(start)
   return string.find(self, "^" .. start)
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

--- Clamp function
function math.clamp(number, low, high)
   if number < low then
      number = low
   elseif number > high then
      number = high
   end

   return number
end
