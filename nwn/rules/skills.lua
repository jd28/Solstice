--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local skills = {}

table.insert(skills, {"Animal Empithy", "AE"})
table.insert(skills, {"Concentration", "Conc"})
table.insert(skills, {"Disable Trap", "DT"})
table.insert(skills, {"Discipline", "Disc"})
table.insert(skills, {"Heal", "Heal"})
table.insert(skills, {"Hide", "Hide"})
table.insert(skills, {"Listen", "Lstn"})
table.insert(skills, {"Lore", "Lore"})
table.insert(skills, {"Move Silently", "MS"})
table.insert(skills, {"Open Lock", "OL"})
table.insert(skills, {"Parry", "Pry"})
table.insert(skills, {"Perform", "Perf"})
table.insert(skills, {"Persuade", "Pers"})
table.insert(skills, {"Pick Pocket", "PP"})
table.insert(skills, {"Search", "Srch"})
table.insert(skills, {"Set Trap", "ST"})
table.insert(skills, {"Spellcraft", "Sc"})
table.insert(skills, {"Spot", "Spot"})
table.insert(skills, {"Taunt", "Tuant"})
table.insert(skills, {"Use Magic Device", "UMD"})
table.insert(skills, {"Appraise", "App"})
table.insert(skills, {"Tumble", "Tmb"})
table.insert(skills, {"Craft Trap", "CT"})
table.insert(skills, {"Bluff", "Bluff"})
table.insert(skills, {"Intimidate", "Int"})
table.insert(skills, {"Craft Armor", "CA"})
table.insert(skills, {"Craft Weapon", "CW"})
table.insert(skills, {"Ride", "Ride"})

---
function nwn.GetSkillName(skill, abbrev)
   if skill < 0 or skill > #skills then
      error("Invalid Skill: " .. skill)
      return ""
   end
   -- Lua Indexed Tables are 1 based.
   return abbrev and skills[skill+1][2] or skills[skill+1][1]
end