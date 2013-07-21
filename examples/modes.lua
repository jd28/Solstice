-- Woefully out of date...

require 'solstice.nwn.modes'
require 'solstice.nwn.constants'

-- This is an example file dealing with the Combat Modes.
-- At this point, it's already been confirmed that the creature has the
-- requist feat(s) (if any) to use a combat mode.


--Defensive Cast--------------------------------------------------------
local function def_cast(cre)
   -- Nothing to be done but return true really
   -- Concentration checks are dealt with during damage application.
   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_DEFENSIVE_CASTING, def_cast)

--Detect----------------------------------------------------------------
local function def_stance(cre)

   return true
end
solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_DEFENSIVE_STANCE, def_stance)

--Dirty Fighting--------------------------------------------------------
local function dirty(cre)
   -- Really is worthless but there you go.  Attack number modifications
   -- are dealth with in NSInitializeNumberOfAttacks
   cre.ci.mode.dmg_type = solstice.nwn.DAMAGE_TYPE_BASE_WEAPON
   cre.ci.mode.dmg.dice = 1
   cre.ci.mode.dmg.sides = 4

   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_DIRTY_FIGHTING, dirty)

--Expertise-------------------------------------------------------------

local function expertise(cre, mode)
   if mode == solstice.nwn.COMBAT_MODE_IMPROVED_EXPERTISE then
      cre.ci.mode.ab = -10
      cre.ci.mode.ac = 10
   else
      cre.ci.mode.ab = -5
      cre.ci.mode.ac = 5
   end

   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_EXPERTISE, expertise)
solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_IMPROVED_EXPERTISE, expertise)

--Flurry of Blows-------------------------------------------------------
local function flurry(cre)
   local result = false
   local monk = cre:GetLevelByClass(solstice.nwn.CLASS_TYPE_MONK)
   local rh = cre:GetItemInSlot(solstice.nwn.INVENTORY_SLOT_RIGHTHAND)

   if not rh:GetIsValid() then
      -- Creature is unarmed
      result = true
   elseif rh:GetIsRangedWeapon() then
      -- Right hand is valid and is a ranged weapon.
      result = false
   else
      -- Right hand weapon is valid and not ranged
      local m = rh:GetIsMonkWeapon()
      -- If it's a monk weapon and creature has enough levels of monk to
      -- use it, then check if there is an offhand weapon.
      print(monk, m)
      if m and monk >= m then
	 local lh = cre:GetItemInSlot(solstice.nwn.INVENTORY_SLOT_LEFTHAND)
	 if not lh:GetIsValid() then
	    -- lefthand weapon if invalid
	    -- righthand weapon is a monk weapon
	    result = true
	 else
	    m = lh:GetIsMonkWeapon()
	    if m and monk >= m then
	       -- lefthand weapon is a monk weapon
	       -- righthand weapon is a monk weapon
	       result = true
	    else
	       -- lefthand weapon is not a monk weapon
	       -- righthand weapon is a monk weapon
	       result = false
	    end
	 end
      else
	 -- righthand weapon is not a monk weapon.
	 result = false
      end
   end
      
   if result then
      -- Addition onhand attack is dealt with in NSInitializeNumberOfAttacks.
      -- So only the AB needs to be set here.
      cre.ci.mode.ab = -2
   else
      cre:SendMessageByStrRef(66246)
   end

   return result
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_FLURRY_OF_BLOWS, flurry)

--Power Attack----------------------------------------------------------
local function power_attack(cre, mode)

   cre.ci.mode.dmg_type = solstice.nwn.DAMAGE_TYPE_BASE_WEAPON
   if mode == solstice.nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK then
      cre.ci.mode.ab = -10
      cre.ci.mode.dmg.bonus = 10
   else
      cre.ci.mode.ab = -5
      cre.ci.mode.dmg.bonus = 5
   end

   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_POWER_ATTACK, power_attack)
solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK, power_attack)

--Rapid Shot------------------------------------------------------------
local function rapid_shot(cre)
   local weap = cre:GetItemInSlot(solstice.nwn.INVENTORY_SLOT_RIGHTHAND)
   if not weap:GetIsRangedWeapon() then
      cre:SendMessageByStrRef(66246)
      return false
   end

   -- Addition onhand attack is dealt with in NSInitializeNumberOfAttacks.
   -- So only the AB needs to be set here.
   cre.ci.mode.ab = -2

   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_RAPID_SHOT, rapid_shot)


--Parry-----------------------------------------------------------------
local function parry(cre)
   -- The parry ripostes are dealth with in the attack roll.
   -- Nothing to be done but return true.
   return true
end

solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_PARRY, parry)

--Stupid Uber----------------------------------------------------------
-- Test custom combat mode
local function stupid(cre, mode, off)
   if off then
      cre:FloatingText("* Stupid Uber Deactivated *")
      return false
   end

   cre.ci.mode.ab = 20
   cre.ci.mode.ac = 20
   cre.ci.mode.dmg.dice = 20
   cre.ci.mode.dmg.sides = 20

   cre:FloatingText("* Stupid Uber Activated *")

   return true
end

solstice.nwn.COMBAT_MODE_STUPID_UBER = 12
solstice.nwn.RegisterCombatMode(solstice.nwn.COMBAT_MODE_STUPID_UBER, stupid)