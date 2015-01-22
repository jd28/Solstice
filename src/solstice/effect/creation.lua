--- Effects module
-- @module effect

local NWE = require 'solstice.nwn.engine'
local M = require 'solstice.effect.init'
local C = require('ffi').C

--- Effect Creation
-- @section

--- Create raw effect.
-- It's initial type will be EFFECT_TYPE_INVALID
-- @bool[opt=true] generate_id Generate effect ID.  If false
-- the effects ID will be 0.
-- @param[opt=10] ints Number of effect integers.
local function Create(generate_id, ints)
   if generate_id == nil then generate_id = true end
   ints = ints or 10
   local eff = M.effect_t(C.nwn_CreateEffect(generate_id and 1 or 0),
                          false)
   eff:SetType(EFFECT_TYPE_INVALID)
   eff:SetCreator(NWE.GetCommandObject())
   eff:SetNumIntegers(ints)
   eff:SetAllInts(0)
   eff:SetSubType(SUBTYPE_MAGICAL)
   eff:SetDurationType(DURATION_TYPE_PERMANENT)

   return eff
end

--- Creates simple effect.
-- NOTE: This is for simple effects, that have less than
-- 10 integers and always generate a new ID.
-- @param type EFFECT_TYPE_*
-- @param ... Ints to set on the effect.
local function CreateSimple(type, ...)
   local eff = Create()
   eff:SetType(type)
   local t = {...}
   if #t > 0 then
      for i=0, #t - 1 do
         eff:SetInt(i, t[i+1])
      end
   end
   return eff
end

--- Creates simple custom effect.
-- NOTE: This is for simple custom effects, that have less than
-- 8 integers and always generate a new ID.
-- @see nwnx.effects
-- @param type CUSTOM_EFFECT_TYPE_*
-- @param ... Ints to set on the effect.
local function CreateSimpleCustom(type, ...)
   local eff = Create()
   eff:SetType(EFFECT_TYPE_MODIFY_NUM_ATTACKS)
   eff:SetInt(0, type)
   local t = {...}

   for i, v in ipairs(t) do
      eff:SetInt(i, v)
   end
   return eff
end

M.Create = Create
M.CreateSimple = CreateSimple
M.CreateSimpleCustom = CreateSimpleCustom

local function determine_type_amount(inctype, dectype, amount)
   if amount < 0 then
      return dectype, -amount
   end
   return inctype, amount
end

--- Creates a Recurring Effect
-- This effect when applied is merely a place holder.
function M.Recurring()
   return CreateSimpleCustom(CUSTOM_EFFECT_TYPE_RECURRING)
end

--- Creates an ability increase/decrease effect on specified ability score.
-- @param ability ABILITY_*
-- @param amount If less than 0 effect will cause an ability decrease,
-- if greater than 0 an ability increase.
-- @return Invalid effect if amount is 0, or the ability is an invalid type.
function M.Ability(ability, amount)
   if ability < 0 or ability >= ABILITY_NUM or amount == 0 then
      return Create()
   end

   local type, amt = determine_type_amount(EFFECT_TYPE_ABILITY_INCREASE,
                                           EFFECT_TYPE_ABILITY_DECREASE,
                                           amount)
   return CreateSimple(type, ability, amt)
end

--- Creates an AC increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
-- and increase if > 0
-- @param[opt=AC_DODGE_BONUS] modifier_type AC_*
function M.ArmorClass(amount, modifier_type)
   modifier_type = modifier_type or AC_DODGE_BONUS
   if amount == 0 or modifier_type < 0 then
      return Create()
   end
   local damage_type = 4103

   local type, amt = determine_type_amount(EFFECT_TYPE_AC_INCREASE,
                                           EFFECT_TYPE_AC_DECREASE,
                                           amount)
   return CreateSimple(type, modifier_type, amt, 28, 0, 0, damage_type)
end

--- Create a special effect to make the object "fly in".
-- @param[opt=false] animation Use animation
function M.Appear(animation)
   return CreateSimple(EFFECT_TYPE_APPEAR, animation and 1 or 0)
end

--- Returns a new effect object.
-- @param aoe The ID of the Area of Effect
-- @param[opt=""] enter The script to use when a creature enters the radius of the Area of Effect.
-- @param[opt=""] heartbeat The script to run on each of the Area of Effect's Heartbeats.
-- @param[opt=""] exit The script to run when a creature leaves the radius of an Area of Effect.
function M.AreaOfEffect(aoe, enter, heartbeat, exit)
   enter = enter or ""
   heartbeat = heartbeat or ""
   exit = exit or ""

   local eff = CreateSimple(EFFECT_TYPE_AREA_OF_EFFECT, aoe)
   eff:SetString(0, enter)
   eff:SetString(1, heartbeat)
   eff:SetString(2, exit)

   return eff
end

--- Create an Attack increase/decrease effect.
-- @param amount If < 0 effect will cause a decrease by amount, it will be
-- and increase if > 0
-- @param[opt=ATTACK_TYPE_MISC] modifier_type ATTACK_TYPE_*
function M.AttackBonus(amount, modifier_type)
   local type, amt = determine_type_amount(EFFECT_TYPE_ATTACK_INCREASE,
                                           EFFECT_TYPE_ATTACK_DECREASE,
                                           amount)
   return CreateSimple(type, amt, modifier_type or ATTACK_BONUS_MISC, 28)
end

--- Create a Beam effect.
-- @param beam VFX_BEAM_* Constant defining the visual type of beam to use.
-- @param creator The beam is emitted from this creature
-- @param bodypart BODY_NODE_* Constant defining where on the creature the beam originates from.
-- @param[opt=false] miss_effect If true, the beam will fire to a random vector near or past the target.
function M.Beam(beam, creator, bodypart, miss_effect)
   miss_effect = miss_effect and 1 or 0
   local eff = CreateSimple(EFFECT_TYPE_BEAM,
                            beam, bodypart, miss_effect)
   eff:SetObject(0, creator)
   return eff
end

--- Create a Blindness effect.
function M.Blindness()
   return CreateSimple(EFFECT_TYPE_BLINDNESS, 16)
end

--- Creates a bonus feat effect.
function M.BonusFeat (feat)
   return CreateSimple(EFFECT_TYPE_BONUS_FEAT, feat)
end

--- Create a Charm effect
function M.Charmed()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 1)
end

--- Creates a concealment effect.
-- @param percent [1,100]
-- @param[opt=MISS_CHANCE_TYPE_NORMAL] miss_type MISS_CHANCE_TYPE_*
function M.Concealment(percent, miss_type)
   percent = math.clamp(percent, 1, 100)
   miss_type = miss_type or MISS_CHANCE_TYPE_NORMAL
   return CreateSimple(EFFECT_TYPE_CONCEALMENT, percent, miss_type)
end

--- Creates a confusion effect.
function M.Confused()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 2)
end

--- Create a Curse effect.
-- @param[opt=1] str strength modifier.
-- @param[opt=1] dex dexterity modifier.
-- @param[opt=1] con constitution modifier.
-- @param[opt=1] int intelligence modifier.
-- @param[opt=1] wis wisdom modifier.
-- @param[opt=1] cha charisma modifier.
function M.Curse(str, dex, con, int, wis, cha)
   return CreateSimple(EFFECT_TYPE_CURSE,
                       str or 1,
                       dex or 1,
                       con or 1,
                       int or 1,
                       wis or 1,
                       cha or 1)
end

--- Creates an effect that is guranteed to dominate a creature.
function M.CutsceneDominated()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 21)
end

--- Creates a cutscene ghost effect
function M.CutsceneGhost()
   return CreateSimple(EFFECT_TYPE_CUTSCENEGHOST)
end

--- Creates a cutscene immobilize effect
function M.CutsceneImmobilize()
   return CreateSimple(EFFECT_TYPE_CUTSCENEIMMOBILE)
end

--- Creates an effect that will paralyze a creature for use in a cut-scene.
function M.CutsceneParalyze()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 20)
end

--- Creates Damage effect.
-- @param amount amount of damage to be dealt.
-- @param damage_type DAMAGE_INDEX_*
-- @param[opt=DAMAGE_POWER_NORMAL] power DAMAGE_POWER_*
function M.Damage(amount, damage_type, power)
   damage_type = damage_type or DAMAGE_INDEX_MAGICAL
   local damage_flag = bit.lshift(1, damage_type)
   power = power or DAMAGE_POWER_NORMAL

   local eff = CreateSimple(EFFECT_TYPE_DAMAGE)
   eff:SetNumIntegers(20)
   for i=0, 13 do
      eff:SetInt(i, -1)
   end

   eff:SetInt(damage_type, amount)
   eff:SetInt(14, 1000)
   eff:SetInt(15, damage_flag)
   eff:SetInt(16, power)

   return eff
end

--- Effect Damage Decrease
-- @param amount DAMAGE_BONUS_*
-- @param[opt=DAMAGE_INDEX_MAGICAL] damage_type DAMAGE_INDEX_*
-- @bool critical Only applicable on critical hits.
-- @bool unblockable Not modified by damage protections.
function M.DamageDecrease(amount, damage_type, critical, unblockable)
   damage_type = damage_type or DAMAGE_INDEX_MAGICAL
   local damage_flag = bit.lshift(1, damage_type)

   local mask = 1
   if critical then
      mask = bit.bor(mask, 2)
   end

   if unblockable then
      mask = bit.bor(mask, 4)
   end
   return CreateSimple(EFFECT_TYPE_DAMAGE_DECREASE,
                       amount, damage_flag, 28, 0, 0, 0, mask)
end

--- Effect Damage Increase
-- @param amount DAMAGE_BONUS_*
-- @param[opt=DAMAGE_INDEX_MAGICAL] damage_type DAMAGE_INDEX_*
-- @bool critical Only applicable on critical hits.
-- @bool unblockable Not modified by damage protections.
function M.DamageIncrease(amount, damage_type, critical, unblockable)
   damage_type = damage_type or DAMAGE_INDEX_MAGICAL
   local damage_flag = bit.lshift(1, damage_type)

   local mask = 0
   if critical then
      mask = bit.bor(mask, 2)
   end

   if unblockable then
      mask = bit.bor(mask, 4)
   end

   return CreateSimple(EFFECT_TYPE_DAMAGE_INCREASE,
                       amount, damage_flag, 28, 0, 0, 0, mask)
end

--- Effect Damage Increase
-- @param start Minimum damage.
-- @param stop Maximum damage.
-- @param[opt=DAMAGE_INDEX_MAGICAL] damage_type DAMAGE_INDEX_*
-- @bool critical Only applicable on critical hits.
-- @bool unblockable Not modified by damage protections.
function M.DamageRange(start, stop, damage_type, critical, unblockable)
   assert(stop > start, "Damage Range maximum must be greater than its minimum!")
   damage_type = damage_type or DAMAGE_INDEX_MAGICAL
   local damage_flag = bit.lshift(1, damage_type)

   local mask = 0
   if critical then
      mask = bit.bor(mask, 2)
   end

   if unblockable then
      mask = bit.bor(mask, 4)
   end

   return CreateSimple(EFFECT_TYPE_DAMAGE_INCREASE,
                       1, damage_flag, 28, start, stop, 0, mask, 1)
end


--- Damage immunity effect.
-- @param damage_type DAMAGE_INDEX_*
-- @param amount [-100, -1] or [1,100]
function M.DamageImmunity(damage_type, amount)
   local type, amt = determine_type_amount(EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE,
                                           EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE,
                                           amount)
   local damage_flag = bit.lshift(1, damage_type)
   return CreateSimple(type, damage_flag, math.clamp(amt, 1, 100))
end

--- Damage reduction effect.
-- @param amount Amount
-- @param power Power
-- @param[opt=0] limit Limit
function M.DamageReduction(amount, power, limit)
   if not limit or limit < 0 then limit = 0 end

   return CreateSimple(EFFECT_TYPE_DAMAGE_REDUCTION, amount, power, limit)
end

--- Damage resistance effect.
-- @param damage_type DAMAGE_INDEX_*
-- @param amount Amount
-- @param[opt=0] limit Limit
function M.DamageResistance(damage_type, amount, limit)
   if not limit or limit < 0 then limit = 0 end
   local damage_flag = bit.lshift(1, damage_type)
   return CreateSimple(EFFECT_TYPE_DAMAGE_RESISTANCE, damage_flag, amount, limit)
end

--- Damage Shield effect.
-- @param amount
-- @param random
-- @param damage_type DAMAGE_INDEX_*
function M.DamageShield(amount, random, damage_type)
   local damage_flag = bit.lshift(1, damage_type)
   return CreateSimple(EFFECT_TYPE_DAMAGE_SHIELD, amount, random, damage_flag)
end

--- Create a Darkness effect.
function M.Darkness()
   return CreateSimple(EFFECT_TYPE_DARKNESS)
end

--- Create a Daze effect.
function M.Dazed()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 5)
end

--- Create a Deaf effect.
function M.Deaf()
   return CreateSimple(EFFECT_TYPE_DEAF)
end

--- Death effect
-- @param spectacular
-- @param feedback
function M.Death(spectacular, feedback)
   local eff = Create()
   eff:SetType(EFFECT_TYPE_DEATH)
   eff:SetInt(0, spectacular)
   eff:SetInt(1, feedback)
   return eff
end

--- Disappear effect.
-- @param[opt=false] animation Use animation
function M.Disappear(animation)
   return CreateSimple(EFFECT_TYPE_DISAPPEAR, animation and 1 or 0)
end

--- Disappear Appear effect.
-- @param location
-- @param[opt=false] animation Use animation
function M.DisappearAppear(location, animation)
   animation = animation and 1 or 0

   local eff = CreateSimple(EFFECT_TYPE_DISAPPEARAPPEAR)
   eff:SetInt(0, animation)
   eff:SetObject(0, location.area)
   eff:SetFloat(0, location.position.x)
   eff:SetFloat(1, location.position.y)
   eff:SetFloat(2, location.position.z)

   return eff
end

--- Create Disarm effect
function M.Disarm()
   return CreateSimple(EFFECT_TYPE_DISARM)
end

--- Create a Disease effect.
-- @param disease DISEASE_*
function M.Disease(disease)
   return CreateSimple(EFFECT_TYPE_DISEASE, disease)
end

--- Create a Dispel Magic All effect.
-- @param[opt] caster_level The highest level spell to dispel.
function M.DispelMagicAll(caster_level)
   caster_level = caster_level or -1
   return CreateSimple(EFFECT_TYPE_DISPEL_ALL_MAGIC, caster_level)
end

--- Create a Dispel Magic Best effect.
-- @param[opt] caster_level The highest level
-- spell to dispel.
function M.DispelMagicBest(caster_level)
   caster_level = caster_level or -1
   return CreateSimple(EFFECT_TYPE_DISPEL_BEST_MAGIC, caster_level)
end

--- Create a Dominate effect.
function M.Dominated()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 7)
end

--- Create an Entangle effect
function M.Entangle()
   return CreateSimple(EFFECT_TYPE_ENTANGLE)
end

--- Creates a Sanctuary effect but the observers get no saving throw.
function M.Ethereal()
   local eff = CreateSimple(EFFECT_TYPE_SANCTUARY)
   eff:SetInt(0, 8)
   eff:SetInt(1, 28)
   return eff
end

--- Create a frightened effect for use in making creatures shaken or flee.
function M.Frightened()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 3)
end

--- Create a Haste effect.
function M.Haste()
   return CreateSimple(EFFECT_TYPE_HASTE)
end

--- Creates a healing effect.
-- @param amount Hit points to heal.
function M.Heal(amount)
   if amount <= 0 then return Create() end
   return CreateSimple(EFFECT_TYPE_HEAL, amount)
end

--- Create a Hit Point Change When Dying effect.
-- @param hitpoint_change Positive or negative, but not zero.
function M.HitPointChangeWhenDying(hitpoint_change)
   local eff = CreateSimple(EFFECT_TYPE_HITPOINTCHANGEWHENDYING)
   eff:SetFloat(0, hitpoint_change)
   return eff
end

--- Creates an icon effect
function M.Icon(icon)
   return CreateSimple(EFFECT_TYPE_ICON, icon)
end

--- Create an Immunity effect.
-- @param immunity One of the IMMUNITY_TYPE_* constants.
-- @param amount Percent immunity.
function M.Immunity(immunity, amount)
   local type, amt = EFFECT_TYPE_IMMUNITY, amount
   if amount < 0 then
      type, amt = CUSTOM_EFFECT_TYPE_IMMUNITY_MISC_PENALTY, -amount
   end
   amt = math.clamp(amt, 1, 100)

   if amount < 0 then
      return CreateSimpleCustom(type, immunity, amt)
   end

   return CreateSimple(type, immunity, amt)
end

--- Create an Invisibility effect.
-- @param invisibilty_type One of the INVISIBILITY_TYPE_*
-- constants defining the type of invisibility to use.
function M.Invisibility(invisibilty_type)
   return CreateSimple(EFFECT_TYPE_INVISIBILITY, invisibilty_type)
end

--- Create a Knockdown effect
function M.Knockdown()
   return CreateSimple(EFFECT_TYPE_KNOCKDOWN)
end

--- Creates one new effect object from two seperate effect objects.
-- @param child One of the two effects to link together.
-- @param parent One of the two effects to link together.
function M.LinkEffects(child, parent)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, parent)
   NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, child)
   NWE.ExecuteCommandUnsafe(199, 2)
   return NWE.StackPopEngineStructure(NWE.STRUCTURE_EFFECT)
end

--- Creates a miss chance effect.
-- @param percent [1,100].
-- @param[opt=MISS_CHANCE_TYPE_NORMAL] misstype MISS_CHANCE_TYPE_*
function M.MissChance(percent, misstype)
   misstype = misstype or MISS_CHANCE_TYPE_NORMAL
   return CreateSimple(EFFECT_TYPE_MISS_CHANCE, percent, misstype)
end

--- Create a Modify Attacks effect that adds attacks to the target.
-- @param attacks Maximum is 5, even with the effect stacked
function M.ModifyAttacks(attacks)
   if attacks < 0 or attacks > 5 then return Create() end
   return CreateSimple(EFFECT_TYPE_MODIFY_NUM_ATTACKS, attacks)
end

--- Create a Movement Speed Increase/Decrease effect to slow target.
-- @param amount If < 0 effect will cause a decrease by amount, it
-- will be and increase if > 0
function M.MovementSpeed(amount)
   local type, amt = determine_type_amount(EFFECT_TYPE_MOVEMENT_SPEED_INCREASE,
                                           EFFECT_TYPE_MOVEMENT_SPEED_DECREASE,
                                           amount)
   return CreateSimple(type, math.clamp(amt, 1, 100))
end

--- Create a Negative Level effect that will decrease the level of the target.
-- @param amount Number of levels
-- @param hp_bonus
function M.NegativeLevel(amount, hp_bonus)
   return CreateSimple(EFFECT_TYPE_NEGATIVE_LEVEL, amount, hp_bonus)
end

--- Create a Paralyze effect.
function M.Paralyze()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 8)
end

--- Creates an effect that will petrify a creature.
function M.Petrify()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 15)
end

--- Create a Poison effect.
-- @param poison The type of poison to use, as defined in the POISON_* constant group.
function M.Poison(poison)
   return CreateSimple(EFFECT_TYPE_POISON, poison)
end

--- Create a Polymorph effect that changes the target into a different type of creature.
-- @param polymorph POLYMORPH_TYPE_*
-- @param[opt=false] locked If true, player can't cancel polymorph.
function M.Polymorph(polymorph, locked)
   local eff = CreateSimple(EFFECT_TYPE_POLYMORPH)
   eff:SetInt(0, polymorph)
   eff:SetInt(2, locked)
   return eff
end

function M.RacialType(race)
   return CreateSimple(EFFECT_TYPE_RACIAL_TYPE, race)
end

--- Create a Regenerate effect.
-- @param amount Amount of damage to be regenerated per time interval
-- @param interval Length of interval in seconds
function M.Regenerate(amount, interval)
   return CreateSimple(EFFECT_TYPE_REGENERATE, amount, 1000 * interval)
end

--- Create a Resurrection effect.
function M.Resurrection()
   return CreateSimple(EFFECT_TYPE_RESURRECTION)
end

--- Creates a sanctuary effect.
-- @param dc Must be a non-zero, positive number.
function M.Sanctuary(dc)
   return CreateSimple(EFFECT_TYPE_SANCTUARY, 8, 28, dc, 1)
end

--- Create a Saving Throw Increase/Decrease effect to modify one Saving Throw type.
-- @param save The Saving Throw to affect, as defined by the SAVING_THROW_* constants group.
-- @param amount The amount to modify the saving throws by.  If > 0 an increase, if < 0 a decrease.
-- @param[opt=SAVING_THROW_TYPE_ALL] save_type The type of resistance this effect applies to as
-- defined by the SAVING_THROW_VS_* constants group.
function M.SavingThrow(save, amount, save_type)
   local type, amt = determine_type_amount(EFFECT_TYPE_SAVING_THROW_INCREASE,
                                           EFFECT_TYPE_SAVING_THROW_DECREASE,
                                           amount)
   local eff = CreateSimple(type)
   save_type = save_type or SAVING_TYROW_VS_ALL
   eff:SetInt(0, amt)
   eff:SetInt(1, save)
   eff:SetInt(2, save_type)
   eff:SetInt(3, 28)
   return eff
end

--- Create a See Invisible effect.
function M.SeeInvisible()
   return CreateSimple(EFFECT_TYPE_SEEINVISIBLE)
end

--- Create a Silence effect
function M.Silence()
   return CreateSimple(EFFECT_TYPE_SILENCE)
end

--- Returns an effect to decrease a skill.
-- @param skill SKILL_*
-- @param amount The amount to modify the skill by.  If > 0 an increase, if < 0 a decrease.
function M.Skill(skill, amount)
   local type, amt = determine_type_amount(EFFECT_TYPE_SKILL_INCREASE,
                                           EFFECT_TYPE_SKILL_DECREASE,
                                           amount)
   return CreateSimple(type, skill, amt, 28)
end

--- Creates a sleep effect.
function M.Sleep()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 9)
end

--- Creates a slow effect.
function M.Slow()
   return CreateSimple(EFFECT_TYPE_SLOW)
end

--- Creates an effect that inhibits spells.
-- @param[opt=100] percent Percent chance of spell failing (1 to 100).
-- @param[opt=SPELL_SCHOOL_GENERAL] spell_school SPELL_SCHOOL_*
function M.SpellFailure(percent, spell_school)
   percent = percent or 100
   spell_school = spell_school or SPELL_SCHOOL_GENERAL
   return CreateSimple(EFFECT_TYPE_SPELL_FAILURE, percent, spell_school)
end

--- Returns an effect of spell immunity.
-- @param[opt=SPELL_ALL_SPELLS] spell SPELL_*
function M.SpellImmunity(spell)
   return CreateSimple(EFFECT_TYPE_SPELL_IMMUNITY, spell or SPELL_ALL_SPELLS)
end

--- Creates a Spell Level Absorption effect
-- @param max_level Highest spell level that can be absorbed.
-- @param max_spells Maximum number of spells to absorb
-- @param[opt=SPELL_SCHOOL_GENERAL] school SPELL_SCHOOL_*.
function M.SpellLevelAbsorption(max_level, max_spells, school)
   max_spells = max_spells or 0
   school = school or SPELL_SCHOOL_GENERAL

   return CreateSimple(EFFECT_TYPE_SPELL_LEVEL_ABSORPTION,
                       max_level, max_spells, school)
end

--- Modify Creature Spell Resistance
-- @param amount If > 0 an increase, if < 0 a decrease
function M.SpellResistance(amount)
   local type, amt = determine_type_amount(EFFECT_TYPE_SPELL_RESISTANCE_INCREASE,
                                           EFFECT_TYPE_SPELL_RESISTANCE_DECREASE,
                                           amount)
   return CreateSimple(type, amt)
end

--- Creates a Stunned effect.
function M.Stunned()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 6)
end

--- Summon Creature Effect
-- @param resref Identifies the creature to be summoned by resref name.
-- @param[opt=VFX_NONE] vfx VFX_*.
-- @param[opt=0.0] delay There can be delay between the visual effect being played,
-- and the creature being added to the area.
-- @param[opt=false] appear
function M.SummonCreature(resref, vfx, delay, appear)
   vfx = vfx or VFX_NONE
   delay = delay or 0.0
   appear = appear and 1 or 0

   local eff = CreateSimple(EFFECT_TYPE_SUMMON_CREATURE, vfx, appear)
   eff:SetFloat(3, delay)
   eff:SetString(0, resref)
   return eff
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
   local eff = CreateSimple(EFFECT_TYPE_SWARM, looping)
   eff:SetString(0, resref1)
   eff:SetString(1, resref2)
   eff:SetString(2, resref3)
   eff:SetString(3, resref4)
   return eff
end

--- Create a Temporary Hitpoints effect that raises the Hitpoints of the target.
-- @param amount A positive integer
function M.TemporaryHitpoints(amount)
   if amount <= 0 then return Create() end
   return CreateSimple(EFFECT_TYPE_TEMPORARY_HITPOINTS, amount)
end

--- Create a Time Stop effect.
function M.TimeStop()
   return CreateSimple(EFFECT_TYPE_TIMESTOP)
end

--- Creats a True Seeing effect.
function M.TrueSeeing()
   return CreateSimple(EFFECT_TYPE_TRUESEEING)
end

--- Create a Turned effect.
function M.Turned()
   return CreateSimple(EFFECT_TYPE_SETSTATE, 4)
end

--- Create a Turn Resistance Increase/Decrease effect that can make creatures more susceptible to turning.
-- @param amount If > 0 an increase, if < 0 a decrease.
function M.TurnResistance(amount)
   local type, amt = determine_type_amount(EFFECT_TYPE_TURN_RESISTANCE_INCREASE,
                                           EFFECT_TYPE_TURN_RESISTANCE_DECREASE,
                                           amount)
   return CreateSimple(type, amt)
end

--- Creates an Ultravision effect
function M.Ultravision()
   return Create(EFFECT_TYPE_ULTRAVISION)
end

--- Creates a new visual effect
-- @param id The visual effect to be applied.
-- @param[opt=false] miss if this is true, a random vector near or past the
-- target will be generated, on which to play the effect.
function M.VisualEffect(id, miss)
   miss = miss and 1 or 0
   local eff = CreateSimple(EFFECT_TYPE_VISUALEFFECT)
   eff:SetInt(0, id)
   eff:SetInt(1, miss)
   return eff
end

--- Creates a wounding effect
-- @param amount Amount of damage to do each round
function M.Wounding (amount)
   return CreateSimple(EFFECT_TYPE_WOUNDING, amount)
end
