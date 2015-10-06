.. highlight:: lua
.. default-domain:: lua

class Object
============

.. class:: Object

  .. method:: Object:ActionCloseDoor(door)

    An action that causes an object to close a door.

    :param door: Door to close
    :type door: :class:`Door`

  .. method:: Object:ActionGiveItem(item, target)

    Gives a specified item to a target creature.

    :param item: Item to give.
    :type item: :class:`Item`
    :param target: Receiver
    :type target: :class:`Object`

  .. method:: Object:ActionLockObject(target)

    An action that will cause a creature to lock a door or other unlocked object.

    :param target: Door or placeable object that will be the target of the lock attempt.
    :type target: :class:`Door` or :class:`Placeable`

  .. method:: Object:ActionOpenDoor(door)

    An action that will cause a creature to open a door.

    :param door: Door to close
    :type door: :class:`Door`

  .. method:: Object:ActionPauseConversation()

    Pause the current conversation.

  .. method:: Object:ActionResumeConversation()

    Resume a conversation after it has been paused.

  .. method:: Object:ActionSpeakString(message[, volume])

    Causes an object to speak.

    :param string message: String to be spoken.
    :param int volume: VOLUME_* constant.  Default: VOLUME_TALK

  .. method:: Object:ActionSpeakStringByStrRef(strref, volume)

    Causes the creature to speak a translated string.

    :param int strref: Reference of the string in the talk table.
    :param int volume: VOLUME_* constant.  Default: VOLUME_TALK

  .. method:: Object:ActionStartConversation(target[, dialog[, private[, hello]]])

    Action to start a conversation with a PC

    :param target: An object to converse with.
    :type target: :class:`Object`
    :param string dialog: The resource reference (filename) of a conversation.  Default: ""
    :param bool private: Specify whether the conversation is audible to everyone or only to the PC.  Default: ``false``
    :param bool hello: Determines if initial greeting is played.  Default: ``true``

  .. method:: Object:ActionTakeItem(item, target)

    Takes an item from an object.

    :param item: The item to take.
    :type item: :class:`Item`
    :param target: The object from which to take the item.
    :type target: :class:`Object`

  .. method:: Object:ActionUnlockObject(target)

    Causes a creature to unlock a door or other locked object.

    :param target: Door or placeable object that will be the target of the unlock attempt.
    :type target: :class:`Door` or :class:`Placeable`

  .. method:: Object:ActionWait(time)

    Adds a wait action to an objects queue.

    :param float time: Time in seconds to wait.

  .. method:: Object:ApplyEffect(dur_type, effect, duration)

    Applies an effect to an object.

    :param int dur_type: DURATION_TYPE_* constant.
    :param effect: Effect to apply.
    :type effect: :class:`Effect`
    :param float duration: Time in seconds for effect to last.  Default: 0.0

  .. method:: Object:ApplyVisual(vfx, duration)

    Applies visual effect to object.

    :param int vfx: VFX_* constant.
    :param float duration: Duration in seconds.  If not passed effect will be of duration type DURATION_TYPE_INSTANT

  .. method:: Object:AssignCommand(f)

    Assigns a command to an object.

    .. note::

      No longer really necessary as all actions are explicitly assigned.

    :param function f: A closure.

  .. method:: Object:BeginConversation(target, conversation)

    Begin conversation.

    :param target: Object to converse with
    :param string conversation: Dialog resref.  Default: ""

  .. method:: Object:ChangeFaction(faction)

    Changes objects faction.

    :param faction: Object of desired faction.
    :type faction: :class:`Object`

  .. method:: Object:CheckType(...)

    Checks object type.

    :param ...: Any number of OBJECT_TYPE_* constants

  .. method:: Object:ClearAllActions([clear_combat])

    Removes all actions from an action queue.

    :param bool clear_combat: combat along with all other actions.  Default: ``false``.

  .. method:: Object:Copy(location, owner, tag)

    Copies an object

    :param location: Location to copy the object to.
    :param owner: Owner of the object
    :param string tag: Tag of new object.  Default: ""

  .. method:: Object:CountItem(id[, resref])

    Get number of items that an object carries.

    :param string id: Tag or Resref.
    :param bool resref: If ``true`` count by resref.  Default: ``false``

  .. method:: Object:DecrementLocalInt(name, val)

    Decrements local integer variable.

    :param string name: Variable name.
    :param int val: Amount to decrement.  Default: 1
    :rtype: New value.

  .. method:: Object:DelayCommand(delay, action)

    Delays a command.

    :param float delay: Time in seconds.
    :param function action: A closure.

  .. method:: Object:DeleteLocalBool(name)

    Boolean wrapper around DeleteLocalInt Int/Bool values are stored under the same name

    :param string name: Variable name.

  .. method:: Object:DeleteLocalFloat(name)

    Delete a local float variable

    :param string name: Variable to delete

  .. method:: Object:DeleteLocalInt(name)

    Delete a local int variable

    :param string name: Variable name.

  .. method:: Object:DeleteLocalLocation(name)

    Delete a local location variable

    :param string name: Variable to delete

  .. method:: Object:DeleteLocalObject(name)

    Delete a local object variable

    :param string name: Variable to delete

  .. method:: Object:DeleteLocalString(name)

    Delete a local string variable

    :param string name: Variable to delete

  .. method:: Object:Destroy([delay])

    Destroy an object.

    :param float delay: Delay (in seconds) before object is destroyed.  Default: 0.0


  .. method:: Object:DoCommand(action)

    Inserts action into action queue.

    :param function action: A closure.

  .. method:: Object:DoDamage(amount)

  .. method:: Object:Effects([direct])

    An iterator that iterates over applied effects.

    :param bool direct:  If ``true``, the actual effect will be returned.  Modifying it will modify the applied effect.  If ``false``, a copy of the effect will be returned.

  .. method:: Object:FortitudeSave(dc, save_type, vs)

    Do fortitude save.

    :param int dc: Difficult class
    :param int save_type:
    :param vs: Save versus object
    :type vs: :class:`Object`

  .. method:: Object:GetAllVars([match[, type]])

    Get all variables.  TODO: Document variable type constant.

    :param string match: A string pattern for testing variable names.  See string.find
    :param int type: Get variables of a particular type.

  .. method:: Object:GetArea()

    Get area object is in.

  .. method:: Object:GetCasterLevel()

    Determines caster level.

  .. method:: Object:GetColor(channel)

  .. method:: Object:GetCommandable()

    Get is object commandable.

  .. method:: Object:GetCurrentAction()

    Returns the currently executing Action.

  .. method:: Object:GetCurrentHitPoints()

    Gets an object's current hitpoints

  .. method:: Object:GetDescription([original[, identified]])

    Get object's description.

    :param bool original: If true get original description.  Default: ``false``
    :param bool identified: If true get identified description.  Default: ``true``

  .. method:: Object:GetDistanceToObject(obj)

    Get distance between two objects.

    :param obj: Object to determine distance to.
    :type obj: :class:`Object`

  .. method:: Object:GetEffectAtIndex(idx)

    Get an effect.

    .. note::

      This returns effects directly.  Modifying them will modify the applied effect.

    :param int idx: Index is zero based.
    :rtype: :class:`Effect` or ``nil``

  .. method:: Object:GetEffectCount()

    Get the number effects applied to an object;

  .. method:: Object:GetFacing()

    Get direction object is facing.

  .. method:: Object:GetFactionAverageGoodEvilAlignment()

  .. method:: Object:GetFactionAverageLawChaosAlignment()

  .. method:: Object:GetFactionAverageLevel()

  .. method:: Object:GetFactionAverageReputation(target)

  .. method:: Object:GetFactionAverageXP()

  .. method:: Object:GetFactionBestAC([visible])

    Get faction member with best AC.

    :param bool visible: If ``true`` member must be visible.  Default: ``false``.

  .. method:: Object:GetFactionGold()

    Get factions gold.

  .. method:: Object:GetFactionId()

    Gets an objects faction ID.

  .. method:: Object:GetFactionLeader()

  .. method:: Object:GetFactionLeastDamagedMember(visible)

  .. method:: Object:GetFactionMostDamagedMember(visible)

  .. method:: Object:GetFactionMostFrequentClass()

  .. method:: Object:GetFactionStrongestMember(visible)

  .. method:: Object:GetFactionWeakestMember(visible)

  .. method:: Object:GetFactionWorstAC(visible)

  .. method:: Object:GetFortitudeSavingThrow()

    Get fortitude saving throw.

  .. method:: Object:GetGold()

    Get object's gold.

  .. method:: Object:GetHardness()

    Determine object's 'hardness'.

  .. method:: Object:GetHasEffectById(id)

    Get if an object has an effect by ID.

    :param int id: Effect ID.

  .. method:: Object:GetHasInventory()

    Determines if object has an inventory.

  .. method:: Object:GetHasSpellEffect(spell)

    Get if object has an effect applied by a spell.

    :param int spell: SPELL_* constant.

  .. method:: Object:GetIsDead()

    Determine if dead.

  .. method:: Object:GetIsImmune(immunity)

    Determines if object is immune to an effect.

    :param int immunity: IMMUNITY_TYPE_* constant.
    :rtype: Always ``false``.

  .. method:: Object:GetIsInvulnerable()

    Determine if object is invulnerable.

  .. method:: Object:GetIsListening()

    Get if object is listening.

  .. method:: Object:GetIsOpen()

    Get is object open.

  .. method:: Object:GetIsTimerActive(name)

    Determine if named timer is still active.

    :param string name: Timer name.
    :rtype: ``bool``

  .. method:: Object:GetIsTrapped()

    Check whether an object is trapped.

    :rtype: ``bool``

  .. method:: Object:GetIsValid()

    Determines if an object is valid.

  .. method:: Object:GetItemPossessedBy(tag[, is_resref])

    Determine if object has an item.

    :param string tag: Object tag to search for
    :param bool is_resref: If true search by resref rather than tag.  Default: ``false``

  .. method:: Object:GetKeyRequired()

    Determine if a key is required.

  .. method:: Object:GetKeyRequiredFeedback()

    Feedback for when missing key.

  .. method:: Object:GetKiller()

    Gets the object's killer.

    :rtype: :class:`Object`

  .. method:: Object:GetLastAttacker()

    Determine who last attacked a creature, door or placeable object.

  .. method:: Object:GetLastDamager()

    Get the object which last damaged a creature or placeable object.

  .. method:: Object:GetLastHostileActor()

    Gets the last living, non plot creature that performed a hostile act against the object.

  .. method:: Object:GetLastOpenedBy()

    Gets the last object to open an object.

  .. method:: Object:GetLocalBool(name)

    A wrapper around GetLocalInt returning ``false`` if the result is 0, ``true`` otherwise.

    :param string name: Variable name

  .. method:: Object:GetLocalFloat(name)

    Get local float variable

    :param string name: Variable name

  .. method:: Object:GetLocalInt(name)

    Get a local int variable

    :param string name: Variable name

  .. method:: Object:GetLocalLocation(name)

    Get local location variable

    :param string name: Variable name

  .. method:: Object:GetLocalObject(name)

    Get local object variable

    :param string name: Variable name

  .. method:: Object:GetLocalString(name)

    Get local string

    :param string name: Variable name.

  .. method:: Object:GetLocalVarByIndex(index)

    Get local variable by index.  TODO: Return type???

    :param index: Positive integer.

  .. method:: Object:GetLocalVarCount()

    Get local variable count.

  .. method:: Object:GetLocation()

    Get object's location.

    :rtype: :class:`Location`

  .. method:: Object:GetLockDC()

    Get lock's DC.

  .. method:: Object:GetLockKeyTag()

    Get lock's key tag.

    :rtype: ``string``

  .. method:: Object:GetLockable()

    Get if object is lockable.

  .. method:: Object:GetLocked()

    Get if object is locked.

  .. method:: Object:GetMaxHitPoints()

    Get object's max hitpoints.

  .. method:: Object:GetName([original])

    Get object's name.

    :param bool original: If ``true`` returns object's original name, if ``false`` returns overridden name.  Default: ``false``.

  .. method:: Object:GetNearestCreature(type1, value1, nth, ...)

    Gets nearest creature by criteria types and values.

  .. method:: Object:GetNearestObject([obj_type[, nth]])

    Get nearest object.

    :param int obj_type: OBJECT_TYPE_* constant.  Default: OBJECT_TYPE_ALL
    :param int nth: Which object to return.  Default: 1

  .. method:: Object:GetNearestObjectByTag(tag[, nth])

    Get nearest object by tag.

    :param string tag: Tag of object
    :param int nth: Which object to return.  Default: 1

  .. method:: Object:GetNearestTrap(is_detected)

    Get nearest trap.

    :param bool is_detected: If ``true`` return only detected traps.  Default: ``false``.

  .. method:: Object:GetPlotFlag()

    Get plot flag.

  .. method:: Object:GetPortraitId()

    Get portrait ID.

  .. method:: Object:GetPortraitResRef()

    Get portrait resref.

    :rtype: ``string``

  .. method:: Object:GetPosition()

    Get object's position.

    :rtype: :class:`Vector`

  .. method:: Object:GetReflexSavingThrow()

    Get reflex saving throw.

  .. method:: Object:GetResRef()

    Returns the Resref of an object.

    :rtype: ``string``

  .. method:: Object:GetSpellCastAtCaster()

    Gets the caster of the last spell.

  .. method:: Object:GetSpellCastAtHarmful()

    Determine if the last spell cast at object is harmful.

  .. method:: Object:GetSpellCastAtId()

    Determine spell id of the last spell cast at object.

  .. method:: Object:GetSpellCastClass()

    Determine class of the last spell cast at object.

  .. method:: Object:GetSpellCastItem()

    Get item of that last spell cast.

  .. method:: Object:GetSpellId()

    Get spell id of that last spell cast.

  .. method:: Object:GetSpellResistance()

    Get spell resistance.

  .. method:: Object:GetSpellSaveDC(spell)

    Determine spell save DC.

    :param int spell: SPELL_* constant.

  .. method:: Object:GetSpellTargetLocation()

    Get spell target location.

    :rtype: :class:`Location`

  .. method:: Object:GetSpellTargetObject()

    Get last spell target.

    :rtype: :class:`Object`

  .. method:: Object:GetTag()

    Determine the tag associated with an object.

    :rtype: ``string``

  .. method:: Object:GetTransitionTarget()

    Gets transition target.

  .. method:: Object:GetTrapBaseType()

  .. method:: Object:GetTrapCreator()

    Get traps creator

  .. method:: Object:GetTrapDetectable()

    Get if trap is detectable.

  .. method:: Object:GetTrapDetectDC()

    Get the DC required to detect trap.

  .. method:: Object:GetTrapDetectedBy(creature)

    Get if trap was detected by creature

  .. method:: Object:GetTrapDisarmable()

    Get if trap is disarmable

  .. method:: Object:GetTrapDisarmDC()

    Get DC required to disarm trap

  .. method:: Object:GetTrapFlagged()

    Get if trap is flagged

  .. method:: Object:GetTrapKeyTag()

    Get trap's key tag

  .. method:: Object:GetTrapOneShot()

    Get if trap is oneshot

  .. method:: Object:GetType()

    Get an object's type.

    :rtype: OBJECT_TYPE_* or OBJECT_TYPE_NONE on error.

  .. method:: Object:GetUnlockDC()

    Get lock unlock DC.

  .. method:: Object:GetWillSavingThrow()

    Get will saving throw.

  .. method:: Object:GiveItem(resref[, stack_size[, new_tag[, only_once]])

    Create a specific item in an objects inventory.

    :param string resref: The blueprint ResRef string of the item to be created or tag.
    :param int stack_size: The number of items to be created.  Default: 1
    :param string new_tag: If this string is empty (""), it be set to the default tag from the template.  Default: ""
    :param bool only_once: If ``true``, function will not give item if object already possess one.  Default ``false``

  .. method:: Object:HasItem(tag)

    Determines if an object has an item by tag.

    :param string tag: Tag to search for.

  .. method:: Object:IncrementLocalInt(name, val)

    Increment local integer variable

    :param string name: Variable name
    :param int val: Amount to increment.  Default: 1
    :rtype: New local variable value.

  .. method:: Object:Items()

    Iterator over items in an object's inventory.

  .. method:: Object:LineOfSight(target)

    Get is target in line of sight

    :param target: Target to check.
    :type target: :class:`Object`

  .. method:: Object:ModifyCurrentHitPoints(amount)

    Modifies an object's current hitpoints.

    :param int amount: Amount to modify.

  .. method:: Object:OpenInventory(target)

    Open Inventory of specified target

    :param target: Creature to view the inventory of.

  .. method:: Object:PlaySound(sound)

    Causes object to play a sound

    :param string sound: Sound to play

  .. method:: Object:PlaySoundByStrRef(strref[, as_action])

    Causes object to play a sound.

    :param int strref: Sound to play
    :param bool as_action: Determines if this is an action that can be stacked on the action queue.  Default: ``true``

  .. method:: Object:ReflexSave(dc, save_type, vs)

    Do reflex save.

    :param int dc: Difficult class
    :param int save_type:
    :param vs: Save versus object
    :type vs: :class:`Object`

  .. method:: Object:RemoveEffect(effect)

    Removes an effect from object

    :param effect: Effect to remove.
    :type effect: :class:`Effect`

  .. method:: Object:RemoveEffectByID(id)

    Removes an effect from object by ID

    :param int id: Effect id to remove.

  .. method:: Object:RemoveEffectsByType(type)

    Remove effect by type.

    :param int type: EFFECT_TYPE_*

  .. method:: Object:ResistSpell(vs)

    Attempt to resist a spell.

    :param vs: Attacking caster
    :type vs: :class:`Object`

  .. method:: Object:SetColor(channel, value)

  .. method:: Object:SetCommandable([commandable])

    Set is object commandable.

    :param bool commandable: New value.  Default: ``false``.

  .. method:: Object:SetCurrentHitPoints(hp)

    Sets an object's current hitpoints.

    :param int hp: A number between 1 and 10000

  .. method:: Object:SetDescription(description[, identified])

    Set object's description.

    :param string description: New description.
    :param bool identified: If ``true`` sets identified description.  Default: ``true``

  .. method:: Object:SetFacing(direction)

    Set direction object is facing in.

  .. method:: Object:SetFacingPoint(target)

    Set the point the object is facing.

    :param target: Vector position.
    :type target: :class:`Vector`

  .. method:: Object:SetFactionId(faction)

    Sets an objects faction ID.

    :param int faction: New faction ID.

  .. method:: Object:SetFortitudeSavingThrow(val)

    Set fortitude saving throw.

    :param int val: New value

  .. method:: Object:SetHardness(hardness)

    Sets an object's hardness.

    :param int hardness: New hardness value.

  .. method:: Object:SetIsDestroyable([destroyable[, raiseable[, selectable]])


    :param bool destroyable: Default: ``false``
    :param bool raiseable: Default: ``false``
    :param bool selectable: Default: ``true``

  .. method:: Object:SetKeyRequired(key_required)

    Set lock requires key

    :param bool key_required: If ``true`` key is required, if ``false`` not.

  .. method:: Object:SetKeyRequiredFeedback(message)

    Set feedback message

    :param string message: Message sent when creature does not have the key

  .. method:: Object:SetKeyTag(tag)

    Set lock's key tag

    :param string tag: New key tag.

  .. method:: Object:SetLastHostileActor(actor)

    Sets the last hostile actor.

    :param actor: New last hostile actor.
    :type actor: :class:`Object`

  .. method:: Object:SetListenPattern(pattern, number)

    Set listening patterns.

    :param string pattern: Pattern to listen for.
    :param int number: Number.  Default: 0

  .. method:: Object:SetListening(val)

    Set object to listen or not.

    :param bool val: New value.

  .. method:: Object:SetLocalBool(name, val)

    A wrapper around SetLocalInt.

    :param string name: Variable name
    :param bool val: Value

  .. method:: Object:SetLocalFloat(name, val)

    Set local float variable

    :param string name: Variable name
    :param float val: Value

  .. method:: Object:SetLocalInt(name, val)

    Set local int variable

    :param string name: Variable name
    :param int val: Value

  .. method:: Object:SetLocalLocation(name, val)

    Set local location variable

    :param string name: Variable name
    :param val: Value
    :type val: :class:`Location`

  .. method:: Object:SetLocalObject(name, val)

    Set local object variable

    :param string name: Variable name
    :param val: Value
    :type val: :class:`Object`

  .. method:: Object:SetLocalString(name, val)

    Set local string variable

    :param string name: Variable name
    :param string val: Value

  .. method:: Object:SetLockDC(dc)

    Set lock's lock DC.

    :param int dc: New DC.

  .. method:: Object:SetLockLockable(lockable)

    Set lock to be lockable.

    :param bool lockable: if ``true`` lock can be locked, if ``false`` it can't.

  .. method:: Object:SetLocked(locked)

    Set object locked

    :param bool locked: If ``true`` object will be locked, if ``false`` unlocked.

  .. method:: Object:SetMaxHitPoints(hp)

    Sets an object's max hitpoints.

    :param int hp: New maximum hitpoints.

  .. method:: Object:SetName([name])

    Set object's name.

    :param string name: New name.

  .. method:: Object:SetPlotFlag(flag)

    Set object's plot flag.

    :param bool flag: If ``true`` object is plot.  Default: ``false``.

  .. method:: Object:SetPortraitId(id)

    Set portrait ID.

    :param int id: Portrait ID

  .. method:: Object:SetPortraitResRef(resref)

    Set Portrait resref.

    :param string resref: Portrait resref

  .. method:: Object:SetReflexSavingThrow(val)

    Set reflex saving throw

    :param int val: New value.

  .. method:: Object:SetTag(tag)

    Changes an objects tag.

    :param string tag: New tag.

  .. method:: Object:SetTimer(var_name, duration[, on_expire])

    Sets a timer on an object

    :param string var_name: Variable name to hold the timer
    :param float duration: Duration in seconds before timer expires.
    :param function on_expire: Function which takes to arguments then object the timer was set on and the variable.

  .. method:: Object:SetTrapDetectedBy(object[, is_detected])

    Set whether an object has detected the trap

    :param object: the detector
    :type object: :class:`Creature`
    :param bool is_detected: Default: ``false``

  .. method:: Object:SetTrapKeyTag(tag)

    Set the trap's key tag

    :param string tag: New key tag.

  .. method:: Object:SetUnlockDC(dc)

    Set lock's unlock DC.

    :param int dc: New DC.

  .. method:: Object:SetWillSavingThrow(val)

    Set will saving throw.

    :param int val: New value.

  .. method:: Object:SpeakString(text, volume)

    Forces an object to immediately speak.

    :param string text: Text to be spoken.
    :param int volume: VOLUME_* constant.  Default: VOLUME_TALK

  .. method:: Object:SpeakStringByStrRef(strref, volume)

    Causes an object to instantly speak a translated string.

    :param int strref: TLK string reference to speak.
    :param int volume: VOLUME_* constant.  Default: VOLUME_TALK

  .. method:: Object:TakeItem(id[, count[, resref]])

    Take an item from an object.

    .. note::

      This function handles stack size reduction.  It also checks if the object posses enough of them before taking any.

    :param string id: Tag or Resref.
    :param int count: How many of the items to take.  Default: 1
    :param bool resref: If ``true`` take by resref.  Default: ``false``.
    :rtype: Amount taken.

  .. method:: Object:Trap(type, faction, on_disarm, on_trigger)

    Traps an object.

    :param int type: TRAP_BASE_TYPE_*
    :param int faction: STANDARD_FACTION_*
    :param string on_disarm: OnDisarmed script.  Default: ""
    :param string on_trigger: OnTriggered script.  Default: ""

  .. method:: Object:WillSave(dc, save_type, vs)

    Do will save
    :param int dc: Difficult class
    :param int save_type:
    :param vs: Save versus object.
    :type vs: :class:`Object`

