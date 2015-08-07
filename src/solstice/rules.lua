--- Rules module.
-- Globally exported as `Rules`.
-- @alias M

local ffi = require 'ffi'
local bit = require 'bit'
local C = ffi.C

local M = require 'solstice.rules.init'
safe_require 'solstice.rules.ability'
safe_require 'solstice.rules.classes'
safe_require 'solstice.rules.combatmods'
safe_require 'solstice.rules.combat'
safe_require 'solstice.rules.conceal'
safe_require 'solstice.rules.constants'
safe_require 'solstice.rules.damage'
safe_require 'solstice.rules.dmgred'
safe_require 'solstice.rules.effects'
safe_require 'solstice.rules.feats'
safe_require 'solstice.rules.hitpoints'
safe_require 'solstice.rules.immunities'
safe_require 'solstice.rules.modes'
safe_require 'solstice.rules.races'
safe_require 'solstice.rules.saves'
safe_require 'solstice.rules.situations'
safe_require 'solstice.rules.specattack'
safe_require 'solstice.rules.skills'
safe_require 'solstice.rules.weapons'
safe_require 'solstice.rules.levels'

return M
