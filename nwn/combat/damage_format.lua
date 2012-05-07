local color = require 'nwn.color'

local damage_format = color.LIGHT_BLUE.."%s" .. color.END .. 
   color.ORANGE .. " damages %s: %d (%s)" .. color.END

local immunity_format = color.ORANGE 
   .. "%s : Damage Immunity absorbs: %d (%s)" .. color.END

local resist_format = color.ORANGE 
   .. "%s : Damage Resitance absorbs: %d (%s)" .. color.END

local dr_format = color.ORANGE 
   .. "%s : Damage Reduction absorbs: %d" .. color.END

function NSFormatDamageRoll(attacker, target, dmg_result, idx)
   local out = {}

   if not idx then
      table.insert(out, tostring(dmg_result.immunity_adjust[12]) .. " Physical" )
   end

   for i = idx or 0, NS_OPT_NUM_DAMAGES - 2 do
      if dmg_result.damages[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.damages[i]))
      end
   end

   local str = string.format(damage_format, 
                             attacker:GetName(false),
                             target:GetName(false),
                             NSGetTotalDamage(dmg_result, idx),
                             table.concat(out, " "))
   return str
end

function NSFormatDamageRollImmunities(attacker, target, dmg_result)
   local out = {}

   table.insert(out, tostring(dmg_result.immunity_adjust[12]) .. " Physical" )

   for i = 0, NS_OPT_NUM_DAMAGES - 2 do
      if dmg_result.immunity_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.immunity_adjust[i]))
      end
   end

   local str = string.format(immunity_format, 
                             target:GetName(),
                             NSGetTotalImmunityAdjustment(dmg_result),
                             table.concat(out, " "))
   return str
end

function NSFormatDamageRollResistance(attacker, target, dmg_result)
   local out = {}

   table.insert(out, tostring(dmg_result.resist_adjust[12]) .. " Physical" )

   for i = 0, NS_OPT_NUM_DAMAGES - 2 do
      if dmg_result.resist_adjust[i] > 0 then
         table.insert(out, string.format(nwn.GetDamageFormatByIndex(i), dmg_result.resist_adjust[i]))
      end
   end

   local str = string.format(resist_format,
                             target:GetName(),
                             NSGetTotalResistAdjustment(dmg_result),
                             table.concat(out, " "))
   return str
end

function NSFormatDamageRollReduction(attacker, target, dmg_result)
   local str = string.format(dr_format,
                             target:GetName(),
                             dmg_result.soak_adjust)

   return str
end