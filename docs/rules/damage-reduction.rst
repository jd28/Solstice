.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Damage Reduction
----------------

.. function:: GetBaseDamageImmunity(cre, dmgidx)

  Get base damage immunity.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int dmgidx: DAMAGE_INDEX_*

.. function:: GetBaseDamageReduction(cre)

  Get base damage reduction.

  .. note::

    This function doesn't have a user supplied override.  To modify its behavior simply replace the function.

  :param cre: Creature instance.
  :type cre: :class:`Creature`

.. function:: GetBaseDamageResistance(cre, dmgidx)

  Get base damage resistance.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int dmgidx: DAMAGE_INDEX_*

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

  :param function func: (:class:`Creature`) -> ``int``
  :param ...: DAMAGE_INDEX_* constants.

.. function:: SetBaseDamageResistanceOverride(func, ...)

  Sets a damage resistance override function.

  :param function func: (:class:`Creature`) -> ``int``
  :param ...: DAMAGE_INDEX_* constants.
