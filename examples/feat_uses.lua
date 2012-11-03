local function only_one() return 1 end
local function none() return 0 end
local function infinite() return 100 end

nwn.RegisterFeatUses(
   nwn.FEAT_BARBARIAN_RAGE,
   function (cre)
      return 1 + (cre:GetLevelByClass(nwn.CLASS_TYPE_BARBARIAN) / 4)
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_CONTAGION,
   function (cre)
      if cre:GetLevelByClass(nwn.CLASS_TYPE_BLACKGUARD) >= 45
	 or cre:GetLevelByClass(nwn.CLASS_TYPE_ASSASSIN) >= 45
      then
	 return 2
      else
	 return 1
      end
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_DIVINE_WRATH,
   function (cre)
      local uses
      local dc = cre:GetLevelByClass(nwn.CLASS_TYPE_DIVINECHAMPION)
      if dc >= 40 then 
	 uses = 4
      elseif dc >= 30 then 
	 uses = 3
      elseif dc >= 20 then 
	 uses = 2
      else 
	 uses = 1
      end
      return uses
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_DRAGON_DIS_BREATH,
   function (cre)
      return 3 + (cre:GetLevelByClass(nwn.CLASS_TYPE_DRAGONDISCIPLE) / 10)
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE,
   function (cre)
      return 1 + ((cre:GetLevelByClass(nwn.CLASS_TYPE_DWARVENDEFENDER) - 1) / 2)
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_BARD_SONGS,
   function (cre)
      local uses = cre:GetLevelByClass(nwn.CLASS_TYPE_BARD)
      if cre:GetHasFeat(nwn.FEAT_EXTRA_MUSIC) then
	 uses = uses + (uses > 6 and uses / 6 or 1)
      end
      return uses
   end)

nwn.RegisterFeatUses(nwn.FEAT_KI_DAMAGE, none)

nwn.RegisterFeatUses(
   nwn.FEAT_TURN_UNDEAD,
   function (cre)
      local uses = 3 + cre:GetAbilityModifier(nwn.ABILITY_CHARISMA)
      if cre:GetHasFeat(nwn.FEAT_EXTRA_TURNING) then
	 uses = uses + 6
      end
      return uses
   end)

local function smite(cre)
   local uses = 1
   if cre:GetHasFeat(nwn.FEAT_EXTRA_SMITING) then
      uses = 3
   end
end

nwn.RegisterFeatUses(nwn.FEAT_SMITE_EVIL, smite)
nwn.RegisterFeatUses(nwn.FEAT_SMITE_GOOD, smite)

nwn.RegisterFeatUses(nwn.FEAT_HARPER_CATS_GRACE, only_one)
nwn.RegisterFeatUses(nwn.FEAT_HARPER_EAGLES_SPLENDOR, only_one)
nwn.RegisterFeatUses(nwn.FEAT_HARPER_SLEEP, only_one)

nwn.RegisterFeatUses(
   2089,
   function (cre)
      local sd = cre:GetLevelByClass(nwn.CLASS_TYPE_SHADOWDANCER)
      local uses

      if sd >= 45 then 
	 uses = 2
      else
	 uses = 1
      end
      return uses
   end)


nwn.RegisterFeatUses(
   nwn.FEAT_UNDEAD_GRAFT_1,
   function () return 2 end)

nwn.RegisterFeatUses(
   nwn.FEAT_UNDEAD_GRAFT_2,
   function () return 3 end)

nwn.RegisterFeatUses(
   nwn.FEAT_PRESTIGE_DARKNESS,
   function (cre)
      local temp = cre:GetLevelByClass(nwn.CLASS_TYPE_ASSASSIN)
      if temp >= 40 then     
	 uses = 4
      elseif temp >= 30 then 
	 uses = 3
      elseif temp >= 20 then
	 uses = 2
      else
	 uses = 1
      end
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_STUNNING_FIST,
   function (cre)
      local temp = cre:GetLevelByClass(nwn.CLASS_TYPE_MONK)
      local uses = 1 + (temp / 4)
      if cre:GetHasFeat(nwn.FEAT_EXTRA_STUNNING_ATTACK) then
	 uses = uses + 3
      end
   end)

nwn.RegisterFeatUses(
   2097, -- Mielikki's Truth
   function (cre)
      local temp = cre:GetLevelByClass(nwn.CLASS_TYPE_HARPER)
      local uses
      if temp >= 45 then
	 uses = 3
      elseif temp >= 20 then
	 uses = 2
      else
	 uses = 1
      end
   end)

nwn.RegisterFeatUses(
   nwn.FEAT_DENEIRS_EYE,
   function (cre)
      local temp = cre:GetLevelByClass(nwn.CLASS_TYPE_HARPER);
      local uses
   function (cre)
      local temp = cre:GetLevelByClass(nwn.CLASS_TYPE_HARPER)
      local uses
      if temp >= 45 then
	 uses = 3
      elseif temp >= 30 then
	 uses = 2
      else
	 uses = 1
      end
   end)

nwn.RegisterFeatUses(nwn.FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_1, infinite)
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_2, infinite)
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_3, infinite)
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_4, infinite)
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE, infinite)

local function epic_spell(cre)
   local level = math.max(cre:GetLevelByClass(nwn.CLASS_TYPE_SORCERER),
			  cre:GetLevelByClass(nwn.CLASS_TYPE_WIZARD),
			  cre:GetLevelByClass(nwn.CLASS_TYPE_DRUID),
			  cre:GetLevelByClass(nwn.CLASS_TYPE_CLERIC),
			  cre:GetLevelByClass(nwn.CLASS_TYPE_PALEMATER))
   local uses
   if level >= 50 then 
      uses = 3
   elseif level >= 40 then
      uses = 2
   else
      uses = 1
   end
   return uses
end
   
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SPELL_RUIN, epic_spell)
nwn.RegisterFeatUses(nwn.FEAT_EPIC_SPELL_HELLBALL, epic_spell)

--[[

    else if((feat == FEAT_ELEMENTAL_SHAPE || (feat >= 340 && feat <= 342)) &&
            CNWSCreatureStats__HasFeat(stats, FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE)){
        return 100;                
    }
    else if((feat == FEAT_WILD_SHAPE || (feat >= 335 && feat <= 399)) &&
            CNWSCreatureStats__HasFeat(stats, FEAT_EPIC_DRUID_INFINITE_WILDSHAPE)){
        return 100;                
    }
 
--]]