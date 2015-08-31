.. highlight:: lua
.. default-domain:: lua

class Object
============

.. class:: Object

General
-------

  .. method:: Object:Copy(location, owner, tag)

  .. method:: Object:BeginConversation(target, conversation)

  .. method:: Object:Destroy(delay)

  .. method:: Object:GetIsDead()

  .. method:: Object:GetIsTimerActive(name)

  .. method:: Object:GetTrap()

  .. method:: Object:GetIsTrapped()

  .. method:: Object:GetIsValid()

  .. method:: Object:PlaySound(sound)

  .. method:: Object:PlaySoundByStrRef(strref, as_action)

  .. method:: Object:ResistSpell(vs)

  .. method:: Object:SetTag(tag)

  .. method:: Object:Trap(type, faction, on_disarm, on_trigger)

  .. method:: Object:GetTransitionTarget()

  .. method:: Object:GetType()

  .. method:: Object:GetLastOpenedBy()

  .. method:: Object:SetTimer(var_name, duration, on_expire)

Actions
-------

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

  .. method:: Object:ClearAllActions(clear_combat)

  .. method:: Object:GetCurrentAction()

  .. method:: Object:SpeakString(text, volume)

  .. method:: Object:SpeakStringByStrRef(strref, volume)

Combat
------

  .. method:: Object:DoDamage(amount)

  .. method:: Object:GetACVersus(attacker, attack)

  .. method:: Object:GetConcealment()

  .. method:: Object:GetHardness()

  .. method:: Object:GetIsImmune(immunity)

  .. method:: Object:GetLastAttacker()

  .. method:: Object:GetLastDamager()

  .. method:: Object:GetKiller()

  .. method:: Object:GetLastHostileActor()

  .. method:: Object:SetHardness(hardness)

  .. method:: Object:SetLastHostileActor(actor)

  .. method:: Object:GetDamageImmunity(dmgidx)

  .. method:: Object:DebugDamageImmunities()

  .. method:: Object:DebugDamageResistance()

  .. method:: Object:DebugDamageReduction()

  .. method:: Object:DoDamageImmunity(amt, dmgidx)

  .. method:: Object:GetBestDamageResistEffect(dmgidx, start)

  .. method:: Object:GetBestDamageReductionEffect(power, start)

  .. method:: Object:GetBaseResist(dmgidx)

  .. method:: Object:DoDamageResistance(amt, eff, dmgidx)

  .. method:: Object:DoDamageReduction(amt, eff, power)

  .. method:: Object:GetIsInvulnerable()

Commands
--------

  .. method:: Object:AssignCommand(f)

  .. method:: Object:DelayCommand(delay, action)

  .. method:: Object:DoCommand(action)

  .. method:: Object:GetCommandable()

  .. method:: Object:SetCommandable(commandable)

Effects
-------

  .. method:: Object:ApplyEffect(dur_type, effect, duration)

  .. method:: Object:ApplyVisual(vfx, duration)

  .. method:: Object:Effects(direct)

  .. method:: Object:GetEffectAtIndex(idx)

  .. method:: Object:GetEffectCount()

  .. method:: Object:GetHasEffectById(id)

  .. method:: Object:GetHasSpellEffect(spell)

  .. method:: Object:GetFirstEffect()

  .. method:: Object:GetNextEffect()

  .. method:: Object:LogEffects()

  .. method:: Object:RemoveEffect(effect)

  .. method:: Object:RemoveEffectByID(id)

  .. method:: Object:RemoveEffectsByType(type)

Faction
-------

  .. method:: Object:ChangeFaction(faction)

  .. method:: Object:GetFactionId()

  .. method:: Object:SetFactionId(faction)

  .. method:: Object:GetFactionAverageGoodEvilAlignment()

  .. method:: Object:GetFactionAverageLawChaosAlignment()

  .. method:: Object:GetFactionAverageLevel()

  .. method:: Object:GetFactionAverageReputation(target)

  .. method:: Object:GetFactionAverageXP()

  .. method:: Object:GetFactionBestAC(visible)

  .. method:: Object:GetFactionGold()

  .. method:: Object:GetFactionLeastDamagedMember(visible)

  .. method:: Object:GetFactionMostDamagedMember(visible)

  .. method:: Object:GetFactionMostFrequentClass()

  .. method:: Object:GetFactionLeader()

  .. method:: Object:GetFactionStrongestMember(visible)

  .. method:: Object:GetFactionWeakestMember(visible)

  .. method:: Object:GetFactionWorstAC(visible)

Hitpoints
---------

  .. method:: Object:GetCurrentHitPoints()

  .. method:: Object:ModifyCurrentHitPoints(amount)

  .. method:: Object:SetCurrentHitPoints(hp)

  .. method:: Object:GetMaxHitPoints()

  .. method:: Object:SetMaxHitPoints(hp)

Info
----

  .. method:: Object:GetColor(channel)

  .. method:: Object:GetDescription(original, identified)

  .. method:: Object:GetGold()

  .. method:: Object:GetName(original)

  .. method:: Object:GetType()

  .. method:: Object:CheckType(...)

  .. method:: Object:GetPlotFlag()

  .. method:: Object:GetPortraitId()

  .. method:: Object:GetPortraitResRef()

  .. method:: Object:GetResRef()

  .. method:: Object:GetTag()

  .. method:: Object:SetColor(channel, value)

  .. method:: Object:SetDescription(description, identified)

  .. method:: Object:SetIsDestroyable(destroyable, raiseable, selectable)

  .. method:: Object:SetName(name)

  .. method:: Object:SetPlotFlag(flag)

  .. method:: Object:SetPortraitId(id)

  .. method:: Object:SetPortraitResRef(resref)

Inventory
---------

  .. method:: Object:GetFirstItemInInventory()

  .. method:: Object:GetHasInventory()

  .. method:: Object:HasItem(tag)

  .. method:: Object:GetItemPossessedBy(tag, is_resref)

  .. method:: Object:Items()

  .. method:: Object:GetNextItemInInventory()

  .. method:: will not give item if

  .. method:: Object:GiveItem(resref, stack_size, new_tag, only_once)

  .. method:: Object:OpenInventory(target)

  .. method:: Object:CountItem(id, resref)

  .. method:: handles stack size reduction.  It also checks if the

  .. method:: Object:TakeItem(id, count, resref)

Location
--------

  .. method:: Object:GetArea()

  .. method:: Object:GetDistanceToObject(obj)

  .. method:: Object:GetFacing()

  .. method:: Object:GetLocation()

  .. method:: Object:GetPosition()

  .. method:: Object:LineOfSight(target)

  .. method:: Object:SetFacing(direction)

  .. method:: Object:SetFacingPoint(target)

Lock
----

  .. method:: Object:GetLocked()

  .. method:: Object:GetLockable()

  .. method:: Object:GetIsOpen()

  .. method:: Object:SetLocked(locked)

  .. method:: Object:GetKeyRequired()

  .. method:: Object:GetKeyRequiredFeedback()

  .. method:: Object:GetLockKeyTag()

  .. method:: Object:GetUnlockDC()

  .. method:: Object:GetLockDC()

  .. method:: Object:SetLocked(locked)

  .. method:: Object:SetKeyRequired(key_required)

  .. method:: Object:SetKeyRequiredFeedback(message)

  .. method:: Object:SetKeyTag(tag)

  .. method:: Object:SetLockLockable(lockable)

  .. method:: Object:SetUnlockDC(dc)

  .. method:: Object:SetLockDC(dc)

Nearest
-------

  .. method:: Object:GetNearestCreature(type1, value1, nth, ...)

  .. method:: Object:GetNearestObject(obj_type, nth)

  .. method:: Object:GetNearestObjectByTag(tag, nth)

  .. method:: Object:GetNearestTrap(is_detected)

Perception
----------

  .. method:: Object:GetIsListening()

  .. method:: Object:SetListening(val)

  .. method:: Object:SetListenPattern(pattern, number)

Properties
----------

  .. method:: Object:GetProperty(prop)

  .. method:: Object:SetProperty(prop, value)

  .. method:: Object:GetAllProperties()

  .. method:: Object:DeleteProperty(prop)

  .. method:: Object:DeleteAllProperties()

Saves
-----

  .. method:: Object:FortitudeSave(dc, save_type, vs)

  .. method:: Object:GetFortitudeSavingThrow()

  .. method:: Object:GetReflexSavingThrow()

  .. method:: Object:GetWillSavingThrow()

  .. method:: Object:ReflexSave(dc, save_type, vs)

  .. method:: Object:SetFortitudeSavingThrow(val)

  .. method:: Object:SetReflexSavingThrow(val)

  .. method:: Object:SetWillSavingThrow(val)

  .. method:: Object:WillSave(dc, save_type, vs)

Spells
------

  .. method:: Object:GetCasterLevel()

  .. method:: Object:GetSpellCastAtCaster()

  .. method:: Object:GetSpellCastAtHarmful()

  .. method:: Object:GetSpellCastAtId()

  .. method:: Object:GetSpellCastClass()

  .. method:: Object:GetSpellId()

  .. method:: Object:GetSpellCastItem()

  .. method:: Object:GetSpellResistance()

  .. method:: Object:GetSpellSaveDC(spell)

  .. method:: Object:GetSpellTargetLocation()

  .. method:: Object:GetSpellTargetObject()

Variables
---------

  .. method:: Object:GetLocalVarCount()

  .. method:: Object:GetLocalVarByIndex(index)

  .. method:: Object:GetAllVars(match, type)

  .. method:: Object:DecrementLocalInt(name, val)

  .. method:: Object:DeleteLocalBool(name)

  .. method:: Object:DeleteLocalInt(name)

  .. method:: Object:DeleteLocalFloat(name)

  .. method:: Object:DeleteLocalString(name)

  .. method:: Object:DeleteLocalObject(name)

  .. method:: Object:DeleteLocalLocation(name)

  .. method:: Object:GetLocalBool(name)

  .. method:: Object:GetLocalInt(name)

  .. method:: Object:GetLocalFloat(name)

  .. method:: Object:GetLocalLocation(name)

  .. method:: Object:GetLocalObject(name)

  .. method:: Object:GetLocalString(name)

  .. method:: Object:IncrementLocalInt(name, val)

  .. method:: Object:SetLocalBool(name, val)

  .. method:: Object:SetLocalFloat(name, val)

  .. method:: Object:SetLocalInt(name, val)

  .. method:: Object:SetLocalLocation(name, val)

  .. method:: Object:SetLocalString(name, val)

  .. method:: Object:SetLocalObject(name, val)