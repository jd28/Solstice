.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Damage Reduction
----------------

.. function:: GetBaseDamageImmunity(cre, dmgidx)

  Get base damage immunity.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  dmgidx : ``int``
    DAMAGE_INDEX_*

.. function:: SetBaseDamageImmunityOverride(func, ...)

  Sets a damage immunity override function.

  **Example**

  .. code-block:: lua

    local function rdd(cre)
       local res = 0
       if cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 10 then
          res = 100
       end
       return res
    end

    Rules.SetBaseDamageImmunityOverride(rdd, DAMAGE_INDEX_FIRE)

  **Arguments**

  func : ``function``
    (:class:`Creature`) -> ``int``

  ...
    DAMAGE_INDEX\_* constants.

.. function:: GetBaseDamageReduction(cre)

  Get base damage reduction.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.

.. function:: GetBaseDamageResistance(cre, dmgidx)

  Get base damage resistance.

  **Arguments**

  cre : :class:`Creature`
    Creature instance.
  dmgidx
    DAMAGE_INDEX\_* constants.

.. function:: SetBaseDamageResistanceOverride(func, ...)

  Sets a damage resistance override function.

  **Arguments**

  func : ``function``
    (:class:`Creature`) -> ``int``

  ...
    DAMAGE_INDEX\_* constants.
