local ffi = require 'ffi'
local C = ffi.C

function Creature:GetWeaponAttackBonus(weap)
   local feat = -1
   local ab = 0
   local base = weap:GetBaseType()
   local ewf = false

   -- Epic Weapon Focus
   feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_FOCUS_EPIC, base)
   if feat ~= -1 and self:GetHasFeat(feat) then
      ab = ab + 3
      ewf = true
   end
   
   -- Weapon Focus, included above if creature has EWF
   if not ewf then
      feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_FOCUS, base)
      if feat ~= -1 and self:GetHasFeat(feat) then
         ab = ab + 1
      end
   end

   -- WM Weapon of Choice
   local wm = self:GetLevelByClass(nwn.CLASS_TYPE_WEAPON_MASTER)
   if wm >= 5 then
      feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_WEAPON_OF_CHOICE, base)
      if feat ~= -1 and self:GetHasFeat(feat) then
         ab = ab + 1
      end
      if wm >= 13 then
         ab = ab + math.floor((wm - 10) / 3)
      end
   end

   -- Enchant Arrow
   if base == nwn.BASE_ITEM_LONGBOW or base == nwn.BASE_ITEM_SHORTBOW then
      feat = self:GetHighestFeatInRange(nwn.FEAT_PRESTIGE_ENCHANT_ARROW_6, nwn.FEAT_PRESTIGE_ENCHANT_ARROW_20)
      if feat ~= -1 and self:GetHasFeat(feat) then
         ab = ab + (feat - nwn.FEAT_PRESTIGE_ENCHANT_ARROW_6) + 6
      else
         feat = self:GetHighestFeatInRange(nwn.FEAT_PRESTIGE_ENCHANT_ARROW_1, nwn.FEAT_PRESTIGE_ENCHANT_ARROW_5)
         if feat ~= -1 and self:GetHasFeat(feat) then
            ab = ab + (feat - nwn.FEAT_PRESTIGE_ENCHANT_ARROW_1) + 1
         end
      end
   end

   return ab
end

function Creature:GetWeaponAttackAbility(weap)
   local abil
   if weap:GetIsRangedWeapon() then
      abil = nwn.ABILITY_DEXTERITY
   else
      abil = nwn.ABILITY_STRENGTH 
   end
   local mod = self:GetAbilityModifier(abil)

   for i = 0, 5 do
      local t = nwn.GetWeaponAttackAbilityModifier(self, weap, i)
      if t > mod then
         abil = i
         mod = t
      end
   end

   return abil
end

function Creature:GetWeaponDamageBonus(weap)
   local feat
   local bonus = 0
   
   feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_SPECIALIZATION_EPIC,
                            basetype)
   local epic = false
   if feat ~= -1 and self:GetHasFeat(feat) then
      bonus = bonus + 6
      epic = true
   end
   
   if not epic then
      feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_SPECIALIZATION,
                               basetype)
      if feat ~= -1 and self:GetHasFeat(feat) then
         bonus = bonus + 2
      end
   end

   return bonus
end
---
-- @return dice, sides
function Creature:GetWeaponBaseDamage(weap)
   if not weap:GetIsValid() then return 0, 0 end

   local dice, sides = 0, 0
   local basetype = weap:GetBaseType()

   -- In Solstice Monster Damage works on all weapons, if it exists
   -- it overwrites base damage dice.
   if C.nwn_HasPropertyType(weap.obj, nwn.ITEM_PROPERTY_MONSTER_DAMAGE) then
      local ip = C.nwn_GetPropertyByType(weap.obj, nwn.ITEM_PROPERTY_MONSTER_DAMAGE)
      dice, sides = 0, 0
   else
      local bi = C.nwn_GetBaseItem(basetype)
      dice = bi.bi_dmg_dice
      sides = bi.bi_dmg_sides
   end

   if weap:GetIsUnarmedWeapon() and
      self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
   then
      local udice, usides = 0, 0
      if (udice * usides) / 2 > (dice * sides) / 2 then
         dice, sides = udice, usides
      end
   end

   return dice, sides
end

function Creature:GetWeaponDamageAbility(weap)
   local abil = nwn.ABILITY_STRENGTH
   local mod = self:GetAbilityModifier(abil)

   nwn.GetWeaponDamageAbilityModifier(self, weap, ability)

   for i = 1, 5 do
      local t = nwn.GetWeaponDamageAbilityModifier(self, weap, i)
      if t > mod then
         abil = i
         mod = t
      end
   end
   return abil
end

function Creature:GetWeaponCritRange(weap)
   if not weap:GetIsValid() then return 0 end

   local basetype = weap:GetBaseType()
   local bi = C.nwn_GetBaseItem(basetype)
   local basecr = bi.bi_crit_range
   local cr = basecr

   -- Keen doubles crit range.  Applicable to creature weapons.
   if C.nwn_HasPropertyType(weap.obj, nwn.ITEM_PROPERTY_KEEN) then
      cr = cr + basecr
   end

   -- Improved Crit doubles crit range
   local feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_CRITICAL_IMPROVED,
                                  basetype)
   if feat ~= -1 and self:GetHasFeat(feat) then
      cr = cr + basecr
   end

   -- WM Ki Critical add +2.  Might be more efficient to calculate via level.
   if self:GetHasFeat(nwn.FEAT_KI_CRITICAL) then
      feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_WEAPON_OF_CHOICE,
                               basetype)
      if feat ~= -1 and self:GetHasFeat(feat) then
         cr = cr + 2
      end
   end

   return cr
end

function Creature:GetWeaponCritMultiplier(weap)
   if not weap:GetIsValid() then return 0 end

   local basetype = weap:GetBaseType()
   local bi = C.nwn_GetBaseItem(basetype)
   local basecm = bi.bi_crit_mult
   local feat

   -- WM Ki Critical add +2.  Might be more efficient to calculate via level.
   if self:GetHasFeat(nwn.FEAT_INCREASE_MULTIPLIER) then
      feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_WEAPON_OF_CHOICE,
                               basetype)
      if feat ~= -1 and self:GetHasFeat(feat) then
         basecm = basecm + 1
      end
   end

   return basecm
end

---
-- @return dice, sides
function Creature:GetWeaponCritDamage(weap)
   if not weap:GetIsValid() then return 0, 0 end

   local basetype = weap:GetBaseType()
   local dice, sides = 0, 0

   -- When using the weapon chosen, the character deals +1d6 points of damage
   -- on a successful critical hit. If the weapon's critical multiplier is
   -- x3, add +2d6 and if the multiplier is x4, add 3d6. 
   local feat = nwn.GetWeaponFeat(nwn.WEAPON_MASTERFEAT_CRITICAL_OVERWHELMING,
                                  basetype)

   if feat ~= -1 and self:GetHasFeat(feat) then
      local bi = C.nwn_GetBaseItem(basetype)
      local basecm = bi.bi_crit_mult

      if basecm == 4 then
         dice, sides = 1, 6
      elseif basecm == 3 then
         dice, sides = 2, 6
      else
         dice, sides = 3, 6
      end
   end
   return dice, sides
end

---
-- TODO: FIX!!!
function Creature:GetWeaponIteration(weap)
   local iter = 5
   
   if self:GetLevelByClass(nwn.CLASS_TYPE_MONK) > 0 
      and self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
      and (not weap:GetIsValid() or weap:GetIsUnarmedWeapon())
   then
      iter = 3
   end
      

   return iter
end