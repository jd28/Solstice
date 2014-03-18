local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effects'

-- This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are
-- fully healable. Since it's kind of annoying to have the effect applied but
-- not to have those HP usable this will heal the target amount for the
-- additional hitpoints that it receives.
NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_apply)
      local amount = effect:GetInt(0)

      if is_apply then
         if target:GetIsDead() then return true end
         target.ci.defense.hp_eff = target.ci.defense.hp_eff + amount
         target:ApplyEffect(Eff.Heal(amount))
      else
         target.ci.defense.hp_eff = target.ci.defense.hp_eff - amount
      end
   end,
   EFFECT_TYPE_HITPOINTS)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_apply)
      if is_apply and target:GetIsDead() then
         return true
      end
   end,
   EFFECT_TYPE_RECURRING)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_apply)
      local immunity = effect:GetInt(0)
      local amount   = effect:GetInt(1)
      local new      = target.ci.defense.immunity_misc[immunity]

      if is_apply then
         if target:GetIsDead() then return true end
         new = new - amount
      else
         new = new + amount
      end

      target.ci.defense.immunity_misc[immunity] = new
   end,
   EFFECT_TYPE_IMMUNITY_DECREASE)
