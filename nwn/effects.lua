--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

require 'nwn.ctypes.effect'
local ffi = require 'ffi'
local C = ffi.C

ffi.cdef [[
typedef struct Effect {
    CGameEffect     *eff;
    bool            direct;
} Effect;
]]

local nie = require 'nwn.internal.effects'

local effect_mt = { __index = Effect,
                    __gc = function(eff) 
                       if not eff.direct then
                          C.free(eff)
                       end
                    end
}
effect_t = ffi.metatype("Effect", effect_mt)

local function CreateEffect(command, args)
    nwn.engine.ExecuteCommand(command, args)
    return nwn.engine.StackPopEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT)
end

local function FakeEffect(eff_type)
   local eff = nwn.EffectVisualEffect(0)
   eff:SetTrueType(eff_type)
   return eff
end

--- Returns effect's creator.
function Effect:GetCreator()
    return _NL_GET_CACHED_OBJECT(self.eff.eff_creator)
end

--- Returns a Custom Effect Type
function Effect:GetCustomType()
   if self:GetTrueType() ~= nwn.EFFECT_TRUETYPE_MODIFYNUMATTACKS then
      return -1
   end
   return self:GetInt(0)
end

--- Gets the duration of an effect.
-- Returns the duration specified when applied for
-- the effect. The value of this is undefined for effects which are
-- not of DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function Effect:GetDuration ()
   return self.eff.eff_duration
end

--- Gets the remaing duration of an effect
-- Returns the remaining duration of the specified effect. The value
-- of this is undefined for effects which are not of
-- DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function Effect:GetDurationRemaining ()
   local current = ffi.C.nwn_GetWorldTime(nil, nil)
   local expire = self.eff.eff_expire_time
   expire = (expire * 2880000LL) + self.eff.eff_expire_time
   return expire - current / 1000.0
end 

--- Gets the specifed effects Id
function Effect:GetId()
   return self.eff.eff_id
end

--- Determines whether an effect is valid.
function Effect:GetIsValid()
    nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, self)
    nwn.engine.ExecuteCommand(88, 1)
    return nwn.engine.StackPopBoolean()
end

--- Returns the internal effect integer at the index specified.
-- @param index The index is limited to being between 0 and 15, and which index contains what
-- value depends entirely on the type of effect.  Source: nwnx_structs by Acaos
function Effect:GetInt(index)
   if index < 0 or index > self.eff.eff_num_integers then
      return -1
   end
   return self.eff.eff_integers[index]
end

--- Gets Spell Id associated with effect
function Effect:GetSpellId()
   return self.eff.eff_spellid
end


--- Get the subtype of the effect.
-- @return SUBTYPE_*
function Effect:GetSubType()
   return self.eff.eff_dursubtype
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:GetTrueType()
   return self.eff.eff_type
end

--- Sets the effects creator
-- @param object 
function Effect:SetCreator(object)
    self.eff.eff_creator = object.id
end

--- Sets the internal effect integer at the specified index to the
-- value specified. Source: nwnx_structs by Acaos
function Effect:SetInt(index, value)
   if index < 0 or index > self.eff.eff_num_integers then
      return -1
   end
   self.eff.eff_integers[index] = value
   return self.eff.eff_integers[index]
end

---
function Effect:SetNumIntegers(num)
   C.nwn_EffectSetNumIntegers(self.eff, num)
end

--- Sets the effect's spell id as specified, which will later be returned
-- with Effect:GetSpellId(). Source: nwnx_structs by Acaos
function Effect:SetSpellId (spellid)
   self.eff.eff_spellid = spellid
end

---
function Effect:SetString(index, str)
   if index < 0 or index > 5 then
      error "Effect:SetString must be between 0 and 5"
      return
   end
   self.eff.eff_strings[index].text = C.strdup(str)
   self.eff.eff_strings[index].len = #str
end

--- Set the subtype of the effect.
-- @param value SUBTYPE_*
function Effect:SetSubType(value)
   self.eff.eff_dursubtype = value
   return self.eff.eff_dursubtype
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function Effect:SetTrueType(value)
   self.eff.eff_type = value
   return self.eff.eff_type
end

--[[
function Effect:SetVersusAlignment(lawchaos, goodevil)
   lawchaos = lawchaos or nwn.ALIGNMENT_ALL
   goodevil = goodevil or nwn.ALIGNMENT_ALL
   --self.eff.
end

function Effect:SetVersusRace(race)

end

function Effect:SetVersusTrap()

end

static int NWScript_VersusAlignmentEffect(lua_State *L)
{
	void *eEffect = luaL_checklightnwndata(L, 1, EFFECT)
	int nLawChaos = luaL_optint(L, 2, ALIGNMENT_ALL)
	int nGoodEvil = luaL_optint(L, 3, ALIGNMENT_ALL)
	
	StackPushInteger(nGoodEvil)
	StackPushInteger(nLawChaos)
	StackPushEngineStructure(ENGINE_STRUCTURE_EFFECT, eEffect)
	VM_ExecuteCommand(355, 3)
	void *pRetVal
	StackPopEngineStructure(ENGINE_STRUCTURE_EFFECT, &pRetVal)
	lua_pushlightuserdata(L, pRetVal)
  return 1
}

static int NWScript_VersusRacialTypeEffect(lua_State *L)
{
	void *eEffect = luaL_checklightnwndata(L, 1, EFFECT)
	int nRacialType = luaL_checkint(L, 2)
  
	StackPushInteger(nRacialType)
	StackPushEngineStructure(ENGINE_STRUCTURE_EFFECT, eEffect)
	VM_ExecuteCommand(356, 2)
	void *pRetVal
	StackPopEngineStructure(ENGINE_STRUCTURE_EFFECT, &pRetVal)
	lua_pushlightuserdata(L, pRetVal)
  return 1
}

static int NWScript_VersusTrapEffect(lua_State *L)
{
	void *eEffect = luaL_checklightnwndata(L, 1, EFFECT)
  
	StackPushEngineStructure(ENGINE_STRUCTURE_EFFECT, eEffect)
	VM_ExecuteCommand(357, 1)
	void *pRetVal
	StackPopEngineStructure(ENGINE_STRUCTURE_EFFECT, &pRetVal)
	lua_pushlightuserdata(L, pRetVal)
  return 1
}
   --]]

----------------------------------------------------------------------

--- Creates a Custom Effect
-- @param eff_type Effect Type.  This value is returned by Effect:GetCustomType()
--    see nwn.EFFECT_CUSTOM_* to see which constants are already in use.
-- @param ints A list of integers to store on the effect.
function nwn.EffectCustom(eff_type, ints)
   local eff = nwn.EffectVisualEffect(eff_type)
   eff:SetTrueType(nwn.EFFECT_TRUETYPE_MODIFYNUMATTACKS)
   if ints then
      for i, int in ipairs(ints) do
         eff:SetInt(i, int)
      end
   end
   return eff
end

--- Creates a Recurring Effect
-- This effect when applied is merely a place holder.
function nwn.EffectRecurring()
   return nwn.EffectCustom(nwn.EFFECT_CUSTOM_RECURRING_EFFECT)
end

--- Creates an ability increase/decrease effect on specified ability score.
-- @param ability nwn.ABILITY_*
-- @param amount If < 0 effect will cause a decrease by amount, it will be
--    and increase if > 0
function nwn.EffectAbility(ability, amount)
   cmd = 80
   
   if amount < 0 then
      cmd = 446
      amount = -amount
   end	

   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(ability)

   return CreateEffect(cmd, 2)
end

--- Creates an AC increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
--    and increase if > 0
-- @param modifier_type AC_* (Default: nwn.AC_DODGE_BONUS)
-- @param damage_type nwn.DAMAGE_TYPE_* (Default: nwn.AC_VS_DAMAGE_TYPE_ALL) 
function nwn.EffectAC(amount, modifier_type, damage_type)
   cmd = 115
   modifier_type = nwn.AC_DODGE_BONUS
   damage_type = nwn.AC_VS_DAMAGE_TYPE_ALL

   if amount < 0 then
      cmd = 450
      amount = -amount
   end	

   nwn.engine.StackPushInteger(damage_type)
   nwn.engine.StackPushInteger(modifier_type)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(cmd, 3)
end

--- Create a special effect to make the object "fly in".
-- @param animation
function nwn.EffectAppear(animation)
   animation = animation and 1 or 0

   nwn.engine.StackPushInteger(animation)
   return CreateEffect(482, 1)
end

--- Returns a new effect object.
-- @param aoe The ID of the Area of Effect
-- @param enter The script to use when a creature enters the radius of the Area of Effect. (Default: "") 
-- @param heartbeat The script to run on each of the Area of Effect's Heartbeats. (Default: "") 
-- @param exit The script to run when a creature leaves the radius of an Area of Effect. (Default: "") 
function nwn.EffectAreaOfEffect(aoe, enter, heartbeat, exit)
   enter = enter or ""
   heartbeat = heartbeat or ""
   exit = heartbeat or ""
   
   nwn.engine.StackPushString(exit)
   nwn.engine.StackPushString(heartbeat)
   nwn.engine.StackPushString(enter)
   nwn.engine.StackPushInteger(aoe)

   return CreateEffect(171, 4)
end   

--- Create an Attack increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
--    and increase if > 0
-- @param modifier_type nwn.ATTACK_BONUS_* (Default: nwn.ATTACK_BONUS_MISC) 
function nwn.EffectAttackBonus(amount, modifier_type)
   cmd = 118
   modifier_type = modifier_type or nwn.ATTACK_BONUS_MISC
   
   if amount < 0 then
      amount = -amount
      cmd = 447
   end

   nwn.engine.StackPushInteger(modifier_type)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(cmd, 2)
end

--- Create a Beam effect.
-- @param beam nwn.VFX_BEAM_* Constant defining the visual type of beam to use.
-- @param creator The beam is emitted from this creature
-- @param bodypart nwn.BODY_NODE_* Constant defining where on the creature the beam originates from.
-- @param miss_effect If this is TRUE, the beam will fire to a random vector near or past the target (Default: false) 
function nwn.EffectBeam(beam, creator, bodypart, miss_effect)
   nwn.engine.StackPushBoolean(miss_effect)
   nwn.engine.StackPushInteger(bodypart)
   nwn.engine.StackPushObject(creator)
   nwn.engine.StackPushInteger(beam)

   return CreateEffect(207, 4)
end

--- Create a Blindness effect.
function nwn.EffectBlindness()
   return CreateEffect(468, 0)
end

--- Creates a bonus feat effect.
function nwn.EffectBonusFeat (feat)
   local eff = FakeEffect(nwn.EFFECT_TRUETYPE_BONUS_FEAT)
   eff:SetInt(0, feat)
   return eff
end

--- Create a Charm effect
function nwn.EffectCharmed()
   return CreateEffect(156, 0)
end

---
-- @param damages An array containing the damages to be applied
--    in order of index.
-- @param unblockable (Default: false)
function nwn.EffectCombatDamage(dmg_power, damages, unblockable)
   local eff = nwn.EffectCustom(nwn.EFFECT_CUSTOM_COMBAT_DAMAGE)
   local num_dmgs = table.maxn(damages)

   eff:SetInt(1, dmg_power)
   eff:SetInt(2, unblockable)
   eff:SetNumIntegers(num_dmgs + 3)
   
   for i = 1, num_dmgs do
      eff:SetInt(i+2, damages[i] or 0)
   end

   return eff
end

--- Creates a concealment effect.
-- @param percent 1-100 inclusive
-- @param
-- TODO... this is wrong
function nwn.EffectConcealment(percent, miss_type)
   miss_type = miss_type or nwn.MISS_CHANCE_TYPE_NORMAL
   
   nwn.engine.StackPushInteger(miss_type)
   nwn.engine.StackPushInteger(percent)

   return CreateEffect(458, 2)
end

--- Creates a confusion effect.
function nwn.EffectConfused()
   return CreateEffect(157, 0)
end

--- Create a Curse effect.
-- @param str strength modifier (Default: 1) 
-- @param dex dexterity modifier (Default: 1) 
-- @param con constitution modifier (Default: 1) 
-- @param int intelligence modifier (Default: 1) 
-- @param wis wisdom modifier (Default: 1) 
-- @param cha charisma modifier (Default: 1) 
function nwn.EffectCurse(str, dex, con, int, wis, cha)
   str = str or 1
   dex = dex or 1
   con = con or 1
   int = int or 1
   wis = wis or 1
   cha = cha or 1

   nwn.engine.StackPushInteger(cha)
   nwn.engine.StackPushInteger(wis)
   nwn.engine.StackPushInteger(int)
   nwn.engine.StackPushInteger(con)
   nwn.engine.StackPushInteger(dex)
   nwn.engine.StackPushInteger(str)

   return CreateEffect(138, 6)
end

--- Creates an effect that is guranteed to dominate a creature.
function nwn.EffectCutsceneDominated()
   return CreateEffect(604, 0)
end

---
-- @param
-- @param
function nwn.EffectCutsceneGhost()
   return CreateEffect(757, 0)
end

--- Creates a cutscene ghost effect
function nwn.EffectCutsceneImmobilize()
   return CreateEffect(767, 0)
end

--- Creates an effect that will paralyze a creature for use in a cut-scene.
function nwn.EffectCutsceneParalyze()
   return CreateEffect(585, 0)
end

--- Creates Damate effect.
-- @param amount amount of damage to be dealt. This should be applied as an instantaneous effect.
-- @param damage_type DAMAGE_TYPE_* (Default: nwn.DAMAGE_TYPE_MAGICAL) 
-- @param power (Default: nwn.DAMAGE_POWER_NORMAL) 
function nwn.EffectDamage(amount, damage_type, power)
   damage_type = damage_type or nwn.DAMAGE_TYPE_MAGICAL
   power = power or nwn.DAMAGE_POWER_NORMAL

   nwn.engine.StackPushInteger(power)
   nwn.engine.StackPushInteger(damage_type)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(79, 3)
end

---
-- @param
-- @param damage_type DAMAGE_TYPE_* (Default: nwn.DAMAGE_TYPE_MAGICAL) 
function nwn.EffectDamageBonus(amount, damage_type)
   cmd = 120
   damage_type = damage_type or nwn.DAMAGE_TYPE_MAGICAL

   if amount < 0 then
      amount = -amount
      cmd = 448
   end

   nwn.engine.StackPushInteger(damage_type)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(cmd, 2)
end

---
-- @param damage_type DAMAGE_TYPE_*
-- @param
function nwn.EffectDamageImmunity(damage_type, percent)
   cmd = 275
   
   if percent < 0 then
      percent = -percent
      cmd = 449
   end

   nwn.engine.StackPushInteger(percent)
   nwn.engine.StackPushInteger(damage_type)

   return CreateEffect(cmd, 2)
end

---
-- @param
-- @param
function nwn.EffectDamageReduction(amount, power, limit)
   limit = limit or 0
   nwn.engine.StackPushInteger(limit)
   nwn.engine.StackPushInteger(power)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(119, 3)
end

---
-- @param damage_type DAMAGE_TYPE_* (Default: nwn.DAMAGE_TYPE_MAGICAL) 
-- @param
-- @param
function nwn.EffectDamageResistance(damage_type, amount, limit)
   limit = limit or 0

   nwn.engine.StackPushInteger(limit)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(damage_type)

   return CreateEffect(81, 3)
end

---
-- @param
-- @param
-- @param damage_type DAMAGE_TYPE_* (Default: nwn.DAMAGE_TYPE_MAGICAL) 
function nwn.EffectDamageShield(amount, random, damage_type)
   nwn.engine.StackPushInteger(damage_type)
   nwn.engine.StackPushInteger(random)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(487, 3)
end

--- Create a Darkness effect. 
function nwn.EffectDarkness()
   return CreateEffect(459, 0)
end

--- Create a Daze effect. 
function nwn.EffectDazed()
   return CreateEffect(160, 0)
end

--- Create a Deaf effect. 
function nwn.EffectDeaf()
   return CreateEffect(150, 0)
end

---
-- @param
-- @param
function nwn.EffectDeath(specatular, feedback)
   nwn.engine.StackPushBoolean(feedback)
   nwn.engine.StackPushBoolean(spectacular)

   return CreateEffect(133, 2)
end

---
-- @param
-- @param
function nwn.EffectDisappear(animation)
   animation = animation and 1 or 0
   
   nwn.engine.StackPushInteger(nAnimation)

   return CreateEffect(481, 1)
end

---
-- @param
-- @param
function nwn.EffectDisappearAppear(location, animation)
   animation = animation and 1 or 0
   
   nwn.engine.StackPushInteger(animation)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_LOCATION, location)

   return CreateEffect(480, 2)
end

--- Create a Disease effect.
-- @param disease The type of disease this effect should apply, chosen from nwn.DISEASE_*constant group.
function nwn.EffectDisease(disease)
   nwn.engine.StackPushInteger(disease)

   return CreateEffect(251, 1)
end

--- Create a Dispel Magic All effect.
-- @param caster_level The highest level spell to dispel.
function nwn.EffectDispelMagicAll(caster_level)
   caster_level = caster_level or nwn.USE_CREATURE_LEVEL

   nwn.engine.StackPushInteger(caster_level)

   return CreateEffect(460, 1)
end

--- Create a Dispel Magic Best effect.
-- @param caster_level The highest level spell to dispel.
function nwn.EffectDispelMagicBest(caster_level)
   caster_level = caster_level or nwn.USE_CREATURE_LEVEL

   nwn.engine.StackPushInteger(caster_level)

   return CreateEffect(473, 1)
end

--- Create a Dominate effect. 
function nwn.EffectDominated()
   return CreateEffect(159, 0)
end

--- Create an Entangle effect
function nwn.EffectEntangle()
   return CreateEffect(130, 0)
end

--- Creates a Sanctuary effect but the observers get no saving throw.
function nwn.EffectEthereal()
   return CreateEffect(711, 0)
end

--- Create a frightened effect for use in making creatures shaken or flee.
function nwn.EffectFrightened()
   return CreateEffect(158, 0)
end

--- Create a Haste effect. 
function nwn.EffectHaste()
   return CreateEffect(270, 0)
end

--- Creates a healing effect.
-- @param amount Hit points to heal.
function nwn.EffectHeal(amount)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(78, 1)
end

--- Create a Hit Point Change When Dying effect. 
-- @param hitpoint_change Positive or negative, but not zero.
function nwn.EffectHitPointChangeWhenDying(hitpoint_change)
   nwn.engine.StackPushFloat(hitpoint_change)

   return CreateEffect(387, 1)
end

--- Creates an icon effect
-- Source: nwnx_structs
function nwn.EffectIcon(icon)
   local eff = FakeEffect(nwn.EFFECT_TRUETYPE_ICON)
   eff:SetInt(0, icon)
   return eff
end

--- Create an Immunity effect.
-- @param immunity One of the nwn.IMMUNITY_TYPE_* constants.
function nwn.EffectImmunity(immunity, percent)
   percent = percent or 100
   nwn.engine.StackPushInteger(immunity)
   local eff = CreateEffect(273, 1)
   eff:SetInt(1, percent)

   return eff
end

--- Create an Invisibility effect.
-- @param invisibilty_type One of the nwn.INVISIBILITY_TYPE_*
--    constants defining the type of invisibility to use.
function nwn.EffectInvisibility(invisibilty_type)
   nwn.engine.StackPushInteger(invisibilty_type)

   return CreateEffect(457, 1)
end

--- Create a Knockdown effect
function nwn.EffectKnockdown()
   return CreateEffect(134, 0)
end

--- Creates one new effect object from two seperate effect objects.
-- @param child One of the two effects to link together.
-- @param parent One of the two effects to link together.
function nwn.EffectLinkEffects(child, parent)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, parent)
   nwn.engine.StackPushEngineStructure(nwn.ENGINE_STRUCTURE_EFFECT, child)

   return CreateEffect(199, 2)
end

--- Creates a miss chance effect.
-- @param percent 1-100 inclusive
-- @param misstype nwn.MISS_CHANCE_TYPE_* (Default: nwn.MISS_CHANCE_TYPE_NORMAL) 
function nwn.EffectMissChance(percent, misstype)
   misstype = misstype or nwn.MISS_CHANCE_TYPE_NORMAL

   nwn.engine.StackPushInteger(misstype)
   nwn.engine.StackPushInteger(percent)

   return CreateEffect(477, 2)
end

--- Create a Modify Attacks effect that adds attacks to the target.
-- @param attacks Maximum is 5, even with the effect stacked
function nwn.EffectModifyAttacks(attacks)
   nwn.engine.StackPushInteger(attacks)

   return CreateEffect(485, 1)
end

--- Create a Movement Speed Increase/Decrease effect to slow target.
-- @param percent_change If < 0 effect will cause a decrease by amount, it will be
--    and increase if > 0
function nwn.EffectMovementSpeed(percent_change)
   cmd = 165
   if(percent_change < 0) then
      cmd = 451
      percent_change = -percent_change
   end
   
   nwn.engine.StackPushInteger(percent_change)

   return CreateEffect(cmd, 1)
end

--- Create a Negative Level effect that will decrease the level of the target.
-- @param amount Number of levels
-- @param hp_bonus
function nwn.EffectNegativeLevel(amount, hp_bonus)
   nwn.engine.StackPushBoolean(hp_bonus)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(462, 2)
end
 
--- Create a Paralyze effect. 
function nwn.EffectParalyze()
   return CreateEffect(148, 0)
end

--- Creates an effect that will petrify a creature.
function nwn.EffectPetrify()
   return CreateEffect(583, 0)
end

--- Create a Poison effect.
-- @param poison The type of poison to use, as defined in the nwn.POISON_* constant group.
function nwn.EffectPoison(poison)
   nwn.engine.StackPushInteger(poison)

   return CreateEffect(250, 1)
end

--- Create a Polymorph effect that changes the target into a different type of creature.
-- @param polymorph nwn.POLYMORPH_TYPE_*
-- @param locked If true, player can't cancel polymorph (Default: false) 
function nwn.EffectPolymorph(polymorph, locked)
   nwn.engine.StackPushBoolean(locked)
   nwn.engine.StackPushInteger(polymorph)

   return CreateEffect(463, 2)
end

--- Create a Regenerate effect.
-- @param amount Amount of damage to be regenerated per time interval
-- @param interval Length of interval in seconds
function nwn.EffectRegenerate(amount, interval)
   nwn.engine.StackPushFloat(interval)
   nwn.engine.StackPushInteger(amount)

   return CreateEffect(164, 2)
end

--- Create a Resurrection effect. 
function nwn.EffectResurrection()
   return CreateEffect(82, 0)
end

--- Creates a sanctuary effect.
-- @param dc Must be a non-zero, positive number.
function nwn.EffectSanctuary(dc)
   nwn.engine.StackPushInteger(dc)

   return CreateEffect(464, 1)
end

--- Create a Saving Throw Increase/Decrease effect to modify  one Saving Throw type.
-- @param save The Saving Throw to affect, as defined by the nwn.SAVING_THROW_* constants group.
-- @param amount The amount to modify the saving throws by.  If > 0 an increase, if < 0 a decrease.
-- @param save_tpe The type of resistance this effect applies to as
--     defined by the nwn.SAVING_THROW_TYPE_* constants group. (Default: nwn.SAVING_THROW_TYPE_ALL) 
function nwn.EffectSavingThrow(save, amount, save_type)
   cmd = 117
   save_type = save_type or nwn.SAVING_TYROW_TYPE_ALL

   if amount < 0 then
      cmd = 452
      amount = -amount
   end

   nwn.engine.StackPushInteger(nSaveType)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(save)

   return CreateEffect(cmd, 3)
end

--- Create a See Invisible effect. 
function nwn.EffectSeeInvisible()
   return CreateEffect(466, 0)
end

--- Create a Silence effect
function nwn.EffectSilence()
   return CreateEffect(252, 0)
end

--- Returns an effect to decrease a skill.
-- @param skill nwn.SKILL_*
-- @param amount The amount to modify the skill by.  If > 0 an increase, if < 0 a decrease.
function nwn.EffectSkill(skill, amount)
   cmd = 351

   if amount < 0 then
      cmd = 453 
      amount = -amount
   end
   
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushInteger(skill)

   return CreateEffect(cmd, 2)
end

--- Creates a sleep effect.
function nwn.EffectSleep()
   return CreateEffect(154, 0)
end

--- Creates a slow effect.
function nwn.EffectSlow()
   return CreateEffect(271, 0)
end

--- Creates an effect that inhibits spells.
-- @param percent Percent chance of spell failing (1 to 100). (Default: 100) 
-- @param spell_school Spell school that is affected (nwn.SPELL_SCHOOL_*).
--    (Default: nwn.SPELL_SCHOOL_GENERAL) 
function nwn.EffectSpellFailure(percent, spell_scool)
   percent = percent or 100
   spell_school = spell_school or nwn.SPELL_SCHOOL_GENERAL
   
   nwn.engine.StackPushInteger(spell_school)
   nwn.engine.StackPushInteger(percent)

   return CreateEffect(690, 2)
end

--- Returns an effect of spell immunity.
-- @param spell nwn.SPELL_* (Default: nwn.SPELL_ALL_SPELLS) 
function nwn.EffectSpellImmunity(spell)
   spell = spell or nwn.SPELL_ALL_SPELLS

   nwn.engine.StackPushInteger(spell)

   return CreateEffect(149, 1)
end

--- Creates a Spell Level Absorption effect
-- @param max_level Highest spell level that can be absorbed.
-- @param max_spells Maximum number of spells to absorb
-- @param school nwn.SPELL_SCHOOL_* (Default: nwn.SPELL_SCHOOL_GENERAL)
function nwn.EffectSpellLevelAbsorption(max_level, max_spells, school)
   max_spells = max_spells or 0
   school = school or nwn.SPELL_SCHOOL_GENERAL
   
   nwn.engine.StackPushInteger(school)
   nwn.engine.StackPushInteger(max_spells)
   nwn.engine.StackPushInteger(max_level)

   return CreateEffect(472, 3)
end

--- Modify Creature Spell Resistance
-- @param value If > 0 an increase, if < 0 a decrease
function nwn.EffectSpellResistance(value)
   cmd = 212

   if(value < 0) then
      cmd = 454
      value = -value
   end

   nwn.engine.StackPushInteger(value)
   return CreateEffect(cmd, 1)
end

--- Creates a Stunned effect.
function nwn.EffectStunned()
   return CreateEffect(161, 0)
end

---
-- @param resref Identifies the creature to be summoned by resref name.
--    Not case sensitive.
-- @param vfx nwn.VFX_* (Default: nwn.VFX_NONE) 
-- @param delay There can be delay between the visual effect being played,
--    and the creature being added to the area. (Default: 0.0f) 
-- @param appear
function nwn.EffectSummonCreature(resref, vfx, delay, appear)
   vfx = vfx or nwn.VFX_NONE
   delay = delay or 0.0
   appear = appear or 0

   nwn.engine.StackPushInteger(appear)
   nwn.engine.StackPushFloat(delay)
   nwn.engine.StackPushInteger(vfx)
   nwn.engine.StackPushString(resref)

   return CreateEffect(83, 4)
end

---
-- @param looping If this is TRUE, for the duration of the effect when one
--    creature created by this effect dies, the next one in the list will
--    be created. If the last creature in the list dies, we loop back to the
--    beginning and sCreatureTemplate1 will be created, and so on...
-- @param resref1 Blueprint of first creature to spawn
-- @param resref2 Optional blueprint for second creature to spawn (Default: "") 
-- @param resref3 Optional blueprint for third creature to spawn (Default: "") 
-- @param resref4 Optional blueprint for fourth creature to spawn (Default: "") 
function nwn.EffectSwarm(looping, resref1, resref2, resref3, resref4)
   resref2 = resref2 or ""
   resref3 = resref3 or ""
   resref4 = resref4 or ""

   nwn.engine.StackPushString(resref4)
   nwn.engine.StackPushString(resref3)
   nwn.engine.StackPushString(resref2)
   nwn.engine.StackPushString(resref1)
   nwn.engine.StackPushInteger(looping)

   return CreateEffect(510, 5)
end

--- Create a Temporary Hitpoints effect that raises the Hitpoints of the target.
-- @param hitpoints A positive integer
function nwn.EffectTemporaryHitpoints(hitpoints)
   nwn.engine.StackPushInteger(hitpoints)

   return CreateEffect(314, 1)
end

--- Create a Time Stop effect. 
function nwn.EffectTimeStop()
   return CreateEffect(467, 0)
end

--- Creats a True Seeing effect.
function nwn.EffectTrueSeeing()
   return CreateEffect(465, 0)
end

--- Create a Turned effect. 
function nwn.EffectTurned()
   return CreateEffect(379, 0)
end

--- Create a Turn Resistance Increase/Decrease effect that can make creatures more susceptible to turning.
-- @param hitdice If > 0 an increase, if < 0 a decrease.
function nwn.EffectTurnResistance(hitdice)
   cmd = 553

   if(hitdice < 0) then
      cmd = 552
      hitdice = -hitdice
   end

   nwn.engine.StackPushInteger(hitdice)
   return CreateEffect(cmd, 1)
end

--- Creates an Ultravision effect
function nwn.EffectUltravision()
   return CreateEffect(461, 0)
end

--- Creates a new visual effect
-- @param The visual effect to be applied
-- @param if this is true, a random vector near or past the
--     target will be generated, on which to play the effect (Default: false) 
function nwn.EffectVisualEffect(id, miss)
   nwn.engine.StackPushBoolean(miss)
   nwn.engine.StackPushInteger(id)

   return CreateEffect(180, 2)
end

--- Creates a wounding effect
-- @param amount Amount of damage to do each round
function nwn.EffectWounding (amount)
   local eff = FakeEffect(nwn.EFFECT_TRUETYPE_WOUNDING)
   eff:SetInt(0, amount)
   return eff
end

