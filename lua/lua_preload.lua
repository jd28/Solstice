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

function string:color(nRed, nGreen, nBlue)
  return string.format("<c%c%c%c>%s</c>", nRed, nGreen, nBlue, self)
end

function string:tolocation()
  local t = self:split()
  if #t < 5 then return end
  local oArea, x, y, z, facing = GetObjectByTag(t[1]), tonumber(t[2]),tonumber(t[3]),tonumber(t[4]),tonumber(t[5])
  if not GetIsObjectValid(oArea) then return end
  return Location(oArea, Vector(x,y,z), facing)
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
      local args = arg or {}
      local cur, prev = first(unpack(args))
      while cur:GetIsValid() do
         prev, cur = cur, next(unpack(args))
         return prev
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