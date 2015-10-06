.. highlight:: lua
.. default-domain:: lua

class Creature
==============

.. class:: Creature

  .. method:: Creature:ActionAttack(target[, passive])

    Add attack action to creature.

    :param target: Target to attack.
    :type target: :class:`Object`
    :param bool passive:  If ``true`` the attack is in passive mode.  Default: ``false``.

  .. method:: Creature:ActionCastFakeSpellAtLocation(spell, target[, path_type])

    :param int spell: SPELL_* constant.
    :param target: Object to cast fake spell at.
    :type target: :class:`Object`
    :param int path_type: PROJECTILE_PATH_TYPE_*.  Default: PROJECTILE_PATH_TYPE_DEFAULT

  .. method:: Creature:ActionCastFakeSpellAtObject(spell, target[, path_type])

    :param int spell: SPELL_* constant.
    :param target: Location to cast spell at.
    :type target: :class:`Location`
    :param int path_type: PROJECTILE_PATH_TYPE_*.  Default: PROJECTILE_PATH_TYPE_DEFAULT

  .. method:: Creature:ActionCastSpellAtLocation(spell, target[, metamagic[, cheat[, path_type[, instant]]]])

    :param int spell: SPELL_* constant.
    :param target: Location to cast spell at.
    :type target: :class:`Location`
    :param int metamagic: METAMAGIC_*. Default: METAMAGIC_ANY
    :param bool cheat: If true cast spell even if target does not have the ability. Default: ``false``
    :param int path_type: PROJECTILE_PATH_TYPE_*.  Default: PROJECTILE_PATH_TYPE_DEFAULT
    :param bool instant: If true spell can instantaneously. Default: ``false``

  .. method:: Creature:ActionCastSpellAtObject(spell, target[, metamagic[, cheat[, path_type[, instant]]]])

    :param int spell: SPELL_* constant.
    :param target: Target
    :type target: :class:`Object`
    :param int metamagic: METAMAGIC_*. Default: METAMAGIC_ANY
    :param bool cheat: If true cast spell even if target does not have the ability. Default: ``false``
    :param int path_type: PROJECTILE_PATH_TYPE_*.  Default: PROJECTILE_PATH_TYPE_DEFAULT
    :param bool instant: If true spell can instantaneously. Default: ``false``

  .. method:: Creature:ActionCounterSpell(target)

    Add counter spell action.

    :param target: Counter spell target.
    :type target: :class:`Creature`

  .. method:: Creature:ActionDoWhirlwindAttack([feedback[, improved]])

    Add whirlwind attack action.

    :param bool feedback: Send feedback.  Default: ``true``
    :param bool improved: Determines if effect is Improved Whirlwind Attack.  Default: ``false``

  .. method:: Creature:ActionEquipItem(item, slot)

    Add equip item action.

    :param item: Identified item in the creature's inventory.
    :type item: :class:`Item`
    :param int slot: INVENTORY_SLOT_* constant.

  .. method:: Creature:ActionEquipMostDamagingMelee([versus[, offhand]])

    :param versus: Object to test against.  Default: ``OBJECT_INVALID``
    :type versus: :class:`Object`
    :param bool offhand: If ``true`` the item is equipped in the offhand slot.  Default: ``false``

  .. method:: Creature:ActionEquipMostDamagingRanged([versus])

    :param versus: Object to test against.  Default: ``OBJECT_INVALID``
    :type versus: :class:`Object`

  .. method:: Creature:ActionEquipMostEffectiveArmor()

    Add action to equip the armor with the highest AC in the creature's inventory.

  .. method:: Creature:ActionExamine(target)

    :param target: Object to examine.
    :type target: :class:`Object`

  .. method:: Creature:ActionForceFollowObject(target[, distance])

    Add action to follow a creature until :meth:`Object:ClearAllActions()` is called.

    :param target: Object to follow.
    :type target: :class:`Object`
    :param float distance: Default: 0.0

  .. method:: Creature:ActionForceMoveToLocation(target[, run[, timeout])

    :param target: Location to move to.
    :type target: :class:`Location`
    :param bool run:  If ``true`` run to location.  Default: ``false``
    :param float timeout: Default: 30

  .. method:: Creature:ActionForceMoveToObject(target[, run[, range[, timeout]]])

    :param target: Object to move to.
    :type target: :class:`Object`
    :param bool run:  If ``true`` run to location.  Default: ``false``
    :param float range: Distance to object in meters.  Default: 1.0.
    :param float timeout: Default: 30

  .. method:: Creature:ActionInteractObject(target)

    :param target: Placeable to interact with.
    :type target: :class:`Placeable`

  .. method:: Creature:ActionJumpToLocation(loc)

    :param loc: Location to jump to.
    :type loc: :class:`Location`

  .. method:: Creature:ActionJumpToObject(obj[, straight_line])

    :param obj:  Object to jump to.
    :type obj: :class:`Object`
    :param bool straight_line: If ``true`` creature walks in straight line to object.  Default: ``true``

  .. method:: Creature:ActionMoveAwayFromLocation(loc[, run[, range]])

    :param loc: Location to move away from.
    :type loc: :class:`Location`
    :param bool run: If ``true`` creature will run from location.  Default: ``false``
    :param float range: Distance to move in meters.  Default: 40.0

  .. method:: Creature:ActionMoveAwayFromObject(obj[, run[, range]])

    :param obj: Object to move away from.
    :type obj: :class:`Object`
    :param bool run:  If ``true`` creature will run from object.  Default: ``false``
    :param float range: Distance to move in meters.  Default: 40.0

  .. method:: Creature:ActionMoveToLocation(loc[, run])

    :param loc: Location to jump to.
    :type loc: :class:`Location`
    :param bool run:  If ``true`` creature will run to location.  Default: ``false``

  .. method:: Creature:ActionMoveToObject(obj[, run[, range]])

    :param obj: Object to move to.
    :type obj: :class:`Object`
    :param bool run:  If ``true`` creature will run to location.  Default: ``false``
    :param float range: Distance from object in meters.  Default: 1.0

  .. method:: Creature:ActionPickUpItem(item)

    :param item: Item to pickup.
    :type item: :class:`Item`

  .. method:: Creature:ActionPlayAnimation(animation[, speed[, dur]])

    Causes creature to play an animation.

    :param int animation: ANIMATION_* constant.
    :param float speed: Speed of the animation.  Default: 1.0
    :param float dur: Duration of animation.  Not applicable to fire and forget animations.  Default: 0.0.

  .. method:: Creature:ActionPutDownItem(item)

    :param item: Item to put down.
    :type item: :class:`Item`

  .. method:: Creature:ActionRandomWalk()

    The action subject will generate a random location near its current location and pathfind to it.  ActionRandomwalk never ends, which means it is necessary to call ClearAllActions in order to allow a creature to perform any other action once ActionRandomWalk has been called.

  .. method:: Creature:ActionRest([check_sight])

    The creature will rest if not in combat and no enemies are nearby.

    :param bool check_sight: If ``true`` allow creature to rest if enemies are nearby.  Default: ``false``.

  .. method:: Creature:ActionSit(chair)

    :param chair: Object to sit on.
    :type chair: :class:`Placeable`

  .. method:: Creature:ActionTouchAttackMelee(target[, feedback])

    Add melee touch attack action.

    :param target: Object to perform attack on.
    :type obj: :class:`Object`
    :param bool feedback: If ``true`` feedback will be displayed in the combat log.  Default: ``true``
    :rtype: 0 for miss, 1 for hit, 2 for critical hit.

  .. method:: Creature:ActionTouchAttackRanged(target[, feedback])

    Add melee touch attack action.

    :param target: Object to perform attack on.
    :type obj: :class:`Object`
    :param bool feedback: If ``true`` feedback will be displayed in the combat log.  Default: ``true``
    :rtype: 0 for miss, 1 for hit, 2 for critical hit.

  .. method:: Creature:ActionUnequipItem(item)

    :param item: Item to unequip.
    :type item: :class:`Item`

  .. method:: Creature:ActionUseFeat(feat, target)

    :param int feat: FEAT_*
    :param target: Target
    :param target: :class:`Object`

  .. method:: Creature:ActionUseItem(item, target, area, loc, prop)

  .. method:: Creature:ActionUseSkill(skill, target, subskill, item)

    :param int skill: SKILL_* constant.
    :param target: Object to target.
    :type target: :class:`Object`
    :param int subskill: SUBSKILL_* constant.
    :param item: Item used in conjunction with skill.
    :type item: :class:`Item`

  .. method:: Creature:ActionUseTalentAtLocation(talent, loc)

    :param talent: Talent to use.
    :type talent: :class:`Talent`
    :param loc: Location to use talent.
    :type loc: :class:`Location`

  .. method:: Creature:ActionUseTalentOnObject(talent, target)

    :param talent: Talent to use.
    :type talent: :class:`Talent`
    :param target: Target to use talent on.
    :type target: :class:`Object`

  .. method:: Creature:ActivatePortal(ip, password, waypoint, seemless)

    Activates a portal between servers.

    :param string ip: DNS name or IP address (and optional port) of new server.
    :param string password: Password for login to the destination server.  Default: ""
    :param string waypoint: If set, arriving PCs will jump to this waypoint after appearing at the start location.  Default: ""
    :param bool seemless: If true, the transition will be made 'seamless', and the PC will not get a dialog box on transfer.  Default: ``false``

  .. method:: Creature:AddHenchman(master)

    Adds a henchman NPC to a PC.

    :param master: NPCs new master.
    :type master: :class:`Creature`

  .. method:: Creature:AddJournalQuestEntry(plot, state, entire_party, all_pc, allow_override)

    Add an entry to a player's Journal. (Create the entry in the Journal Editor first).

    :param string plot: The tag of the Journal category (case sensitive).
    :param int state: The ID of the Journal entry.
    :param bool entire_party: If true, the entry is added to the journal of the entire party. Default: ``true``
    :param bool all_pc: If true, the entry will show up in the journal of all PCs in the module.  Default: ``false``
    :param bool allow_override: If true, override restriction that nState must be > current Journal Entry.  Default: ``false``

  .. method:: Creature:AddKnownFeat(feat[, level])

    Add known feat to creature

    :param int feat: FEAT_*
    :param int level: If level is specified feat will be add at that level. Default: 0

  .. method:: Creature:AddKnownSpell(sp_class, sp_id, sp_level)

    Add known spell to creature.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_id: SPELL_*
    :param int sp_level: Spell level.

  .. method:: Creature:AddToParty(leader)

    Add PC to party

    :param leader: Faction leader
    :type leader: :class:`Creature`

  .. method:: Creature:AdjustAlignment(alignment, amount[, entire_party])

    Adjust creature's alignment.

    :param int alignment: ALIGNMENT_* constant.
    :param int amount: Amount to adjust
    :param bool entire_party: If true entire faction's alignment will be adjusted.  Default: ``false``

  .. method:: Creature:AdjustReputation(target, amount)

    Adjust reputation

    :param target: Target
    :param int amount: Amount to adjust

  .. method:: Creature:BlackScreen()

    Sets the screen to black.

  .. method:: Creature:BootPC()

    Abruptly kicks a player off a multi-player server.

  .. method:: Creature:ChangeToStandardFaction()

    Changes creature to standard faction

  .. method:: Creature:Classes()

    TODO: What does this return?

  .. method:: Creature:ClearPersonalReputation(target)

    Clears personal reputation

    :param target: Target

  .. method:: Creature:DayToNight([transition_time])

    Changes the current Day/Night cycle for this player to night

    :param float transition_time: Time it takes to become night.  Default: 0

  .. method:: Creature:DecrementRemainingFeatUses(feat)

    Decrement remaining feat uses.

    :param int feat: FEAT_*

  .. method:: Creature:DecrementRemainingSpellUses(spell)

    Decrements the remaining uses of a spell.

    :param int spell: SPELL_*

  .. method:: Creature:Equips(creature)

    Iterator of a creature's equipped items.

    :param bool creature: If true include creature items.  Default: ``false``

  .. method:: Creature:ErrorMessage(message, ...)

    Send error message on server channel.

    :param string message: Format string, see string.format
    :param ...: Arguments to format string

  .. method:: Creature:ExploreArea(area[, explored])

    Reveals the entire map of an area to a player.

    :param area:  Area to explorer.
    :type area: :class:`Area`
    :param bool explored: ``true`` (explored) or ``false`` (hidden). Whether the map should be completely explored or hidden.  Default: ``true``

  .. method:: Creature:FactionMembers([pc_only])

    Faction Member Iterator.

    :param bool pc_only: If true NPCs will be ignored.  Default: ``true``

  .. method:: Creature:FadeFromBlack([speed])

    Fades screen from black

    :param int speed: FADE_SPEED_* constant.  Default: FADE_SPEED_MEDIUM.

  .. method:: Creature:FadeToBlack([speed])

    Fades screen to black

    :param int speed: FADE_SPEED_* constant.  Default: FADE_SPEED_MEDIUM.

  .. method:: Creature:ForceEquip(equips)

    Forces creature to equip items

    :param table equips: A table with items indexed by INVENTORY_SLOT_* constants.

  .. method:: Creature:ForceUnequip(item)

    Forces creature to unequip an item

    :param item: The item in question.
    :type item: :class:`Item`

  .. method:: Creature:GetAbilityIncreaseByLevel(level)

    Gets ability score that was raised at a particular level.

    :param int level: Level in question.

  .. method:: Creature:GetAbilityModifier(ability[, base])

    Get the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param bool base: If ``true`` will return the base ability modifier without bonuses (e.g. ability bonuses granted from equipped items).  (Default: ``false``)

    :rtype: Returns the ability modifier of type ability for self (otherwise -1).

  .. method:: Creature:GetAbilityScore(ability[, base])

    Get the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param bool base: If ``true`` will return the base ability score without bonuses (e.g. ability bonuses granted from equipped items).  (Default: ``false``)

    :rtype: Returns the ability score of type ability for self (otherwise -1).

  .. method:: Creature:GetDexMod([armor_check])

    Gets a creatures dexterity modifier.

    :param bool armor_check: If true uses armor check penalty.  (Default: ``false``)

  .. method:: Creature:GetAILevel()

    Gets creature's AI level.

  .. method:: Creature:GetActionMode(mode)

    Check if a creature is using a given action mode

    :param int mode: ACTION_MODE_*

  .. method:: Creature:GetAge()

    Gets creature's age.

  .. method:: Creature:GetAlignmentGoodEvil()

    Determines the disposition of a creature.

    :rtype: ALIGNMENT_* constant.

  .. method:: Creature:GetAlignmentLawChaos()

    Determines the disposition of a creature.

    :rtype: ALIGNMENT_* constant.

  .. method:: Creature:GetAnimalCompanionName()

    Gets a creature's animal companion name.

    :rtype: ``string``

  .. method:: Creature:GetAnimalCompanionType()

    Get a creature's familiar creature type.

    :rtype: Animal companion constant.

  .. method:: Creature:GetAppearanceType()

    Gets creature's appearance type

  .. method:: Creature:GetArcaneSpellFailure()

    Get creature's arcane spell failure.

  .. method:: Creature:GetAssociate(assoc_type[, nth])

    Returns an object's associate.

    :param int assoc_type: solstice.associate type constant.
    :param int nth: Which associate to return. Default: 1

  .. method:: Creature:GetAssociateType()

    Returns the associate type of the specified creature

    :rtype: associate type constant.

  .. method:: Creature:GetAttackTarget()

    Get creature's attack target

  .. method:: Creature:GetAttemptedAttackTarget()

    Get creature's attempted attack target

  .. method:: Creature:GetAttemptedSpellTarget()

    Get creature's attempted spell target

  .. method:: Creature:GetBICFileName()

  .. method:: Creature:GetBodyPart(part)

    Gets creature's body part

    :param int part:

  .. method:: Creature:GetBonusSpellSlots(sp_class, sp_level)

    Get bonus spell slots.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.

  .. method:: Creature:GetChallengeRating()

    Get creature's challenge rating

  .. method:: Creature:GetClassByLevel(level)

    Determines class that was chosen at a particular level.

    :param int level: Level to get class at.
    :rtype: CLASS_TYPE_* constant or CLASS_TYPE_INVALID on error.

  .. method:: Creature:GetClassByPosition(position)

    Get class type by position

    :param int position: Valid values: 0, 1, or 2
    :rtype: CLASS_TYPE_* or CLASS_TYPE_INVALID.

  .. method:: Creature:GetClericDomain(domain)

    Determines a cleric's domain.

    :param int domain: Cleric's first or second domain.

  .. method:: Creature:GetCombatMode()

    Gets creature's active combat mode.

    :rtype: COMBAT_MODE_* constant.

  .. method:: Creature:GetConversation()

    Gets creature's conversation resref

  .. method:: Creature:GetCutsceneCameraMoveRate()

    Get cutscene camera movement rate.

  .. method:: Creature:GetCutsceneMode()

    Get a creature's cutscene mode

  .. method:: Creature:GetDamageFlags()

    Get creature's damage flags.

  .. method:: Creature:GetDeity()

    Gets creature's deity.

  .. method:: Creature:GetDetectMode()

  .. method:: Creature:GetFactionEqual(target)

    Get if factions are equal.

    :param target: Target

  .. method:: Creature:GetFamiliarName()

    Gets the creature's familiar creature name.

  .. method:: Creature:GetFamiliarType()

    Gets the creature's familiar creature type.

    :rtype: FAMILIAR_*

  .. method:: Creature:GetFavoredEnemenyMask()

    Determine Creatures Favored Enemey Bit Mask.

  .. method:: Creature:GetGender()

    Gets creature's gender.

  .. method:: Creature:GetGoingToBeAttackedBy()

    Get creatures attacker.

  .. method:: Creature:GetGoodEvilValue()

    Determines a creature's good/evil rating.

  .. method:: Creature:GetHasFeat(feat, has_uses, check_successors)

    Determine if creature has a feat

    :param int feat: FEAT_*
    :param bool has_uses: Check the feat is usable.  Default: ``false``
    :param bool check_successors: Check feat successors.  Default: ``false``

  .. method:: Creature:GetHasFeatEffect(feat)

    Determines if creature has a feat effect.

    :param int feat: FEAT_*

  .. method:: Creature:GetHasSkill(skill)

    Determines if a creature has a skill

    :param int skill: SKILL_*.

  .. method:: Creature:GetHasSpell(spell)

    Determines whether a creature has a spell available.

    :param int spell: SPELL_*

  .. method:: Creature:GetHasTalent(talent)

    Determines whether a creature has a specific talent.

    :param talent: The talent which will be checked for on the given creature.

  .. method:: Creature:GetHasTrainingVs(vs)

    Determine if creature training vs.

    :param vs: Target.
    :type vs: :class:`Creature`

  .. method:: Creature:GetHenchman(nth)

    Gets the nth henchman of a PC.

    :param int nth: Henchman index.

  .. method:: Creature:GetHighestFeat(feat)

    Determines the highest known feat.  This function checks all feat successors.

    :param int feat: FEAT_*
    :rtype: ``bool`` indicating whether creature has feat and the highest feat.

  .. method:: Creature:GetHighestFeatInRange(low_feat, high_feat)

    Returns the highest feat in a range of feats.

    :param int low_feat: FEAT_*
    :param int high_feat: FEAT_*
    :rtype: FEAT_* or -1 on error.

  .. method:: Creature:GetHighestLevelClass()

    Determines creatures highest class level

    :rtype: CLASS_TYPE_*, level

  .. method:: Creature:GetHitDice(use_neg_levels)

    Calculate a creature's hit dice.

    :param bool use_neg_levels: If true negative levels factored in to total hit dice. Default: ``false``

  .. method:: Creature:GetInventorySlotFromItem(item)

    Determine inventory slot from item

    :param item: Item
    :type item: :class:`Item`
    :rtype: INVENTORY_SLOT_* or -1

  .. method:: Creature:GetIsAI()

    Determine if creature is an AI.

  .. method:: Creature:GetIsBlind()

    Determines if a creature is blind.

  .. method:: Creature:GetIsBoss()

    Determine boss creature.  TODO: This should be removed.

  .. method:: Creature:GetIsDM()

    Determines if Creature is a DM

  .. method:: Creature:GetIsDMPossessed()

    Gets if creature is possessed by DM.

  .. method:: Creature:GetIsEncounterCreature()

    Get if creature was spawned by encounter.

  .. method:: Creature:GetIsEnemy(target)

    Determine if target is an enemy

    :param target: Target

  .. method:: Creature:GetIsFavoredEnemy(vs)

    Determine if creature is favored enemy.

  .. method:: Creature:GetIsFlanked(vs)

    Determines if a creature is flanked.

    :param vs: Attacker
    :type vs: :class:`Creature`

  .. method:: Creature:GetIsFlatfooted()

    Determines if a creature is flatfooted.

  .. method:: Creature:GetIsFriend(target)

    Determine if target is a friend

    :param target: Target

  .. method:: Creature:GetIsHeard(target)

    Determines if an object can hear another object.

    :param target: The object that may be heard.

  .. method:: Creature:GetIsImmune(immunity, versus)

    Get if creature has immunity.

    :param int immunity: IMMUNITY_TYPE_*
    :param versus: Versus object.
    :type versus: :class:`Object`
    :rtype: ``bool``

  .. method:: Creature:GetIsInCombat()

    Determines if creature is in combat.

  .. method:: Creature:GetIsInConversation()

    Determines whether an object is in conversation.

  .. method:: Creature:GetIsInvisible(vs)

    Determines if target is invisible.

    :param vs: Creature to test again.
    :type vs: :class:`Object`

  .. method:: Creature:GetIsNeutral(target)

    Determine if target is a neutral

    :param target: Target

  .. method:: Creature:GetIsPC()

    Determine if creature is a PC.

  .. method:: Creature:GetIsPCDying()

    TODO: ???

  .. method:: Creature:GetIsPolymorphed()

    Get if creature is polymorphed

  .. method:: Creature:GetIsPossessedFamiliar()

    Retrieves the controller status of a familiar.

  .. method:: Creature:GetIsReactionTypeFriendly(target)

    Determine reaction type if friendly

    :param target: Target
    :type target: :class:`Object`

  .. method:: Creature:GetIsReactionTypeHostile(target)

    Determine reaction type if hostile

    :param target: Target
    :type target: :class:`Object`

  .. method:: Creature:GetIsReactionTypeNeutral(target)

    Determine reaction type if neutral.

    :param target: Target
    :type target: :class:`Object`

  .. method:: Creature:GetIsResting()

    Check whether a creature is resting.

  .. method:: Creature:GetIsSeen(target)

    Determines whether an object sees another object.

    :param target: Object to determine if it is seen.
    :type target: :class:`Object`

  .. method:: Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)

    Determines if skill check is successful

    :param int skill: SKILL_*
    :param dc: Difficulty Class
    :param vs: Versus a target
    :param feedback: If true sends feedback to participants.
    :param auto: If true a roll of 20 is automatic success, 1 an automatic failure
    :param delay: Delay in seconds.
    :param take: Replaces dice roll.
    :param bonus: And bonus.

  .. method:: Creature:GetIsWeaponEffective(vs, is_offhand)

    Determines if weapon is effect versus a target.

    :param vs: Attack target.
    :param is_offhand: true if the attack is an offhand attack.

  .. method:: Creature:GetItemInSlot(slot)

    Gets an equipped item in creature's inventory.

    :param slot: INVENTORY_SLOT_*

  .. method:: Creature:GetKnownFeat(index)

    Gets known feat at index

    :param int index: Index of feat

  .. method:: Creature:GetKnownFeatByLevel(level, idx)

    Gets known feat by level at index

    :param level: Level in question.
    :param idx: Index of feat.

  .. method:: Creature:GetKnownSpell(sp_class, sp_level, sp_idx)

    Gets known spell.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param sp_idx: Index of the spell.
    :rtype: SPELL_* or -1 on error.

  .. method:: Creature:GetKnowsFeat(feat)

    Determines if a creature knows a feat.  Feats acquired from gear/effects do not count.

    :param int feat: FEAT_*

  .. method:: Creature:GetKnowsSpell(sp_class, sp_id)

    Determines if creature knows a spell.

    :param int sp_class: CLASS_TYPE_*.
    :param sp_id: SPELL_*

  .. method:: Creature:GetLastAssociateCommand()

    Get the last command issued to a given associate.

    :rtype: COMMAND_*

  .. method:: Creature:GetLastAttackMode()

    Get's last attack mode used by creature.

  .. method:: Creature:GetLastAttackType()

    Get's last attack type used by creature.

  .. method:: Creature:GetLastPerceived()

    Determines the last perceived creature in an OnPerception event.

  .. method:: Creature:GetLastPerceptionHeard()

    Determines if the last perceived object was heard.

  .. method:: Creature:GetLastPerceptionInaudible()

    Determines whether the last perceived object is no longer heard.

  .. method:: Creature:GetLastPerceptionSeen()

    Determines if the last perceived object was seen.

  .. method:: Creature:GetLastPerceptionVanished()

    Determines the last perceived creature has vanished.

  .. method:: Creature:GetLastTrapDetected()

    Gets last trap detected by creature.

  .. method:: Creature:GetLastWeaponUsed()

    Gets last weapon used by creature.

  .. method:: Creature:GetLawChaosValue()

    Determines a creature's law/chaos value.

  .. method:: Creature:GetLevelByClass(class)

    Get number of levels a creature by class

    :param int class: CLASS_TYPE_* type constant.

  .. method:: Creature:GetLevelByPosition(position)

    Get number of levels a creature by position

    :param int position: Valid values: 0, 1, or 2

  .. method:: Creature:GetLevelStats(level)

  .. method:: Creature:GetMaster()

    Determines who controls a creature.

  .. method:: Creature:GetMaxAttackRange(target)

    Determines creatures maximum attack range.

    :param target: Target to attack
    :type target: :class:`Object`

  .. method:: Creature:GetMaxHitPoints()

    Get creature's maximum hit points.  See :func:`rules.GetMaxHitPoints`

  .. method:: Creature:GetMaxHitPointsByLevel(level)

    Get max hit points by level

    :param int level: The level in question.

  .. method:: Creature:GetMaxSpellSlots(sp_class, sp_level)

    Gets max spell slots.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.

  .. method:: Creature:GetMemorizedSpell(sp_class, sp_level, sp_idx)

    Determines if a spell is memorized

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param int sp_idx: Index of the spell.

  .. method:: Creature:GetPCBodyBag()

    TODO: Expose this??

  .. method:: Creature:GetPCBodyBagID()

    TODO: Expose this??

  .. method:: Creature:GetPCFileName()

    Gets PC characters bic file.

  .. method:: Creature:GetPCIPAddress()

    Retrieves the IP address of a PC.

  .. method:: Creature:GetPCPlayerName()

    Retrieves the login name of the player of a PC.

  .. method:: Creature:GetPCPublicCDKey(single_player)

    Retrieves the public version of the PC's CD key.

    :param bool single_player: If set to true, the player's public CD key will be returned when the player is playing in single player mode.  Otherwise returns an empty string in single player mode.  Default: ``false``

  .. method:: Creature:GetPhenoType()

    Get creature's phenotype

  .. method:: Creature:GetPositionByClass(class)

    Determines class position by class type.

    :param int class: CLASS_TYPE_*
    :rtype: 0, 1, 2, or -1 on error.

  .. method:: Creature:GetRacialType()

    Gets creature's race.

  .. method:: Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)

    Determines reflex saved damage adjustment.

    :param int damage: Total damage.
    :param int dc: Difficulty class
    :param int savetype: Saving throw type constant.
    :param versus: Creature to roll against.
    :type versus: :class:`Creature`

  .. method:: Creature:GetRelativeWeaponSize(weap)

    Determines a weapons weapon size relative to a creature.

    :param weap: The weapon in question.
    :type weap: :class:`Item`

  .. method:: Creature:GetRemainingFeatUses(feat, has)

    Get remaining feat uses

    :param int feat: FEAT_*
    :param bool has: If true function assumes that creature has the feat in question.  Default: ``false``.

  .. method:: Creature:GetRemainingSpellSlots(sp_class, sp_level)

    Determines remaining spell slots at level.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.

  .. method:: Creature:GetReputation(target)

    Gets reputation of creature.

    :param target: Target

  .. method:: Creature:GetSavingThrowBonus(save)

    Gets creatures saving throw bonus

    :param save: SAVING_THROW_*

  .. method:: Creature:GetSize()

    Gets creature's size

  .. method:: Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)

    Determines a skill check.

    :param int int skill: SKILL_*
    :param int dc: Difficulty Class
    :param vs: Versus a target
    :param bool feedback: If ``true`` sends feedback to participants.
    :param bool auto: If true a roll of 20 is automatic success, 1 an automatic failure
    :param float delay: Delay in seconds.
    :param int take: Replaces dice roll.
    :param int bonus: And bonus.

  .. method:: Creature:GetSkillIncreaseByLevel(level, skill)

    Gets the amount a skill was increased at a level.

    :param int level: Level to check
    :param int skill: SKILL_*
    :rtype: -1 on error.

  .. method:: Creature:GetSkillPoints()

    Returns a creatures unused skillpoints.

  .. method:: Creature:GetSkillRank(skill[, vs[, base]])

    Gets creature's skill rank.

    :param int skill: SKILL_*
    :param vs: Versus.  Default: OBJECT_INVALID
    :param bool base: If true returns base skill rank.  Default: ``false``

  .. method:: Creature:GetStandardFactionReputation(faction)

    Get standard faction reputation

    :param int faction: STANDARD_FACTION_* constant.

  .. method:: Creature:GetStartingPackage()

    Gets creature's starting package.

  .. method:: Creature:GetSubrace()

    Gets creature's subrace

  .. method:: Creature:GetTail()

    Gets creature's tail.

  .. method:: Creature:GetTalentBest(category, cr_max)

    Determines the best talent of a creature from a group of talents.

    :param int category: TALENT_CATEGORY_*
    :param int cr_max: The maximum Challenge Rating of the talent.

  .. method:: Creature:GetTalentRandom(category)

    Retrieves a random talent from a group of talents that a creature possesses.

    :param int category: TALENT_CATEGORY_*

  .. method:: Creature:GetTargetState(target)

    Get target state bit mask.

    :param target: Creature target.
    :type target: :class:`Creature`

  .. method:: Creature:GetTotalFeatUses(feat)

    Get total feat uses.

    :param int feat: FEAT_*

  .. method:: Creature:GetTotalKnownFeats()

    Get total known feats.

  .. method:: Creature:GetTotalKnownFeatsByLevel(level)

    Get total known feats by level.

    :param int level: The level to check.
    :rtype: -1 on error.

  .. method:: Creature:GetTotalKnownSpells(sp_class, sp_level)

    Determines total known spells at level.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.

  .. method:: Creature:GetTotalNegativeLevels()

    Gets total negative levels

  .. method:: Creature:GetTrainingVsMask()

  .. method:: Creature:GetTurnResistanceHD()

    Determines turn resistance hit dice.

  .. method:: Creature:GetWeaponFromAttackType(atype)

    :param int atype: ATTACK_TYPE_*
    :rtype: An item or ``OBJECT_INVALID``

  .. method:: Creature:GetWings()

    Gets creature's wings

  .. method:: Creature:GetWizardSpecialization()

    Gets a creature's wizard specialization.

  .. method:: Creature:GetXP()

    Gets a creatures XP.

  .. method:: Creature:GiveGold(amount, feedback, source)

    Gives gold to creature

    :param int amount: Amount of gold to give.
    :param bool feedback: Sends feedback to creature.  Default: ``true``
    :param source: Source object.  Default: OBJECT_INVALID
    :type source: :class:`Object`

  .. method:: Creature:IncrementRemainingFeatUses(feat)

    Increment remaining feat uses.

    :param int feat: FEAT_*

  .. method:: Creature:JumpSafeToLocation(loc)

    :param loc: Location to jump to.
    :type loc: :class:`Location`

  .. method:: Creature:JumpSafeToObject(obj)

    :param obj: Object to jump to.
    :type obj: :class:`Object`

  .. method:: Creature:JumpSafeToWaypoint(way)

    :param way: Waypoint to jump to.
    :type way: :class:`Waypoint`

  .. method:: Creature:LevelUpHenchman([class[, ready_spells[, package]]])

    Levels up a creature using the default settings.

    :param int class: CLASS_TYPE_* Default: CLASS_TYPE_INVALID
    :param bool ready_spells: Determines if all memorizable spell slots will be filled without requiring rest.  Default: ``false``
    :param int package: PACKAGE_* Default: PACKAGE_INVALID

  .. method:: Creature:LockCameraDirection([locked])

    Locks a creatures camera direction.

    :param bool locked: (Default: false)

  .. method:: Creature:LockCameraDistance([locked])

    Locks a creatures camera distance.

    :param bool locked: (Default: false)

  .. method:: Creature:LockCameraPitch([locked])

    Locks a creatures camera pitch.

    :param bool locked: (Default: false)

  .. method:: Creature:ModifyAbilityScore(ability, value)

    Modifies the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param int value: Amount to modify ability score

  .. method:: Creature:ModifySkillRank(skill, amount, level)

    Modifies skill rank.

    :param int skill: SKILL_*
    :param int amount: Amount to modify skill rank.
    :param int level: If a level is specified the modification will occur at that level.

  .. method:: Creature:ModifyXP(amount, direct)

    Modifies a creatures XP.

    :param int amount: Amount of XP to give or take.
    :param bool direct: If true the xp amount is set directly with no feedback to player.  Default: ``false``

  .. method:: Creature:NightToDay([transition_time])

    Changes the current Day/Night cycle for this player to daylight

    :param float transition_time: Time it takes for the daylight to fade in Default: 0

  .. method:: Creature:NotifyAssociateActionToggle(mode)

    Notifies creature's associates of combat mode change

    :param int mode: COMBAT_MODE_* constant.

  .. method:: Creature:PlayVoiceChat(id)

    :param int id: VOICE_CHAT_* constant.

  .. method:: Creature:PopUpDeathGUIPanel(respawn_enabled, wait_enabled, help_strref, help_str)

    Displays a customizable death panel.

    :param bool respawn_enabled: If ``true``, the "Respawn" button will be enabled.  Default: ``true``
    :param bool wait_enabled: If ``true``, the "Wait For Help" button will be enabled.  Default: ``true``
    :param int help_strref: String reference to display for help.  Default: 0
    :param string help_str: String to display for help which appears in the top of the panel.  Default: ""

  .. method:: Creature:PopUpGUIPanel(gui_panel)

    Displays a GUI panel to a player.

    :param int gui_panel: GUI_PANEL_* constant.

  .. method:: Creature:RecalculateDexModifier()

    Recalculates a creatures dexterity modifier.

  .. method:: Creature:ReequipItemInSlot(slot)

    Forces the item in an inventory slot to be reequiped.

    :param int slot: INVENTORY_SLOT_*

  .. method:: Creature:RemoveFromParty()

    Remove PC from party.

  .. method:: Creature:RemoveHenchman(master)

    Removes the henchmen from the employ of a PC.

    :param master: Henchman's master
    :type master: :class:`Creature`

  .. method:: Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)

    Removes a journal quest entry from a PCs journal.

    :param string plot: The tag for the quest as used in the toolset's Journal Editor.
    :param bool entire_party: If this is true, the entry will be removed from the journal of everyone in the party.  Default: ``true``
    :param bool all_pc: If this is true, the entry will be removed from the journal of everyone in the world.  Default: ``false``

  .. method:: Creature:RemoveKnownFeat(feat)

    Remove feat from creature.

    :param int feat: FEAT_*

  .. method:: Creature:RemoveKnownSpell(sp_class, sp_level, sp_id)

    Remove known spell from creature

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param int sp_id: SPELL_*

  .. method:: Creature:RemoveSummonedAssociate(master)

    Removes an associate NPC from the service of a PC.

    :param master: Creature's master.
    :type master: :class:`Creature`

  .. method:: Creature:ReplaceKnownSpell(sp_class, sp_id, sp_new)

    Remove known spell from creature

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_id: SPELL_*
    :param int sp_new: SPELL_*

  .. method:: Creature:RestoreBaseAttackBonus()

    Restores a creature's base number of attacks.

  .. method:: Creature:RestoreCameraFacing()

    Restore creatures camera orientation.

  .. method:: Creature:SendChatMessage(channel, from, message)

    Sends a chat message

    :param int channel: Channel the message to send message on.
    :param from: Sender.
    :type from: :class:`Object`
    :param string message: Text to send.

  .. method:: Creature:SendMessage(message, ...)

    Sends a message to the PC.

    :param string message: Format string, see string.format
    :param ...: Arguments to format string

  .. method:: Creature:SendMessageByStrRef(strref)

    Sends a message to the PC by StrRef.

    :param int strref: StrRef of the message to send

  .. method:: Creature:SendServerMessage(message, ...)

    Simple wrapper around :func:`SendChatMessage` that sends a server message to a player.

    :param string message: Format string, see string.format
    :param ...: Arguments to format string

  .. method:: Creature:SetAILevel(ai_level)

    Sets creature's AI level.

    :param int ai_level: AI_LEVEL_* constant.

  .. method:: Creature:SetActionMode(mode, status)

    Sets the status of an action mode on a creature

    :param int mode: ACTION_MODE_*
    :param int status: New value.

  .. method:: Creature:SetAge(age)

    Set creature's age.

    :param int age: New age.

  .. method:: Creature:SetAppearanceType(type)

    Sets creature's appearance type

    :param int type: Appearance type.

  .. method:: Creature:SetAssociateListenPatterns()

    Prepares an associate (henchman, summoned, familiar) to be commanded.

  .. method:: Creature:SetBaseAttackBonus(amount)

    Sets a creature's base number of attacks.

    :param int amount: Amount of attacks.

  .. method:: Creature:SetBodyPart(part, model_number)

    Sets creature's body part

    :param part: CREATURE_PART_* constant.
    :param model_number: CREATURE_MODEL_TYPE_* constant.

  .. method:: Creature:SetCameraFacing(direction[, distance[, pitch[, transition_type]]])

    Set creatures camera orientation.

    :param float direction: direction to face.
    :param float distance: Camera distance. Default: -1.0
    :param float pitch: Camera pitch. Default: -1.0
    :param int transition_type: CAMERA_TRANSITION_TYPE_* constant.  Default: CAMERA_TRANSITION_TYPE_SNAP

  .. method:: Creature:SetCameraHeight(height)

    Set camera height

    :param int height: New height.

  .. method:: Creature:SetCameraMode(mode)

    Set Camera mode

    :param int mode: New mode

  .. method:: Creature:SetClericDomain(domain, newdomain)

    Sets a cleric's domain.

    :param int domain: Cleric's first or second domain
    :param int newdomain: See domains.2da

  .. method:: Creature:SetCombatMode(mode, change)

    Sets creature's combat mode

    :param int mode: COMBAT_MODE_* constant.
    :param bool change: If false the combat mode is already active.

  .. method:: Creature:SetCutsceneCameraMoveRate(rate)

    Sets camera movement rate.

    :param float rate: New movement rate

  .. method:: Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)

    Sets cutscene move

    :param bool in_cutscene: Default: ``false``
    :param bool leftclick_enabled: Default: ``false``

  .. method:: Creature:SetDeity(deity)

    Sets creature's deity

    :param string deity: New deity

  .. method:: Creature:SetGender(gender)

    Sets creature's gender

    :param int gender: New gender

  .. method:: Creature:SetIsTemporaryEnemy(target, decays, duration)

    Set creature as a temporary enemy

    :param target: Target
    :type target: :class:`Object`
    :param bool decays: If true reactions will return after duration. Default: ``false``
    :param float duration: Time in seconds. Default: 180.0

  .. method:: Creature:SetIsTemporaryFriend(target, decays, duration)

    Set creature as a temporary friend

    :param target: Target
    :type target: :class:`Object`
    :param bool decays: If true reactions will return after duration. Default: ``false``
    :param float duration: Time in seconds. Default: 180.0

  .. method:: Creature:SetIsTemporaryNeutral(target, decays, duration)

    Set creature as a temporary neutral

    :param target: Target
    :type target: :class:`Object`
    :param bool decays: If true reactions will return after duration. Default: ``false``
    :param float duration: Time in seconds. Default: 180.0

  .. method:: Creature:SetKnownFeat(index, feat)

    Set known feat on creature

    :param int index: Feat index to set
    :param int feat: FEAT_*

  .. method:: Creature:SetKnownFeatByLevel(level, index, feat)

    Set known feat by level

    :param int level: Level to set the feat on.
    :param int index: Feat index
    :param int feat: FEAT_*

  .. method:: Creature:SetKnownSpell(sp_class, sp_level, sp_idx, sp_id)

    Sets a known spell on creature

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param int sp_idx: Index of the spell to change.
    :param int sp_id: SPELL_*

  .. method:: Creature:SetLootable(lootable)

    Sets creature lootable

    :param int lootable: New lootable value

  .. method:: Creature:SetMaxHitPointsByLevel(level, hp)

    Set max hitpoints by level.

    :param int level: The level in question.
    :param int hp: Amount of hitpoints.

  .. method:: Creature:SetMemorizedSpell(sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)

    Sets a memorized spell on creature

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param int sp_idx: Index of the spell to change.
    :param int sp_spell: SPELL_*
    :param int sp_meta: METAMAGIC_*
    :param int sp_flags: Spell flags.

  .. method:: Creature:SetMovementRate(rate)

    Set creatures movement rate.

    :param int rate: MOVE_RATE_*

  .. method:: Creature:SetPCBodyBag(bodybag)

    TODO: Expose???

  .. method:: Creature:SetPCBodyBagID(bodybagid)

    TODO: Expose???

  .. method:: Creature:SetPCDislike(target)

    Sets that a player dislikes a creature (or object).

    :param target: The creature that dislikes the PC (and the PC dislike it).
    :type target: :class:`Creature`

  .. method:: Creature:SetPCLike(target)

    Causes a creature to like a PC.

    :param target: Target to alter the feelings of.
    :type target: :class:`Creature`

  .. method:: Creature:SetPCLootable(lootable)

    TODO: Expose???

  .. method:: Creature:SetPanelButtonFlash(button, enable_flash)

    Make a panel button in the player's client start or stop flashing.

    :param int button: PANEL_BUTTON_* constant.
    :param bool enable_flash: ``true`` to flash, ``false`` to stop flashing

  .. method:: Creature:SetPhenoType(phenotype)

    Set creature's phenotype

    :param int phenotype: Phenotype constant.

  .. method:: Creature:SetRemainingSpellSlots(sp_class, sp_level, sp_slots)

    Sets a remaining spell slots on creature.

    :param int sp_class: CLASS_TYPE_*.
    :param int sp_level: Spell level.
    :param int sp_slots: Number of slots.

  .. method:: Creature:SetSavingThrowBonus(save, bonus)

    Sets creatures saving throw bonus

    :param int save: SAVING_THROW_* constant.
    :param int bonus: New saving throw bonus

  .. method:: Creature:SetSkillPoints(amount)

    Sets a creatures skillpoints available.

    :param int amount: New amount

  .. method:: Creature:SetSkillRank(skill, amount)

    Sets a creatures skill rank

    :param int skill: SKILL_*
    :param int amount: New skill rank

  .. method:: Creature:SetStandardFactionReputation(faction, rep)

    Set standard faction reputation

    :param int faction: STANDARD_FACTION_* constant.
    :param int rep: Reputation. 0-100 inclusive.

  .. method:: Creature:SetSubrace(subrace)

    Set creature's subrace

    :param string subrace: New subrace

  .. method:: Creature:SetTail(tail)

    Sets creature's tail

    :param int tail: Tail type constant.

  .. method:: Creature:SetWings(wings)

    Sets creature's wings

    :param int wings: Wing type constant.

  .. method:: Creature:SetWizardSpecialization(specialization)

    Set a wizard's specialization.

    :param int specialization: see schools.2da

  .. method:: Creature:SetXP(amount, direct)

    Sets a creatures XP

    :param int amount: Amount to set XP to.
    :param bool direct: If true the xp amount is set directly with no feedback to player.  Default: ``false``.

  .. method:: Creature:SpeakOneLinerConversation(resref[, target])

    :param string resref: Dialog resref.
    :param int target: Must be specified if there are creature specific tokens in the string.  Default: OBJECT_TYPE_INVALID

  .. method:: Creature:StopFade()

    Stops a screen fade

  .. method:: Creature:StoreCameraFacing()

    Stores camera orientation.

  .. method:: Creature:SuccessMessage(message, ...)

    Send success message on server channel.

    :param string message: Format string, see string.format
    :param ...: Arguments to format string

  .. method:: Creature:SummonAnimalCompanion()

    Summons creature's animal companion

  .. method:: Creature:SummonFamiliar()

    Summons creature's familiar

  .. method:: Creature:SurrenderToEnemies()

    Causes all creatures in a 10 meter (1 tile) radius to stop actions. Improves the creature's reputation with nearby enemies for 3 minutes. Only works for NPCs.

  .. method:: Creature:TakeGold(amount, feedback, source)

    Takes gold to creature

    :param int amount: Amount of gold to take.
    :param bool feedback: Sends feedback to creature.  Default: ``true``
    :param source: Source object.  Default: ``OBJECT_INVALID``
    :type source: :class:`Object`

  .. method:: Creature:UnpossessFamiliar()

    Unpossesses a familiar from its controller.
