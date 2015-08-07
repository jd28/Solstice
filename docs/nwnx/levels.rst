.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.levels

nwnx.levels
===========

nwnx_levels allows you to set the maximum level beyond 40th.  Due
to some limitations of the client the post 40th level process must
still be done via conversation.

The LevelUp function requires certain local variables to be set:

- 'LL_CLASS': CLASS_TYPE_* + 1
- 'LL_SKILL_POINTS': Number of unspent skillpoints.
- 'LL_HP': Number of class hitpoints gained.
- 'LL_STAT': ABILITY_* + 1
- 'LL_FEAT_COUNT': Number of feats added.
- 'LL_FEAT_[Nth feat]': Feat to add. Value: FEAT_* + 1
- 'LL_SPGN[Spell Level]_USED': Number of spells gained at spell.
- 'LL_SPGN[Spell Level]_[Nth spell]': Spells removed at each spell level. Value: SPELL_* + 1
- 'LL_SPRM[Spell Level]_USED': Number of spells removes at spell
- 'LL_SPRM[Spell Level]_[Nth spell]': Spells removed at each spell level. Value: SPELL_* + 1

Notes:

- Using builtin functions to add / remove XP can cause deleveling.
  In Solstice you'd need to use the `direct` parameter.  Because of
  this it requires having your own custom XP gained on kill scripts.
- All of the [Nth ...] start at 0.

Functions
---------

.. function:: GetMaxLevelLimit()

.. function:: SetMaxLevelLimit (level)

.. function:: LevelDown(pc)

.. function:: LevelUp(pc)

.. function:: GetMeetsLevelUpFeatRequirements (cre, feat)