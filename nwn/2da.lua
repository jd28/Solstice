--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

-- TODO
-- caching(?), etc, etc

-- The following code is based on the CSV reader in PiL
local function read2DAline (s)
   s = s .. ' '        -- ending whitespace
   local t = {}        -- table to collect fields
   local fieldstart = 1

   repeat
      -- next field is quoted? (start with `"'?)
      if string.find(s, '^"', fieldstart) then
         local a, c
         local i = fieldstart
         repeat
            -- find closing quote
            a, i, c = string.find(s, '"(.?)', i+1)
         until c ~= '"'    -- quote not followed by quote?
         if not i then error('unmatched "') end
         local f = string.sub(s, fieldstart+1, i-2)
         f = tonumber(f) or f
         table.insert(t, f)
         fieldstart = string.find(s, '[^%s]', i)
      else                -- unquoted;
         local nexti = string.find(s, '%s', fieldstart)
         local f = trim1(string.sub(s, fieldstart, nexti-1))
         if #f > 0 then
            f = tonumber(f) or f
            table.insert(t, f)
         end
         fieldstart = string.find(s, '[^%s]', nexti)
      end
   until not fieldstart or fieldstart > string.len(s)
   return t
end

--- Read 2da file.
-- @param file File to read.
function read2DA(file)
   local f = assert(io.open(file, "r"))

   local tag = false
   local twoda = {}

   for line in f:lines() do
      if not tag and string.find(line, "2DA V2.0") then
         tag = true
      end

      line = line:trim()
      if tag and #line > 0 then

         local x = read2DAline(line)
         if not twoda.header and x[1] and type(x[1]) ~= "number" then
            twoda.header = x
         else
            table.insert(twoda, x)
         end
      end
   end

   io.close()

   if not tag then
      error (file .. "is not a 2da file!")
   end

   return twoda
end
