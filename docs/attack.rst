.. default-domain:: lua

.. module:: attack
.. highlight:: lua

Attack
======

This module contains ctypes and functions required for interacting with Solstice's and NWN's internal combat attack data structures.

ctypes
------

.. warning::

  The following ctypes **must** be syncronized with nwnx_solstice.  If not bad, bad things will happen.  Good news is it's unlikely that will every be necessary.

.. c:type:: DamageResult

  Constructor ``damage_result_t``

  This struct is used by the combat engine to when determining a damage
  roll.  The length of the arrays is determined by the global DAMAGE_INDEX_NUM
  constant.

  .. c:member:: int32_t damages[DAMAGE_INDEX_NUM]

    Normal damage.

  .. c:member:: int32_t damages_unblocked[DAMAGE_INDEX_NUM]

    Unblockable damages.

  .. c:member:: int32_t immunity[DAMAGE_INDEX_NUM]

    Damage immunity adjustments.

  .. c:member:: int32_t resist[DAMAGE_INDEX_NUM]

    Damage resistance adjustments.

  .. c:member:: int32_t resist_remaining[DAMAGE_INDEX_NUM]

    Damage resistance remaining. This is to provide feedback for DamageResistance effects with limits.

  .. c:member:: int32_t reduction

    Damage reduction adjustment.

  .. c:member:: int32_t reduction_remaining

    Damage reduction remaining. This is to provide feedback for DamageReduction effects with limits.

  .. c:member:: int32_t parry

    Parry adjustment for servers using the Critical Hit Parry reduction designed by Higher Ground.

.. c:type:: Attack

  Information for an attack.

  .. c:member:: CNWSCreature* attacker_nwn

    Internal attacker object, unused in Lua.

  .. c:member:: CNWSObject* target_nwn

    Internal target object, unused in Lua.

  .. c:member:: CNWSCombatAttackData* attack

    Internal NWN attack data.

  .. c:member:: int32_t weapon

    EQUIP_TYPE_* of current weapon.

  .. c:member:: int32_t ranged_type

    RANGED_TYPE_*

  .. c:member:: uint32_t target_state

    Target state bitmask.

  .. c:member:: uint32_t situational_flags

    Situational bitmask.

  .. c:member:: double target_distance

    Distance to target.

  .. c:member:: bool is_offhand

    Is offhand attack.

  .. c:member:: bool is_sneak

    Is sneak attack.

  .. c:member:: bool is_death

    Is death attack.

  .. c:member:: bool is_killing

    Is killing blow.

  .. c:member:: int32_t damage_total

    Total damage done.

  .. c:member:: DamageResult dmg_result

    DamageResult ctype.

  .. c:member:: int32_t effects_to_remove[]

  .. c:member:: int32_t effects_to_remove_len

Functions
---------

.. note::

  When using these functions in performance critical code, you should cache them in local variables.

.. function:: AddCCMessage(info, type, objs, ints, str)

  Adds combat message to an attack.

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: AddDamageToResult(info, dmg, mult)

  Add damage.

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param dmg: :c:type:`DamageRoll`
  :param int mult: Multiplier for crits, etc.

.. function:: AddEffect(info, attacker, eff)

  Adds an onhit effect to an attack.

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param attacker: :class:`Creature`
  :param : :class:`Effect`

.. function:: AddVFX(info, attacker, vfx)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param attacker: :class:`Creature`
  :param int vfx: VFX_*

.. function:: ClearSpecialAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: CopyDamageToNWNAttackData(info, attacker, target)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param attacker: :class:`Creature`
  :param target: :class:`Creature`

.. function:: GetAttackRoll(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsCoupDeGrace(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsCriticalHit(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsDeathAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsHit(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsRangedAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsSneakAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetIsSpecialAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetResult(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetSpecialAttack(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`

.. function:: GetType(info)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :rtype: ATTACK_TYPE_*

.. function:: SetAttackMod(info, ab)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int ab: Attack modifier.

.. function:: SetAttackRoll(info, roll)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int roll: Attack roll.

.. function:: SetConcealment(info, conceal)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int conceal: Concealment.

.. function:: SetCriticalResult(info, threat, result)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int threat: Critical threat roll.
  :param boolean result: Is a critical hit.

.. function:: SetMissedBy(info, roll)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int roll: Attack roll.

.. function:: SetResult(info, result)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param int result: Attack result.

.. function:: SetSneakAttack(info, sneak, death)

  :param info: Attack info.
  :type info: :c:type:`Attack`
  :param boolean sneak: Is sneak attack.
  :param boolean death: Is death attack.
