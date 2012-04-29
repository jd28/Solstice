require 'nwn.modes'
require 'nwn.constants'

-- This is an example file dealing with the Combat Modes.
-- At this point, it's already been confirmed that the creature has the
-- requist feat(s) (if any) to use a combat mode.


--Defensive Cast--------------------------------------------------------
local function def_cast(cre)
   -- Nothing to be done but return true really
   -- Concentration checks are dealt with during damage application.
   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_DEFENSIVE_CASTING, def_cast)

--Detect----------------------------------------------------------------
local function def_stance(cre)

   return true
end
nwn.RegisterCombatMode(nwn.COMBAT_MODE_DEFENSIVE_STANCE, def_stance)

--Dirty Fighting--------------------------------------------------------
local function dirty(cre)
   -- Really is worthless but there you go.  Attack number modifications
   -- are dealth with in NSInitializeNumberOfAttacks
   cre.ci.mode.dmg_type = nwn.DAMAGE_TYPE_BASE_WEAPON
   cre.ci.mode.dmg.dice = 1
   cre.ci.mode.dmg.sides = 4

   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_DIRTY_FIGHTING, dirty)

--Expertise-------------------------------------------------------------

local function expertise(cre, mode)
   if mode == nwn.COMBAT_MODE_IMPROVED_EXPERTISE then
      cre.ci.mode.ab = -10
      cre.ci.mode.ac = 10
   else
      cre.ci.mode.ab = -5
      cre.ci.mode.ac = 5
   end

   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_EXPERTISE, expertise)
nwn.RegisterCombatMode(nwn.COMBAT_MODE_IMPROVED_EXPERTISE, expertise)

--Flurry of Blows-------------------------------------------------------
local function flurry(cre)
   local result = false
   local monk = cre:GetLevelByClass(nwn.CLASS_TYPE_MONK)

   local rh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)
   local rh_valid = rh:GetIsValid()
   local rh_monk_weap = not rh_valid or rh:GetIsMonkWeapon()

   local lh = cre:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND)
   local lh_valid = lh:GetIsValid()
   local lh_monk_weap = not lh_valid or lh:GetIsMonkWeapon()

   if rh_valid and rh:GetIsRangedWeapon() then
      result = false
   elseif not rh_valid or rh:GetIsUnarmedWeapon() then
      result = true
   elseif rh_monk_weap and monk >= rh_monk_weap 
      and lh_monk_weap and monk >= lh_monk_weap
   then
      result = true
   else
      result = false
   end
      
   if result then
      -- Addition onhand attack is dealt with in NSInitializeNumberOfAttacks.
      -- So only the AB needs to be set here.
      cre.ci.mode.ab = -2
   else
      cre:SendMessageByStrRef(188)
   end

   return result
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_FLURRY_OF_BLOWS, flurry)

--Power Attack----------------------------------------------------------
local function power_attack(cre, mode)

   cre.ci.mode.dmg_type = nwn.DAMAGE_TYPE_BASE_WEAPON
   if mode == nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK then
      cre.ci.mode.ab = -10
      cre.ci.mode.dmg.bonus = 10
   else
      cre.ci.mode.ab = -5
      cre.ci.mode.dmg.bonus = 5
   end

   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_POWER_ATTACK, power_attack)
nwn.RegisterCombatMode(nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK, power_attack)

--Rapid Shot------------------------------------------------------------
local function rapid_shot(cre)
   local weap = cre:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND)

   -- Addition onhand attack is dealt with in NSInitializeNumberOfAttacks.
   -- So only the AB needs to be set here.
   cre.ci.mode.ab = -2

   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_RAPID_SHOT, rapid_shot)


--Parry-----------------------------------------------------------------
local function parry(cre)
   -- The parry ripostes are dealth with in the attack roll.
   -- Nothing to be done but return true.
   return true
end

nwn.RegisterCombatMode(nwn.COMBAT_MODE_PARRY, parry)

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

nwn.COMBAT_MODE_STUPID_UBER = 12
nwn.RegisterCombatMode(nwn.COMBAT_MODE_STUPID_UBER, stupid)