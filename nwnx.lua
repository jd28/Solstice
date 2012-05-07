nwnx = nwnx or {}

require "nwnx.areas"
require "nwnx.database"
require "nwnx.dmactions"
require "nwnx.events"
require "nwnx.haks"
require "nwnx.levels"
require "nwnx.system"

--- Gets a result from NWNX
-- @param object Object to set the variable on
-- @param func NWNX function
-- @param vals values to pass.  If this is a table the values will be
--    concated together with "¬" seperating them.  If anything else
--    it will be coereced to a string if necessary
-- @param spacer Spacer for return value, (Default: "          ")
-- @return If the return string contains a "¬" the return value will
--    be a list, else the return string.  Anything that can be coerced
--    to a number will be returned as a number
function nwnx.Apply (object, func, vals, spacer)
   spacer = spacer or "          "
   local sval
   if type(vals) == "table" then
      table.insert(vals, spacer)
      sval = table.concat(vals, "¬")
   else
      sval = tostring(vals) .. spacer
   end

   object:SetLocalString(func, sval)
   local ret = object:GetLocalString(object, func)

   if string.find(ret, "¬") then
      local t = {}
      string.gsub(str, "[^¬]+",
                  function (val)
                     val = tonumber(val) or val
                     table.insert(t, val)
                  end)
      return t
   end

   return tonumber(ret) or ret
end
