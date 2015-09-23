.. highlight:: lua
.. default-domain:: lua

class Creature
==============

.. class:: Creature

  .. method:: Creature:ActionAttack(target, passive)

  .. method:: Creature:ActionCastFakeSpellAtLocation(spell, target, path_type)

  .. method:: Creature:ActionCastFakeSpellAtObject(spell, target, path_type)

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

  .. method:: Creature:ActionUnequipItem(item)

  .. method:: Creature:ActionUseFeat(feat, target)

  .. method:: Creature:ActionUseItem(item, target, area, loc, prop)

  .. method:: Creature:ActionUseSkill(skill, target, subskill, item)

  .. method:: Creature:ActionUseTalentAtLocation(talent, loc)

  .. method:: Creature:ActionUseTalentOnObject(talent, target)

  .. method:: Creature:ActivatePortal(ip, password, waypoint, seemless)

  .. method:: Creature:AddHenchman(master)

  .. method:: Creature:AddJournalQuestEntry(plot, state, entire_party, all_pc, allow_override)

  .. method:: Creature:AddKnownFeat(feat, level)

  .. method:: Creature:AddKnownSpell(sp_class, sp_id, sp_level)

  .. method:: Creature:AddParryAttack(attacker)

  .. method:: Creature:AddToParty(leader)

  .. method:: Creature:AdjustAlignment(alignment, amount, entire_party)

  .. method:: Creature:AdjustReputation(target, amount)

  .. method:: Creature:BlackScreen()

  .. method:: Creature:BootPC()

  .. method:: Creature:CanUseSkill(skill)

  .. method:: Creature:ChangeToStandardFaction()

  .. method:: Creature:Classes()

  .. method:: Creature:ClearPersonalReputation(target)

  .. method:: Creature:CreateEffectDebugString()

  .. method:: Creature:DayToNight(transition_time)

  .. method:: Creature:DebugAbilities()

    Create Ability debug string.

  .. method:: Creature:DebugArmorClass()

  .. method:: Creature:DebugAttackBonus()

  .. method:: Creature:DebugCombatEquips()

  .. method:: Creature:DebugSaves()

  .. method:: Creature:DebugSkills()

  .. method:: Creature:DecrementRemainingFeatUses(feat)

  .. method:: Creature:DecrementRemainingSpellUses(spell)

  .. method:: Creature:Equips(creature)

  .. method:: Creature:ErrorMessage(message, ...)

  .. method:: Creature:ExploreArea(area, explored)

  .. method:: Creature:FactionMembers(pc_only)

  .. method:: Creature:FadeFromBlack(speed)

  .. method:: Creature:FadeToBlack(speed)

  .. method:: Creature:ForceEquip(equips)

  .. method:: Creature:ForceUnequip(item)

  .. method:: Creature:GetAbilityIncreaseByLevel(level)

    Gets ability score that was raised at a particular level.

  .. method:: Creature:GetAbilityModifier(ability[, base])

    Get the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param boolean base: If ``true`` will return the base ability modifier without bonuses (e.g. ability bonuses granted from equipped items).  (Default: ``false``)

    :rtype: Returns the ability modifier of type ability for self (otherwise -1).

  .. method:: Creature:GetAbilityScore(ability[, base])

    Get the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param boolean base: If ``true`` will return the base ability score without bonuses (e.g. ability bonuses granted from equipped items).  (Default: ``false``)

    :rtype: Returns the ability score of type ability for self (otherwise -1).

  .. method:: Creature:GetDexMod([armor_check])

    Gets a creatures dexterity modifier.

    :param boolean armor_check: If true uses armor check penalty.  (Default: ``false``)

  .. method:: Creature:GetACVersus(vs, touch, is_ranged, attack, state)

  .. method:: Creature:GetAILevel()

  .. method:: Creature:GetActionMode(mode)

  .. method:: Creature:GetAge()

  .. method:: Creature:GetAlignmentGoodEvil()

  .. method:: Creature:GetAlignmentLawChaos()

  .. method:: Creature:GetAnimalCompanionName()

  .. method:: Creature:GetAnimalCompanionType()

  .. method:: Creature:GetAppearanceType()

  .. method:: Creature:GetArcaneSpellFailure()

  .. method:: Creature:GetArmorCheckPenalty()

  .. method:: Creature:GetAssociate(assoc_type, nth)

  .. method:: Creature:GetAssociateType()

  .. method:: Creature:GetAttackTarget()

  .. method:: Creature:GetAttemptedAttackTarget()

  .. method:: Creature:GetAttemptedSpellTarget()

  .. method:: Creature:GetBICFileName()

  .. method:: Creature:GetBodyPart(part)

  .. method:: Creature:GetBonusSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetChallengeRating()

  .. method:: Creature:GetClassByLevel(level)

  .. method:: Creature:GetClassByPosition(position)

  .. method:: Creature:GetClericDomain(domain)

  .. method:: Creature:GetCombatMode()

  .. method:: Creature:GetConcealment(vs, is_ranged)

  .. method:: Creature:GetConversation()

  .. method:: Creature:GetCutsceneCameraMoveRate()

  .. method:: Creature:GetCutsceneMode()

  .. method:: Creature:GetDamageFlags()

  .. method:: Creature:GetDamageImmunity(dmgidx)

  .. method:: Creature:GetDeity()

  .. method:: Creature:GetDeityId()

  .. method:: Creature:GetDetectMode()

  .. method:: Creature:GetEffectImmunity(imm_type, vs)

  .. method:: Creature:GetEffectiveLevel()

  .. method:: Creature:GetEffectiveLevelDifference()

  .. method:: Creature:GetFactionEqual(target)

  .. method:: Creature:GetFamiliarName()

  .. method:: Creature:GetFamiliarType()

  .. method:: Creature:GetFavoredEnemenyMask()

  .. method:: Creature:GetFirstFactionMember(pc_only)

  .. method:: Creature:GetGender()

  .. method:: Creature:GetGoingToBeAttackedBy()

  .. method:: Creature:GetGoodEvilValue()

  .. method:: Creature:GetHardness()

  .. method:: Creature:GetHasFeat(feat, has_uses, check_successors)

  .. method:: Creature:GetHasFeatEffect(feat)

  .. method:: Creature:GetHasSkill(skill)

  .. method:: Creature:GetHasSpell(spell)

  .. method:: Creature:GetHasSpell(spell)

  .. method:: Creature:GetHasTalent(talent)

  .. method:: Creature:GetHasTrainingVs(vs)

  .. method:: Creature:GetHenchman(nth)

  .. method:: Creature:GetHighestFeat(feat)

  .. method:: Creature:GetHighestFeatInRange(low_feat, high_feat)

  .. method:: Creature:GetHighestLevelClass()

  .. method:: Creature:GetHitDice(use_neg_levels)

  .. method:: Creature:GetInnateDamageImmunity(dmg_idx)

  .. method:: Creature:GetInnateDamageReduction()

  .. method:: Creature:GetInnateDamageResistance(dmg_idx)

  .. method:: Creature:GetInventorySlotFromItem(item)

  .. method:: Creature:GetIsAI()

  .. method:: Creature:GetIsBlind()

  .. method:: Creature:GetIsBoss()

  .. method:: Creature:GetIsDM()

  .. method:: Creature:GetIsDMPossessed()

  .. method:: Creature:GetIsEncounterCreature()

  .. method:: Creature:GetIsEnemy(target)

  .. method:: Creature:GetIsFavoredEnemy(vs)

  .. method:: Creature:GetIsFlanked(vs)

  .. method:: Creature:GetIsFlatfooted()

  .. method:: Creature:GetIsFriend(target)

  .. method:: Creature:GetIsHeard(target)

  .. method:: Creature:GetIsImmune(immunity, versus)

  .. method:: Creature:GetIsInCombat()

  .. method:: Creature:GetIsInConversation()

  .. method:: Creature:GetIsInvisible(vs)

  .. method:: Creature:GetIsNeutral(target)

  .. method:: Creature:GetIsPC()

  .. method:: Creature:GetIsPCDying()

  .. method:: Creature:GetIsPolymorphed()

  .. method:: Creature:GetIsPossessedFamiliar()

  .. method:: Creature:GetIsReactionTypeFriendly(target)

  .. method:: Creature:GetIsReactionTypeHostile(target)

  .. method:: Creature:GetIsReactionTypeNeutral(target)

  .. method:: Creature:GetIsResting()

  .. method:: Creature:GetIsSeen(target)

  .. method:: Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)

  .. method:: Creature:GetIsWeaponEffective(vs, is_offhand)

  .. method:: Creature:GetItemInSlot(slot)

  .. method:: Creature:GetKnownFeat(index)

  .. method:: Creature:GetKnownFeatByLevel(level, idx)

  .. method:: Creature:GetKnownSpell(sp_class, sp_level, sp_idx)

  .. method:: Creature:GetKnowsFeat(feat)

  .. method:: Creature:GetKnowsSpell(sp_class, sp_id)

  .. method:: Creature:GetLastAssociateCommand()

  .. method:: Creature:GetLastAttackMode()

  .. method:: Creature:GetLastAttackType()

  .. method:: Creature:GetLastPerceived()

  .. method:: Creature:GetLastPerceptionHeard()

  .. method:: Creature:GetLastPerceptionInaudible()

  .. method:: Creature:GetLastPerceptionSeen()

  .. method:: Creature:GetLastPerceptionVanished()

  .. method:: Creature:GetLastTrapDetected()

  .. method:: Creature:GetLastWeaponUsed()

  .. method:: Creature:GetLawChaosValue()

  .. method:: Creature:GetLevelByClass(class)

  .. method:: Creature:GetLevelByPosition(position)

  .. method:: Creature:GetLevelStats(level)

  .. method:: Creature:GetMaster()

  .. method:: Creature:GetMaxArmorClassMod()

  .. method:: Creature:GetMaxAttackRange(target)

  .. method:: Creature:GetMaxHitPoints()

  .. method:: Creature:GetMaxHitPointsByLevel(level)

  .. method:: Creature:GetMaxSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetMemorizedSpell(sp_class, sp_level, sp_idx)

  .. method:: Creature:GetMinArmorClassMod()

  .. method:: Creature:GetMissChance(vs, is_ranged)

  .. method:: Creature:GetNextFactionMember(pc_only)

  .. method:: Creature:GetPCBodyBag()

  .. method:: Creature:GetPCBodyBagID()

  .. method:: Creature:GetPCFileName()

  .. method:: Creature:GetPCIPAddress()

  .. method:: Creature:GetPCPlayerName()

  .. method:: Creature:GetPCPublicCDKey(single_player)

  .. method:: Creature:GetPhenoType()

  .. method:: Creature:GetPositionByClass(class)

  .. method:: Creature:GetRacialType()

  .. method:: Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)

  .. method:: Creature:GetRelativeWeaponSize(weap)

  .. method:: Creature:GetRemainingFeatUses(feat, has)

  .. method:: Creature:GetRemainingSpellSlots(sp_class, sp_level)

  .. method:: Creature:GetReputation(target)

  .. method:: Creature:GetSavingThrowBonus(save)

  .. method:: Creature:GetSize()

  .. method:: Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)

  .. method:: Creature:GetSkillIncreaseByLevel(level, skill)

  .. method:: Creature:GetSkillPoints()

  .. method:: Creature:GetSkillRank(skill, vs, base)

  .. method:: Creature:GetStandardFactionReputation(faction)

  .. method:: Creature:GetStartingPackage()

  .. method:: Creature:GetSubrace()

  .. method:: Creature:GetSubraceId()

  .. method:: Creature:GetTail()

  .. method:: Creature:GetTalentBest(category, cr_max)

  .. method:: Creature:GetTalentRandom(category)

  .. method:: Creature:GetTargetState(target)

  .. method:: Creature:GetTotalFeatUses(feat)

  .. method:: Creature:GetTotalKnownFeats()

  .. method:: Creature:GetTotalKnownFeatsByLevel(level)

  .. method:: Creature:GetTotalKnownSpells(sp_class, sp_level)

  .. method:: Creature:GetTotalNegativeLevels()

  .. method:: Creature:GetTrainingVsMask()

  .. method:: Creature:GetTurnResistanceHD()

  .. method:: Creature:GetWings()

  .. method:: Creature:GetWizardSpecialization()

  .. method:: Creature:GetXP()

  .. method:: Creature:GiveGold(amount, feedback, source)

  .. method:: Creature:IncrementRemainingFeatUses(feat)

  .. method:: Creature:JumpSafeToLocation(loc)

  .. method:: Creature:JumpSafeToObject(obj)

  .. method:: Creature:JumpSafeToWaypoint(way)

  .. method:: Creature:LevelUpHenchman(class, ready_spells, package)

  .. method:: Creature:LockCameraDirection(locked)

  .. method:: Creature:LockCameraDistance(locked)

  .. method:: Creature:LockCameraPitch(locked)

  .. method:: Creature:ModifyAbilityScore(ability, value)

    Modifies the ability score of a specific type for a creature.

    :param int ability: ABILITY_*.
    :param int value: Amount to modify ability score

  .. method:: Creature:RecalculateDexModifier()

    Recalculates a creatures dexterity modifier.

  .. method:: Creature:ModifySkillRank(skill, amount, level)

  .. method:: Creature:ModifyXP(amount, direct)

  .. method:: Creature:NightToDay(transition_time)

  .. method:: Creature:NotifyAssociateActionToggle(mode)

  .. method:: Creature:PlayVoiceChat(id)

  .. method:: Creature:PopUpDeathGUIPanel(respawn_enabled, wait_enabled, help_strref, help_str)

  .. method:: Creature:PopUpGUIPanel(gui_panel)

  .. method:: Creature:ReequipItemInSlot(slot)

  .. method:: Creature:RemoveFromParty()

  .. method:: Creature:RemoveHenchman(master)

  .. method:: Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)

  .. method:: Creature:RemoveKnownFeat(feat)

  .. method:: Creature:RemoveKnownSpell(sp_class, sp_level, sp_id)

  .. method:: Creature:RemoveSummonedAssociate(master)

  .. method:: Creature:ReplaceKnownSpell(sp_class, sp_id, sp_new)

  .. method:: Creature:RestoreBaseAttackBonus()

  .. method:: Creature:RestoreCameraFacing()

  .. method:: Creature:SendChatMessage(channel, from, message)

  .. method:: Creature:SendMessage(message, ...)

  .. method:: Creature:SendMessageByStrRef(strref)

  .. method:: Creature:SendServerMessage(message)

  .. method:: Creature:SetAILevel(ai_level)

  .. method:: Creature:SetActionMode(mode, status)

  .. method:: Creature:SetActivity(act, on)

  .. method:: Creature:SetAge(age)

  .. method:: Creature:SetAppearanceType(type)

  .. method:: Creature:SetAssociateListenPatterns()

  .. method:: Creature:SetBaseAttackBonus(amount)

  .. method:: Creature:SetBodyPart(part, model_number)

  .. method:: Creature:SetCameraFacing(direction, distance, pitch, transition_type)

  .. method:: Creature:SetCameraHeight(height)

  .. method:: Creature:SetCameraMode(mode)

  .. method:: Creature:SetClericDomain(domain, newdomain)

  .. method:: Creature:SetCombatMode(mode, change)

  .. method:: Creature:SetCutsceneCameraMoveRate(rate)

  .. method:: Creature:SetCutsceneMode(in_cutscene, leftclick_enabled)

  .. method:: Creature:SetDeity(deity)

  .. method:: Creature:SetEffectiveLevel(level)

  .. method:: Creature:SetGender(gender)

  .. method:: Creature:SetIsTemporaryEnemy(target, decays, duration)

  .. method:: Creature:SetIsTemporaryFriend(target, decays, duration)

  .. method:: Creature:SetIsTemporaryNeutral(target, decays, duration)

  .. method:: Creature:SetKnownFeat(index, feat)

  .. method:: Creature:SetKnownFeatByLevel(level, index, feat)

  .. method:: Creature:SetKnownSpell(sp_class, sp_level, sp_idx, sp_id)

  .. method:: Creature:SetLootable(lootable)

  .. method:: Creature:SetMaxHitPointsByLevel(level, hp)

  .. method:: Creature:SetMemorizedSpell(sp_class, sp_level, sp_idx, sp_spell, sp_meta, sp_flags)

  .. method:: Creature:SetMovementRate(rate)

  .. method:: Creature:SetPCBodyBag(bodybag)

  .. method:: Creature:SetPCBodyBagID(bodybagid)

  .. method:: Creature:SetPCDislike(target)

  .. method:: Creature:SetPCLike(target)

  .. method:: Creature:SetPCLootable(lootable)

  .. method:: Creature:SetPanelButtonFlash(button, enable_flash)

  .. method:: Creature:SetPhenoType(phenotype)

  .. method:: Creature:SetRemainingSpellSlots(sp_class, sp_level, sp_slots)

  .. method:: Creature:SetSavingThrowBonus(save, bonus)

  .. method:: Creature:SetSkillPoints(amount)

  .. method:: Creature:SetSkillRank(skill, amount)

  .. method:: Creature:SetStandardFactionReputation(faction, rep)

  .. method:: Creature:SetSubrace(subrace)

  .. method:: Creature:SetTail(tail)

  .. method:: Creature:SetWings(wings)

  .. method:: Creature:SetWizardSpecialization(specialization)

  .. method:: Creature:SetXP(amount, direct)

  .. method:: Creature:SpeakOneLinerConversation(resref, target)

  .. method:: Creature:StopFade()

  .. method:: Creature:StoreCameraFacing()

  .. method:: Creature:SuccessMessage(message, ...)

  .. method:: Creature:SummonAnimalCompanion()

  .. method:: Creature:SummonFamiliar()

  .. method:: Creature:SurrenderToEnemies()

  .. method:: Creature:TakeGold(amount, feedback, source)

  .. method:: Creature:UnpossessFamiliar()

  .. method:: Creature:UpdateCombatInfo(all)
