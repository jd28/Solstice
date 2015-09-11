.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Feats
-----

.. function:: GetMaximumFeatUses(feat[, cre])

  Determines a creatures maximum feat uses.

  :param int feat: FEAT_*
  :param cre: Creature instance.
  :type cre: :class:`Creature`

.. function:: RegisterFeatUses(func, ...)

  Register a function to determine maximum feat uses.

  :param function func: A function taking two argument, a Creature instance and and a FEAT_* constant.
  :param ...: FEAT_* constants.

.. function:: GetFeatSuccessors(feat)

  Get array of feats successors.

  :param int feat: FEAT_*
  :rtype: Array of FEAT_* constants.

.. function:: GetFeatIsFirstLevelOnly(feat)

  Determine is first level feat only.

  :param int feat: FEAT_*

.. function:: GetFeatName(feat)

  Get feat name.

  :param int feat: FEAT_*

.. function:: GetIsClassGeneralFeat(feat, class)

  Determine if feat is class general feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetIsClassBonusFeat(feat, class)

  Determine if feat is class bonus feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetIsClassGrantedFeat(feat, class)

  Determine if feat is class granted feat.

  :param int feat: FEAT_*
  :param int class: CLASS_TYPE_*

.. function:: GetMasterFeatName(master)

  Get Master Feat Name

  :param int master: Master feat.
