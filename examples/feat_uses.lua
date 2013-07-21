local Ft = require 'solstice.feat'
local Cls = require 'solstice.class'
local Cre = require 'solstice.creature'

local function infinite() return 100 end
local function one() return 1 end
local function none() return 0 end

Ft.RegisterFeatUses(
   function (feat, cre) 
      return 1 + cre:GetLevelByClass(Cls.BARBARIAN)
   end,
   Ft.BARBARIAN_RAGE)

local function bard_song(feat, cre)
   local level = cre:GetLevelByClass(Cls.BARD)
   local uses = level

   if cre:GetHasFeat(Ft.EXTRA_MUSIC) then
      uses = uses + (level > 6 and uses / 6 or 1)
   end

   return uses
end

Ft.RegisterFeatUses(bard_song, Ft.BARD_SONGS)
-- This is because Bioware decided to make a bunch of (pointless)
-- extra bard song feats.
for i = 355, 373 do
   Ft.RegisterFeatUses(bard_song, i)
end

Ft.RegisterFeatUses(
   function(feat, cre)
      if cre:GetLevelByClass(Cls.BLACKGUARD) >= 45 or
	 cre:GetLevelByClass(Cls.ASSASSIN) >= 45
      then return 2
      else return 1
      end
   end,
   Ft.CONTAGION)

Ft.RegisterFeatUses(
   function(feat, cre)
      local uses = 1
      local l = cre:GetLevelByClass(Cls.DIVINE_CHAMPION)
      if l >= 40 then
	 uses = 4
      elseif l >= 30 then
	 uses = 3
      elseif l >= 20 then
	 uses = 2
      end
      return uses
   end,
   Ft.DIVINE_WRATH)

Ft.RegisterFeatUses(
   function(feat, cre)
      return 3 + cre:GetLevelByClass(Cls.DRAGON_DISCPLE)
   end,
   Ft.DRAGON_DIS_BREATH)

Ft.RegisterFeatUses(
   function(feat, cre)
      local uses = (cre:GetLevelByClass(Cls.DWARVEN_DEFENDER) - 1) / 2
      return 1 + uses
   end,
   Ft.DWARVEN_DEFENDER_DEFENSIVE_STANCE)

Ft.RegisterFeatUses(
   function(feat, cre)
      if cre:GetHasFeat(Ft.EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE) then
	 return 100
      end
   end,
   Ft.ELEMENTAL_SHAPE)

Ft.RegisterFeatUses(
   function(feat, cre)
      if cre:GetHasFeat(Ft.EPIC_DRUID_INFINITE_WILDSHAPE) then
	 return 100
      end
   end,
   Ft.WILD_SHAPE)

Ft.RegisterFeatUses(none, Ft.KI_DAMAGE)

Ft.RegisterFeatUses(one, 
		    Ft.HARPER_CATS_GRACE,
		    Ft.HARPER_EAGLES_SPLENDOR,
		    Ft.HARPER_SLEEP)

local function harper(feat, cre)
   local level = cre:GetLevelByClass(Cls.HARPER)
   local uses = 1
   if level >= 45 then
      uses = 3
   elseif level >= 20 then
      uses = 2
   end
   return uses
end

Ft.RegisterFeatUses(harper,
		    Ft.DENEIRS_EYE,
		    2097)

Ft.RegisterFeatUses(
   function (feat, cre)
      local level = cre:GetLevelByClasss(Cls.ASSASSIN)
      local uses  = 1
      if level >= 40 then
	 uses = 4
      elseif level >= 30 then
	 uses = 3
      elseif level >= 20 then
	 uses = 2
      end
      return uses
   end,
   Ft.PRESTIGE_DARKNESS)

Ft.RegisterFeatUses(
   function (feat, cre)
      return 2
   end,
   Ft.UNDEAD_GRAFT_1)

Ft.RegisterFeatUses(
   function (feat, cre)
      return 3
   end,
   Ft.UNDEAD_GRAFT_2)

Ft.RegisterFeatUses(
   function (feat, cre)
      local uses = 1
      local level = cre:GetLevelByClass(Cls.SHADOWDANCER)
      if level >= 45 then
	 uses = 2
      end
      return uses
   end,
   2089)

Ft.RegisterFeatUses(
   function (feat, cre)
      local level = cre:GetLevelByClass(Cls.MONK)
      local uses = 1 + (level / 4)
      if cre:GetHasFeat(Ft.EXTRA_STUNNING_ATTACK) then
	 uses = uses + 3
      end
      return uses
   end,
   Ft.STUNNING_FIST)

Ft.RegisterFeatUses(
   function (feat, cre)
      local uses = 3 + cre:GetAbilityModifier(Cre.ABILITY_CHARISMA)
      if cre:GetHasFeat(Ft.EXTRA_TURNING) then
	 uses = uses + 6
      end
      return uses
   end,
   Ft.TURN_UNDEAD)


local function smite(feat, cre)
   if cre:GetHasFeat(Ft.EXTRA_SMITING) then
      return 3
   end
   return 1
end

Ft.RegisterFeatUses(smite,
		    Ft.SMITE_EVIL,
		    Ft.SMITE_GOOD)

local function epic_spell(feat, cre)
   local level = math.max(cre:GetLevelByClass(Cls.SORCERER),
			  cre:GetLevelByClass(Cls.WIZARD))

   level = math.max(level, cre:GetLevelByClass(Cls.DRUID))
   level = math.max(level, cre:GetLevelByClass(Cls.CLERIC))

   if level >= 50 then
      return 3
   elseif level >= 40 then
      return 2
   end

   level = cre:GetLevelByClass(Cls.PALEMASTER)
   if level >= 40 then 
      return 3
   elseif level >= 30 then
      return 2
   end

   return 1
end

Ft.RegisterFeatUses(epic_spell,
		    Ft.EPIC_SPELL_RUIN,
		    Ft.EPIC_SPELL_HELLBALL)

Ft.RegisterFeatUses(infinite,
		    Ft.EPIC_SHIFTER_INFINITE_WILDSHAPE_1,
		    Ft.EPIC_SHIFTER_INFINITE_WILDSHAPE_2,
		    Ft.EPIC_SHIFTER_INFINITE_WILDSHAPE_3,
		    Ft.EPIC_SHIFTER_INFINITE_WILDSHAPE_4,
		    Ft.EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE)

