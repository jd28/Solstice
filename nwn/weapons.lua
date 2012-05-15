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

local WEAPONS = {}

-- feats.2da: MASTERFEAT 
nwn.WEAPON_MASTERFEAT_FOCUS = 1
nwn.WEAPON_MASTERFEAT_FOCUS_EPIC = 10
nwn.WEAPON_MASTERFEAT_CRITICAL_IMPROVED = 0
nwn.WEAPON_MASTERFEAT_CRITICAL_DEVISTATING = 13
nwn.WEAPON_MASTERFEAT_CRITICAL_OVERWHELMING = 12
nwn.WEAPON_MASTERFEAT_WEAPON_OF_CHOICE = 9
nwn.WEAPON_MASTERFEAT_SPECIALIZATION = 2
nwn.WEAPON_MASTERFEAT_SPECIALIZATION_EPIC = 11

--- Determines if base item type is a monk weapon
-- Base item time
function nwn.GetIsMonkWeapon(baseitem)
   return WEAPONS.monk[baseitem]
end

--- Determines which ability modifer to use for attack bonus
-- @param cre Creature weilding the weapon.
-- @param weap The weapon in question.
-- @param ability nwn.ABILITY_*
function nwn.GetWeaponAttackAbilityModifier(cre, weap, ability)
   if not WEAPONS.ab_abil or not WEAPONS.ab_abil[ability] then
      return 0
   end
   return WEAPONS.ab_abil[ability](cre, weap, ability)
end

function nwn.GetWeaponBaseDamageType(baseitem)
   local type, mask
   if not WEAPONS.base_dmg_mask or not WEAPONS.base_dmg_mask[baseitem] then
      mask = nwn.DAMAGE_TYPE_PHYSICAL
   end

   if not WEAPONS.base_dmg_type or not WEAPONS.base_dmg_type[baseitem] then
      type = nwn.DAMAGE_TYPE_BASE_WEAPON
   end

   type = type or WEAPONS.base_dmg_type[baseitem]
   mask = mask or WEAPONS.base_dmg_mask[baseitem]

   return type, mask
end

--- Determines which ability modifer to use for damage bonus
-- This is no longer limited to nwn.ABILITY_STRENGTH
-- @param cre Creature weilding the weapon.
-- @param weap The weapon in question.
-- @param ability nwn.ABILITY_*
function nwn.GetWeaponDamageAbilityModifier(cre, weap, ability)
   if not WEAPONS.dmg_abil or WEAPONS.dmg_abil[ability] then
      return 0
   end
   return WEAPONS.dmg_abil[ability](cre, weap, ability)
end

--- Get's a weapon feat.
-- @param masterfeat nwn.WEAPON_MASTERFEAT_* (The masterfeat column in feats.2da)
-- @param basetype The weapon's base item type
function nwn.GetWeaponFeat(masterfeat, basetype)
   if not WEAPONS[masterfeat] then
      error "Invalid Master Feat"
   end
   local feat = WEAPONS[masterfeat][basetype]

   if not feat then
      return -1
   end
   
   return feat
end

--- Determines if a weapon type is usable with a feat.
-- This is for Zen Archery, Weapon Finesse, etc.
-- @param feat nwn.FEAT_*
-- @param basetype The weapon's base item type
function nwn.GetWeaponUsableWithFeat(feat, baseitem)
   if not WEAPONS.useable or
      not WEAPONS.useable[feat] or
      not WEAPONS.useable[feat][baseitem]
   then
      return 
   end
   return WEAPONS.useable[feat][baseitem]
end

--- Registers monk weapon
-- @param basetype The weapon's base item type
-- @param level Monk level at which the weapon is usable as a
--    monk weapon
function nwn.RegisterMonkWeapon(baseitem, level)
   WEAPONS.monk = WEAPONS.monk or {}
   WEAPONS.monk[baseitem] = level
end

--- Registers an attack ability modifer
-- See exampes/weapons.lua
-- @param ability nwn.ABILITY_*
-- @param f A function taking three arguments: the creature weilding the weapon,
--    the weapon to test, and the ability passed in at registration.  It MUST
--    return zero or the ability modifier for the ability.
function nwn.RegisterWeaponAttackAbility(ability, f)
   WEAPONS.ab_abil = WEAPONS.ab_abil or {}
   WEAPONS.ab_abil[ability] = f
end

function nwn.RegisterBaseDamageType(baseitem, dmg_type, dmg_mask)
   if dmg_mask then
      WEAPONS.base_dmg_mask = WEAPONS.base_dmg_mask or {}
      WEAPONS.base_dmg_mask[baseitem] = dmg_mask
   end

   if dmg_type then
      WEAPONS.base_dmg_type = WEAPONS.base_dmg_type or {}
      WEAPONS.base_dmg_type[baseitem] = dmg_type
   end
end

--- Registers an attack ability modifer
-- See exampes/weapons.lua
-- @param ability nwn.ABILITY_*
-- @param f A function taking three arguments: the creature weilding the weapon,
--    the weapon to test, and the ability passed in at registration.  It MUST
--    return zero or the ability modifier for the ability.
function nwn.RegisterWeaponDamageAbility(ability, f)
   WEAPONS.dmg_abil = WEAPONS.dmg_abil or {}
   WEAPONS.dmg_abil[ability] = f
end

--- Registers weapon feat.
-- @param masterfeat nwn.WEAPON_MASTERFEAT_* (The masterfeat column in feats.2da)
-- @param basetype The weapon's base item type
-- @param feat nwn.FEAT_*
function nwn.RegisterWeaponFeat (masterfeat, basetype, feat)
   WEAPONS[masterfeat] = WEAPONS[masterfeat] or {}
   WEAPONS[masterfeat][basetype] = feat
end

--- Registers weapon usable with a feat.
-- See exampes/weapons.lua
-- @param feat nwn.FEAT_*
-- @param basetype The weapon's base item type
-- @param val An integer value dependent on the feat passed at registration.
function nwn.RegisterWeaponUsableWithFeat(feat, baseitem, val)
   WEAPONS.useable = WEAPONS.useable or {}
   WEAPONS.useable[feat] = WEAPONS.useable[feat] or {}
   WEAPONS.useable[feat][baseitem] = val
end

-- Weapon Feat Tables

WEAPONS[nwn.WEAPON_MASTERFEAT_CRITICAL_DEVISTATING] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_EPIC_DEVASTATING_CRITICAL_WHIP
}

WEAPONS[nwn.WEAPON_MASTERFEAT_CRITICAL_IMPROVED] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_IMPROVED_CRITICAL_BASTARD_SWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_IMPROVED_CRITICAL_BATTLE_AXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_IMPROVED_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_IMPROVED_CRITICAL_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_IMPROVED_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_IMPROVED_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_IMPROVED_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_IMPROVED_CRITICAL_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_IMPROVED_CRITICAL_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_IMPROVED_CRITICAL_DIRE_MACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_IMPROVED_CRITICAL_DOUBLE_AXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_IMPROVED_CRITICAL_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_IMPROVED_CRITICAL_GREAT_AXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_IMPROVED_CRITICAL_GREAT_SWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_IMPROVED_CRITICAL_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_IMPROVED_CRITICAL_HAND_AXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_IMPROVED_CRITICAL_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_IMPROVED_CRITICAL_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_IMPROVED_CRITICAL_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_IMPROVED_CRITICAL_LIGHT_MACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_IMPROVED_CRITICAL_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_IMPROVED_CRITICAL_LONG_SWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_IMPROVED_CRITICAL_MORNING_STAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_IMPROVED_CRITICAL_STAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_IMPROVED_CRITICAL_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_IMPROVED_CRITICAL_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_IMPROVED_CRITICAL_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_IMPROVED_CRITICAL_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_IMPROVED_CRITICAL_SPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_IMPROVED_CRITICAL_SHORT_SWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_IMPROVED_CRITICAL_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_IMPROVED_CRITICAL_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_IMPROVED_CRITICAL_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_IMPROVED_CRITICAL_THROWING_AXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_IMPROVED_CRITICAL_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_IMPROVED_CRITICAL_WAR_HAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_IMPROVED_CRITICAL_WHIP
}

WEAPONS[nwn.WEAPON_MASTERFEAT_CRITICAL_OVERWHELMING] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP,
}

WEAPONS[nwn.WEAPON_MASTERFEAT_FOCUS] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_WEAPON_FOCUS_BASTARD_SWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_WEAPON_FOCUS_BATTLE_AXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_WEAPON_FOCUS_UNARMED_STRIKE,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_WEAPON_FOCUS_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_WEAPON_FOCUS_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_WEAPON_FOCUS_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_WEAPON_FOCUS_DIRE_MACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_WEAPON_FOCUS_DOUBLE_AXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_WEAPON_FOCUS_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_WEAPON_FOCUS_UNARMED_STRIKE,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_WEAPON_FOCUS_GREAT_AXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_WEAPON_FOCUS_GREAT_SWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_WEAPON_FOCUS_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_WEAPON_FOCUS_HAND_AXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_WEAPON_FOCUS_HEAVY_FLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_WEAPON_FOCUS_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_WEAPON_FOCUS_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_WEAPON_FOCUS_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_WEAPON_FOCUS_LIGHT_FLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_WEAPON_FOCUS_LIGHT_HAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_WEAPON_FOCUS_LIGHT_MACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_WEAPON_FOCUS_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_WEAPON_FOCUS_LONG_SWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_WEAPON_FOCUS_MORNING_STAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_WEAPON_FOCUS_STAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_WEAPON_FOCUS_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_WEAPON_FOCUS_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_WEAPON_FOCUS_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_WEAPON_FOCUS_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_WEAPON_FOCUS_SPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_WEAPON_FOCUS_SHORT_SWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_WEAPON_FOCUS_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_WEAPON_FOCUS_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_WEAPON_FOCUS_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_WEAPON_FOCUS_THROWING_AXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_WEAPON_FOCUS_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_WEAPON_FOCUS_WAR_HAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_WEAPON_FOCUS_WHIP,
}

WEAPONS[nwn.WEAPON_MASTERFEAT_FOCUS_EPIC] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_UNARMED,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_EPIC_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_EPIC_WEAPON_FOCUS_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_EPIC_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_EPIC_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_EPIC_WEAPON_FOCUS_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_EPIC_WEAPON_FOCUS_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_EPIC_WEAPON_FOCUS_DIREMACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_EPIC_WEAPON_FOCUS_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_UNARMED,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_EPIC_WEAPON_FOCUS_GREATAXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_EPIC_WEAPON_FOCUS_GREATSWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_EPIC_WEAPON_FOCUS_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_EPIC_WEAPON_FOCUS_HANDAXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_EPIC_WEAPON_FOCUS_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_EPIC_WEAPON_FOCUS_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_EPIC_WEAPON_FOCUS_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_EPIC_WEAPON_FOCUS_LONGSWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_EPIC_WEAPON_FOCUS_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_EPIC_WEAPON_FOCUS_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_EPIC_WEAPON_FOCUS_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_EPIC_WEAPON_FOCUS_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_EPIC_WEAPON_FOCUS_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_EPIC_WEAPON_FOCUS_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_EPIC_WEAPON_FOCUS_WARHAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_EPIC_WEAPON_FOCUS_WHIP
}

WEAPONS[nwn.WEAPON_MASTERFEAT_WEAPON_OF_CHOICE] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_WEAPON_OF_CHOICE_BASTARDSWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_WEAPON_OF_CHOICE_BATTLEAXE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_WEAPON_OF_CHOICE_CLUB,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_WEAPON_OF_CHOICE_DAGGER,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_WEAPON_OF_CHOICE_DIREMACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_WEAPON_OF_CHOICE_DOUBLEAXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_WEAPON_OF_CHOICE_DWAXE,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_WEAPON_OF_CHOICE_GREATAXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_WEAPON_OF_CHOICE_GREATSWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_WEAPON_OF_CHOICE_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_WEAPON_OF_CHOICE_HANDAXE,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_WEAPON_OF_CHOICE_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_WEAPON_OF_CHOICE_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_WEAPON_OF_CHOICE_KUKRI,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_WEAPON_OF_CHOICE_LIGHTMACE,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_WEAPON_OF_CHOICE_LONGSWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_WEAPON_OF_CHOICE_MORNINGSTAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_WEAPON_OF_CHOICE_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_WEAPON_OF_CHOICE_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_WEAPON_OF_CHOICE_SCYTHE,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_WEAPON_OF_CHOICE_SHORTSPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_WEAPON_OF_CHOICE_SHORTSWORD,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_WEAPON_OF_CHOICE_SICKLE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_WEAPON_OF_CHOICE_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_WEAPON_OF_CHOICE_WARHAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_WEAPON_OF_CHOICE_WHIP
}

WEAPONS[nwn.WEAPON_MASTERFEAT_SPECIALIZATION] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_WEAPON_SPECIALIZATION_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_WEAPON_SPECIALIZATION_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_WEAPON_SPECIALIZATION_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_WEAPON_SPECIALIZATION_DIRE_MACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_WEAPON_SPECIALIZATION_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_WEAPON_SPECIALIZATION_GREAT_AXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_WEAPON_SPECIALIZATION_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_WEAPON_SPECIALIZATION_HAND_AXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_WEAPON_SPECIALIZATION_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_WEAPON_SPECIALIZATION_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_WEAPON_SPECIALIZATION_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_WEAPON_SPECIALIZATION_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_WEAPON_SPECIALIZATION_LONG_SWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_WEAPON_SPECIALIZATION_MORNING_STAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_WEAPON_SPECIALIZATION_STAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_WEAPON_SPECIALIZATION_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_WEAPON_SPECIALIZATION_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_WEAPON_SPECIALIZATION_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_WEAPON_SPECIALIZATION_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_WEAPON_SPECIALIZATION_SPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_WEAPON_SPECIALIZATION_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_WEAPON_SPECIALIZATION_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_WEAPON_SPECIALIZATION_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_WEAPON_SPECIALIZATION_THROWING_AXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_WEAPON_SPECIALIZATION_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_WEAPON_SPECIALIZATION_WHIP
}

WEAPONS[nwn.WEAPON_MASTERFEAT_SPECIALIZATION_EPIC] = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE,
    [nwn.BASE_ITEM_BRACER]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CLUB]                    = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER,
    [nwn.BASE_ITEM_DART]                    = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_DART,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL,
    [nwn.BASE_ITEM_KAMA]                    = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA,
    [nwn.BASE_ITEM_KATANA]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE,
    [nwn.BASE_ITEM_SLING]                   = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_SLING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER,
    [nwn.BASE_ITEM_WHIP]                    = nwn.FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP
}

WEAPONS.base_dmg_type = {
    [nwn.BASE_ITEM_BASTARDSWORD]            = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_BATTLEAXE]               = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_BRACER]                  = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_CBLUDGWEAPON]            = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_CLUB]                    = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_CPIERCWEAPON]            = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_CSLASHWEAPON]            = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_CSLSHPRCWEAP]            = nwn.DAMAGE_TYPE_PIERCE_SLASH,
    [nwn.BASE_ITEM_DAGGER]                  = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_DART]                    = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_DIREMACE]                = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_DOUBLEAXE]               = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_DWARVENWARAXE]           = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_GLOVES]                  = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_GREATAXE]                = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_GREATSWORD]              = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_HALBERD]                 = nwn.DAMAGE_TYPE_PIERCE_SLASH,
    [nwn.BASE_ITEM_HANDAXE]                 = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_HEAVYCROSSBOW]           = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_HEAVYFLAIL]              = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_KAMA]                    = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_KATANA]                  = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_KUKRI]                   = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_LIGHTCROSSBOW]           = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_LIGHTFLAIL]              = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_LIGHTHAMMER]             = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_LIGHTMACE]               = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_LONGBOW]                 = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_LONGSWORD]               = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_MORNINGSTAR]             = nwn.DAMAGE_TYPE_BLUDG_PIERCE,
    [nwn.BASE_ITEM_QUARTERSTAFF]            = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_RAPIER]                  = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_SCIMITAR]                = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_SCYTHE]                  = nwn.DAMAGE_TYPE_PIERCE_SLASH,
    [nwn.BASE_ITEM_SHORTBOW]                = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_SHORTSPEAR]              = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_SHORTSWORD]              = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_SHURIKEN]                = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_SICKLE]                  = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_SLING]                   = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_THROWINGAXE]             = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_TRIDENT]                 = nwn.DAMAGE_TYPE_PIERCING,
    [nwn.BASE_ITEM_TWOBLADEDSWORD]          = nwn.DAMAGE_TYPE_SLASHING,
    [nwn.BASE_ITEM_WARHAMMER]               = nwn.DAMAGE_TYPE_BLUDGEONING,
    [nwn.BASE_ITEM_WHIP]                    = nwn.DAMAGE_TYPE_SLASHING
}
