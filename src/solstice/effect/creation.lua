--- Effects module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module effect

local NWE = require 'solstice.nwn.engine'
local M = require 'solstice.effect.init'

--- Effect Creation
-- @section

--- Create raw effect.
-- It's initial type will be EFFECT_TYPE_INVALID
-- @param ints Number of effect integers.
-- @bool show_icon Sets whether an icon is shown... maybe?
function M.Create(ints, show_icon)
   ints = ints or 10
   show_icon = show_icon or 0
   local eff = effect_t(C.nwn_CreateEffect(show_icon), false)

   eff:SetType(EFFECT_TYPE_INVALID)
   eff:SetCreator(NWE.GetCommandObject())
   eff:SetNumIntegers(ints)
   eff:SetAllInts(0)
   eff:SetSubType(SUBTYPE_MAGICAL)
   eff:SetDurationType(DURATION_TYPE_PERMANENT)

   return eff
end

--- Creates a Recurring Effect
-- This effect when applied is merely a place holder.
function M.Recurring()
   error "????"
end

--- Creates an ability increase/decrease effect on specified ability score.
-- @param ability ABILITY_*
-- @param amount If < 0 effect will cause a decrease by amount, it will be
-- and increase if > 0
function M.Ability(ability, amount)
   return M.effect_t(C.effect_ability(ability, amount), false)
end

--- Creates an AC increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
-- and increase if > 0
-- @param[opt=AC_DODGE_BONUS] modifier_type AC_*
-- @param[opt=AC_VS_DAMAGE_TYPE_ALL] damage_type DAMAGE\_TYPE\_*
function M.AC(amount, modifier_type, damage_type)
   modifier_type = AC_DODGE_BONUS
   damage_type = AC_VS_DAMAGE_TYPE_ALL

   return M.effect_t(C.effect_ac(amount, modifier_type, damage_type), false)
end

--- Create a special effect to make the object "fly in".
-- @param animation Use animation
function M.Appear(animation)
   return M.effect_t(C.effect_appear(animation), false)
end

--- Returns a new effect object.
-- @param aoe The ID of the Area of Effect
-- @param[opt=""] enter The script to use when a creature enters the radius of the Area of Effect.
-- @param[opt=""] heartbeat The script to run on each of the Area of Effect's Heartbeats.
-- @param[opt=""] exit The script to run when a creature leaves the radius of an Area of Effect.
function M.AreaOfEffect(aoe, enter, heartbeat, exit)
   enter = enter or ""
   heartbeat = heartbeat or ""
   exit = heartbeat or ""

   return M.effect_t(C.effect_aoe(aoe, enter, heartbeat, exit), false)
end

--- Create an Attack increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
-- and increase if > 0
-- @param[opt=ATTACK_BONUS_MISC] modifier_type ATTACK\_BONUS\_*
function M.AttackBonus(amount, modifier_type)
   modifier_type = modifier_type or ATTACK_BONUS_MISC
   return M.effect_t(C.effect_attack(amount, modifier_type), false)
end

--- Create a Beam effect.
-- @param beam VFX\_BEAM\_* Constant defining the visual type of beam to use.
-- @param creator The beam is emitted from this creature
-- @param bodypart BODY_NODE_* Constant defining where on the creature the beam originates from.
-- @param[opt=false] miss_effect If true, the beam will fire to a random vector near or past the target.
function M.Beam(beam, creator, bodypart, miss_effect)
   miss_effect = miss_effect and 1 or 0
   return M.effect_t(C.effect_beam(beam, creator, bodypart,
				     miss_effect),
		       false)
end

--- Create a Blindness effect.
function M.Blindness()
   return M.effect_t(C.effect_blindess(), false)
end

--- Creates a bonus feat effect.
function M.BonusFeat (feat)
   return M.effect_t(C.effect_feat(feat), false)
end

--- Create a Charm effect
function M.Charmed()
   return M.effect_t(C.effect_charmed(), false)
end

--- Creates a concealment effect.
-- @param percent [1,100]
-- @param[opt=MISS_CHANCE_TYPE_NORMAL] miss_type MISS\_CHANCE\_TYPE\_*
function M.Concealment(percent, miss_type)
   miss_type = miss_type or MISS_CHANCE_TYPE_NORMAL
   return M.effect_t(C.effect_conealment(percent, miss_type), false)
end

--- Creates a confusion effect.
function M.Confused()
   return M.effect_t(C.effect_confuse(), false)
end

--- Create a Curse effect.
-- @param[opt=1] str strength modifier.
-- @param[opt=1] dex dexterity modifier.
-- @param[opt=1] con constitution modifier.
-- @param[opt=1] int intelligence modifier.
-- @param[opt=1] wis wisdom modifier.
-- @param[opt=1] cha charisma modifier.
function M.Curse(str, dex, con, int, wis, cha)
   str = str or 1
   dex = dex or 1
   con = con or 1
   int = int or 1
   wis = wis or 1
   cha = cha or 1

   return M.effect_t(C.effect_curse(str, dex, con, int, wis, cha), false)
end

--- Creates an effect that is guranteed to dominate a creature.
function M.CutsceneDominated()
   return M.effect_t(C.effect_cutscene_dominated(), false)
end

--- Creates a cutscene ghost effect
function M.CutsceneGhost()
   return M.effect_t(C.effect_cutscene_ghost(), false)
end

--- Creates a cutscene immobilize effect
function M.CutsceneImmobilize()
   return M.effect_t(C.effect_cutscene_immobilize(), false)
end

--- Creates an effect that will paralyze a creature for use in a cut-scene.
function M.CutsceneParalyze()
   return M.effect_t(C.effect_cutscene_paralyze(), false)
end

--- Creates Damage effect.
-- @param amount amount of damage to be dealt.
-- @param damage_type DAMAGE\_TYPE\_*
-- @param[opt=DAMAGE_POWER_NORMAL] power DAMAGE\_POWER\_*
function M.Damage(amount, damage_type, power)
   damage_type = damage_type or DAMAGE_TYPE_MAGICAL
   power = power or DAMAGE_POWER_NORMAL

   return M.effect_t(C.effect_damage(amount, damage_type, power), false)
end

--- Effect Damage Decrease
-- @param amount Amount
-- @param damage_type DAMAGE\_TYPE\_*
-- @param attack_type
function M.DamageDecrease(amount, damage_type, attack_type)
   error "???"
end

--- Effect Damage Increase
-- @param amount
-- @param[opt=DAMAGE_TYPE_MAGICAL] damage_type DAMAGE\_TYPE\_*
-- @param[opt=ATTACK_TYPE_MISC] attack_type
function M.DamageIncrease(amount, damage_type, attack_type)
   error "???"
end

--- Effect Damage Range Decrease
-- @param start Start of damage range.
-- @param stop Start of damage range.
-- @param[opt=DAMAGE_TYPE_MAGICAL] damage_type DAMAGE\_TYPE\_*
-- @param[opt=ATTACK_TYPE_MISC] attack_type
function M.DamageRangeDecrease(start, stop, damage_type, attack_type)
   error "???"
end

--- Effect Damage Range Increase
-- @param start Start of damage range.
-- @param stop Start of damage range.
-- @param[opt=DAMAGE_TYPE_MAGICAL] damage_type DAMAGE\_TYPE\_*
-- @param[opt=ATTACK_TYPE_MISC] attack_type
function M.DamageRangeIncrease(start, stop, damage_type, attack_type)
   error "???"
end

---
-- @param damage_type DAMAGE_TYPE_*
-- @param percent [1,100]
function M.DamageImmunity(damage_type, percent)
   return M.effect_t(C.effect_damage_immunity(damage_type, percent),
		       false)
end

---
-- @param amount Amount
-- @param power Power
-- @param[opt=0] limit Limit
function M.DamageReduction(amount, power, limit)
   return M.effect_t(C.effect_damage_reduction(amount, power, limit),
		       false)
end

---
-- @param damage_type DAMAGE\_TYPE\_*
-- @param amount Amount
-- @param[opt=0] limit Limit
function M.DamageResistance(damage_type, amount, limit)
   limit = limit or 0
   return M.effect_t(C.effect_damage_resistance(damage_type,
						  amount, limit),
		       false)
end

---
-- @param amount
-- @param random
-- @param damage_type DAMAGE\_TYPE\_*
function M.DamageShield(amount, random, damage_type)
   return M.effect_t(C.effect_damage_shield(amount, random,
					      damage_type),
		       false)

end

--- Create a Darkness effect.
function M.Darkness()
   return M.effect_t(C.effect_darkness(), false)
end

--- Create a Daze effect.
function M.Dazed()
   return M.effect_t(C.effect_dazed(), false)
end

--- Create a Deaf effect.
function M.Deaf()
   return M.effect_t(C.effect_deaf(), false)
end

---
-- @param spectacular
-- @param feedback
function M.Death(spectacular, feedback)
   return M.effect_t(C.effect_deat(spectacular, feedback), false)
end

---
-- @param[opt=false] animation Use animation
function M.Disappear(animation)
   animation = animation and 1 or 0
   return M.effect_t(C.effect_disappear(animation), false)
end

---
-- @param location
-- @param[opt=false] animation Use animation
function M.DisappearAppear(location, animation)
   animation = animation and 1 or 0
   return M.effect_t(C.effect_disappear_appear(location, animation),
		       false)
end

--- Create Disarm effect
function M.Disarm()
   return M.effect_t(C.effect_disarm(), false)
end

--- Create a Disease effect.
-- @param disease DISEASE\_*
function M.Disease(disease)
   return M.effect_t(C.effect_disease(disease), false)
end

--- Create a Dispel Magic All effect.
-- @param[opt] caster_level The highest level spell to dispel.
function M.DispelMagicAll(caster_level)
   caster_level = caster_level or -1
   return M.effect_t(C.effect_dispel_all(caster_level), false)
end

--- Create a Dispel Magic Best effect.
-- @param[opt] caster_level The highest level
-- spell to dispel.
function M.DispelMagicBest(caster_level)
   caster_level = caster_level or -1
   return M.effect_t(C.effect_dispel_best(caster_level), false)
end

--- Create a Dominate effect.
function M.Dominated()
   return M.effect_t(C.effect_dominated(), false)
end

--- Create an Entangle effect
function M.Entangle()
   return M.effect_t(C.effect_entangle(), false)
end

--- Creates a Sanctuary effect but the observers get no saving throw.
function M.Ethereal()
   return M.effect_t(C.effect_ethereal(), false)
end

--- Create a frightened effect for use in making creatures shaken or flee.
function M.Frightened()
   return M.effect_t(C.effect_frightened(), false)
end

--- Create a Haste effect.
function M.Haste()
   return M.effect_t(C.effect_haste(), false)
end

--- Creates a healing effect.
-- @param amount Hit points to heal.
function M.Heal(amount)
   return M.effect_t(C.effect_heal(amount), false)
end

--- Create a Hit Point Change When Dying effect.
-- @param hitpoint_change Positive or negative, but not zero.
function M.HitPointChangeWhenDying(hitpoint_change)
   return M.effect_t(C.effect_hp_change_when_dying(hitpoint_change),
		       false)
end

--- Create a hit point effect
function M.HitPointDecrease(amount)
   error "???"
end

--- Create a hit point effect
function M.HitPointIncrease(amount)
   error "???"
end

--- Creates an icon effect
function M.Icon(icon)
   return M.effect_t(C.effect_icon(icon), false)
end

--- Create an Immunity effect.
-- @param immunity One of the IMMUNITY\_TYPE\_* constants.
-- @param percent Percent immunity.
function M.Immunity(immunity, percent)
   return M.effect_t(C.effect_immunity(immunity, percent), false)
end

--- Create an Invisibility effect.
-- @param invisibilty_type One of the INVISIBILITY\_TYPE\_*
-- constants defining the type of invisibility to use.
function M.Invisibility(invisibilty_type)
   return M.effect_t(C.effect_invisibility(invisibilty_type), false)
end

--- Create a Knockdown effect
function M.Knockdown()
   return M.effect_t(C.effect_knockdown(), false)
end

--- Creates one new effect object from two seperate effect objects.
-- @param child One of the two effects to link together.
-- @param parent One of the two effects to link together.
function M.LinkEffects(child, parent)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, parent)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, child)

   return CreateEffect(199, 2)
end

--- Creates a miss chance effect.
-- @param percent [1,100].
-- @param[opt=MISS_CHANCE_TYPE_NORMAL] misstype MISS\_CHANCE\_TYPE\_*
function M.MissChance(percent, misstype)
   misstype = misstype or MISS_CHANCE_TYPE_NORMAL
   return M.effect_t(C.effect_miss_chance(percent, misstype), false)
end

--- Create a Modify Attacks effect that adds attacks to the target.
-- @param attacks Maximum is 5, even with the effect stacked
function M.ModifyAttacks(attacks)
   if attacks < 0 or attacks > 5 then
      error "EffectModifyAttacks: Invalid argument must be [1,5]"
   end
   return M.effect_t(C.effect_additional_attacks(attacks), false)
end

--- Create a Movement Speed Increase/Decrease effect to slow target.
-- @param percent If < 0 effect will cause a decrease by amount, it
-- will be and increase if > 0
function M.MovementSpeed(percent)
   return M.effect_t(C.effect_move_speed(percent), false)
end

--- Create a Negative Level effect that will decrease the level of the target.
-- @param amount Number of levels
-- @param hp_bonus
function M.NegativeLevel(amount, hp_bonus)
   return M.effect_t(C.effect_negative_level(amount, hp_bonus), false)
end

--- Create a Paralyze effect.
function M.Paralyze()
   return M.effect_t(C.effect_paralyze(), false)
end

--- Creates an effect that will petrify a creature.
function M.Petrify()
   return M.effect_t(C.effect_petrify(), false)
end

--- Create a Poison effect.
-- @param poison The type of poison to use, as defined in the POISON\_* constant group.
function M.Poison(poison)
   return M.effect_t(C.effect_poison(poison), false)
end

--- Create a Polymorph effect that changes the target into a different type of creature.
-- @param polymorph POLYMORPH_TYPE_*
-- @param[opt=false] locked If true, player can't cancel polymorph.
function M.Polymorph(polymorph, locked)
   return M.effect_t(C.effect_polymorph(polymorph, locked), false)
end

--- Create a Regenerate effect.
-- @param amount Amount of damage to be regenerated per time interval
-- @param interval Length of interval in seconds
function M.Regenerate(amount, interval)
   return M.effect_t(C.effect_regenerate(amount, interval), false)
end

--- Create a Resurrection effect.
function M.Resurrection()
   return M.effect_t(C.effect_resurrection(), false)
end

--- Creates a sanctuary effect.
-- @param dc Must be a non-zero, positive number.
function M.Sanctuary(dc)
   return M.effect_t(C.effect_sanctuary(dc), false)
end

--- Create a Saving Throw Increase/Decrease effect to modify one Saving Throw type.
-- @param save The Saving Throw to affect, as defined by the SAVING_THROW_* constants group.
-- @param amount The amount to modify the saving throws by.  If > 0 an increase, if < 0 a decrease.
-- @param[opt=SAVING_THROW_TYPE_ALL] save_type The type of resistance this effect applies to as
-- defined by the SAVING\_THROW\_TYPE\_* constants group.
function M.SavingThrow(save, amount, save_type)
   save_type = save_type or SAVING_TYROW_TYPE_ALL
   return M.effect_t(C.effect_save(save, amount, save_type), false)
end

--- Create a See Invisible effect.
function M.SeeInvisible()
   return M.effect_t(C.effect_see_invisible(), false)
end

--- Create a Silence effect
function M.Silence()
   return M.effect_t(C.effect_silence(), false)
end

--- Returns an effect to decrease a skill.
-- @param skill SKILL_*
-- @param amount The amount to modify the skill by.  If > 0 an increase, if < 0 a decrease.
function M.Skill(skill, amount)
   return M.effect_t(C.effect_skill(skill, amount), false)
end

--- Creates a sleep effect.
function M.Sleep()
   return M.effect_t(C.effect_sleep(), false)
end

--- Creates a slow effect.
function M.Slow()
   return M.effect_t(C.effect_slow(), false)
end

--- Creates an effect that inhibits spells.
-- @param[opt=100] percent Percent chance of spell failing (1 to 100).
-- @param[opt=SPELL_SCHOOL_GENERAL] spell_school SPELL\_SCHOOL\_*
function M.SpellFailure(percent, spell_school)
   percent = percent or 100
   spell_school = spell_school or SPELL_SCHOOL_GENERAL
   return M.effect_t(C.effect_spell_failure(percent, spell_school), false)
end

--- Returns an effect of spell immunity.
-- @param[opt=SPELL_ALL_SPELLS] spell SPELL_*
function M.SpellImmunity(spell)
   spell = spell or SPELL_ALL_SPELLS
   return M.effect_t(C.effect_spell_immunity(spell), false)
end

--- Creates a Spell Level Absorption effect
-- @param max_level Highest spell level that can be absorbed.
-- @param max_spells Maximum number of spells to absorb
-- @param[opt=SPELL_SCHOOL_GENERAL] school SPELL_SCHOOL_*.
function M.SpellLevelAbsorption(max_level, max_spells, school)
   max_spells = max_spells or 0
   school = school or SPELL_SCHOOL_GENERAL
   return M.effect_t(C.effect_spell_absorbtion(max_level,
						 max_spells, school),
		       false)
end

--- Modify Creature Spell Resistance
-- @param value If > 0 an increase, if < 0 a decrease
function M.SpellResistance(value)
   return M.effect_t(C.effect_spell_resistance(value), false)
end

--- Creates a Stunned effect.
function M.Stunned()
   return M.effect_t(C.effect_stunned(), false)
end

--- Summon Creature Effect
-- @param resref Identifies the creature to be summoned by resref name.
-- @param[opt=VFX_NONE] vfx VFX\_*.
-- @param[opt=0.0] delay There can be delay between the visual effect being played,
-- and the creature being added to the area.
-- @param[opt=false] appear
function M.SummonCreature(resref, vfx, delay, appear)
   vfx = vfx or VFX_NONE
   delay = delay or 0.0
   appear = appear and 1 or 0
   return M.effect_t(C.effect_summon(resref, vfx,delay, appear),
		       false)
end

--- Summon swarm effect.
-- @param looping If this is `true`, for the duration of the effect when one
-- creature created by this effect dies, the next one in the list will
-- be created. If the last creature in the list dies, we loop back to the
-- beginning and sCreatureTemplate1 will be created, and so on...
-- @param resref1 Blueprint of first creature to spawn
-- @param[opt=""] resref2 Optional blueprint for second creature to spawn.
-- @param[opt=""] resref3 Optional blueprint for third creature to spawn.
-- @param[opt=""] resref4 Optional blueprint for fourth creature to spawn.
function M.Swarm(looping, resref1, resref2, resref3, resref4)
   resref2 = resref2 or ""
   resref3 = resref3 or ""
   resref4 = resref4 or ""
   return M.effect_t(C.effect_swarm(looping, resref1,
				      resref2, resref3, resref4),
		       false)
end

--- Create a Temporary Hitpoints effect that raises the Hitpoints of the target.
-- @param hitpoints A positive integer
function M.TemporaryHitpoints(hitpoints)
   return M.effect_t(C.effect_hp_temporary(hitpoints), false)
end

--- Create a Time Stop effect.
function M.TimeStop()
   return M.effect_t(C.effect_time_stop(), false)
end

--- Creats a True Seeing effect.
function M.TrueSeeing()
   return M.effect_t(C.effect_true_seeing(), false)
end

--- Create a Turned effect.
function M.Turned()
   return M.effect_t(C.effect_turned(), false)
end

--- Create a Turn Resistance Increase/Decrease effect that can make creatures more susceptible to turning.
-- @param hitdice If > 0 an increase, if < 0 a decrease.
function M.TurnResistance(hitdice)
   return M.effect_t(C.effect_turn_resistance(hitdice), false)
end

--- Creates an Ultravision effect
function M.Ultravision()
   return M.effect_t(C.effect_ultravision(), false)
end

--- Creates a new visual effect
-- @param id The visual effect to be applied.
-- @param[opt=false] miss if this is true, a random vector near or past the
-- target will be generated, on which to play the effect.
function M.VisualEffect(id, miss)
   miss = miss and 1 or 0
   return M.effect_t(C.effect_visual(id, miss), false)
end

--- Creates a wounding effect
-- @param amount Amount of damage to do each round
function M.Wounding (amount)
   return M.effect_t(C.effect_wounding (amount), false)
end
