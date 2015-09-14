.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Feats
-----

.. function:: GetFeatIsFirstLevelOnly(feat)

  Determine is first level feat only.

  :param int feat: FEAT_*

.. function:: GetFeatName(feat)

  Get feat name.

  :param int feat: FEAT_*

.. function:: GetFeatSuccessors(feat)

  Get array of feats successors.

  :param int feat: FEAT_*
  :rtype: Array of FEAT_* constants.

.. function:: GetIsClassBonusFeat(feat, class)

  Determine if feat is class bonus feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetIsClassGeneralFeat(feat, class)

  Determine if feat is class general feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetIsClassGrantedFeat(feat, class)

  Determine if feat is class granted feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetMaximumFeatUses(feat[, cre])

  Determines a creatures maximum feat uses.

  :param int feat: FEAT_*
  :param cre: Creature instance.
  :type cre: :class:`Creature`

.. function:: GetMasterFeatName(master)

  Get Master Feat Name

  :param int master: Master feat.

.. function:: SetMaximumFeatUsesOverride(func, ...)

  Register a function to determine maximum feat uses.

  :param function func: A function taking two arguments, a Creature instance and and a FEAT_* constant and returns an integer.  **Note that returning 100 is equivalent to infinite uses.**
  :param ...: FEAT_* constants.

  **Example**

  .. code:: lua

    -- Let the Champion of Torm have a couple more uses of Divine Wrath
    Rules.RegisterFeatUses(
     function(feat, cre)
        local uses = 1
        local level = cre:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION)
        if level >= 30 then
           uses = 3
        elseif level >= 20 then
           uses = 2
        end
        return uses
     end,
     FEAT_DIVINE_WRATH)


.. function:: SetUseFeatOverride(func, ...)

  Registers a function to be called when a feat is used.

  .. note::

    The feat use handler will be called immediately, as such it has limited applicability to feats that require an action.

  :param function func: A function taking four arguments, FEAT_* constant, the user, a target, and a position.  To bypass the engines UseFeat function return ``true``.
  :param ...: FEAT_* constants.

  **Example**

  .. code:: lua

    local function feat_handler(feat, user, target, position)
      if target:GetIsValid() and target:GetIsPC() then
        target:SendMessage("Hello there.  This is %s", user:GetName())
      end

      -- The game engine doesn't need to handle this.
      return true
    end

    Rules.SetUseFeatOverride(feat_handler, FEAT_HELLO_THERE)