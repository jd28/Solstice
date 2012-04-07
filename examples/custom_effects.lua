require "nwn.object"
require "nwn.effects"
local nie = require 'nwn.internal.effects'

TA_EFFECT_DECREASE_DC = 3

function nwn.EffectDecreaseDC(amount)
   local eff = nwn.EffectCustom(TA_EFFECT_DECREASE_DC, { amount })
   return eff
end

nie.RegisterCustomEffect(TA_EFFECT_DECREASE_DC,
    function (effect, target, is_apply)
       local amount = effect:GetInt(1)
       if is_apply then
          target:DecrementLocalInt("SpellDC", amount)
       else
          target:IncrementLocalInt("SpellDC", amount)
       end
       return 0
    end)
