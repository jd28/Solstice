.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Special Attacks
---------------

.. data:: SpecialAttack

  Table interface for special attacks.  All fields are optional.

  **Fields:**

  ab : ``function`` or ``int``
    Determines attack bonus modifier.  If this field is a integer that value is returned for every special attack.  If it is a function it must satisfy the same function signature as :func:`GetSpecialAttackModifier`
  damage : ``function`` or :data:`DamageRoll`
    Determines damage modifier.  If the value is a :data:`DamageRoll` that value is returned for every special attack.  If it is a function it must satisfy the same function signature as :func:`GetSpecialAttackDamage`
  impact : ``function``
    Determines if a special attack is successful and optionally any effect(s) to be applied.  The function, if any, must satisfy the same function signature as :func:`GetSpecialAttackImpact`.  Its ``boolean`` return value indicates whether a special attack was successful or not, ``false`` or ``nil`` indicates the target has resisted the attack.

    If no function is set, the special attack is always successful.

  use : ``function``
    Determines if a special attack is useable.  The function will be called with the following parameters: special attack type, attacker, target and it must return ``true`` or ``false``.  Note: the function is responsible for providing any feedback to the player.

.. function:: GetSpecialAttackDamage(special_attack, info, attacker, target)

  Determine special attack damage.  Should only every be called from a combat engine.

  :param int special_attack: SPECIAL_ATTACK_*
  :param info: Attack ctype from combat engine.
  :param attacker: Attacking creature.
  :type attacker: :class:`Creature`
  :param target: Attacked creature.
  :type target: :class:`Creature`
  :rtype: :data:`DamageRoll`

.. function:: GetSpecialAttackImpact(special_attack, info, attacker, target)

  Determine special attack effect.  Should only every be called from a combat engine.

  .. note::


  :param int special_attack: FEAT_* or SPECIAL_ATTACK_*
  :param info: Attack ctype from combat engine.
  :param attacker: Attacking creature.
  :type attacker: :class:`Creature`
  :param target: Attacked creature.
  :type target: :class:`Creature`
  :rtype: ``boolean`` and optionally an :class:`Effect` or an array of :class:`Effect`.

.. function:: GetSpecialAttackModifier(special_attack, info, attacker, target)

  Determine special attack bonus modifier.  Should only every be called from a combat engine.

  :param int special_attack: SPECIAL_ATTACK_*
  :param info: Attack ctype from combat engine.
  :param attacker: Attacking creature.
  :type attacker: :class:`Creature`
  :param target: Attacked creature.
  :type target: :class:`Creature`
  :rtype: ``int``

.. function:: RegisterSpecialAttack(special_attack, ...)

  Register special attack handlers.

  The vararg parameter(s) can be any usable feat, it is not limited to hard-coded special attacks.  When a special attack is registered, a use feat event handler is also registered; it will handle adding the special attack action, will override any other uses of the feat, and any feedback messages like \*Special Attack Resisted\* floating strings.

  :param special_attack: See the :data:`SpecialAttack` interface.
  :param ...: FEAT_* or SPECIAL_ATTACK_* constants.

  **Example**

  .. code:: lua

    local Eff = require 'solstice.effect'

    local function kd_use(id, attacker, target)
      if Rules.GetIsRangedWeapon(attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) then
        if attacker:GetIsPC() then
          -- Normally for these hardcoded feats a localized string would be sent,
          -- but this is just an example.
          attacker:SendMessage("You can not use Knockdown with ranged weapons.")
        end
        return false
      end
      return true
    end

    local function kd_impact(id, info, attacker, target)
      local size_bonus = id == SPECIAL_ATTACK_KNOCKDOWN_IMPROVED and 1 or 0
      if target:GetSize() > attacker:GetSize() + size_bonus then return false end

      if info.attack.cad_attack_roll + info.attack.cad_attack_mod >
         target:GetSkillRank(SKILL_DISCIPLINE)
      then
         local eff = Eff.Knockdown()
         eff:SetDurationType(DURATION_TYPE_TEMPORARY)
         eff:SetDuration(6)
         return true, eff
      end

      return false
    end

    Rules.RegisterSpecialAttack({ use = kd_use, impact = kd_impact, ab = -4},
                                SPECIAL_ATTACK_KNOCKDOWN_IMPROVED,
                                SPECIAL_ATTACK_KNOCKDOWN)
