local TDA = require 'solstice.2da'

local function GetShifterEpicLevel(cre)
   return 10
end

local DEFAULT_UNEQUIP_MASK = 64520
local function GetPolymorphUnequipMask(polyid)
   local res = TDA.GetInt("polymorph", "UnequipMask", polyid)
   if res == 0 then
      return DEFAULT_UNEQUIP_MASK
   end
   return res
end

local function GetPolymorphID(cre, spell)
   local druid = cre:GetLevelByClass(CLASS_TYPE_DRUID)
   local shifter = cre:GetLevelByClass(CLASS_TYPE_SHIFTER)
   local poly = -1

   local function epic_shifter(pre, epic)
      return shifter >= GetShifterEpicLevel(cre) and epic or pre
   end

   if spell == 401 then
      poly = druid >= 12 and POLYMORPH_TYPE_DIRE_BROWN_BEAR
         or POLYMORPH_TYPE_BROWN_BEAR
   elseif spell == 402 then
       poly = druid >= 12 and POLYMORPH_TYPE_DIRE_PANTHER
          or POLYMORPH_TYPE_PANTHER
   elseif spell == 403 then
       poly = druid >= 12 and POLYMORPH_TYPE_DIRE_WOLF
          or POLYMORPH_TYPE_WOLF
   elseif spell == 404 then
       poly = druid >= 12 and POLYMORPH_TYPE_DIRE_BOAR
          or POLYMORPH_TYPE_BOAR
   elseif spell == 405 then
       poly = druid >= 12 and POLYMORPH_TYPE_DIRE_BADGER
          or POLYMORPH_TYPE_BADGER
   -- Greater Wildshape I - Wyrmling shape
   elseif spell == 658 then poly = POLYMORPH_TYPE_WYRMLING_RED
   elseif spell == 659 then poly = POLYMORPH_TYPE_WYRMLING_BLUE
   elseif spell == 660 then poly = POLYMORPH_TYPE_WYRMLING_BLACK
   elseif spell == 661 then poly = POLYMORPH_TYPE_WYRMLING_WHITE
   elseif spell == 662 then poly = POLYMORPH_TYPE_WYRMLING_GREEN

   -- Greater Wildshape II  - Minotaur, Gargoyle, Harpy
   elseif spell == 672 then
      poly = epic_shifter(POLYMORPH_TYPE_HARPY, 97)
   elseif spell == 678 then
      poly = epic_shifter(POLYMORPH_TYPE_GARGOYLE, 98)
   elseif spell == 680 then
      poly = epic_shifter(POLYMORPH_TYPE_MINOTAUR, 96)

   -- Greater Wildshape III  - Drider, Basilisk, Manticore
   elseif spell == 670 then
      poly = epic_shifter(POLYMORPH_TYPE_BASILISK, 99)
   elseif spell == 673 then
      poly = epic_shifter(POLYMORPH_TYPE_DRIDER, 100)
   elseif spell == 674 then
      poly = epic_shifter(POLYMORPH_TYPE_MANTICORE, 101)

   -- Greater Wildshape IV - Dire Tiger, Medusa, MindFlayer
   elseif spell == 679 then poly = POLYMORPH_TYPE_MEDUSA
   elseif spell == 691 then poly = 68  -- Mindflayer
   elseif spell == 694 then poly = 69  -- DireTiger

    -- Humanoid Shape - Kobold Commando, Drow, Lizard Whip Specialist
   elseif spell == 682 then --drow
      if cre:GetGender() == GENDER_MALE then
         poly = epic_shifter(59, 105)
      else
         poly = epic_shifter(70, 10)
      end
   elseif spell == 683 then -- Lizard
      poly = epic_shifter(82, 104)
   elseif spell == 684 then -- Kobold
      poly = epic_shifter(83, 103)

   -- Undead Shape - Spectre, Risen Lord, Vampire
   elseif spell == 704 then -- Risen lord
      poly = 75

   elseif spell == 705 then -- vampire
      if cre:GetGender() == GENDER_MALE then
         poly = 74
      else
         poly = 77
      end
   elseif spell == 706 then -- spectre
      poly = 76

   -- Dragon Shape - Red Blue and Green Dragons
   elseif spell == 707 then -- Ancient Red Dragon
      if cre:GetPlayerInt("pc_dragshape") > 0 then -- kin
         poly = 153
      else
         poly = 72
      end
   elseif spell == 708 then  -- Ancient Blue  Dragon
      if cre:GetPlayerInt("pc_dragshape") > 0 then -- kin
         poly = 152
      else
         poly = 71
      end
   elseif spell == 709 then -- Ancient Green Dragon
      if cre:GetPlayerInt("pc_dragshape") > 0 then -- kin
         poly = 154
      else
         poly = 73
      end

   -- Outsider Shape - Rakshasa, Azer Chieftain, Black Slaad
   elseif spell == 733 then -- Azer
      poly = cre:GetGender() == GENDER_MALE and 85 or 86
   elseif spell == 734 then -- Rakasha
      poly = cre:GetGender() == GENDER_MALE and 88 or 89

   elseif spell == 735 then poly = 87  -- slaad

   -- Construct Shape - Stone Golem, Iron Golem, Demonflesh Golem
   elseif spell == 738 then poly = 91  -- stone golem
   elseif spell == 739 then poly = 92  -- demonflesh golem
   elseif spell == 740 then poly = 90  -- iron golem
   end

   return poly
end

local M = require 'solstice.rules.init'
M.GetPolymorphUnequipMask = GetPolymorphUnequipMask
