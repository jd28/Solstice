.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

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
    FEAT_* or SPECIAL_ATTACK_*
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

.. data:: SpecialAttack

  Table interface for special attacks.  All fields are optional.

  **Fields:**

  use : ``function``
    Determines if a special attack is useable.  The function will be
    called with the following parameters: special attack type, attacker,
    target and it must return ``true`` or ``false``.
  ab : ``function`` or ``int``
    Determines attack bonus modifier.  If this field is a integer that value is
    returned for every special attack.  If it is a function it will be called with
    the following parameters: special attack type, INFO, attacker, target and it
    must return an integer.
  effect : ``function``
    Determines any effect to be applied on a successful attack.  The function will be
    called with the following parameters: special attack type, INFO, attacker,
    target and it must return ``true`` or ``false``.
  damage : ``function``
    Determines damage modifier.  The function will be
    called with the following parameters: special attack type, INFO, attacker,
    target and it must return an a :data:`DamageRoll` ctype.

.. function:: RegisterSpecialAttack(feat, special_attack)

  Register special attack handlers.

  The ``feat`` parameter can be any usable feat, it is not limited to hardcoded special attacks.  When a special attack is registered a nwnx.events.UseFeat event handler is registered.  It will bypass the event and handle adding the special attack action.

  .. note::

    Because the special attack type is passed as a parameter to the special attack handler functions, a special attack handler can be used for multiple special attacks.

  **Arguments**

  feat
    FEAT_*
  special_attack
    See the :data:`SpecialAttack` interface.