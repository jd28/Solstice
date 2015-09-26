.. highlight:: lua
.. default-domain:: lua

class Object
============

.. class:: Object

  .. method:: Object:ActionCloseDoor(door)

  .. method:: Object:ActionGiveItem(item, target)

  .. method:: Object:ActionLockObject(target)

  .. method:: Object:ActionOpenDoor(door)

  .. method:: Object:ActionPauseConversation()

  .. method:: Object:ActionResumeConversation()

  .. method:: Object:ActionSpeakString(message, volume)

  .. method:: Object:ActionSpeakStringByStrRef(strref, volume)

  .. method:: Object:ActionStartConversation(target, dialog, private, hello)

  .. method:: Object:ActionTakeItem(item, target)

  .. method:: Object:ActionUnlockObject(target)

  .. method:: Object:ActionWait(time)

  .. method:: Object:ApplyEffect(dur_type, effect, duration)

  .. method:: Object:ApplyVisual(vfx, duration)

  .. method:: Object:AssignCommand(f)

  .. method:: Object:BeginConversation(target, conversation)

  .. method:: Object:ChangeFaction(faction)

  .. method:: Object:CheckType(...)

  .. method:: Object:ClearAllActions(clear_combat)

  .. method:: Object:Copy(location, owner, tag)

  .. method:: Object:CountItem(id, resref)

  .. method:: Object:DecrementLocalInt(name, val)

  .. method:: Object:DelayCommand(delay, action)

  .. method:: Object:DeleteAllProperties()

  .. method:: Object:DeleteLocalBool(name)

  .. method:: Object:DeleteLocalFloat(name)

  .. method:: Object:DeleteLocalInt(name)

  .. method:: Object:DeleteLocalLocation(name)

  .. method:: Object:DeleteLocalObject(name)

  .. method:: Object:DeleteLocalString(name)

  .. method:: Object:DeleteProperty(prop)

  .. method:: Object:Destroy(delay)

  .. method:: Object:DoCommand(action)

  .. method:: Object:DoDamage(amount)

  .. method:: Object:DoDamageImmunity(amt, dmgidx)

  .. method:: Object:DoDamageReduction(amt, eff, power)

  .. method:: Object:DoDamageResistance(amt, eff, dmgidx)

  .. method:: Object:Effects(direct)

  .. method:: Object:FortitudeSave(dc, save_type, vs)

  .. method:: Object:GetACVersus(attacker, attack)

  .. method:: Object:GetAllProperties()

  .. method:: Object:GetAllVars(match, type)

  .. method:: Object:GetArea()

  .. method:: Object:GetBaseResist(dmgidx)

  .. method:: Object:GetCasterLevel()

  .. method:: Object:GetColor(channel)

  .. method:: Object:GetCommandable()

  .. method:: Object:GetConcealment()

  .. method:: Object:GetCurrentAction()

  .. method:: Object:GetCurrentHitPoints()

  .. method:: Object:GetDescription(original, identified)

  .. method:: Object:GetDistanceToObject(obj)

  .. method:: Object:GetEffectAtIndex(idx)

  .. method:: Object:GetEffectCount()

  .. method:: Object:GetFacing()

  .. method:: Object:GetFactionAverageGoodEvilAlignment()

  .. method:: Object:GetFactionAverageLawChaosAlignment()

  .. method:: Object:GetFactionAverageLevel()

  .. method:: Object:GetFactionAverageReputation(target)

  .. method:: Object:GetFactionAverageXP()

  .. method:: Object:GetFactionBestAC(visible)

  .. method:: Object:GetFactionGold()

  .. method:: Object:GetFactionId()

  .. method:: Object:GetFactionLeader()

  .. method:: Object:GetFactionLeastDamagedMember(visible)

  .. method:: Object:GetFactionMostDamagedMember(visible)

  .. method:: Object:GetFactionMostFrequentClass()

  .. method:: Object:GetFactionStrongestMember(visible)

  .. method:: Object:GetFactionWeakestMember(visible)

  .. method:: Object:GetFactionWorstAC(visible)

  .. method:: Object:GetFirstEffect()

  .. method:: Object:GetFirstItemInInventory()

  .. method:: Object:GetFortitudeSavingThrow()

  .. method:: Object:GetGold()

  .. method:: Object:GetHardness()

  .. method:: Object:GetHasEffectById(id)

  .. method:: Object:GetHasInventory()

  .. method:: Object:GetHasSpellEffect(spell)

  .. method:: Object:GetIsDead()

  .. method:: Object:GetIsImmune(immunity)

  .. method:: Object:GetIsInvulnerable()

  .. method:: Object:GetIsListening()

  .. method:: Object:GetIsOpen()

  .. method:: Object:GetIsTimerActive(name)

  .. method:: Object:GetIsTrapped()

  .. method:: Object:GetIsValid()

  .. method:: Object:GetItemPossessedBy(tag, is_resref)

  .. method:: Object:GetKeyRequired()

  .. method:: Object:GetKeyRequiredFeedback()

  .. method:: Object:GetKiller()

  .. method:: Object:GetLastAttacker()

  .. method:: Object:GetLastDamager()

  .. method:: Object:GetLastHostileActor()

  .. method:: Object:GetLastOpenedBy()

  .. method:: Object:GetLocalBool(name)

  .. method:: Object:GetLocalFloat(name)

  .. method:: Object:GetLocalInt(name)

  .. method:: Object:GetLocalLocation(name)

  .. method:: Object:GetLocalObject(name)

  .. method:: Object:GetLocalString(name)

  .. method:: Object:GetLocalVarByIndex(index)

  .. method:: Object:GetLocalVarCount()

  .. method:: Object:GetLocation()

  .. method:: Object:GetLockDC()

  .. method:: Object:GetLockKeyTag()

  .. method:: Object:GetLockable()

  .. method:: Object:GetLocked()

  .. method:: Object:GetMaxHitPoints()

  .. method:: Object:GetName(original)

  .. method:: Object:GetNearestCreature(type1, value1, nth, ...)

  .. method:: Object:GetNearestObject(obj_type, nth)

  .. method:: Object:GetNearestObjectByTag(tag, nth)

  .. method:: Object:GetNearestTrap(is_detected)

  .. method:: Object:GetNextEffect()

  .. method:: Object:GetNextItemInInventory()

  .. method:: Object:GetPlotFlag()

  .. method:: Object:GetPortraitId()

  .. method:: Object:GetPortraitResRef()

  .. method:: Object:GetPosition()

  .. method:: Object:GetProperty(prop)

  .. method:: Object:GetReflexSavingThrow()

  .. method:: Object:GetResRef()

  .. method:: Object:GetSpellCastAtCaster()

  .. method:: Object:GetSpellCastAtHarmful()

  .. method:: Object:GetSpellCastAtId()

  .. method:: Object:GetSpellCastClass()

  .. method:: Object:GetSpellCastItem()

  .. method:: Object:GetSpellId()

  .. method:: Object:GetSpellResistance()

  .. method:: Object:GetSpellSaveDC(spell)

  .. method:: Object:GetSpellTargetLocation()

  .. method:: Object:GetSpellTargetObject()

  .. method:: Object:GetTag()

  .. method:: Object:GetTransitionTarget()

  .. method:: Object:GetTrap()

  .. method:: Object:GetType()

  .. method:: Object:GetType()

  .. method:: Object:GetUnlockDC()

  .. method:: Object:GetWillSavingThrow()

  .. method:: Object:GiveItem(resref, stack_size, new_tag, only_once)

  .. method:: Object:HasItem(tag)

  .. method:: Object:IncrementLocalInt(name, val)

  .. method:: Object:Items()

  .. method:: Object:LineOfSight(target)

  .. method:: Object:LogEffects()

  .. method:: Object:ModifyCurrentHitPoints(amount)

  .. method:: Object:OpenInventory(target)

  .. method:: Object:PlaySound(sound)

  .. method:: Object:PlaySoundByStrRef(strref, as_action)

  .. method:: Object:ReflexSave(dc, save_type, vs)

  .. method:: Object:RemoveEffect(effect)

  .. method:: Object:RemoveEffectByID(id)

  .. method:: Object:RemoveEffectsByType(type)

  .. method:: Object:ResistSpell(vs)

  .. method:: Object:SetColor(channel, value)

  .. method:: Object:SetCommandable(commandable)

  .. method:: Object:SetCurrentHitPoints(hp)

  .. method:: Object:SetDescription(description, identified)

  .. method:: Object:SetFacing(direction)

  .. method:: Object:SetFacingPoint(target)

  .. method:: Object:SetFactionId(faction)

  .. method:: Object:SetFortitudeSavingThrow(val)

  .. method:: Object:SetHardness(hardness)

  .. method:: Object:SetIsDestroyable(destroyable, raiseable, selectable)

  .. method:: Object:SetKeyRequired(key_required)

  .. method:: Object:SetKeyRequiredFeedback(message)

  .. method:: Object:SetKeyTag(tag)

  .. method:: Object:SetLastHostileActor(actor)

  .. method:: Object:SetListenPattern(pattern, number)

  .. method:: Object:SetListening(val)

  .. method:: Object:SetLocalBool(name, val)

  .. method:: Object:SetLocalFloat(name, val)

  .. method:: Object:SetLocalInt(name, val)

  .. method:: Object:SetLocalLocation(name, val)

  .. method:: Object:SetLocalObject(name, val)

  .. method:: Object:SetLocalString(name, val)

  .. method:: Object:SetLockDC(dc)

  .. method:: Object:SetLockLockable(lockable)

  .. method:: Object:SetLocked(locked)

  .. method:: Object:SetLocked(locked)

  .. method:: Object:SetMaxHitPoints(hp)

  .. method:: Object:SetName(name)

  .. method:: Object:SetPlotFlag(flag)

  .. method:: Object:SetPortraitId(id)

  .. method:: Object:SetPortraitResRef(resref)

  .. method:: Object:SetProperty(prop, value)

  .. method:: Object:SetReflexSavingThrow(val)

  .. method:: Object:SetTag(tag)

  .. method:: Object:SetTimer(var_name, duration, on_expire)

  .. method:: Object:SetUnlockDC(dc)

  .. method:: Object:SetWillSavingThrow(val)

  .. method:: Object:SpeakString(text, volume)

  .. method:: Object:SpeakStringByStrRef(strref, volume)

  .. method:: Object:TakeItem(id, count, resref)

  .. method:: Object:Trap(type, faction, on_disarm, on_trigger)

  .. method:: Object:WillSave(dc, save_type, vs)

