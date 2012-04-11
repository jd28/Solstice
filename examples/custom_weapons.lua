require 'nwn.weapons'

-- The value is the minimum creature size necessary to finesse weapon.
nwn.RegisterWeaponUsableWithFeat(nwn.FEAT_WEAPON_FINESSE, nwn.BASE_ITEM_RAPIER, 3)
nwn.RegisterWeaponUsableWithFeat(nwn.FEAT_WEAPON_FINESSE, nwn.BASE_ITEM_KATANA, 3)

-- Weapon Finesse
nwn.RegisterWeaponAttackAbility(
   nwn.ABILITY_DEXTERITY, 
   function (cre, weap, abil)
      if not cre:GetHasFeat(nwn.FEAT_WEAPON_FINESSE) or
         not cre:GetIsWeaponFinessable(weap)
      then
         return 0
      end
      return cre:GetAbilityModifier(abil)
   end)
