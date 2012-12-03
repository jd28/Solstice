-- String Function
function string:split(sep)
  local sep, fields = sep or " ", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function string:starts(start)
   return string.find(self, "^" .. start)
end

function string:strip_margin (header)
   local pat = "\n%s+|"
   if header then
      pat = string.format("\n%%s+%s", header)
   end
   return string.gsub(self, pat, "\n")
end

function string:trim()
  return self:match "^%s*(.-)%s*$"
end

-- Object Orientation Functions
function inheritsFrom( baseClass )
   local new_class = {}
   local class_mt = { __index = new_class }

   function new_class:new( obj_id, obj_pointer )
      local new_inst = { id = obj_id, pointer = obj_pointer }
      setmetatable( new_inst, class_mt)
      return new_inst
   end

   if baseClass then
      setmetatable( new_class, { __index = baseClass } )
   end

   return new_class
end

-- Math Functions
function math.clamp(number, low, high)
   if number < low then
      number = low
   elseif number > high then
      number = high
   end

   return number
end

-- Iterator Functions
function iter_first_next_isvalid(first, next)
   local self
   return function (...)
      local cur, prev = first(...)
      return function (...)
         while cur:GetIsValid() do
            prev, cur = cur, next(...)
            return prev
         end
      end
   end
end

-- Iterator Functions
function iter_first_next_notnull(first, next)
   return function(...)
      cur, prev = first(not arg or unpack(arg))
      return function ()
         while cur do
            prev, cur = cur, next(not arg or unpack(arg))
            return prev
         end
      end
   end
end

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