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

function GetIsWeaponLight(item, cre)
   if GetWeaponType(item) == 8 then return true end
   return cre:GetRelativeWeaponSize(item) < 0
end

function GetIsWeaponFinessable(item, cre)
   if GetIsWeaponLight(item, cre) then return true end
   local size = cre:GetSize()
   local rel = cre:GetRelativeWeaponSize(item)
   local fin = TDA.Get2daInt("wpnprops", "Finesse", BaseitemToWeapon(item))
   if size >= fin then return true end

   -- ensure Small beings can finesse Small weapons still
   return size < 3 and rel <= 0
end


local function GetUnarmedDamageBonus(cre)
   local d, s, b = 0, 0, 0
   local dmgtype = DAMAGE_TYPE_BLUDGEONING

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
            bonus = bonus + math.floor(monk / 6)
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


local function GetWeaponIteration(cre, item)
   local can, lvl = M.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
   if can and GetIsMonkWeapon(item, cre) then
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
   if GetIsRangedWeapon(item) and cre:GetHasFeat(FEAT_ZEN_ARCHERY) then
      return cre:GetAbilityModifier(ABILITY_WISDOM)
   end
   return 0
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

   if base ~= BASE_ITEM_DART         and
      base ~= BASE_ITEM_SHURIKEN     and
      base ~= BASE_ITEM_THROWING_AXE and
      GetIsRangedWeapon(item)
   then
      for _it, ip in item:ItemProperties() do
         if ip:GetType() == ITEM_PROPERTY_MIGHTY then
            mighty = ip:GetCostTableValue()
            break
         end
      end
   end

   -- TODO: Ensure this is correct...
   if cre:GetRelativeWeaponSize(item) > 0 then
      if TA and cre:GetLocalInt('pc_style_fighting') == 4 then
         str = str * 2
      else
         str = math.floor(str * 1.5)
      end
   end

   if TA then
      -- Ki strike replacement
      local feat = GetWeaponFeat(MASTERWEAPON_FEAT_CHOICE, item)
      if feat ~= -1 and cre:GetHasFeat(feat) then
         str = str + math.floor(cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER) / 3)
      end
   end

   return mighty and math.clamp(str, 0, mighty) or str
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
      local mx = math.floor((rogue - 20) / 5)
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
      if ip:GetPropertyType() == ITEM_PROPERTY_ENHANCEMENT_BONUS then
         eb = math.max(eb, ip:GetCostTableValue())
      end
   end

   power = math.max(power, eb)

   local base = item:GetBaseType()
   local aa = 0
   -- Enchant Arrow
   if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
      feat = cre:GetHighestFeatInRange(FEAT_PRESTIGE_ENCHANT_ARROW_6,
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
      type = DAMAGE_TYPE_PIERCING
   elseif t == 2 then
      type = DAMAGE_TYPE_BLUDGEONING
   elseif t == 3 then
      type = DAMAGE_TYPE_SLASHING
   else
      error(string.format("Invalid base damage type: %d", t))
   end
   return type
end

local function GetWeaponBaseDamage(item, cre)
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local d = TDA.Get2daInt(tda, "Dice", BaseitemToWeapon(item))
   local s = TDA.Get2daInt(tda, "Sides", BaseitemToWeapon(item))
   local b = TDA.Get2daInt(tda, "Bonus", BaseitemToWeapon(item))

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

   return d, s, b
end

local function GetWeaponCritRange(cre, item)
   local base = item
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local basethreat = TDA.Get2daInt(tda, "CritThreat", BaseitemToWeapon(base))
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

local function GetWeaponCritMultiplier(cre, item)
   local base = item
   local tda = TDA.GetCached2da("wpnprops")
   if tda == nil then error "Unable to locate wpnprops.2da!" end
   local mult = TDA.Get2daInt(tda, "CritMult", BaseitemToWeapon(base))

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

   if cre:GetHasFeat(374) then -- Ranger dual.
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

   if ip <= 0 or ip >= _ROLLS_LEN then
      error "Invalid IP Const"
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

M.GetWeaponIteration              = GetWeaponIteration
M.GetWeaponType                   = GetWeaponType
M.GetWeaponPower                  = GetWeaponPower
M.GetUnarmedDamageBonus           = GetUnarmedDamageBonus

M.UnpackItempropDamageRoll        = UnpackItempropDamageRoll
M.AttackTypeToEquipType           = AttackTypeToEquipType
