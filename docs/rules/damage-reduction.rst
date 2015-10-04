.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Damage Reduction
----------------

.. function:: DebugDamageImmunity(cre)

  Generates a debug string with damage immunity related values.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: ``string``

.. function:: DebugDamageResistance(cre)

  Generates a debug string with damage resistance related values.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: ``string``

.. function:: DebugDamageReduction(cre)

  Generates a debug string with damage reduction related values.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :rtype: ``string``

.. function:: DoDamageImmunity(obj, amt, dmgidx)

  Determines the amount damage is modified by damage immunity.

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int amt: Damage amount.
  :param int dmgidx: DAMAGE_INDEX_*
  :rtype: Modified damage amount and the amount damage was modified.

.. function:: DoDamageReduction(obj, amt, eff, power)

  Determines the amount damage is modified by damage reduction.  If the parameter ``eff`` is a damage absorbtion limit, it will be removed from ``obj``.

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int amt: Damage amount.
  :param eff: Effect to use to modify the damage amount.  Generally this should be the value returned from :func:`GetBestDamageReductionEffect`.
  :type eff: :class:`Effect`
  :param int power: Damage power.
  :rtype: Modified damage amount, the amount damage was modified, and a ``bool`` indicating whether the effect was removed.

.. function:: DoDamageResistance(obj, amt, eff, dmgidx)

  Determines the amount damage is modified by damage resistance.  If the parameter ``eff`` is a damage absorbtion limit, it will be removed from ``obj``.

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int amt: Damage amount.
  :param eff: Effect to use to modify the damage amount.  Generally this should be the value returned from :func:`GetBestDamageResistEffect`.
  :type eff: :class:`Effect`
  :param int dmgidx: DAMAGE_INDEX_*
  :rtype: Modified damage amount, the amount damage was modified, and a ``bool`` indicating whether the effect was removed.

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

.. function:: GetBestDamageReductionEffect(obj, power[, start])

  Determines the best damage reduction effect currently applied to ``obj``.  The effect with the highest reduction at any power level greater than ``power`` is selected.  If multiple effects have the same reduction the effect with the highest soak absorbtion limit is selected.

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int power: Damage power.
  :param int start: Hint for where to start looking in ``obj``'s effect list.  This is uesful only for creature objects.
  :rtype: :class:`Effect`


.. function:: GetBestDamageResistEffect(obj, dmgidx[, start])

  Determines the best damage resistance effect currently applied to ``obj``.  The effect with the highest resistance to ``dmgidx`` is selected.  If multiple effects have the same resistance the effect with the highest damage absorbtion limit is selected.

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int dmgidx: DAMAGE_INDEX_*
  :param int start: Hint for where to start looking in ``obj``'s effect list.  This is uesful only for creature objects.
  :rtype: :class:`Effect`

.. function:: GetEffectDamageImmunity(obj[, dmgidx])

  Get damage immunity from effects.  The values returned by this function are not clamped by :func:`GetEffectDamageImmunityLimits`

  :param obj: Object instance.
  :type obj: :class:`Object`
  :param int dmgidx: DAMAGE_INDEX_*
  :rtype: If ``dmgidx`` is provided an ``int`` is returned, otherwise an array of all damage immunity effects is returned.

.. function:: GetEffectDamageImmunityLimits(obj)

  :param obj: Object instance.
  :type obj: :class:`Object`
  :rtype: -100, 100

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

