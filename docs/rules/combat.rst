.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

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