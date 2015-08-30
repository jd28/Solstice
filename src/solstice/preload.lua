----
-- This module never needs to be required explicitly except in your
-- preload.lua.  It loads the solstice library as well as setting
-- up a few custom effect handlers.
--
-- Custom Effect Handlers:
--
-- * `CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS`
-- * `CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE`
-- * `CUSTOM_EFFECT_TYPE_RECURRING`
-- * `CUSTOM_EFFECT_TYPE_HITPOINTS`
--
-- @module preload

local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

require 'solstice.global'
require 'solstice.bridge'

local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effect'
local GetObjectByID = require('solstice.game').GetObjectByID

if OPT.JIT_DUMP then
   local dump = require 'jit.dump'
   dump.on(nil, "luajit.dump")
end

-- Seed random number generator.
math.randomseed(os.time())
math.random(100)

local Eff = require 'solstice.effect'

-- This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are
-- fully healable. Since it's kind of annoying to have the effect applied but
-- not to have those HP usable this will heal the target amount for the
-- additional hitpoints that it receives.
NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local amount = eff:GetInt(0)
      if not is_remove then
         if target:GetIsDead() then return true end
         target.ci.defense.hp_eff = target.ci.defense.hp_eff + amount
         target:ApplyEffect(DURATION_TYPE_INSTANT, Eff.Heal(amount))
      else
         target.ci.defense.hp_eff = target.ci.defense.hp_eff - amount
      end
   end,
   CUSTOM_EFFECT_TYPE_HITPOINTS)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      local immunity = effect:GetInt(0)
      local amount   = effect:GetInt(1)
      local new      = target.ci.defense.immunity_misc[immunity]

      if not is_remove then
         if target:GetIsDead() then return true end
         new = new - amount
      else
         new = new + amount
      end

      target.ci.defense.immunity_misc[immunity] = new
      return false
   end,
   CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE)
