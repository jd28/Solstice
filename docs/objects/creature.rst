.. highlight:: lua
.. default-domain:: lua

class Creature
==============

.. class:: Creature

Signals
-------

.. data:: Creature.signals

  A Lua table containing signals for creature events.

  .. note::

    These signals are shared by **all** :class:`Creature` instances.  If special behavior
    is required for a specific creature it must be filtered by a signal handler.

  .. data:: Creature.signals.OnConversation

  .. data:: Creature.signals.OnBlocked

  .. data:: Creature.signals.OnDisturbed

  .. data:: Creature.signals.OnPerception

  .. data:: Creature.signals.OnSpellCastAt

  .. data:: Creature.signals.OnCombatRoundEnd

  .. data:: Creature.signals.OnDamaged

  .. data:: Creature.signals.OnPhysicalAttacked

  .. data:: Creature.signals.OnDeath

  .. data:: Creature.signals.OnHeartbeat

  .. data:: Creature.signals.OnRested

  .. data:: Creature.signals.OnSpawn

  .. data:: Creature.signals.OnUserDefined


Abilities
~~~~~~~~~

  .. method:: Creature:DebugAbilities()

    Create Ability debug string.

  .. method:: Creature:GetAbilityIncreaseByLevel(level)

    Gets ability score that was raised at a particular level.

  .. method:: Creature:GetAbilityModifier(ability[, base])

    Get the ability score of a specific type for a creature.

    **Arguments**

    ability
      ABILITY_*.
    base
      If ``true`` will return the base ability modifier
      without bonuses (e.g. ability bonuses granted from equipped
      items).  (Default: ``false``)

    **Returns**

    Returns the ability modifier of type ability for self (otherwise -1).

  .. method:: Creature:GetAbilityScore(ability[, base])

    Get the ability score of a specific type for a creature.

    **Arguments**

    ability
      ABILITY_*.
    base
      If ``true`` will return the base ability score
      without bonuses (e.g. ability bonuses granted from equipped
      items).  (Default: ``false``)

    **Returns**

    Returns the ability score of type ability for self (otherwise -1).

  .. method:: Creature:GetDexMod([armor_check])

    Gets a creatures dexterity modifier.

    **Arguments**

    armor_check
      If true uses armor check penalty.  (Default: ``false``)

  .. method:: Creature:ModifyAbilityScore(ability, value)

    Modifies the ability score of a specific type for a creature.

    **Arguments**

    ability
      ABILITY_*.
    value
      Amount to modify ability score

    .. method:: Creature:RecalculateDexModifier()

    Recalculates a creatures dexterity modifier.

  .. method:: Creature:SetAbilityScore(ability, value)

    Sets the ability score of a specific type for a creature.

    **Arguments**

    ability
      ABILITY_*.
    value
      Amount to modify ability score

Actions
-------

  .. method:: Creature:ActionAttack(target, passive)

  .. method:: Creature:ActionCastFakeSpellAtObject(spell, target, path_type)

  .. method:: Creature:ActionCastFakeSpellAtLocation(spell, target, path_type)

  .. method:: Creature:ActionCastSpellAtLocation(spell, target, metamagic, cheat, path_type, instant)

  .. method:: Creature:ActionCastSpellAtObject(spell, target, metamagic, cheat, path_type, instant)

  .. method:: Creature:ActionCounterSpell(target)

  .. method:: Creature:ActionDoWhirlwindAttack(feedback, improved)

  .. method:: Creature:ActionEquipItem(item, slot)

  .. method:: Creature:ActionEquipMostDamagingMelee(versus, offhand)

  .. method:: Creature:ActionEquipMostDamagingRanged(versus)

  .. method:: Creature:ActionEquipMostEffectiveArmor()

  .. method:: Creature:ActionExamine(target)

  .. method:: Creature:ActionForceFollowObject(target, distance)

  .. method:: Creature:ActionForceMoveToLocation(target, run, timeout)

  .. method:: Creature:ActionForceMoveToObject(target, run, range, timeout)

  .. method:: Creature:ActionInteractObject(target)

  .. method:: Creature:ActionJumpToLocation(loc)

  .. method:: Creature:ActionJumpToObject(destination, straight_line)

  .. method:: Creature:ActionMoveAwayFromLocation(loc, run, range)

  .. method:: Creature:ActionMoveAwayFromObject(target, run, range)

  .. method:: Creature:ActionMoveToLocation(target, run)

  .. method:: Creature:ActionMoveToObject(target, run, range)

  .. method:: Creature:ActionPickUpItem(item)

  .. method:: Creature:ActionPlayAnimation(animation, speed, dur)

  .. method:: Creature:ActionPutDownItem(item)

  .. method:: Creature:ActionRandomWalk()

  .. method:: Creature:ActionRest(check_sight)

  .. method:: Creature:ActionSit(chair)

  .. method:: Creature:ActionTouchAttackMelee(target, feedback)

  .. method:: Creature:ActionTouchAttackRanged(target, feedback)

  .. method:: Creature:ActionUseFeat(feat, target)

  .. method:: Creature:ActionUseItem(item, target, area, loc, prop)

  .. method:: Creature:ActionUseSkill(skill, target, subskill, item)

  .. method:: Creature:ActionUseTalentAtLocation(talent, loc)

  .. method:: Creature:ActionUseTalentOnObject(talent, target)

  .. method:: Creature:ActionUnequipItem(item)

  .. method:: Creature:PlayVoiceChat(id)

  .. method:: Creature:SpeakOneLinerConversation(resref, target)

  .. method:: Creature:JumpSafeToLocation(loc)

  .. method:: Creature:JumpSafeToObject(obj)

  .. method:: Creature:JumpSafeToWaypoint(way)

AI
--

  .. method:: Creature:GetAILevel()

  Gets creature's AI level.

  .. method:: Creature:SetAILevel(ai_level)

  Sets creature's AI level.

Alignment
---------

  .. method:: Creature:AdjustAlignment(alignment, amount, entire_party)

  .. method:: Creature:GetAlignmentLawChaos()

  .. method:: Creature:GetAlignmentGoodEvil()

  .. method:: Creature:GetLawChaosValue()

  .. method:: Creature:GetGoodEvilValue()

Armor Class
-----------

  .. method:: Creature:GetArmorCheckPenalty()

  .. method:: Creature:GetACVersus(vs, touch, is_ranged, attack, state)

  .. method:: Creature:DebugArmorClass()

  .. method:: Creature:GetMaxArmorClassMod()

  .. method:: Creature:GetMinArmorClassMod()

Associate
---------

  .. method:: Creature:AddHenchman(master)

  .. method:: Creature:GetAnimalCompanionType()

  .. method:: Creature:GetAnimalCompanionName()

  .. method:: Creature:GetAssociate(assoc_type, nth)

  .. method:: Creature:GetAssociateType()

  .. method:: Creature:GetFamiliarType()

  .. method:: Creature:GetFamiliarName()

  .. method:: Creature:GetHenchman(nth)

  .. method:: Creature:GetIsPossessedFamiliar()

  .. method:: Creature:GetMaster()

  .. method:: Creature:GetLastAssociateCommand()

  .. method:: Creature:LevelUpHenchman(class, ready_spells, package)

  .. method:: Creature:RemoveHenchman(master)

  .. method:: Creature:RemoveSummonedAssociate(master)

  .. method:: Creature:SetAssociateListenPatterns()

  .. method:: Creature:SummonAnimalCompanion()

  .. method:: Creature:SummonFamiliar()

  .. method:: Creature:UnpossessFamiliar()

Attack Bonus
------------

  .. method:: Creature:GetAttackBonusVs(target, equip)

  .. method:: Creature:GetBaseAttackBonus()

  .. method:: Creature:GetRangedAttackMod(target, distance)

  .. method:: Creature:DebugAttackBonus()

Class
-----

  .. method:: Creature:Classes()

  .. method:: Creature:GetClassByLevel(level)

  .. method:: Creature:GetClericDomain(domain)

  .. method:: Creature:GetLevelByClass(class)

  .. method:: Creature:GetLevelByPosition(position)

  .. method:: Creature:GetLevelStats(level)

  .. method:: Creature:GetClassByPosition(position)

  .. method:: Creature:GetPositionByClass(class)

  .. method:: Creature:GetWizardSpecialization()

  .. method:: Creature:SetClericDomain(domain, newdomain)

  .. method:: Creature:SetWizardSpecialization(specialization)

  .. method:: Creature:GetHighestLevelClass()

Combat
------

  .. method:: Creature:GetDamageImmunity(dmgidx)

  .. method:: Creature:GetInnateDamageImmunity(dmg_idx)

  .. method:: Creature:GetInnateDamageReduction()

  .. method:: Creature:GetInnateDamageResistance(dmg_idx)

  .. method:: Creature:GetHardness()

  .. method:: Creature:AddParryAttack(attacker)

  .. method:: Creature:GetArcaneSpellFailure()

  .. method:: Creature:GetAttackTarget()

  .. method:: Creature:GetAttemptedAttackTarget()

  .. method:: Creature:GetAttemptedSpellTarget()

  .. method:: Creature:GetChallengeRating()

  .. method:: Creature:GetCombatMode()

  .. method:: Creature:GetConcealment(vs, is_ranged)

  .. method:: Creature:GetDamageFlags()

  .. method:: Creature:GetGoingToBeAttackedBy()

  .. method:: Creature:GetIsInCombat()

  .. method:: Creature:GetLastAttackType()

  .. method:: Creature:GetLastAttackMode()

  .. method:: Creature:GetLastTrapDetected()

  .. method:: Creature:GetLastWeaponUsed()

  .. method:: Creature:GetMaxAttackRange(target)

  .. method:: Creature:GetMissChance(vs, is_ranged)

  .. method:: Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)

  .. method:: Creature:GetTargetState(target)

  .. method:: Creature:GetFavoredEnemenyMask()

  .. method:: Creature:GetIsFavoredEnemy(vs)

  .. method:: Creature:GetHasTrainingVs(vs)

  .. method:: Creature:GetTrainingVsMask()

  .. method:: Creature:GetTurnResistanceHD()

  .. method:: Creature:RestoreBaseAttackBonus()

  .. method:: Creature:SetBaseAttackBonus(amount)

  .. method:: Creature:SurrenderToEnemies()

  .. method:: Creature:DebugCombatEquips()

  .. method:: Creature:UpdateCombatInfo(all)

Cutscene
--------

  .. method:: Creature:BlackScreen()

  .. method:: Creature:FadeFromBlack(speed)

  .. method:: Creature:FadeToBlack(speed)

  .. method:: Creature:GetCutsceneCameraMoveRate()

  .. method:: Creature:GetCutsceneMode()

  .. method:: Creature:LockCameraDirection(locked)

  .. method:: Creature:LockCameraDistance(locked)

  .. method:: Creature:LockCameraPitch(locked)

  .. method:: Creature:RestoreCameraFacing()

  .. method:: Creature:SetCameraFacing(direction, distance, pitch, transition_type)

  .. method:: Creature:SetCameraHeight(height)

  .. method:: Creature:SetCameraMode(mode)

  .. method:: Creature:SetCutsceneCameraMoveRate(rate)

  .. method:: Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)

  .. method:: Creature:StopFade()

  .. method:: Creature:StoreCameraFacing()

Effects
-------

  .. method:: Creature:CreateEffectDebugString()

  .. method:: Creature:GetEffectImmunity(imm_type, vs)

  .. method:: Creature:GetHasFeatEffect(feat)

  .. method:: Creature:GetIsInvisible(vs)

  .. method:: Creature:GetIsImmune(immunity, versus)

Faction
-------

  .. method:: Creature:AddToParty(leader)

  .. method:: Creature:AdjustReputation(target, amount)

  .. method:: Creature:ChangeToStandardFaction()

  .. method:: Creature:ClearPersonalReputation(target)

  .. method:: Creature:GetFactionEqual(target)

  .. method:: Creature:GetIsEnemy(target)

  .. method:: Creature:GetIsFriend(target)

  .. method:: Creature:GetIsNeutral(target)

  .. method:: Creature:GetIsReactionTypeFriendly(target)

  .. method:: Creature:GetIsReactionTypeHostile(target)

  .. method:: Creature:GetIsReactionTypeNeutral(target)

  .. method:: Creature:GetReputation(target)

  .. method:: Creature:GetStandardFactionReputation(faction)

  .. method:: Creature:RemoveFromParty()

  .. method:: Creature:SetIsTemporaryEnemy(target, decays, duration)

  .. method:: Creature:SetIsTemporaryFriend(target, decays, duration)

  .. method:: Creature:SetIsTemporaryNeutral(target, decays, duration)

  .. method:: Creature:SetStandardFactionReputation(faction, rep)

  .. method:: Creature:GetFirstFactionMember(pc_only)

  .. method:: Creature:GetNextFactionMember(pc_only)

  .. method:: Creature:FactionMembers(pc_only)

Feats
-----

  .. method:: Creature:AddKnownFeat(feat, level)

  .. method:: Creature:DecrementRemainingFeatUses(feat)

  .. method:: Creature:GetHasFeat(feat, has_uses, check_successors)

  .. method:: Creature:GetHighestFeat(feat)

  .. method:: Creature:GetHighestFeatInRange(low_feat, high_feat)

  .. method:: Creature:GetKnownFeat(index)

  .. method:: Creature:GetKnownFeatByLevel(level, idx)

  .. method:: Creature:GetKnowsFeat(feat)

  .. method:: Creature:GetRemainingFeatUses(feat, has)

  .. method:: Creature:GetTotalFeatUses(feat)

  .. method:: Creature:GetTotalKnownFeats()

  .. method:: Creature:GetTotalKnownFeatsByLevel(level)

  .. method:: Creature:IncrementRemainingFeatUses(feat)

  .. method:: Creature:RemoveKnownFeat(feat)

  .. method:: Creature:SetKnownFeat(index, feat)

  .. method:: Creature:SetKnownFeatByLevel(level, index, feat)

Hit Points
----------

  .. method:: Creature:GetMaxHitPointsByLevel(level)

  .. method:: Creature:SetMaxHitPointsByLevel(level, hp)

  .. method:: Creature:GetMaxHitPoints()

Info
----

  .. method:: Creature:GetAge()

  .. method:: Creature:GetAppearanceType()

  .. method:: Creature:GetBodyPart(part)

  .. method:: Creature:GetConversation()

  .. method:: Creature:GetIsBoss()

  .. method:: Creature:GetSize()

  .. method:: Creature:GetDeity()

  .. method:: Creature:GetDeityId()

  .. method:: Creature:GetIsDM()

  .. method:: Creature:GetIsDMPossessed()

  .. method:: Creature:GetIsEncounterCreature()

  .. method:: Creature:GetIsPolymorphed()

  .. method:: Creature:GetGender()

  .. method:: Creature:GetPCFileName()

  .. method:: Creature:GetPhenoType()

  .. method:: Creature:GetRacialType()

  .. method:: Creature:GetStartingPackage()

  .. method:: Creature:GetSubrace()

  .. method:: Creature:GetSubraceId()

  .. method:: Creature:GetTail()

  .. method:: Creature:SetTail(tail)

  .. method:: Creature:GetWings()

  .. method:: Creature:SetWings(wings)

  .. method:: Creature:SetAge(age)

  .. method:: Creature:SetAppearanceType(type)

  .. method:: Creature:SetBodyPart(part, model_number)

  .. method:: Creature:SetDeity(deity)

  .. method:: Creature:SetGender(gender)

  .. method:: Creature:SetLootable(lootable)

  .. method:: Creature:SetMovementRate(rate)

  .. method:: Creature:SetPhenoType(phenotype)

  .. method:: Creature:SetSubrace(subrace)

Internal
--------

  .. method:: Creature:GetPCBodyBag()

  .. method:: Creature:GetPCBodyBagID()

  .. method:: Creature:SetPCBodyBag(bodybag)

  .. method:: Creature:SetPCBodyBagID(bodybagid)

  .. method:: Creature:SetPCLootable(lootable)

Inventory
~~~~~~~~~

  .. method:: Creature:Equips(creature)

  .. method:: Creature:GetInventorySlotFromItem(item)

  .. method:: Creature:ForceEquip(equips)

  .. method:: Creature:ForceUnequip(item)

  .. method:: Creature:GetIsWeaponEffective(vs, is_offhand)

  .. method:: Creature:GetItemInSlot(slot)

  .. method:: Creature:GetRelativeWeaponSize(weap)

  .. method:: Creature:GiveGold(amount, feedback, source)

  .. method:: Creature:ReequipItemInSlot(slot)

  .. method:: Creature:TakeGold(amount, feedback, source)

Level
-----

  .. method:: Creature:GetHitDice(use_neg_levels)

  .. method:: Creature:GetEffectiveLevel()

  .. method:: Creature:GetEffectiveLevelDifference()

  .. method:: Creature:GetTotalNegativeLevels()

  .. method:: Creature:SetEffectiveLevel(level)

Combat Modes
------------

  .. method:: Creature:GetDetectMode()

  .. method:: Creature:NotifyAssociateActionToggle(mode)

  .. method:: Creature:SetActivity(act, on)

  .. method:: Creature:SetCombatMode(mode, change)

PC
--

Player character specific functions.

  .. method:: Creature:ActivatePortal(ip, password, waypoint, seemless)

  .. method:: Creature:AddJournalQuestEntry(plot, state, entire_party, all_pc, allow_override)

  .. method:: Creature:BootPC()

  .. method:: Creature:DayToNight(transition_time)

  .. method:: Creature:ExploreArea(area, explored)

  .. method:: Creature:GetIsPC()

  .. method:: Creature:GetBICFileName()

  .. method:: Creature:GetIsAI()

  .. method:: Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)

  .. method:: Creature:GetPCPublicCDKey(single_player)

  .. method:: Creature:GetPCIPAddress()

  .. method:: Creature:GetPCPlayerName()

  .. method:: Creature:NightToDay(transition_time)

  .. method:: Creature:PopUpDeathGUIPanel(respawn_enabled, wait_enabled, help_strref, help_str)

  .. method:: Creature:PopUpGUIPanel(gui_panel)

  .. method:: Creature:SendMessage(message, ...)

  .. method:: Creature:SendMessageByStrRef(strref)

  .. method:: Creature:SetPCLike(target)

  .. method:: Creature:SetPCDislike(target)

  .. method:: Creature:SetPanelButtonFlash(button, enable_flash)

  .. method:: Creature:SendChatMessage(channel, from, message)

  .. method:: Creature:SendServerMessage(message)

  .. method:: Creature:ErrorMessage(message, ...)

  .. method:: Creature:SuccessMessage(message, ...)

Perception
----------

  .. method:: Creature:GetIsSeen(target)

  .. method:: Creature:GetIsHeard(target)

  .. method:: Creature:GetLastPerceived()

  .. method:: Creature:GetLastPerceptionHeard()

  .. method:: Creature:GetLastPerceptionInaudible()

  .. method:: Creature:GetLastPerceptionVanished()

  .. method:: Creature:GetLastPerceptionSeen()

Saves
-----

  .. method:: Creature:DebugSaves()

  .. method:: Creature:GetSavingThrowBonus(save)

  .. method:: Creature:SetSavingThrowBonus(save, bonus)

Skills
------

  .. method:: Creature:CanUseSkill(skill)

  .. method:: Creature:GetHasSkill(skill)

  .. method:: Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)

  .. method:: Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)

  .. method:: Creature:GetSkillIncreaseByLevel(level, skill)

  .. method:: Creature:GetSkillPoints()

  .. method:: Creature:GetSkillRank(skill, vs, base)

  .. method:: Creature:ModifySkillRank(skill, amount, level)

  .. method:: Creature:SetSkillPoints(amount)

  .. method:: Creature:SetSkillRank(skill, amount)

  .. method:: Creature:DebugSkills()

Spells
------

  .. method:: Creature:AddKnownSpell(sp_class, sp_id, sp_level)

  .. method:: Creature:DecrementRemainingSpellUses(spell)

  .. method:: Creature:GetBonusSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetHasSpell(spell)

  .. method:: Creature:GetHasSpell(spell)

  .. method:: Creature:GetKnownSpell(sp_class, sp_level, sp_idx)

  .. method:: Creature:GetKnowsSpell(sp_class, sp_id)

  .. method:: Creature:GetMaxSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetMemorizedSpell(sp_class, sp_level, sp_idx)

  .. method:: Creature:GetRemainingSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetTotalKnownSpells(sp_class, sp_level)

  .. method:: Creature:RemoveKnownSpell(sp_class, sp_level, sp_id)

  .. method:: Creature:ReplaceKnownSpell(sp_class, sp_id, sp_new)

  .. method:: Creature:SetKnownSpell(sp_class, sp_level, sp_idx, sp_id)

  .. method:: Creature:SetMemorizedSpell(sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)

  .. method:: Creature:SetRemainingSpellSlots(sp_class, sp_level, sp_slots)

State
-----

  .. method:: Creature:GetActionMode(mode)

  .. method:: Creature:GetIsBlind()

  .. method:: Creature:GetIsFlanked(vs)

  .. method:: Creature:GetIsFlatfooted()

  .. method:: Creature:GetIsInConversation()

  .. method:: Creature:GetIsPCDying()

  .. method:: Creature:GetIsResting()

  .. method:: Creature:SetActionMode(mode, status)

Talents
-------

  .. method:: Creature:GetHasTalent(talent)

  .. method:: Creature:GetTalentBest(category, cr_max)

  .. method:: Creature:GetTalentRandom(category)

Variables
---------

  .. method:: Creature:GetPlayerInt(var, global, dbtable)

  .. method:: Creature:SetPlayerInt(var, value, global, dbtable)

  .. method:: Creature:GetPlayerString(var, global, dbtable)

  .. method:: Creature:SetPlayerString(var, value, global, dbtable)

XP
--

  .. method:: Creature:GetXP()

  .. method:: Creature:ModifyXP(amount, direct)

  .. method:: Creature:SetXP(amount, direct)





