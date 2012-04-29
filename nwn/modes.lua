local MODES = {}

function NSToggleMode(cre, mode)
   cre = _NL_GET_CACHED_OBJECT(cre)
   local bypass = true
   local act, on

   if cre:GetIsDead() or cre:GetIsPCDying() then
      return false
   end

   if mode == nwn.ACTION_MODE_DETECT then
      if cre:GetDetectMode() == 1 then
         act, on = 2, 0
      else
         act, on = 2, 1
      end
      cre:SetActivity(act, on)
   elseif mode == nwn.ACTION_MODE_STEALTH then
      if self.obj.cre_attack_target ~= nwn.OBJECT_INVALID.id
         or self.obj.cre_attempted_target ~= nwn.OBJECT_INVALID.id
      then
         cre:SendMessageByStrRef(60)
      elseif cre:CanUseSkill(nwn.SKILL_HIDE) or cre:CanUseSkill(nwn.SKILL_MOVE_SILENTLY) then
         if cre.obj.cre_mode_stealth == 1 then
            act, on = 1, 0
         else
            act, on = 1, 1
         end
         cre:SetActivity(act, on)
      end
   elseif mode == nwn.ACTION_MODE_PARRY then
      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_PARRY then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_PARRY, false)
      end
   elseif mode == nwn.ACTION_MODE_POWER_ATTACK then
      if not cre:GetHasFeat(nwn.FEAT_POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_POWER_ATTACK then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_POWER_ATTACK, false)
      end
   elseif mode == nwn.ACTION_MODE_IMPROVED_POWER_ATTACK then
      if not cre:GetHasFeat(nwn.FEAT_IMPROVED_POWER_ATTACK) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_IMPROVED_POWER_ATTACK, false)
      end
   elseif mode == nwn.ACTION_MODE_COUNTERSPELL then
      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_COUNTERSPELL then
         cre:SetCombatMode(nwn.COMBAT_MODE_COUNTERSPELL, false)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_COUNTERSPELL, true)
      end
   elseif mode == nwn.ACTION_MODE_FLURRY_OF_BLOWS then
      if not cre:GetHasFeat(nwn.FEAT_FLURRY_OF_BLOWS) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_FLURRY_OF_BLOWS then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_FLURRY_OF_BLOWS, false)
      end
   elseif mode == nwn.ACTION_MODE_RAPID_SHOT then
      if not cre:GetHasFeat(nwn.FEAT_RAPID_SHOT) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_RAPID_SHOT then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_RAPID_SHOT, false)
      end
   elseif mode == nwn.ACTION_MODE_EXPERTISE then
      if not cre:GetHasFeat(nwn.FEAT_EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_EXPERTISE then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_EXPERTISE, false)
      end
   elseif mode == nwn.ACTION_MODE_IMPROVED_EXPERTISE then
      if not cre:GetHasFeat(nwn.FEAT_IMPROVED_EXPERTISE) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_IMPROVED_EXPERTISE then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_IMPROVED_EXPERTISE, true)
      end
   elseif mode == nwn.ACTION_MODE_DEFENSIVE_CAST then
      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_DEFENSIVE_CAST then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_DEFENSIVE_CAST, false)
      end
   elseif mode == nwn.ACTION_MODE_DIRTY_FIGHTING then
      if not cre:GetHasFeat(nwn.FEAT_DIRTY_FIGHTING) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_DIRTY_FIGHTING then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_DIRTY_FIGHTING, false)
      end
   elseif mode == nwn.ACTION_MODE_DEFENSIVE_STANCE then
      if not cre:GetHasFeat(nwn.FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE) then
         return false
      end

      if cre.obj.cre_mode_combat == nwn.COMBAT_MODE_DEFENSIVE_STANCE then
         cre:SetCombatMode(nwn.COMBAT_MODE_INVALID, true)
      else
         cre:SetCombatMode(nwn.COMBAT_MODE_DEFENSIVE_STANCE, false)
      end
   end

   cre:NotifyAssociateActionToggle(mode)
   return true
end

function nwn.GetCombatMode(mode)
   return MODES[mode]
end

function nwn.RegisterCombatMode(mode, f)
   MODES[mode] = f
end