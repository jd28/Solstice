--- Item Generator Environment
-- The solstice.item.env.
-- @module item.env
-- @alias E

local ffi = require 'ffi'
local ip = require 'solstice.itemprop'
local ipc = ip.const

ffi.cdef [[
typedef struct {
   int32_t start;
   int32_t stop;
} Range;
]]

local range_t = ffi.typeof("Range")

local M = require 'solstice.item.init'
M.env = {}
local E = M.env

---
function E.Random(start, stop)
   return range_t(start, stop)
end

---
function E.Chance(perc, ip)
   local idx = #E.item.props
   local prop = E.item.props[idx]
   prop.chance = perc
   return true
end

---
function E.Ability(ability, mod)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { ability, mod, f = "AbilityScore" })
   return true
end

---
function E.ArcaneSpellFailure(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "ArcaneSpellFailure" })
   return true
end

---
function E.AC(bonus, ac_type)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { bonus, ac_type, f = "AC" })
   return true
end

---
function E.AttackModifier(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "AttackModifier" })
   return true
end

---
function E.BonusFeat(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "BonusFeat" })
   return true
end

---
function E.BonusLevelSpell(class, level, n)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { class, level, f = "CastSpell", n = n })
   return true
end

---
function E.CastSpell(spell, uses)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { spell, uses, f = "CastSpell" })
   return true
end

---
function E.DamageBonus(damage_type, va1, val2, is_range, is_penalty)
   return true
end

---
function E.DamageImmunity(damage_type, amount)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { damage_type, amount, f = "DamageImmunity" })
   return true
end

--- Item Property Enhancement Bonus
-- @see solstice.itemprop.EnhancementModifier
function E.EnhancementModifier(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "EnhancementModifier" })
   return true
end

---
function E.Haste()
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { f = "Haste" })
   return true
end

---
function E.HolyAvenger()
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { f = "HolyAvenger" })
   return true
end

---
function E.Keen()
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { f = "Keen" })
   return true
end

---
function E.Light(brightness, color)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { brightness, color, f = "Light" })
   return true
end

---
function E.Mighty(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, "Mighty" })
   return true
end

---
function E.NoDamage()
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { f = "NoDamage" })
   return true
end

---
function E.OnHit(prop, dc, special)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { prop, dc, special, f = "OnHitProps" })
   return true
end

---
function E.Regeneration(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "Regeneration" })
   return true
end

---
function E.Skill(skill, mod)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { skill, mod, f = "Skill" })
   return true
end

---
function E.SpellResistance(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, "SpellResistance" })
   return true
end

--- Creates a turn resistance item property.
-- see solstice.itemprop.TurnResistance
function E.TurnResistance(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, "TurnResistance" })
   return true
end

--- Creates a visual effect item property
-- @see solstice.itemprop.VisualEffect
function E.VisualEffect(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, f = "VisualEffect" })
   return true
end

--[[
function E.WeightModifier(value)
   E.item = E.item or {}
   E.item.props = E.item.props or {}
   table.insert(
      E.item.props,
      { value, "VisualEffect" })
end
--]]

return E