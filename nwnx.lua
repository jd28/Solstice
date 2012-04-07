nwnx = {}

print "nwnx.areas"
require "nwnx.areas"
print "nwnx.database"
require "nwnx.database"
print "nwnx.defenses"
require "nwnx.defenses"
print "nwnx.dmactions"
require "nwnx.dmactions"
print "nwnx.events"
require "nwnx.events"
print "nwnx.haks"
require "nwnx.haks"
print "nwnx.levels"
require "nwnx.levels"
print "nwnx.system"
require "nwnx.system"
print "nwnx.weapons"
require "nwnx.weapons"

function nwnx.ApplyNumber (object, func, vals, spacer)
   spacer = spacer or "          "
   table.insert(vals, spacer)
   local sval = table.concat(vals, " ")

   object:SetLocalString(func, sval)
   return tonumber(object:GetLocalString(object, func))
end

function nwnx.ApplyString (object, func, vals, spacer)
   spacer = spacer or "          "
   table.insert(vals, spacer)
   local sval = table.concat(vals, " ")

   object:SetLocalString(func, sval)
   return object:GetLocalString(object, func)
end
