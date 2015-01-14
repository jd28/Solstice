local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effects'

-- The following file of examples are of those custom effects that
-- are built into the system.

-- This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are
-- fully healable. Since it's kind of annoying to have the effect applied but
-- not to have those HP usable this will heal the target amount for the
-- additional hitpoints that it receives.
NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove, is_preapply)
      -- Since this our own effect, we needn't worry about pre/post
      -- application, we can deal with it all in pre.
      if not is_preapply then return end
      local amount = effect.eff_integers[2]

      if not is_remove then
         if target:GetIsDead() then return true end
         target.ci.defense.hp_eff = target.ci.defense.hp_eff + amount
         target:ApplyEffect(DURATION_TYPE_INSTANT, Eff.Heal(amount))
         return false, true
      else
         target.ci.defense.hp_eff = target.ci.defense.hp_eff - amount
         return true, true
      end
   end,
   CUSTOM_EFFECT_TYPE_HITPOINTS)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove, is_preapply)
      -- Since this our own effect, we needn't worry about pre/post
      -- application, we can deal with it all in pre.
      if not is_preapply then return end

      if not is_remove and target:GetIsDead() then
         return true
      end
      return false, true
   end,
   CUSTOM_EFFECT_TYPE_RECURRING)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove, is_preapply)
      -- Since this our own effect, we needn't worry about pre/post
      -- application, we can deal with it all in pre.
      if not is_preapply then return end

      local immunity = effect.eff_integers[2]
      local amount   = effect.eff_integers[3]
      local new      = target.ci.defense.immunity_misc[immunity]

      if not is_remove then
         if target:GetIsDead() then return true end
         new = new - amount
      else
         new = new + amount
      end

      target.ci.defense.immunity_misc[immunity] = new
      return false, true
   end,
   CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove, is_preapply)
      -- Since this our own effect, we needn't worry about pre/post
      -- application, we can deal with it all in pre.
      if not is_preapply then return end

      if not is_remove then
         if target:GetIsDead() or target.type ~= OBJECT_TRUETYPE_CREATURE then
            return true
         end
         target:SetMovementRate(effect.eff_integers[2])
      else
         target:SetMovementRate(0)
      end
      return false, true
   end,
   CUSTOM_EFFECT_TYPE_MOVEMENT_RATE)

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove, is_preapply)
      -- Since this our own effect, we needn't worry about pre/post
      -- application, we can deal with it all in pre.
      if not is_preapply then return end

      if not is_remove then
         if target:GetIsDead() or target.type ~= OBJECT_TRUETYPE_CREATURE then
            return true
         end
         target.obj.cre_combat_round.cr_effect_atks =
            math.clamp(target.obj.cre_combat_round.cr_effect_atks + eff.eff_integers[2], 0, 5)
      else
         local att = -eff.eff_integers[2]
         for i=0, target.obj.obj.obj_effects_len - 1 do
            if target.obj.obj.obj_effects[i].eff_type > 44 then break end
            if target.obj.obj.obj_effects[i].eff_type == 44 and
               target.obj.obj.obj_effects[i].eff_integers[1] == CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS
            then
               att = att + target.obj.obj.obj_effects[i].eff_integers[2]
            end
         end
         target.obj.cre_combat_round.cr_effect_atks = math.clamp(att, 0, 5)
      end
   end,
   CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS)
