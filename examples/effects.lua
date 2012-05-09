require 'nwn.object'
require 'nwn.effects'

-- See nwn/constants/effects.lua and nwn.EFFECT_CUSTOMTYPE_* for values already
-- in use.
nwn.EFFECT_CUSTOMTYPE_DECREASE_DC = 1000

-- Custom effect creation function.
function nwn.EffectDecreaseDC(amount)
   -- Simply call nwn.EffectCustom with the effect type and a list of 
   -- integer values that you want to store on the effect.  In this case
   -- there is only one value the amount to decrease the casters DC by.
   return nwn.EffectCustom(ta.EFFECT_CUSTOMTYPE_DECREASE_DC, {amount})
end

-- Register the effect and a function to call when the effect is applied/removed.
-- This particular effect assumes you have a spell system that can adjust spell DCs
-- by local variables set on the caster.  I believe the one in the Community Patch 
-- can do this, tho it uses different variable names.
nwn.RegisterCustomEffect(
   -- The custom effect type.
   nwn.EFFECT_CUSTOMTYPE_DECREASE_DC,
   -- When the function is called it is passed three arguments,
   -- the effect itself, the target that it is being applied to
   -- and a boolean value which is true when the effect is applied
   -- and false when the effect is removed.
   function (effect, target, is_apply)
      -- The integer values that we stored when we created the effect are indexed from one.
      -- So the amount to decrease here is the effect integer at index 1.
      local amount = effect:GetInt(1)
      if is_apply then
	 -- We're applying the function so decrement the spell DC adjustment by the amount.
	 target:DecrementLocalInt("SpellDC", amount)
      else
	 -- We're removing the function so increase the spell DC adjustment by the amount.
	 target:IncrementLocalInt("SpellDC", amount)
      end
      
      -- There must be a return value that is 1 or 0 when an effect is applied.
      -- The 0 indicates that effect was successfully applied and 1 that it was not.
      -- The engine already checks for cases like invalid target and if the target is dead.
      -- When the effect is removed the return value is ignored.
      -- In this case since the target is alive and valid there's nothing stopping the effect from
      -- being applied so it's safe to always return 0.
      return 0
   end)

-- Another example.  This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are fully healable.
-- Since it's kind of annoying to have the effect applied but not to have those HP usable this
-- will heal the target amount for the additional hitpoints that it receives.
nwn.RegisterCustomEffect(
   nwn.EFFECT_CUSTOMTYPE_HITPOINTS,
   function (effect, target, is_apply)
      local amount = effect:GetInt(1)
      if is_apply then
	 target:ApplyEffect(nwn.EffectHeal(amount))
      end

      return 0
   end)
