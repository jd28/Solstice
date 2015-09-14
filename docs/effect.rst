.. highlight:: lua
.. default-domain:: lua

.. module:: effect

.. warning::

  There are some non-default behaviors currently here.

Effect
------

.. function:: Ability(ability, amount)

  Creates an ability increase/decrease effect on specified ability score.

  :param int ability: ABILITY_*
  :param int amount: If less than 0 effect will cause an ability decrease, if greater than 0 an ability increase.
  :rtype: Invalid effect if amount is 0, or the ability is an invalid type.

.. function:: ArmorClass(amount[, modifier_type])

  Creates an AC increase/decrease effect.

  :param int amount: If < 0 effect will cause a decrease by amount, it will be and increase if > 0
  :param int modifier_type: AC_* constant.  (Default: AC_DODGE_BONUS)

.. function:: Appear([animation=false])

  Create a special effect to make the object "fly in".

  :param boolean animation: Use animation  (Default: false)

.. function:: AreaOfEffect(aoe, [enter[, heartbeat[, exit]]])

  Returns a new effect object.

  :param int aoe: The ID of the Area of Effect
  :param string enter: The script to use when a creature enters the radius of the Area of Effect.  (Default: "")
  :param string heartbeat: The script to run on each of the Area of Effect's Heartbeats.  (Default: "")
  :param string exit: The script to run when a creature leaves the radius of an Area of Effect.  (Default: "")

.. function:: AttackBonus(amount[, modifier_type])

  Create an Attack increase/decrease effect.

  :param int amount: If < 0 effect will cause a decrease by amount, it will be and increase if > 0
  :param int modifier_type: ATTACK_TYPE_* constant.  (Default: ATTACK_TYPE_MISC)

.. function:: Beam(beam, creator, bodypart[, miss_effect])

  Create a Beam effect.

  :param int beam: VFX_BEAM_* Constant defining the visual type of beam to use.
  :param creator: The beam is emitted from this creature
  :type creator: :class:`creature`
  :param int bodypart: BODY_NODE_* Constant defining where on the creature the beam originates from.
  :param boolean miss_effect: If true, the beam will fire to a random vector near or past the target.  (Default: false)

.. function:: Blindness()

  Create a Blindness effect.

.. function:: BonusFeat (feat)

  Creates a bonus feat effect.

  :param int feat: FEAT_*

.. function:: Charmed()

  Create a Charm effect

.. function:: Concealment(percent[, miss_type])

  Creates a concealment effect.

  :param int percent: [1,100]
  :param int miss_type: MISS_CHANCE_TYPE_* constant.  (Default: MISS_CHANCE_TYPE_NORMAL)

.. function:: Confused()

  Creates a confusion effect.

.. function:: Curse([str[, dex[, con[, int[, wis[, cha]]]]]])

  Create a Curse effect.

  :param int str: strength modifier.  (Default: 1)
  :param int dex: dexterity modifier.  (Default: 1)
  :param int con: constitution modifier.  (Default: 1)
  :param int int: intelligence modifier.  (Default: 1)
  :param int wis: wisdom modifier.  (Default: 1)
  :param int cha: charisma modifier.  (Default: 1)

.. function:: CutsceneDominated()

  Creates an effect that is guranteed to dominate a creature.

.. function:: CutsceneGhost()

  Creates a cutscene ghost effect

.. function:: CutsceneImmobilize()

  Creates a cutscene immobilize effect

.. function:: CutsceneParalyze()

  Creates an effect that will paralyze a creature for use in a cut-scene.

.. function:: Damage(amount, damage_type[, power])

  Creates Damage effect.

  :param int amount: amount of damage to be dealt.
  :param int damage_type: DAMAGE_INDEX_*
  :param int power: DAMAGE_POWER_* (Default: DAMAGE_POWER_NORMAL)

.. function:: DamageDecrease(amount[, damage_type[, critical[, unblockable]]])

  Effect Damage Decrease

  :param int amount: DAMAGE_BONUS_*
  :param int damage_type: DAMAGE_INDEX_* constant.  (Default: DAMAGE_INDEX_MAGICAL)
  :param boolean critical: Only applicable on critical hits.  (Default: false)
  :param boolean unblockable: Not modified by damage protections.  (Default: false)

.. function:: DamageIncrease(amount[, damage_type[, critical[, unblockable]]])

  Effect Damage Increase

  :param int amount: DAMAGE_BONUS_*
  :param int damage_type: DAMAGE_INDEX_* constant.  (Default: DAMAGE_INDEX_MAGICAL)
  :param boolean critical: Only applicable on critical hits.  (Default: false)
  :param boolean unblockable: Not modified by damage protections.  (Default: false)

.. function:: DamageRange(start, stop, [, damage_type[, critical[, unblockable]]])

  Effect Damage Increase

  :param int start: Minimum damage.
  :param int stop: Maximum damage.
  :param int damage_type: DAMAGE_INDEX_* constant.  (Default: DAMAGE_INDEX_MAGICAL)
  :param boolean critical: Only applicable on critical hits.  (Default false)
  :param boolean unblockable: Not modified by damage protections.  (Default false)

.. function:: DamageImmunity(damage_type, amount)

  Damage immunity effect.

  :param int damage_type: DAMAGE_INDEX_*
  :param int amount: 100, -1] or [1,100]

.. function:: DamageReduction(amount, power[, limit])

  Damage reduction effect.

  :param int amount: Amount
  :param int power: Power
  :param int limit: Limit.  (Default: 0)

.. function:: DamageResistance(damage_type, amount[, limit])

  Damage resistance effect.

  :param int damage_type: DAMAGE_INDEX_*
  :param int amount: Amount
  :param int limit: Limit.  (Default: 0)

.. function:: DamageShield(amount, random, damage_type[, chance])

  Damage Shield effect.

  :param int amount: Base damage
  :param int random: DAMAGE_BONUS_*
  :param int damage_type: DAMAGE_INDEX_*
  :param int chance: Chance of doing damage to attacker.  (Default: 100)

.. function:: Darkness()

  Create a Darkness effect.

.. function:: Dazed()

  Create a Daze effect.

.. function:: Deaf()

  Create a Deaf effect.

.. function:: Death(spectacular, feedback)

  Death effect

  :param boolean spectacular: Spectacular
  :param boolean feedback: Feedback

.. function:: Disappear([animation])

  Disappear effect.

  :param boolean animation: Use animation.  (Default: false)

.. function:: DisappearAppear(location[, animation])

  Disappear Appear effect.

  :param location: Location.
  :type location: :class:`Location`
  :param boolean animation: Use animation.  (Default: false)

.. function:: Disarm()

  Create Disarm effect

.. function:: Disease(disease)

  Create a Disease effect.

  :param int disease: DISEASE_*

.. function:: DispelMagicAll([caster_level])

  Create a Dispel gic All effect.

  :param int caster_level: The highest level spell to dispel.

.. function:: DispelMagicBest([caster_level])

  Create a Dispel gic Best effect.

  :param int caster_level: The highest level spell to dispel.

.. function:: Dominated()

  Create a Dominate effect.

.. function:: Entangle()

  Create an Entangle effect

.. function:: Ethereal()

  Creates a Sanctuary effect but the observers get no saving throw.

.. function:: Frightened()

  Create a frightened effect for use in making creatures shaken or flee.

.. function:: Haste()

  Create a Haste effect.

.. function:: Heal(amount)

  Creates a healing effect.

  :param int amount: Hit points to heal.

.. function:: HitPointChangeWhenDying(hitpoint_change)

  Create a Hit Point Change When Dying effect.

  :param int hitpoint_change: Positive or negative, but not zero.

.. function:: Icon(icon)

  Creates an icon effect

.. function:: Immunity(immunity[, amount])

  Create an Immunity effect.

  :param int immunity: One of the IUNITY_TYPE_* constants.
  :param int amount: Percent immunity.  (Default: 100)

.. function:: Invisibility(invisibilty_type)

  Create an Invisibility effect.

  :param int invisibilty_type: One of the INVISIBILITY_TYPE_* constants defining the type of invisibility to use.

.. function:: Knockdown()

  Create a Knockdown effect

.. function:: LinkEffects(child, parent)

  Creates one new effect object from two seperate effect objects.

  :param child: One of the two effects to link together.
  :type child: :class:`Effect`
  :param parent: One of the two effects to link together.
  :type parent: :class:`Effect`

.. function:: MissChance(percent, misstype)

  Creates a miss chance effect.

  :param int percent: [1,100].
  :param int misstype: MISS_CHANCE_TYPE_* constant.  (Default: MISS_CHANCE_TYPE_NORMAL)

.. function:: ModifyAttacks(attacks)

  Create a modify Attacks effect that adds attacks to the target.

  :param attacks: Maximum is 5, even with the effect stacked

.. function:: MovementSpeed(amount)

  Create a Movement Speed Increase/Decrease effect to slow target.

  :param int amount: If < 0 effect will cause a decrease by amount, it will be and increase if > 0


.. function:: NegativeLevel(amount, hp_bonus)

  Create a Negative Level effect that will decrease the level of the target.

  :param int amount: Number of levels
  :param int hp_bonus: TODO

.. function:: Paralyze()

  Create a Paralyze effect.

.. function:: Petrify()

  Creates an effect that will petrify a creature.

.. function:: Poison(poison)

  Create a Poison effect.

  poison
    The type of poison to use, as defined in the POISON_* constant group.

.. function:: Polymorph(polymorph[, locked])

  Create a Polymorph effect that changes the target into a different type of creature.

  :param int polymorph: POLYRPH_TYPE_*
  :param boolean locked: If true, player can't cancel polymorph.  (Default: false)

.. function:: RacialType(race)

.. function:: Regenerate(amount, interval)

  Create a Regenerate effect.

  :param int amount: Amount of damage to be regenerated per time interval
  :param float interval: Length of interval in seconds

.. function:: Resurrection()

  Create a Resurrection effect.

.. function:: Sanctuary(dc)

  Creates a sanctuary effect.

  :param int dc: Must be a non-zero, positive number.

.. function:: SavingThrow(save, amount[, save_type])

  Create a Saving Throw Increase/Decrease effect to modify one Saving Throw type.

  :param int save: The Saving Throw to affect, as defined by the SAVING_THROW_* constants group.
  :param int amount: The amount to modify the saving throws by.  If > 0 an increase, if < 0 a decrease.
  :param int save_type: The type of resistance this effect applies to as defined by the SAVING_THROW_VS_* constants group.  (Default: SAVING_THROW_TYPE_ALL)

.. function:: SeeInvisible()

  Create a See Invisible effect.

.. function:: Silence()

  Create a Silence effect

.. function:: Skill(skill, amount)

  Returns an effect to decrease a skill.

  :param int skill: SKILL_*
  :param int amount: The amount to modify the skill by.  If > 0 an increase, if < 0 a decrease.

.. function:: Sleep()

  Creates a sleep effect.

.. function:: Slow()

  Creates a slow effect.

.. function:: SpellFailure(percent, spell_school)

  Creates an effect that inhibits spells.

  :param int percent:     Percent chance of spell failing (1 to 100).  (Default: 100)
  :param int spell_school: SPELL_SCHOOL_*.  (Default: SPELL_SCHOOL_GENERAL)

.. function:: SpellImmunity(spell)

  Returns an effect of spell immunity.

  :param int spell: SPELL_* (Default: SPELL_ALL_SPELLS)

.. function:: SpellLevelAbsorption(max_level, max_spells, school)

  Creates a Spell Level Absorption effect

  :param int max_level: Highest spell level that can be absorbed.
  :param int max_spells: Maximum number of spells to absorb
  :param int school: SPELL_SCHOOL_*.  Default: SPELL_SCHOOL_GENERAL

.. function:: SpellResistance(amount)

  Create spell resistance effect.

  :param int amount: If > 0 an increase, if < 0 a decrease

.. function:: Stunned()
  Creates a Stunned effect

.. function:: SummonCreature(resref[, vfx[, delay[, appear]]])

  Summon Creature Effect

  :param string resref: Identifies the creature to be summoned by resref name.
  :param int vfx: VFX_*.  (Default: VFX_NONE)
  :param float delay: There can be delay between the visual effect being played, and the creature being added to the area.  (Default: 0.0)
  :param boolean appear: (Default: false)

.. function:: Swarm(looping, resref1[, resref2[, resref3[, resref4]]])

  Summon swarm effect.

  :param boolean looping: If this is ``true``, for the duration of the effect when one creature created by this effect dies, the next one in the list will be created. If the last creature in the list dies, we loop back to the beginning and sCreatureTemplate1 will be created, and so on...
  :param string resref1: Blueprint of first creature to spawn
  :param string resref2: Optional blueprint for second creature to spawn.
  :param string resref3: Optional blueprint for third creature to spawn.
  :param string resref4: Optional blueprint for fourth creature to spawn.

.. function:: TemporaryHitpoints(amount)

  Create a Temporary Hitpoints effect that raises the Hitpoints of the target.

  :param int amount: A positive integer

.. function:: TimeStop()

  Create a Time Stop effect.

.. function:: TrueSeeing()

  Creates a True Seeing effect.

.. function:: Turned()

  Create a Turned effect.

.. function:: TurnResistance(amount)

  Create a Turn Resistance Increase/Decrease effect that can make creatures more susceptible to turning.

  :param int amount: If > 0 an increase, if < 0 a decrease.

.. function:: Ultravision()

  Creates an Ultravision effect

.. function:: VisualEffect(id[, miss])

  Creates a new visual effect

  :param int id: The visual effect to be applied.
  :param boolean miss: If this is true, a random vector near or past the target will be generated, on which to play the effect.  (Default: false)

.. function:: Wounding (amount)

  Creates a wounding effect

  :param int amount: Amount of damage to do each round
