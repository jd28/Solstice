.. default-domain:: lua
.. highlight:: lua

.. module:: itemprop

Itemprop
========

Functions
---------

.. function:: AbilityScore(ability, mod)

  Create Ability bonus/penalty item property.

  **Arguments:**

  ability : ``int``
    ABILITY_*
  mod : ``int``
    bonus: [1, 12], Penalty [-12, -1]

.. function:: ArmorClass(value)

  Create AC item property

  **Arguments:**

  value : ``int``
    Bonus: [1,20] Penalty [-20, -1]

.. function:: Additional(addition)

  Creates additional item property

  **Arguments:**

  addition
    IP_CONST_ADDITIONAL_*

.. function:: ArcaneSpellFailure(value)

  Create arcane spell failure item property

  **Arguments:**

  value
    [1-100]

.. function:: AttackModifier(value)

  Creatures attack modifier item property

  **Arguments:**

  value : int
    Amount attack bonus is modified.

.. function:: BonusFeat(feat)

  Item Property Bonus Feat

  **Arguments:**

  feat
    IP_CONST_FEAT_*

.. function:: BonusLevelSpell(class, level)

  Creates a "bonus spell of a specified level" itemproperty.

  **Arguments:**

  class
    solstice.class constant
  level
    [0, 9]

.. function:: CastSpell(spell, uses)

  Creates a "cast spell" itemproperty.

  **Arguments:**

  spell
    IP_CONST_CASTSPELL_*
  uses
    IP_CONST_CASTSPELL_NUMUSES_*

.. function:: ContainerReducedWeight(amount)

  Create a "reduced weight container" itemproperty.

  **Arguments:**

  amount
    IP_CONST_CONTAINERWEIGHTRED_*

.. function:: DamageBonus(damage_type, damage)

  Creates a damage bonus itemproperty.

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  damage
    DAMAMGE_BONUS_*

.. function:: DamageRange(damage_type, min, max)

  Creates a damage range itemproperty.

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  min
    Minimum damage.
  max
    Maximum damage.

.. function:: DamageImmunity(damage_type, amount)

  Creates a damage immunity itemproperty.

  .. note::
    If you are using CEP and CEP is set to true in your global options then you can pass values 1-100, otherwise you will have to pass the item property constants.

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  amount
    Amount.

.. function:: DamagePenalty(amount)

  Creates a damage penalty itemproperty.

  **Arguments:**

  amount
    [1,5]

.. function:: DamageReduction(enhancement, soak)

  Creates a damage reduction itemproperty.

  .. note::
    If you are using CEP then values can be passed for the soak parameter rather
    than IP_CONST_SOAK_*.  The value must be a multiple of 5 and in the range [5, 100]

  **Arguments:**

  enhancement
    [1,20]
  soak
    Amount soaked.

.. function:: DamageResistance(damage_type, amount)

  Creates damage resistance item property.

  If you are using CEP then values can be passed for the amount parameter rather
  than IP_CONST_RESIST_*.  The value must be a multiple of 5 and in the range
  [5, 100]

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  amount
    Resist value.

.. function:: DamageVulnerability(damage_type, amount)

  Creates damage vulnerability item property.

  If you are using CEP and CEP is set to true in your global options then you can pass values 1-100,
  otherwise you will have to pass the item property constants.

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  amount
    Amount.

.. function:: Darkvision()

  Creates Darkvision Item Property

.. function:: EnhancementModifier(amount)

  Item Property Enhancement Bonus

  **Arguments:**

  amount
    If greater than 0 enhancment bonus, else penalty

.. function:: ExtraDamageType(damage_type, is_ranged)

  Creates an "extra damage type" item property.

  **Arguments:**

  damage_type
    DAMAGE_INDEX_*
  is_ranged
    ExtraRangedDamge if true, melee if false.

.. function:: Freedom()

  Creates a free action (freedom of movement) itemproperty.

.. function:: Haste()

  Creates haste item property.

.. function:: HealersKit(modifier)

  Creates a healers' kit item property.

  **Arguments:**

  modifier
    [1,12]

.. function:: HolyAvenger()

  Creates Holy Avenger item propety.

.. function:: ImmunityMisc(immumity_type)

  Creates immunity item property

  **Arguments:**

  immumity_type
    IMMUNITY_TYPE_*

.. function:: ImprovedEvasion()

  Creates Improved evasion item property.

.. function:: Keen()

  Creates keen item property

.. function:: Light(brightness, color)

  Creates a light item property.

  **Arguments:**

  brightness
    IP_CONST_LIGHTBRIGHTNESS_*
  color
    IP_CONST_LIGHTCOLOR_*

.. function:: LimitUseByClass(class)

  Creates a class use limitation item property

  **Arguments:**

  class
    CLASS_TYPE_*

.. function:: LimitUseByRace(race)

  Creates a race use limitation item property

  **Arguments:**

  race
    RACIAL_TYPE_*

.. function:: MassiveCritical(damage)

  Creates a massive criticals item property.


  **Arguments:**

  damage
    DAMAGE_BONUS_*

.. function:: Material(material)

  Creates material item property

  **Arguments:**

  material
    The material type should be [0, 77] based on iprp_matcost.2da.

.. function:: Mighty(value)

  Creates a mighty item property.

  **Arguments:**

  value
    [1,20]

.. function:: MonsterDamage(damage)

  Creates Monster Damage effect.

  **Arguments:**

  damage
    IP_CONST_MONSTERDAMAGE_*

.. function:: NoDamage()

  Creates no damage item property

.. function:: OnHitCastSpell(spell, level)

  Creates an "on hit cast spell" item property.

  **Arguments:**

  spell
    IP_CONST_ONHIT_CASTSPELL_*
  level
    Level spell is cast at.

.. function:: OnHitMonster(prop, special)

  Creates on monster hit item property.

  .. WARNING::
    Item property is bugged.  See NWN Lexicon.

  **Arguments:**

  prop
    IP_CONST_ONMONSTERHIT_*
  special
    Unknown

.. function:: OnHitProps(prop, dc, special)

  Creates an OnHit itemproperty.

  **Arguments:**

  prop
    IP_CONST_ONHIT_*
  dc
    IP_CONST_ONHIT_SAVEDC_*
  special: Meaning varies with type. (Default
    0)

.. function:: Quality(quality)

  Creates quality item property

  **Arguments:**

  quality
    IP_CONST_QUALITY_*

.. function:: Regeneration(amount)

  Creates a regeneration item property.

  **Arguments:**

  amount
    [1, 20]

.. function:: SavingThrow(save_type, amount)

  Creates saving throw bonus item property

  **Arguments:**

  save_type
    SAVING_THROW_*
  amount
    [1,20] or [-20, -1]

.. function:: SavingThrowVersus(save_type, amount)

  Creates saving throw bonus vs item property

  **Arguments:**

  save_type
    SAVING_THROW_VS_*
  amount
    [1,20] or [-20, -1]

.. function:: SkillModifier(skill, amount)

  Creates skill modifier item property

  **Arguments:**

  skill
    solstice.skill type constant.
  amount
    [1, 50] or [-10, -1]

.. function:: SpecialWalk(walk)

  Creates a special walk itemproperty.

  walk: Optional
    Only 0 is a valid argument

.. function:: SpellImmunityLevel(level)

  Create an "immunity to spell level" item property.

  **Arguments:**

  level
    Spell level [1,9]

.. function:: SpellImmunitySpecific(spell)

  Creates an "immunity to specific spell" itemproperty.

  **Arguments:**

  spell
    IP_CONST_IMMUNITYSPELL_*

.. function:: SpellImmunitySchool(school)

  Creates an "immunity against spell school" itemproperty.

  **Arguments:**

  school
    IP_CONST_SPELLSCHOOL_*

.. function:: SpellResistance(amount)

  Creates a spell resistince item property

  **Arguments:**

  amount
    IP_CONST_SPELLRESISTANCEBONUS_*

.. function:: ThievesTools(modifier)

  Creates a thieves tool item property

  **Arguments:**

  modifier
    [1, 12]

.. function:: Trap(level, trap_type)

  Creates a trap item property

  **Arguments:**

  level
    IP_CONST_TRAPSTRENGTH_*
  trap_type
    IP_CONST_TRAPTYPE_*

.. function:: TrueSeeing()

  Creates true seeing item property

.. function:: TurnResistance(modifier)

  Creates a turn resistance item property.

  **Arguments:**

  modifier
    [1, 50]

.. function:: UnlimitedAmmo([ammo])

  Creates an unlimited ammo itemproperty.

  **Arguments:**

  ammo : ``int``, optional
    IP_CONST_UNLIMITEDAMMO_* (Default: IP_CONST_UNLIMITEDAMMO_BASIC)

.. function:: VampiricRegeneration(amount)

  Creates vampiric regeneration effect.

  **Arguments:**

  amount
    [1,20]

.. function:: VisualEffect(effect)

  Creates a visual effect item property

  **Arguments:**

  effect
    IP_CONST_VISUAL_*

.. function:: WeightIncrease(amount)

  Item Property Weight Increase

  **Arguments:**

  amount
    IP_CONST_WEIGHTINCREASE_*

.. function:: WeightReduction(amount)

  Item Property Weight Reuction

  **Arguments:**

  amount
    IP_CONST_REDUCEDWEIGHT_*
