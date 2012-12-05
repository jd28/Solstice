-- This file contains functions relating to the combat info struct.

--- Creates debug string for combat info equips
function Creature:DebugCombatEquips()
   self:UpdateCombatInfo(nwn.COMBAT_UPDATE_EQUIP)
   local t = {}
   local fmt = sm([[Dmg Ability: %s : %d, Base Damage: %dd%d + %d, 
		    |Base Damage Type(s): %x, Base Damage Mask: %x
		    |Crit Range: %d, Crit Multiplier: %d, Crit Damage: %dd%d + %d\n]])
   
   for i = 0, 5 do
      table.insert(t, string.format(fmt,
				    self.ci.equips[i].id,
				    nwn.GetAbilityName(self.ci.equips[i].dmg_ability),
				    self:GetAbilityModifier(self.ci.equips[i].dmg_ability),
				    self.ci.equips[i].base_dmg.dice,
				    self.ci.equips[i].base_dmg.sides,
				    self.ci.equips[i].base_dmg.bonus,
				    self.ci.equips[i].base_type,
				    self.ci.equips[i].base_mask,
				    self.ci.equips[i].crit_range,
				    self.ci.equips[i].crit_mult,
				    self.ci.equips[i].crit_dmg.dice,
				    self.ci.equips[i].crit_dmg.sides,
				    self.ci.equips[i].crit_dmg.bonus))
   end

   return table.concat(t)
end




--- Updates equipped weapon object IDs.
function Creature:UpdateCombatEquips()
   self.ci.equips[0].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_RIGHTHAND).id
   self.ci.equips[1].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_LEFTHAND).id
   self.ci.equips[2].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_ARMS).id
   self.ci.equips[3].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_L).id
   self.ci.equips[4].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_R).id
   self.ci.equips[5].id = self:GetItemInSlot(nwn.INVENTORY_SLOT_CWEAPON_B).id
end

--- Updates a creature's combat modifiers.
-- See ConbatMod ctype.
-- @param update_flags
function Creature:UpdateCombatInfo(update_flags)
   update_flags = nwn.COMBAT_UPDATE_ALL

   self:UpdateDamageResistance()
   self:UpdateDamageReduction()

   --self.num_attacks_on = self:GetNumberOfAttacks()
   --self.num_attacks_off = self:GetNumberOfAttacks(true)
   
   if bit.band(nwn.COMBAT_UPDATE_EQUIP, update_flags) then
      self:UpdateCombatEquips()
      self:UpdateCombatWeaponInfo()
      self.ci.offhand_penalty_on,
      self.ci.offhand_penalty_off = self:GetOffhandAttackPenalty()
   end

   if bit.band(nwn.COMBAT_UPDATE_AREA, update_flags) then
      self:UpdateCombatModifierArea()
   end

   if bit.band(nwn.COMBAT_UPDATE_LEVELUP, update_flags) then
      self.ci.bab = self:GetBaseAttackBonus()
      self:UpdateCombatModifierClass()
      self:UpdateCombatModifierFeat()
   end

   if bit.band(nwn.COMBAT_UPDATE_SHIFT, update_flags) then
      self:UpdateCombatModifierRace()
      self:UpdateCombatModifierSize()
   end
   self:UpdateCombatModifierSkill()
end

--- Determines creature's area combat modifiers.
function Creature:UpdateCombatModifierArea()
   local mod = self.ci.area
   nwn.ZeroCombatMod(mod)
   local area = self:GetArea()
   local area_type = area.obj.area_type
   local ab = 0

   if bit.band(area_type, 4) and
      not bit.band(area_type, 2) and
      not bit.band(area_type, 1) and
      self:GetHasFeat(nwn.FEAT_NATURE_SENSE)
   then
      ab = 2
   end
   
   mod.ab = ab
   mod.hp = self:GetAreaHitPointAdj()
end

--- Determines creature's class combat modifiers.
function Creature:UpdateCombatModifierClass()
   nwn.ZeroCombatMod(self.ci.class)
   local ac = 0

   local monk = self:GetLevelByClass(nwn.CLASS_TYPE_MONK)
   if monk > 0 and
      self:CanUseClassAbilities(nwn.CLASS_TYPE_MONK)
   then
      ac = ac + self:GetAbilityModifier(nwn.ABILITY_WISDOM)
      ac = ac + (monk / 5)
   end

   self.ci.class.ac = ac

   self.ci.class.hp = self:GetClassHitPointAdj()
end

--- Determines creature's feat combat modifiers.
function Creature:UpdateCombatModifierFeat()
   local mod = self.ci.feat
   nwn.ZeroCombatMod(mod)
   local ab, ac = 0, 0

   if self:GetHasFeat(nwn.FEAT_EPIC_PROWESS) then
      ab = ab + 1
   end

   if self:GetHasFeat(nwn.FEAT_EPIC_ARMOR_SKIN) then
      ac = ac + 2
   end

   mod.ab = ab
   mod.ac = ac
   mod.hp = self:GetFeatHitPointAdj()
end

--- Determines creature's race combat modifiers.
function Creature:UpdateCombatModifierRace()
   local mod = self.ci.race
   nwn.ZeroCombatMod(mod)

   mod.hp = self:GetRaceHitPointAdj()
end

--- Determines creature's size combat modifiers.
function Creature:UpdateCombatModifierSize()
   local mod = self.ci.size
   nwn.ZeroCombatMod(mod)
   local size = self:GetSize()
   local ac, ab = 0, 0

   if size == nwn.CREATURE_SIZE_TINY then
      ac, ab = 2, 2
   elseif size == nwn.CREATURE_SIZE_SMALL then
      ac, ab = 1, 1
   elseif size == nwn.CREATURE_SIZE_LARGE then
      ac, ab = -1, -1
   elseif size == nwn.CREATURE_SIZE_HUGE then
      ac, ab = -2, -2
   end
   
   mod.ab = ab
   mod.ac = ac
   mod.hp = self:GetSizeHitPointAdj()
end

--- Determines creature's skill combat modifiers.
function Creature:UpdateCombatModifierSkill()
   nwn.ZeroCombatMod(self.ci.skill)

   local ac = 0
   ac = ac + self:GetSkillRank(nwn.SKILL_TUMBLE, nwn.OBJECT_INVALID, true) / 5
   self.ci.skill.ac = ac

   self.ci.skill.hp = self:GetSkillHitPointAdj()
end


--- Determines creature's weapon combat info.
function Creature:UpdateCombatWeaponInfo()
   local weap
   for i = 0, 5 do
      weap = _NL_GET_CACHED_OBJECT(self.ci.equips[i].id)
      if weap:GetIsValid() then
         self.ci.equips[i].ab_mod = self:GetWeaponAttackBonus(weap)
         self.ci.equips[i].ab_ability = self:GetWeaponAttackAbility(weap)
         self.ci.equips[i].dmg_ability = self:GetWeaponDamageAbility(weap)

         self.ci.equips[i].iter = self:GetWeaponIteration(weap)

	 self.ci.equips[i].base_type = nwn.GetWeaponBaseDamageType(weap:GetBaseType())

	 local extra_type
	 if weap:GetIsRangedWeapon() then
	    extra_type = nwn.ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE
	 else
	    extra_type = nwn.ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE
	 end

	 for ip in weap:ItemProperties() do
	    if ip:GetPropertyType() == extra_type then
	       self.ci.equips[i].base_type = bit.bor(self.ci.equips[i].base_type,
						     nwn.GetDamageFlagFromIPConst(ip:GetSubType()))
	    end
	 end

         self.ci.equips[i].base_dmg.dice,
         self.ci.equips[i].base_dmg.sides = self:GetWeaponBaseDamage(weap)
         self.ci.equips[i].base_dmg.bonus = self:GetWeaponDamageBonus(weap)

         self.ci.equips[i].crit_range = self:GetWeaponCritRange(weap)
         self.ci.equips[i].crit_mult = self:GetWeaponCritMultiplier(weap)
         self.ci.equips[i].crit_dmg.dice,
         self.ci.equips[i].crit_dmg.sides = self:GetWeaponCritDamage(weap)
      else
         self.ci.equips[i].ab_mod = 0
         self.ci.equips[i].ab_ability = 0
         self.ci.equips[i].dmg_ability = 0
         self.ci.equips[i].base_dmg.dice = 0
         self.ci.equips[i].base_dmg.sides = 0
         self.ci.equips[i].base_dmg.bonus = 0
	 self.ci.equips[i].base_type = 0
	 self.ci.equips[i].base_mask = 0
         self.ci.equips[i].crit_range = 0
         self.ci.equips[i].crit_mult = 0
         self.ci.equips[i].crit_dmg.dice = 0
         self.ci.equips[i].crit_dmg.sides = 0
         self.ci.equips[i].crit_dmg.bonus = 0
      end
   end
end
