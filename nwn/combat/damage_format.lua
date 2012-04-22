local color = require 'nwn.color'

local damage_format = color.LIGHT_BLUE.."%s" .. color.END .. 
   color.ORANGE .. " damages %s: %d (%s)" .. color.END

local immunity_format = color.ORANGE 
   .. "%s : Damage Immunity absorbs: %d (%s)" .. color.END

local resist_format = color.ORANGE 
   .. "%s : Damage Resitance absorbs: %d (%s)" .. color.END

local dr_format = color.ORANGE 
   .. "%s : Damage Reduction absorbs: %d" .. color.END

function NSFormatDamageRoll(attacker, target, dmg_result)
   local pc = nwn.GetFirstPC()
   local out = {}

   table.insert(out, tostring(dmg_result.immunity_adjust[12]) .. " Physical" )

   for i = 0, 11 do
      if dmg_result.damages[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.damages[i]))
      end
   end

   local str = string.format(damage_format, 
                             attacker:GetName(),
                             target:GetName(),
                             NSGetTotalDamage(dmg_result),
                             table.concat(out, " "))
   pc:SendMessage(str)
end

function NSFormatDamageRollImmunities(attacker, target, dmg_result)
   local pc = nwn.GetFirstPC()
   local out = {}

   table.insert(out, tostring(dmg_result.immunity_adjust[12]) .. " Physical" )

   for i = 0, 11 do
      if dmg_result.immunity_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.immunity_adjust[i]))
      end
   end

   local str = string.format(immunity_format, 
                             target:GetName(),
                             NSGetTotalImmunityAdjustment(dmg_result),
                             table.concat(out, " "))
   pc:SendMessage(str)
   return str
end

function NSFormatDamageRollResistance(attacker, target, dmg_roll)
   local pc = nwn.GetFirstPC()
   local out = {}

   table.insert(out, tostring(dmg_roll.resist_adjust[12]) .. " Physical" )

   for i = 0, 11 do
      if dmg_result.resist_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.resist_adjust[i]))
      end
   end

   local str = string.format(resist_format,
                             NSGetTotalResistAdjustment(dmg_result),
                             target:GetName(),
                             table.concat(out, " "))
   pc:SendMessage(str)
   return str
end