.. highlight:: lua
.. default-domain:: lua

.. module:: rules

Rules
=====

Abilities
---------

.. function:: GetAbilityName(ability)

  Gets the name of an ability.

  **Arguments**

  ability : ``int``
    ABILITY_*

.. function:: GetAbilityEffectLimits(cre, ability)

  Get the limits of ability effects

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  ability : ``int``
    ABILITY_*

  **Returns**

  - -12
  - 12

.. function:: GetAbilityEffectModifier(cre, ability)

  Get ability modification from effects.

  .. warning::
    This currently does not provide default behavior.  Everything stacks: items, spells, etc.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  ability : ``int``
    ABILITY_*

Classes
-------

.. function:: GetBaseAttackBonus(cre[, pre_epic])

  Get base attack bonus.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  pre_epic : ``bool``
    Only calculate pre-epic BAB.


.. function:: CanUseClassAbilities(cre, class)

  Determine if creature can use class abilites.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  class : ``int``
    CLASS_TYPE_*

.. function:: SetCanUseClassAbilitiesOverride(class, func)

  Registers a class ability handler.

  **Example**

  .. code-block:: lua

    local function monk(cre, class)
       local level = cre:GetLevelByClass(class)
       if level == 0 then return false, 0 end

       if not cre:GetIsPolymorphed() then
          local chest = cre:GetItemInSlot(INVENTORY_SLOT_CHEST)
          if chest:GetIsValid() and chest:ComputeArmorClass() > 0 then
             return false, level
          end

          local shield = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
          if shield:GetIsValid() and
             (shield:GetBaseType() == BASE_ITEM_SMALLSHIELD
              or shield:GetBaseType() == BASE_ITEM_LARGESHIELD
              or shield:GetBaseType() == BASE_ITEM_TOWERSHIELD)
          then
             return false, level
          end
       end

       return true, level
    end

    Rules.SetCanUseClassAbilitiesOverride(CLASS_TYPE_MONK, monk)

  **Arguments**

  class : ``int``
    CLASS_TYPE_*
  func : ``function``
    A function that takes a creature and optionally a CLASS_TYPE_* argument and returns
    a boolean indicating whether the creature can use the abilities for the class and the
    creatures class level.  NOTE: you must return both or an assertion will fail.

.. function:: GetLevelBonusFeats(cre, class, level)

  Get bonus feats for level.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  class : ``int``
    CLASS_TYPE_*
  level : ``int``
    Class level.

.. function:: GetClassName(class)

  Get class name.

  **Arguments**

  class : ``int``
    CLASS_TYPE_*

.. function:: GetSkillPointsGainedOnLevelUp(class, pc)

  Get number of skillpoints class gains on level up.

  **Arguments**

  class : ``int``
    CLASS_TYPE_*
  pc : :class:`Creature`
    Creature instance.

.. function:: GetHitPointsGainedOnLevelUp(class, pc)

  Get number of hitpoints class gains on level up.

  **Arguments**

  class : ``int``
    CLASS_TYPE_*
  pc : :class:`Creature`
    Creature instance.

Combat
------

.. data:: CombatEngine

  Table CombatEngine

  **Fields**

  DoPreAttack : ``function``
    Function to do pre-attack initialization, taking
    attacker and target object instances.  Note that since DoMeleeAttack,
    and DoRangedAttack have no parameters, the very least you need to do
    is store those in local variables for later use.
  DoMeleeAttack : ``function``
    Function to do a melee attack.
  DoRangedAttack : ``function``
    Function to do a ranged attack.
  UpdateCombatInformation : ``function``
    Update combat information function,
    taking a Creature object instance.  This is optional can be used to do
    any other book keeping you might need.

.. function:: RegisterCombatEngine(engine)

  Register a combat engine.

  **Arguments**

  engine : :data:`CombatEngine`
    Combat engine.

.. function:: GetCombatEngine()

  Get current combat engine.

.. function:: SetCombatEngineActive(active)

  Set combat engine active.  This is implicitly called by RegisterCombatEngine.

  **Arguments**

  active : ``bool``
    Turn combat engine on or off.

Combat Modifiers
----------------

.. function:: ZeroCombatModifier(cre, mod)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  mod : ``int``
    COMBAT_MOD_*

.. function:: GetAreaCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetClassCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetFeatCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetRaceCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetSizeCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetSkillCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetTrainingVsCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetFavoredEnemyCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetAbilityCombatModifier(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: ResolveCombatModifier(type, cre)

  Resolves combat modifier.

  **Arguments**

  type : ``int``
    COMBAT_MOD\_*
  cre : :class:`Creature`
    Creature instance.

.. function:: ResolveCombatModifiers(cre)

  Resolves all combat modifiers

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: SetCombatModifierOverride(type, func)

  Sets combat modifier override.

  **Arguments**

  type : ``int``
    COMBAT_MOD\_*
  func : ``function``
    (:class:`Creature`) -> ``nil``

Concealment
-----------

.. function:: GetConcealment(cre, vs, is_ranged)

  Determine concealment.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  vs : :class:`Creature`
    Creature instance.
  is_ranged : ``bool``
    Check versus ranged attack.

Constants
---------

.. function:: RegisterConstants(tda, column_label[, extract[, value_label[, value_type]]])

  Register constant loader.

  tda : ``string``
    2da name (without .2da)
  column_label : ``string``
    Label of the 2da column that contains constant names.
  extract : ``string``
    A lua string.match pattern for extracting a constant name.
    E,g: `"FEAT_([%w_]+)"` to strip off 'FEAT\_'
  value_label : ``string``
    Label of the 2da column that contains the constants value.  If not passed constant
    value will be the 2da row number.
  value_type : ``string``
    Constant type.  Only used when ``value_label`` is passed. Legal values: "int", "string", "float"

.. function:: RegisterConstant(name, value)

  Register constant in global constant table.

  **Arguments**

  name : ``string``
    Constant's name.
  value
    Consants's value.  Can be any Lua object.

.. function:: ConvertSaveToItempropConstant(const)

  **Arguments**

  const : ``int``
    SAVING_THROW\_*

.. function:: ConvertSaveVsToItempropConstant(const)

  **Arguments**

  const : ``int``
    SAVING_THROW_VS\_*

.. function:: ConvertImmunityToIPConstant(const)

  **Arguments**

  const : ``int``
    IMMUNITY_TYPE\_*

Damage
------

.. function:: GetDamageName(index)

  **Arguments**

  index : ``int``
    DAMAGE_INDEX_*

.. function:: GetDamageColor(index)

  **Arguments**

  index : ``int``
    DAMAGE_INDEX_*

.. function:: GetDamageVisual(dmg)

  **Arguments**

  dmg : ``int``
    DAMAGE_INDEX_*

.. function:: ConvertDamageToItempropConstant(const)

.. function:: ConvertDamageIndexToItempropConstant(const)

.. function:: ConvertItempropConstantToDamageIndex(const)

.. function:: UnpackItempropDamageRoll(ip)

.. function:: UnpackItempropMonsterRoll(ip)

Damage Reduction
----------------

.. function:: GetBaseDamageImmunity(cre, dmgidx)

  Get base damage immunity.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  dmgidx : ``int``
    DAMAGE_INDEX_*

.. function:: SetBaseDamageImmunityOverride(func, ...)

  Sets a damage immunity override function.

  **Example**

  .. code-block:: lua

    local function rdd(cre)
       local res = 0
       if cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 10 then
          res = 100
       end
       return res
    end

    Rules.SetBaseDamageImmunityOverride(rdd, DAMAGE_INDEX_FIRE)

  **Arguments**

  func : ``function``
    (:class:`Creature`) -> ``int``

  ...
    DAMAGE_INDEX\_* constants.

.. function:: GetBaseDamageReduction(cre)

  Get base damage reduction.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetBaseDamageResistance(cre, dmgidx)

  Get base damage resistance.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  dmgidx
    DAMAGE_INDEX\_* constants.

.. function:: SetBaseDamageResistanceOverride(func, ...)

  Sets a damage resistance override function.

  **Arguments**

  func : ``function``
    (:class:`Creature`) -> ``int``

  ...
    DAMAGE_INDEX\_* constants.

Effects
-------

.. function:: UpdateAttackBonusEffects(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: UpdateAbilityEffects(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: UpdateMiscImmunityEffects(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: UpdateDamageImmunityEffects(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

Feats
-----

.. function:: GetMaximumFeatUses(feat[, cre])

  Determines a creatures maximum feat uses.

  **Arguments**

  feat : ``int``
    FEAT_*
  cre : :class:`Creature`
    Creature instance.

.. function:: RegisterFeatUses(func, ...)

  Register a function to determine maximum feat uses.

  **Arguments**

  func
    A function taking two argument, a Creature instance and and a FEAT\_* constant.

  ...
    Vararg list FEAT\_* constants.

.. function:: GetFeatSuccessors(feat)

  Get array of feats successors.

  **Arguments**

  feat : ``int``
    FEAT\_*

  **Returns**

  An array of FEAT\_* constants.

.. function:: GetFeatIsFirstLevelOnly(feat)

  Determine is first level feat only.

  **Arguments**

  feat : ``int``
    FEAT_*

.. function:: GetFeatName(feat)

  Get feat name.

  **Arguments**

  feat : ``int``
    FEAT_*

.. function:: GetIsClassGeneralFeat(feat, class)

  Determine if feat is class general feat.

  **Arguments**

  feat : ``int``
    FEAT_*
  class : ``int``
    CLASS_TYPE_*

.. function:: GetIsClassBonusFeat(feat, class)

  Determine if feat is class bonus feat.

  **Arguments**

  feat : ``int``
    FEAT_*
  class : ``int``
    CLASS_TYPE_*

.. function:: GetIsClassGrantedFeat(feat, class)

  Determine if feat is class granted feat.

  **Arguments**

  feat : ``int``
    FEAT_*
  class : ``int``
    CLASS_TYPE_*

.. function:: GetMasterFeatName(master)

  Get Master Feat Name

  master : ``int``
    master feat

Hitpoints
---------

.. function:: GetMaxHitPoints(cre)

  Determine Maximum Hitpoints.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

Immunities
----------

.. function:: GetInnateImmunity(imm, cre)

  Get innate immunity.

  **Arguments**

  imm : ``int``
    IMMUNITY_TYPE\_* constant.
  cre : :class:`Creature`
    Creature instance.

.. function:: SetInnateImmunityOverride(func, ...)

  **Arguments**

  func : ``function``
    Function taking a creature parameter and returning a percent immunity.
  ... : ``int[]``
    List of IMMUNITY_TYPE\_* constants.

.. function:: GetEffectImmunity(cre, imm, vs)

  Determine if creature has an immunity.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  imm : ``int``
    IMMUNITY_TYPE\_* constant.
  vs : :class:`Creature`
    ``cre``'s attacker.

Levels
------

.. function:: GetXPLevelRequirement(level)

  Determine XP requirements for level.

  **Arguments**

  level : ``int``
    Class level.

.. function:: GetGainsStatOnLevelUp(level)

  Determine if an ability score is gained on level up.

  **Arguments**

  level : ``int``
    Class level.

.. function:: GainsFeatAtLevel(level)

  Determine if a feat is gained on level up.

  **Arguments**

  level : ``int``
    Class level.

Modes
-----

.. function:: RegisterMode(mode, f)

  **Arguments**

.. function:: ResolveMode(mode, cre, off)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: ToAction(mode)

  **Arguments**

Races
-----

.. function:: GetRaceAbilityBonus(race, ability)

  Determine race's ability bonus.

  **Arguments**

  race : ``int``
    RACIAL_TYPE_*
  ability : ``int``
    ABILITY_*

Saves
-----

.. function:: GetSaveEffectLimits(cre, save, save_vs)

  Get save effect limits.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  save
    SAVING_THROW\_* constant.
  save_vs
    SAVING_THROW_VS\_* constant.

  **Returns**

  - -20
  - 20

.. function:: GetSaveEffectBonus(cre, save, save_vs)

  Get save effect bonus unclamped.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

Situations
----------

.. function:: ZeroSituationMod(cre, situ)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: SetSituationModiferOverride(situation, func)

.. function:: ResolveSituationModifier(type, cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: ResolveSituationModifiers(cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

Skills
------

.. function:: GetSkillAbility(skill)

  Get skill's associated ability.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillAllCanUse(skill)

  Check if skill requires training.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillHasArmorCheckPenalty(skill)

  Check if skill has armor check penalty.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillIsUntrained(skill)

  Check if skill requires training.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillName(skill)

  Get Skill name.

  **Arguments**

  skill : ``int``
    SKILL_*

.. function:: GetSkillArmorCheckPenalty(cre, skill)

  Determine penalty from armor/shield.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: GetSkillFeatBonus(cre, skill)

  Get Skill Bonuses from feats.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: GetSkillEffectLimits(cre, skill)

  Get the limits of skill effects

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

  **Returns**

  - -50
  - 50

.. function:: GetSkillEffectModifier(cre, skill)

  Get skill modification from effects.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  skill : ``int``
    SKILL_*

.. function:: CanUseSkill(skill, cre)

  Determines if a creature can use a skill.

  **Arguments**

  skill : ``int``
    SKILL_*
  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsClassSkill(skill, class)

  Determines if a skill is a class skill.

  **Arguments**

  skill : ``int``
    SKILL_*
  class : ``int``
    CLASS_TYPE_*

Special Attacks
---------------

.. function:: GetSpecialAttackDamage(special_attack, info, attacker, target)

  Determine special attack damage.

  **Arguments**

  special_attack
    SPECIAL_ATTACK\_*
  info
    Attack ctype from combat engine.
  attacker
    Attacking creature.
  target
    Attacked creature.

.. function:: GetSpecialAttackEffect(special_attack, info, attacker, target)

  Determine special attack effect.

  **Arguments**

  special_attack
    SPECIAL_ATTACK\_*
  info
    Attack ctype from combat engine.
  attacker
    Attacking creature.
  target
    Attacked creature.

.. function:: GetSpecialAttackModifier(special_attack, info, attacker, target)

  Determine special attack bonus modifier.

  **Arguments**

  special_attack
    SPECIAL_ATTACK\_*
  info
    Attack ctype from combat engine.
  attacker
    Attacking creature.
  target
    Attacked creature.

.. function:: RegisterSpecialAttack(special_attack, damage, effect, attack)

  Register special attack handlers.

  **Arguments**

  special_attack
    SPECIAL_ATTACK\_*
  damage
    See :func:`GetSpecialAttackDamage`
  effect
    See :func:`GetSpecialAttackEffect`
  attack
    See :func:`GetSpecialAttackModifier`

Weapons
-------

.. function:: BaseitemToWeapon(base)

.. function:: GetWeaponFeat(masterfeat, basetype)

.. function:: SetWeaponFeat(masterfeat, basetype, feat)

.. function:: GetWeaponType(item)

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetIsMonkWeapon(item, cre)

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsRangedWeapon(item)

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetIsWeaponLight(item, cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsWeaponSimple(item, cre)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetIsWeaponFinessable(item, cre)

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponIteration(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponAttackAbility(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponDamageAbility(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: SetWeaponAttackAbilityOverride(ability, func)

  **Arguments**

  ability : ``int``
    ABILITY_*

.. function:: SetWeaponDamageAbilityOverride(ability, func)

  **Arguments**

  ability : ``int``
    ABILITY_*

.. function:: GetWeaponAttackBonus(cre, weap)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponPower(cre, item)

  Determine weapons damage power.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponBaseDamageType(item)

  Determine weapons base damage type.

  .. note::

    This does not support multiple weapon damage types and most likely never will.

  **Arguments**

  item : :class:`Item`
    Item instance.

.. function:: GetWeaponBaseDamage(item, cre)

  Determine weapons base damage roll.

  **Arguments**

  item : :class:`Item`
    Item instance.
  cre : :class:`Creature`
    Creature instance.

.. function:: GetUnarmedDamageBonus(cre)

  Determine unarmed damage bonus.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetWeaponCritRange(cre, item)

  Determine weapons critical hit range.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetWeaponCritMultiplier(cre, item)

  Determine weapons critical hit multiplier.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.

.. function:: GetDualWieldPenalty(cre)

  Get dual wielding penalty.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: AttackTypeToEquipType(atype)

  **Arguments**

  atype : ``int``
    ATTACK_TYPE\_*

  **Returns**

  EQUIP_TYPE\_*

.. function:: EquipTypeToAttackType(atype)

  **Arguments**

  atype : ``int``
    EQUIP_TYPE\_*

  **Returns**

  ATTACK_TYPE\_*

.. function:: InventorySlotToAttackType(atype)

  **Arguments**

  atype : ``int``
    Inventory slot constant.

  **Returns**

  ATTACK_TYPE\_*

.. function:: GetOnhandAttacks(cre)

  Determine number of onhand attacks.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetOffhandAttacks(cre)

  Determine number of offhand attacks.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: InitializeNumberOfAttacks(cre)

  Initialize combat rounds attack counts.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetCreatureDamageBonus(cre, item)

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  item : :class:`Item`
    Item instance.
