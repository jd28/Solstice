--- Lua preloads...
-- @module test

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