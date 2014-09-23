--- Rules module
-- @module rules

--- Weapons
-- @section

local M = require 'solstice.rules.init'

local ffi = require 'ffi'
local max = math.max
local TDA = require 'solstice.2da'
local Log = require('solstice.system').GetLogger()
local TA = OPT.TA

local WEAP_CONV

local function BaseitemToWeapon(base)
   if not WEAP_CONV then
      WEAP_CONV = {}
      local tda = TDA.GetCached2da("wpnprops")
      if tda == nil then error "Unable to locate wpnprops.2da!" end
      for i = 0, TDA.Get2daRowCount(tda) - 1 do
         WEAP_CONV[TDA.Get2daInt(tda, "Baseitems", i)] = i
      end
   end

   if type(base) ~= "number" then
      if base:GetIsValid() then
         base = base:GetBaseType()
      else
         return 0
      end
   end
   return WEAP_CONV[base] or 0
end

local _WEAPON_FEAT = {}

for c = 0, TDA.Get2daRowCount("mstrwpnfeats") - 1 do
   _WEAPON_FEAT[c] = {}
   for r = 0, TDA.Get2daRowCount("wpnfeats") - 1 do
      -- offset column by one, because of the labels...
      local feat = TDA.Get2daInt("wpnfeats", c+1, r)
      _WEAPON_FEAT[c][r] = feat
   end
end

--- Get Weapon Feat.
-- @param masterfeat
-- @param basetype
local function GetWeaponFeat(masterfeat, basetype)
   return _WEAPON_FEAT[masterfeat][BaseitemToWeapon(basetype)] or -1
end

--- Set Weapon Feat.
-- @param masterfeat
-- @param basetype
-- @param feat
local function SetWeaponFeat(masterfeat, basetype, feat)
   _WEAPON_FEAT[masterfeat] = _WEAPON_FEAT[masterfeat] or {}
   _WEAPON_FEAT[masterfeat][BaseitemToWeapon(basetype)] = feat
end

local function GetWeaponType(item)
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   return TDA.Get2daInt(tda, "Type", BaseitemToWeapon(item))
end

local function GetIsMonkWeapon(item, cre)
   return TDA.Get2daInt("wpnprops", "Monk", BaseitemToWeapon(item)) ~= 0
end

local function GetIsRangedWeapon(item)
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   return TDA.Get2daInt(tda, "Ranged", BaseitemToWeapon(item)) ~= 0
end

--- Determine if weapon is light.
-- @param item The weapon in question.
-- @param cre Creature weilding weapon
local function GetIsWeaponLight(item, cre)
   if GetWeaponType(item) == 8 then return true end
   return cre:GetRelativeWeaponSize(item) < 0
end

--- Determine if weapon is simple
-- @param item Weapon in question
-- @param[opt] cre Creature wielding weapon.
local function GetIsWeaponSimple(item, cre)
   if GetWeaponType(item) == 8 then return true end
   local base = item:GetBaseType()
   return base == BASE_ITEM_CLUB
      or base == BASE_ITEM_DAGGER
      or base == BASE_ITEM_DART
      or base == BASE_ITEM_HEAVYCROSSBOW
      or base == BASE_ITEM_LIGHTCROSSBOW
      or base == BASE_ITEM_LANCE
      or base == BASE_ITEM_LIGHTMACE
      or base == BASE_ITEM_LIGHT_MACE_2
      or base == BASE_ITEM_MAGICSTAFF
      or base == BASE_ITEM_MORNINGSTAR
      or base == BASE_ITEM_QUARTERSTAFF
      or base == BASE_ITEM_SICKLE
      or base == BASE_ITEM_SLING
      or base == BASE_ITEM_TINY_SPEAR
      or base == BASE_ITEM_SHORTSPEAR
end

--- Determine if weapon is finessable.
-- @param item The weapon in question.
-- @param cre Creature weilding weapon
local function GetIsWeaponFinessable(item, cre)
   if GetIsWeaponLight(item, cre) then return true end
   local size = cre:GetSize()
   local rel = cre:GetRelativeWeaponSize(item)
   local fin = TDA.Get2daInt("wpnprops", "Finesse", BaseitemToWeapon(item))
   if fin > 0 and size >= fin then return true end


   if TA then return rel <= 0 end

   -- ensure Small beings can finesse Small weapons still
   return size < 3 and rel <= 0
end

--- Determine Weapon Iteration.
-- @param cre Creature weilding weapon
-- @param item The weapon in question.
local function GetWeaponIteration(cre, item)
   local can, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
   if can and GetIsMonkWeapon(item, cre) then
      return 3
   elseif TA and cre:GetLocalInt("pc_style_fighting") == 2 then
      return 3
   end
   return 5
end

local function default_strength(cre, item)
   if GetIsRangedWeapon(item) then return 0 end
   return cre:GetAbilityModifier(ABILITY_STRENGTH)
end

local function default_dexterity(cre, item)
   if GetIsRangedWeapon(item) or
      (cre:GetHasFeat(FEAT_WEAPON_FINESSE) and
       GetIsWeaponFinessable(item, cre))
   then
      return cre:GetAbilityModifier(ABILITY_DEXTERITY)
   end

   return 0
end

local function default_wisdom(cre, item)
   local can = false
   if GetIsRangedWeapon(item) and cre:GetHasFeat(FEAT_ZEN_ARCHERY) then
      can = true
   elseif GetIsWeaponSimple(item, cre) and cre:GetHasFeat(TA_FEAT_INTUITIVE_STRIKE) then
      can = true
   elseif TA and cre:GetIsPolymorphed() then
      can = true
   end
   return can and cre:GetAbilityModifier(ABILITY_WISDOM) or 0
end

local function default_zero(cre, item) return 0 end

local _WEAPON_ABIL = {
   [0] = default_strength,
   default_dexterity,
   default_zero,
   default_zero,
   default_wisdom,
   default_zero
}

--- Gets weapons attack bonus ability score.
-- @param cre Creature
-- @param item Item
local function GetWeaponAttackAbility(cre, item)
   local result = 0
   for i=0, ABILITY_NUM - 1 do
      result = max(result, _WEAPON_ABIL[i](cre, item))
   end
   return result
end

local function default_dmg(cre, item)
   local str = cre:GetAbilityModifier(ABILITY_STRENGTH)
   if not item:GetIsValid() then return str end
   local base = item:GetBaseType()
   local mighty = false
   local mighty_needed = false

   if base == BASE_ITEM_LONGBOW or
      base == BASE_ITEM_SHORTBOW or
      base == BASE_ITEM_SLING or
      base == BASE_ITEM_HEAVYCROSSBOW or
      base == BASE_ITEM_LIGHTCROSSBOW
   then
      mighty_needed = true
      for _it, ip in item:ItemProperties() do
         if ip:GetType() == ITEM_PROPERTY_MIGHTY then
            mighty = ip:GetCostTableValue()
            break
         end
      end
   end

   -- TODO: Ensure this is correct...
   if cre:GetRelativeWeaponSize(item) > 0 and not GetIsRangedWeapon(item) then
      if TA and cre:GetLocalInt('pc_style_fighting') == 4 then
         str = str * 2
      else
         str = math.floor(str * 1.5)
      end
   end

   if mighty_needed then
      return mighty and math.clamp(str, 0, mighty) or 0
   end

   return str
end

local _WEAPON_DMG = {
   [0] = default_dmg,
   default_zero,
   default_zero,
   default_zero,
   default_zero,
   default_zero
}

--- Gets weapons damage ability score.
-- @param cre Creature
-- @param item Item
local function GetWeaponDamageAbility(cre, item)
   local result = 0
   for i=0, ABILITY_NUM - 1 do
      result = max(result, _WEAPON_DMG[i](cre, item))
   end
   return result
end

--- Sets an override function for determining ab bonus from
-- a creatures ability scores.
-- @param ability ABILITY_*
-- @func func (creature, item) -> int
local function SetWeaponAttackAbilityOverride(ability, func)
   _WEAPON_ABIL[ability] = func
end

--- Sets an override function for determining damage bonus from
-- a creatures ability scores.
-- TODO: does not include two-handed bonus
-- @param ability ABILITY_*
-- @func func (creature, item) -> int
local function SetWeaponDamageAbilityOverride(ability, func)
   _WEAPON_DMG[ability] = func
end

--- Determines a creatures attack bonus using a particular weapon.
-- @param cre Creature weilding weapon
-- @param weap The weapon in question.
local function GetWeaponAttackBonus(cre, weap)
   local feat = -1
   local ab = 0
   local ewf = false

   -- Epic Weapon Focus
   feat = GetWeaponFeat(MASTERWEAPON_FEAT_FOCUS_EPIC, weap)
   if feat ~= -1 and cre:GetHasFeat(feat) then
      ab = ab + 3
      ewf = true
   end

   -- Weapon Focus, included above if creature has EWF
   if not ewf then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_FOCUS, weap)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         ab = ab + 1
      end
   end

   -- WM Weapon of Choice
   local wm = cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)
   if wm >= 5 then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_CHOICE, weap)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         ab = ab + 1
         if wm >= 13 then
            ab = ab + math.floor((wm - 10) / 3)
         end
         if TA then
            if wm >= 30 then
               ab = ab + 4
            elseif wm >= 29 then
               ab = ab + 2
            elseif wm >= 10 then
               ab = ab + 1
            end
         end
      end
   end

   if TA then
      local monk, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
      if monk and GetIsMonkWeapon(weap, cre) then
         if cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5) then
            ab = ab + 5
         elseif cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4) then
            ab = ab + 4
         elseif cre:GetHasFeat(FEAT_KI_STRIKE_3) then
            ab = ab + 3
         elseif cre:GetHasFeat(FEAT_KI_STRIKE_2) then
            ab = ab + 2
         elseif cre:GetHasFeat(FEAT_KI_STRIKE) then
            ab = ab + 1
         end
      end
   end

   if not weap:GetIsValid() then return ab end
   local base = weap:GetBaseType()

   -- NOTE: Derived from nwnx_weapons
   -- rogues with the Opportunist feat get to add their base int modifier
   -- to attacks with light weapons (including slings, light crossbows,
   -- and morningstars) capped by rogue level
   local rogue = cre:GetLevelByClass(CLASS_TYPE_ROGUE)
   if rogue >= 25                              and
      cre.obj.cre_stats.cs_ac_armour_base <= 3 and
      (GetIsWeaponLight(weap, cre)             or
       base == BASE_ITEM_LIGHTCROSSBOW         or
       base == BASE_ITEM_MORNINGSTAR           or
       base == BASE_ITEM_SLING)
   then
      local mx = math.min(5, math.floor((rogue - 20) / 5))
      local int = math.floor((cre:GetAbilityScore(ABILITY_INTELLIGENCE) - 10) / 2)
      int = math.clamp(int, 0, mx)
      if int > 0 and rogue >= 30 then
         int = int + 1
      end
      ab = ab + int
   end

   -- Enchant Arrow
   if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
      feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_6,
                                       FEAT_PRESTIGE_ENCHANT_ARROW_20)
      if feat ~= -1 then
         ab = ab + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_6) + 6
      else
         feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_1, FEAT_PRESTIGE_ENCHANT_ARROW_5)
         if feat ~= -1 then
            ab = ab + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_1) + 1
         end
      end
   end

   return ab
end

--- Determine weapons damage power.
-- @param cre Creature weilding weapon
-- @param item The weapon in question.
local function GetWeaponPower(cre, item)
   local power = 0

   local monk, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
   if monk and GetIsMonkWeapon(item, cre) then
      if cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5) then
         power = 5
      elseif cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4) then
         power = 4
      elseif cre:GetHasFeat(FEAT_KI_STRIKE_3) then
         power = 3
      elseif cre:GetHasFeat(FEAT_KI_STRIKE_2) then
         power = 2
      elseif cre:GetHasFeat(FEAT_KI_STRIKE) then
         power = 1
      end
   end

   if not item:GetIsValid() then return power end

   local eb = 0
   for _it, ip in item:ItemProperties() do
      if ip:GetPropertyType() == ITEM_PROPERTY_ENHANCEMENT_BONUS or
         ip:GetPropertyType() == ITEM_PROPERTY_ATTACK_BONUS
      then
         eb = math.max(eb, ip:GetCostTableValue())
      end
   end

   power = math.max(power, eb)

   local base = item:GetBaseType()
   local aa = 0
   -- Enchant Arrow
   if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
      local feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_6,
                                             FEAT_PRESTIGE_ENCHANT_ARROW_20)
      if feat ~= -1 then
         aa = aa + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_6) + 6
      else
         feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_1, FEAT_PRESTIGE_ENCHANT_ARROW_5)
         if feat ~= -1 then
            aa = aa + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_1) + 1
         end
      end
   end
   power = math.max(power, aa)

   return power
end

--- Determine weapons base damage type.
-- NOTE: This does not support multiple weapon damage types and most likely never will.
-- @param item Weapon.
local function GetWeaponBaseDamageType(item)
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local t = TDA.Get2daInt(tda, "BaseDamage", BaseitemToWeapon(item))
   local type = 0

   if t == 1 then
      type = DAMAGE_INDEX_PIERCING
   elseif t == 2 then
      type = DAMAGE_INDEX_BLUDGEONING
   elseif t == 3 then
      type = DAMAGE_INDEX_SLASHING
   else
      error(string.format("Invalid base damage type: %d", t))
   end
   return type
end

--- Determine weapons base damage roll.
-- @param item Weapon.
-- @param cre Creature
local function GetWeaponBaseDamage(item, cre)
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local d = TDA.Get2daInt(tda, "Dice", BaseitemToWeapon(item))
   local s = TDA.Get2daInt(tda, "Sides", BaseitemToWeapon(item))
   local b = TDA.Get2daInt(tda, "Bonus", BaseitemToWeapon(item))
   local base = type(item) == 'number' and item or item:GetBaseType()
   local found = false
   local feat

   if TA then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_SPEC_LEG, item)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         found = true
         b = b + 18
      end

      if not found then
         feat = GetWeaponFeat(MASTERWEAPON_FEAT_SPEC_SUP, item)
         if feat ~= -1 and cre:GetHasFeat(feat) then
            found = true
            b = b + 12
         end
      end

      local wm = cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)
      if wm >= 3 then
         feat = GetWeaponFeat(MASTERWEAPON_FEAT_CHOICE, item)
         if feat ~= -1 and cre:GetHasFeat(feat) then
            b = b + math.floor(wm / 3)
         end
      end
   end

   if not found then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_FOCUS_EPIC, item)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         found = true
         b = b + 8
      end
   end

   if not found then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_SPEC, item)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         found = true
         b = b + 4
      end
   end

   -- Enchant Arrow
   if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
      feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_6,
                                       FEAT_PRESTIGE_ENCHANT_ARROW_20)
      if feat ~= -1 then
         b = b + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_6) + 6
      else
         feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_1, FEAT_PRESTIGE_ENCHANT_ARROW_5)
         if feat ~= -1 then
            b = b + (feat - FEAT_PRESTIGE_ENCHANT_ARROW_1) + 1
         end
      end
   end

   return d, s, b
end

--- Determine unarmed damage bonus.
-- @param cre Creature unarmed.
local function GetUnarmedDamageBonus(cre)
   local d, s, b = GetWeaponBaseDamage(BASE_ITEM_GLOVES, cre)
   d, s = 0, 0

   local big = false
   if cre:GetSize() == CREATURE_SIZE_HUGE   or
      cre:GetSize() == CREATURE_SIZE_LARGE  or
      cre:GetSize() == CREATURE_SIZE_MEDIUM
   then
      big = true
   end

   local can, monk = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
   if monk > 0 then
      d = 1
      if monk >= 16 then
         if big then
            d, s = 1, 20
         else
            d, s = 2, 6
         end
      elseif monk >= 12 then
         s = big and 12 or 10
      elseif monk >= 10 then
         s = big and 12 or 10
      elseif monk >= 8 then
         s = big and 10 or 8
      elseif monk >= 4 then
         s = big and 8 or 6
      else
         s = big and 6 or 4
      end
      if TA then
         if can and cre:GetLocalInt("pc_style_fighting") == 8 then
            b = b + math.floor(monk / 6)
         end
      end
   else
      if big then
         d, s = 1, 3
      else
         d, s = 1, 2
      end
   end

   return d, s, b
end

--- Determine weapons critical hit range.
-- @param cre Creature
-- @param item Weapon.
local function GetWeaponCritRange(cre, item)
   local base = item
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local basethreat = TDA.Get2daInt(tda, "CritThreat", BaseitemToWeapon(base))
   local override = item:GetLocalInt("PL_CRIT_OVERRIDE")
   if override > 0 then
      if override == 1 then
         basethreat = 3
      elseif override == 2 then
         basethreat = 2
      elseif override == 3 then
         basethreat = 1
      end
   end

   local threat = basethreat
   local haswoc = false

   local feat = GetWeaponFeat(MASTERWEAPON_FEAT_CRIT_IMPROVED, base)
   if feat ~= -1 and cre:GetHasFeat(feat) then
      threat = threat + basethreat
   end

   local wm = cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)
   if wm >= 7 then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_CHOICE, base)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         threat = threat + 2
         haswoc = true
      end
   end

   if TA then
      if not haswoc then
         feat = GetWeaponFeat(MASTERWEAPON_FEAT_CRIT_OVERWHELMING, base)
         if feat ~= -1 and cre:GetHasFeat(feat) then
            threat = threat + 1
         end
      end
   end

   if item:GetIsValid() then
      for _it, ip in item:ItemProperties() do
         if ip:GetPropertyType() == ITEM_PROPERTY_KEEN then
            threat = threat + basethreat
            break
         end
      end
   end

   return threat
end

--- Determine weapons critical hit multiplier.
-- @param cre Creature
-- @param item Weapon.
local function GetWeaponCritMultiplier(cre, item)
   local base = item
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local mult = TDA.Get2daInt(tda, "CritMult", BaseitemToWeapon(base))
   local override = item:GetLocalInt("PL_CRIT_OVERRIDE")
   if override > 0 then
      if override == 1 then
         mult = 2
      elseif override == 2 then
         mult = 3
      elseif override == 3 then
         mult = 4
      end
   end

   local wm = cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)
   if wm >= 5 then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_CHOICE, base)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         mult = mult + 1
      end
   end

   if TA then
      feat = GetWeaponFeat(MASTERWEAPON_FEAT_CRIT_DEVASTATING, base)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         mult = mult + 1
      end
   end

   return mult
end

--- Get dual wielding penalty.
-- @param cre Creature
-- @return onhand penalty, offhand penalty
local function GetDualWieldPenalty(cre)
   local rh = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   local lh = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)

   if BaseitemToWeapon(rh) == 0 or
      BaseitemToWeapon(lh) == 0
   then
      return 0, 0
   end

   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local is_double = TDA.Get2daInt(tda, "Type", BaseitemToWeapon(rh)) == 7

   local on, off = 0, 0
   local rel = cre:GetRelativeWeaponSize(rh)
   if rel <= -1 or is_double then
      on, off = -4, -8
   else
      on, off = -6, -10
   end

   -- Ranger dual.
   if cre.obj.cre_stats.cs_ac_armour_base <= 3
      and cre:GetLevelByClass(CLASS_TYPE_RANGER) > 0 then
      on, off = on + 2, off + 6
   else
      if cre:GetHasFeat(FEAT_TWO_WEAPON_FIGHTING) then
         on, off = on + 2, off + 2
      end

      if cre:GetHasFeat(FEAT_AMBIDEXTERITY) then
         off = off + 4
      end
   end

   return on, off
end

local _ROLLS
local _ROLLS_LEN = 0
local function UnpackItempropDamageRoll(ip)
   if _ROLLS_LEN == 0 then
      local tda = TDA.GetCached2da("iprp_damagecost")
      if tda == nil then error "Unable to locate iprp_damagecost.2da!" end

      _ROLLS_LEN = TDA.Get2daRowCount(tda)
      _ROLLS = ffi.new("DiceRoll[?]", _ROLLS_LEN)

      for i=1, TDA.Get2daRowCount(tda) - 1 do

         local d = TDA.Get2daInt(tda, "NumDice", i)
         local s = TDA.Get2daInt(tda, "Die", i)
         if d == 0 then
            _ROLLS[i].dice, _ROLLS[i].sides, _ROLLS[i].bonus = 0, 0, s
         else
            _ROLLS[i].dice, _ROLLS[i].sides, _ROLLS[i].bonus = d, s, 0
         end
      end
   end

   if ip < 0 or ip >= _ROLLS_LEN then
      error(string.format("Invalid IP Const: %d, %s", ip, debug.traceback()))
   end

   return _ROLLS[ip].dice, _ROLLS[ip].sides, _ROLLS[ip].bonus

end

local function AttackTypeToEquipType(atype)
   assert(atype > 0)
   if atype == ATTACK_TYPE_OFFHAND then
      return EQUIP_TYPE_OFFHAND
   elseif atype == ATTACK_TYPE_CWEAPON1 then
      return EQUIP_TYPE_CREATURE_1
   elseif atype == ATTACK_TYPE_CWEAPON2 then
      return EQUIP_TYPE_CREATURE_2
   elseif atype == ATTACK_TYPE_CWEAPON3 then
      return EQUIP_TYPE_CREATURE_3
   elseif atype == ATTACK_TYPE_UNARMED then
      return EQUIP_TYPE_UNARMED
   end
   return EQUIP_TYPE_ONHAND
end

local function EquipTypeToAttackType(atype)
   assert(atype >= 0)
   if atype == EQUIP_TYPE_OFFHAND then
      return ATTACK_TYPE_OFFHAND
   elseif atype == EQUIP_TYPE_CREATURE_1 then
      return ATTACK_TYPE_CWEAPON1
   elseif atype == EQUIP_TYPE_CREATURE_2 then
      return ATTACK_TYPE_CWEAPON2
   elseif atype == EQUIP_TYPE_CREATURE_3 then
      return ATTACK_TYPE_CWEAPON3
   elseif atype == EQUIP_TYPE_UNARMED then
      return ATTACK_TYPE_UNARMED
   end
   return ATTACK_TYPE_ONHAND
end

local function InventorySlotToAttackType(atype)
   assert(atype >= 0)
   if atype == INVENTORY_SLOT_LEFTHAND then
      return ATTACK_TYPE_OFFHAND
   elseif atype == INVENTORY_SLOT_CWEAPON_L then
      return ATTACK_TYPE_CWEAPON1
   elseif atype == INVENTORY_SLOT_CWEAPON_R then
      return ATTACK_TYPE_CWEAPON2
   elseif atype == INVENTORY_SLOT_CWEAPON_B then
      return ATTACK_TYPE_CWEAPON3
   elseif atype == INVENTORY_SLOT_ARMS then
      return ATTACK_TYPE_UNARMED
   elseif atype == INVENTORY_SLOT_RIGHTHAND then
      return ATTACK_TYPE_ONHAND
   else
      assert(false, "Inventory slot does not have an attack type.")
   end
end
--- Determine number of onhand attacks.
-- @param cre Creature
local function GetOnhandAttacks(cre)
   local rh   = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   local iter = GetWeaponIteration(cre, rh)
   local bab  = M.GetBaseAttackBonus(cre, true)
   local res  = math.ceil(bab / iter)

   if iter == 5 then
      if cre:GetHitDice(cre) >= 55 then
         res = res + 2
      elseif cre:GetHitDice(cre) >= 45 then
         res = res + 1
      end
   end

   res = math.clamp(res, 1, 6)

   if TA then
      local style = cre:GetLocalInt("pc_style_fighting")
      if not rh:GetIsValid() then
         if style == 7 then res = res + 1 end
         if cre:GetKnowsFeat(2001) then res = res + 1 end
      elseif style == 3 then
         local lh = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
         if lh:GetIsValid() and
            (lh:GetBaseType() == BASE_ITEM_SMALLSHIELD or
             lh:GetBaseType() == BASE_ITEM_LARGESHIELD or
             lh:GetBaseType() == BASE_ITEM_TOWERSHIELD)
         then
            res = res + 1
         end
      end
   end

   return res
end

--- Determine number of offhand attacks.
-- @param cre Creature
local function GetOffhandAttacks(cre)
   local rh   = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   local tda  = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end

   local is_double = TDA.Get2daInt(tda, "Type", BaseitemToWeapon(rh)) == 7
   local item      = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
   if BaseitemToWeapon(item) == 0 and not is_double then return 0 end

   local ranger_9 = cre:GetLevelByClass(CLASS_TYPE_RANGER) >= 9

   local res = 1

   if ranger_9 and cre.obj.cre_stats.cs_ac_armour_base > 3 then
      return res
   end

   if ranger_9 or cre:GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) then
      res = res + 1
   end

   if TA then
      local ranger = cre:GetLevelByClass(CLASS_TYPE_RANGER)
      local monk   = cre:GetLevelByClass(CLASS_TYPE_MONK)

      if res > 0 and ranger >= 40 and
         (monk == 0 or not GetIsMonkWeapon(cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND), cre))
      then
         res = res + 1
      end
   end

   return res
end

--- Initialize combat rounds attack counts.
-- @param cre Creature
local function InitializeNumberOfAttacks(cre)
   local add = 0
   local rh  = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   local rbi = rh:GetIsValid() and rh:GetBaseType() or -1

   local on, off = cre.ci.offense.attacks_on, cre.ci.offense.attacks_off

   if (rbi == BASE_ITEM_HEAVYCROSSBOW or
       rbi == BASE_ITEM_LIGHTCROSSBOW) and
      not cre:GetHasFeat(FEAT_RAPID_RELOAD)
   then
      on = 1
   end

   if cre.obj.cre_stats.cs_override_atks > 0 then
      on = cre.obj.cre_stats.cs_override_atks
   end

   -- Dirty Fighting
   if cre.obj.cre_mode_combat == 10 then
      cre:SetCombatMode(0)
      on, off = 1, 0
   -- Rapid Shot
   elseif cre.obj.cre_mode_combat == 6 then
      add = add + 1
   -- Flurry can only be toggled on IFF the monk weapon reqs are met.
   elseif cre.obj.cre_mode_combat == 5 then
      add = add + 1
   end

   if cre.obj.cre_hasted ~= 0 then
      add = add + 1
   end

   cre.obj.cre_combat_round.cr_additional_atks = add
   cre.obj.cre_combat_round.cr_onhand_atks = on
   cre.obj.cre_combat_round.cr_offhand_atks = off

   cre.obj.cre_combat_round.cr_offhand_taken = 0
   cre.obj.cre_combat_round.cr_extra_taken = 0

end

-- Exports.
M.GetWeaponAttackAbility          = GetWeaponAttackAbility
M.SetWeaponAttackAbilityOverride  = SetWeaponAttackAbilityOverride
M.GetWeaponDamageAbility          = GetWeaponDamageAbility
M.SetWeaponDamageAbilityOverride  = SetWeaponDamageAbilityOverride

M.GetWeaponAttackBonus            = GetWeaponAttackBonus
M.GetWeaponFeat                   = GetWeaponFeat
M.SetWeaponFeat                   = SetWeaponFeat
M.GetWeaponBaseDamageType         = GetWeaponBaseDamageType
M.GetWeaponBaseDamage             = GetWeaponBaseDamage
M.GetWeaponCritRange              = GetWeaponCritRange
M.GetWeaponCritMultiplier         = GetWeaponCritMultiplier
M.GetDualWieldPenalty             = GetDualWieldPenalty

M.GetIsMonkWeapon                 = GetIsMonkWeapon
M.GetIsRangedWeapon               = GetIsRangedWeapon
M.GetIsWeaponLight                = GetIsWeaponLight
M.GetIsWeaponFinessable           = GetIsWeaponFinessable
M.GetIsWeaponSimple               = GetIsWeaponSimple

M.GetWeaponIteration              = GetWeaponIteration
M.GetWeaponType                   = GetWeaponType
M.GetWeaponPower                  = GetWeaponPower
M.GetUnarmedDamageBonus           = GetUnarmedDamageBonus

M.UnpackItempropDamageRoll        = UnpackItempropDamageRoll
M.AttackTypeToEquipType           = AttackTypeToEquipType
M.EquipTypeToAttackType           = EquipTypeToAttackType
M.InventorySlotToAttackType       = InventorySlotToAttackType
M.GetOnhandAttacks                = GetOnhandAttacks
M.GetOffhandAttacks               = GetOffhandAttacks
M.InitializeNumberOfAttacks       = InitializeNumberOfAttacks
M.BaseitemToWeapon                = BaseitemToWeapon
