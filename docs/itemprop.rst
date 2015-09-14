.. default-domain:: lua
.. highlight:: lua

.. module:: itemprop

.. warning::

  There are some non-default behaviors currently here.

Itemprop
========

.. function:: AbilityScore(ability, mod)

  Create Ability bonus/penalty item property.

  :param int ability: ABILITY_*
  :param int mod: bonus: [1, 12], Penalty [-12, -1]

.. function:: ArmorClass(value)

  Create AC item property

  :param int value: Bonus: [1,20] Penalty [-20, -1]

.. function:: Additional(addition)

  Creates additional item property

  :param int addition: IP_CONST_ADDITIONAL_*

.. function:: ArcaneSpellFailure(value)

  Create arcane spell failure item property

  :param int value: [1-100]

.. function:: AttackModifier(value)

  Creatures attack modifier item property

  :param int value: Amount attack bonus is modified.

.. function:: BonusFeat(feat)

  Item Property Bonus Feat

  :param int feat: IP_CONST_FEAT_*

.. function:: BonusLevelSpell(class, level)

  Creates a "bonus spell of a specified level" itemproperty.

  :param int class: solstice.class constant
  :param int level: [0, 9]

.. function:: CastSpell(spell, uses)

  Creates a "cast spell" itemproperty.

  :param int spell: IP_CONST_CASTSPELL_*
  :param int uses: IP_CONST_CASTSPELL_NUMUSES_*

.. function:: ContainerReducedWeight(amount)

  Create a "reduced weight container" itemproperty.

  :param int amount: IP_CONST_CONTAINERWEIGHTRED_*

.. function:: DamageBonus(damage_type, damage)

  Creates a damage bonus itemproperty.

  :param int damage_type: DAMAGE_INDEX_*
  :param int damage: DAMAMGE_BONUS_*

.. function:: DamageRange(damage_type, min, max)

  Creates a damage range itemproperty.

  :param int damage_type: DAMAGE_INDEX_*
  :param int min: Minimum damage.
  :param int max: Maximum damage.

.. function:: DamageImmunity(damage_type, amount)

  Creates a damage immunity itemproperty.

  .. note::
    If you are using CEP and CEP is set to true in your global options then you can pass values 1-100, otherwise you will have to pass the item property constants.

  :param int damage_type: DAMAGE_INDEX_*
  :param int amount: Amount.

.. function:: DamagePenalty(amount)

  Creates a damage penalty itemproperty.

  :param int amount: [1,5]

.. function:: DamageReduction(enhancement, soak)

  Creates a damage reduction itemproperty.

  .. note::
    If you are using CEP then values can be passed for the soak parameter rather
    than IP_CONST_SOAK_*.  The value must be a multiple of 5 and in the range [5, 100]

  :param int enhancement: [1,20]
  :param int soak: Amount soaked.

.. function:: DamageResistance(damage_type, amount)

  Creates damage resistance item property.

  If you are using CEP then values can be passed for the amount parameter rather
  than IP_CONST_RESIST_*.  The value must be a multiple of 5 and in the range
  [5, 100]

  :param int damage_type: DAMAGE_INDEX_*
  :param int amount: Resist value.

.. function:: DamageVulnerability(damage_type, amount)

  Creates damage vulnerability item property.

  If you are using CEP and CEP is set to true in your global options then you can pass values 1-100,
  otherwise you will have to pass the item property constants.

  :param int damage_type: DAMAGE_INDEX_*
  :param int amount: Amount.

.. function:: Darkvision()

  Creates Darkvision Item Property

.. function:: EnhancementModifier(amount)

  Item Property Enhancement Bonus

  :param int amount: If greater than 0 enhancment bonus, else penalty

.. function:: ExtraDamageType(damage_type, is_ranged)

  Creates an "extra damage type" item property.

  :param int damage_type: DAMAGE_INDEX_*
  :param boolean is_ranged: ExtraRangedDamge if true, melee if false.

.. function:: Freedom()

  Creates a free action (freedom of movement) itemproperty.

.. function:: Haste()

  Creates haste item property.

.. function:: HealersKit(modifier)

  Creates a healers' kit item property.

  :param int modifier: [1,12]

.. function:: HolyAvenger()

  Creates Holy Avenger item propety.

.. function:: ImmunityMisc(immumity_type)

  Creates immunity item property

  :param int immumity_type: IMMUNITY_TYPE_*

.. function:: ImprovedEvasion()

  Creates Improved evasion item property.

.. function:: Keen()

  Creates keen item property

.. function:: Light(brightness, color)

  Creates a light item property.

  :param int brightness: IP_CONST_LIGHTBRIGHTNESS_*
  :param int color: IP_CONST_LIGHTCOLOR_*

.. function:: LimitUseByClass(class)

  Creates a class use limitation item property

  :param int class: CLASS_TYPE_*

.. function:: LimitUseByRace(race)

  Creates a race use limitation item property

  :param int race: RACIAL_TYPE_*

.. function:: MassiveCritical(damage)

  Creates a massive criticals item property.


  :param int damage: DAMAGE_BONUS_*

.. function:: Material(material)

  Creates material item property

  :param int material: The material type should be [0, 77] based on iprp_matcost.2da.

.. function:: Mighty(value)

  Creates a mighty item property.

  :param int value: [1,20]

.. function:: MonsterDamage(damage)

  Creates Monster Damage effect.

  :param int damage: IP_CONST_MONSTERDAMAGE_*

.. function:: NoDamage()

  Creates no damage item property

.. function:: OnHitCastSpell(spell, level)

  Creates an "on hit cast spell" item property.

  :param int spell: IP_CONST_ONHIT_CASTSPELL_*
  :param int level: Level spell is cast at.

.. function:: OnHitMonster(prop, special)

  Creates on monster hit item property.

  .. WARNING::
    Item property is bugged.  See NWN Lexicon.

  :param int prop: IP_CONST_ONMONSTERHIT_*
  :param int special: Unknown

.. function:: OnHitProps(prop, dc, special)

  Creates an OnHit itemproperty.

  :param int prop: IP_CONST_ONHIT_*
  :param int dc: IP_CONST_ONHIT_SAVEDC_*
  :param int special: Meaning varies with type. (Default: 0)

.. function:: Quality(quality)

  Creates quality item property

  :param int quality: IP_CONST_QUALITY_*

.. function:: Regeneration(amount)

  Creates a regeneration item property.

  :param int amount: 1, 20]

.. function:: SavingThrow(save_type, amount)

  Creates saving throw bonus item property

  :param int save_type: SAVING_THROW_*
  :param int amount: 1,20] or [-20, -1]

.. function:: SavingThrowVersus(save_type, amount)

  Creates saving throw bonus vs item property

  :param int save_type: SAVING_THROW_VS_*
  :param int amount: 1,20] or [-20, -1]

.. function:: SkillModifier(skill, amount)

  Creates skill modifier item property

  :param int skill: solstice.skill type constant.
  :param int amount: 1, 50] or [-10, -1]

.. function:: SpecialWalk([walk])

  Creates a special walk itemproperty.

  :param int walk: Only 0 is a valid argument

.. function:: SpellImmunityLevel(level)

  Create an "immunity to spell level" item property.

  :param int level: Spell level [1,9]

.. function:: SpellImmunitySpecific(spell)

  Creates an "immunity to specific spell" itemproperty.

  :param int spell: IP_CONST_IMMUNITYSPELL_*

.. function:: SpellImmunitySchool(school)

  Creates an "immunity against spell school" itemproperty.

  :param int school: IP_CONST_SPELLSCHOOL_*

.. function:: SpellResistance(amount)

  Creates a spell resistince item property

  :param int amount: IP_CONST_SPELLRESISTANCEBONUS_*

.. function:: ThievesTools(modifier)

  Creates a thieves tool item property

  :param int modifier: [1, 12]

.. function:: Trap(level, trap_type)

  Creates a trap item property

  :param int level: IP_CONST_TRAPSTRENGTH_*
  :param int trap_type: IP_CONST_TRAPTYPE_*

.. function:: TrueSeeing()

  Creates true seeing item property

.. function:: TurnResistance(modifier)

  Creates a turn resistance item property.

  :param int modifier: [1, 50]

.. function:: UnlimitedAmmo([ammo])

  Creates an unlimited ammo itemproperty.

  :param int ammo: IP_CONST_UNLIMITEDAMMO_* (Default: IP_CONST_UNLIMITEDAMMO_BASIC)

.. function:: VampiricRegeneration(amount)

  Creates vampiric regeneration effect.

  :param int amount: [1,20]

.. function:: VisualEffect(effect)

  Creates a visual effect item property

  :param int effect: IP_CONST_VISUAL_*

.. function:: WeightIncrease(amount)

  Item Property Weight Increase

  :param int amount: IP_CONST_WEIGHTINCREASE_*

.. function:: WeightReduction(amount)

  Item Property Weight Reuction

  :param int amount: IP_CONST_REDUCEDWEIGHT_*
