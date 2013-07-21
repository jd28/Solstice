safe_require "solstice.nwnx.areas"
safe_require 'solstice.nwnx.chat'
safe_require 'solstice.nwnx.combat'
safe_require "solstice.nwnx.database"
safe_require "solstice.nwnx.dmactions"
safe_require "solstice.nwnx.effects"
safe_require 'solstice.nwnx.equips'
safe_require "solstice.nwnx.events"
safe_require "solstice.nwnx.haks"
safe_require "solstice.nwnx.levels"
safe_require "solstice.nwnx.system"

--[[
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
function solstice.nwnx.Apply (object, func, vals, spacer)
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
   --]]