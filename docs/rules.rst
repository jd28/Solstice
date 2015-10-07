.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Rules
=====

The rules modules, imported globally as ``Rules``, allows anyone who wishes to modify default behaviors to do so in a way that will be compatible with all other users.  The only limitation is that the function signatures must remain the same.

Sections
--------

.. toctree::
  :maxdepth: 1

  rules/abilities
  rules/armor-class
  rules/attack-bonus
  rules/classes
  rules/combat
  rules/combat-mods
  rules/concealment
  rules/constants
  rules/damage
  rules/damage-reduction
  rules/feats
  rules/hp
  rules/immunities
  rules/levels
  rules/modes
  rules/race
  rules/saves
  rules/situations
  rules/skills
  rules/special-attacks
  rules/weapons

Examples
--------

Replacing a function.
~~~~~~~~~~~~~~~~~~~~~

.. code:: lua

  -- In some file that you load from your preload file.

  -- Suppose you think it more appropriate to change Epic Toughness feats to grant 40hp per feat.
  -- We'll leave aside whether this is a good or bad idea.

  local function GetMaxHitPoints(cre)
    local res = 0
    local not_pc = cre:GetIsAI()
    local level = cre:GetHitDice()
    if cre:GetHasFeat(FEAT_TOUGHNESS) then
      res = res + level
    end

    res = res + math.max(0, cre:GetAbilityModifier(ABILITY_CONSTITUTION) * level)

    local pm = cre:GetLevelByClass(CLASS_TYPE_PALE_MASTER)
    local pmhp = 0
    if pm >= 5 then
      if pm >= 25 then
        pmhp = 18 + (math.floor(pm / 5) * 20)
      elseif pm >= 15 then
        pmhp = 18 + (math.floor(pm / 5) * 10)
      elseif pm >= 10 then
        pmhp = 18 + math.floor((pm - 10) / 5)
      else
        pmhp = pm * 3
      end
    end
    res = res + pmhp

    local epictough = cre:GetHighestFeatInRange(FEAT_EPIC_TOUGHNESS_1, FEAT_EPIC_TOUGHNESS_10)
    if epictough ~= -1 then
      -- Changed 20 -> 40.
      local et = 40 * (epictough - FEAT_EPIC_TOUGHNESS_1 + 1)
      res = res + et
    end

    -- Some of the underlying engine object is exposed here.
    -- It isn't necessary to understand this unless you have a reason
    -- to change it... and you probably shouldn't.
    if not_pc then
      res = res + cre.obj.obj.obj_hp_max
    else
      local base = 0
      for i = 1, cre:GetHitDice() do
        base = base + cre:GetMaxHitPointsByLevel(i)
      end
      res = res + base
      cre.obj.obj.obj_hp_max = res
    end

    if res <= 0 then res = 1 end

    return res
  end

  -- Replace the global function and now anywhere in your code
  -- or in the api that calls this function will call your
  -- modified version.
  Rules.GetMaxHitPoints = GetMaxHitPoints

Using overrides.
~~~~~~~~~~~~~~~~

A number of functions provide explicit means of overriding behaviors.  In those cases it's not necessary to replace any functions.  To see examples of those checkout the sections of the rules module.
