.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Classes
=======

.. function:: CanUseClassAbilities(cre, class)

  Determine if creature can use class abilites.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int class: CLASS_TYPE_*

.. function:: GetBaseAttackBonus(cre, [pre_epic=false])

  Get base attack bonus.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param boolean pre_epic: If ``true`` only calculate pre-epic BAB.

.. function:: GetClassName(class)

  Get class name.

  **Arguments**

  :param int class: CLASS_TYPE_*
  :rtype: string

.. function:: GetHitPointsGainedOnLevelUp(class, pc)

  Get number of hitpoints class gains on level up.

  :param int class: CLASS_TYPE_*
  :param pc: Creature instance.
  :type pc: :class:`Creature`

.. function:: GetLevelBonusFeats(cre, class, level)

  Get bonus feats for level.

  :param cre: Creature instance.
  :type cre: :class:`Creature`
  :param int class: CLASS_TYPE_*
  :param int level: Class level.

.. function:: GetSkillPointsGainedOnLevelUp(class, pc)

  Get number of skillpoints class gains on level up.

  :param int class: CLASS_TYPE_*
  :param pc: Creature instance.
  :type pc: :class:`Creature`

.. function:: SetCanUseClassAbilitiesOverride(class, func)

  Registers a class ability handler.

  :param int class: CLASS_TYPE_*
  :param function func: A function that takes a creature and optionally a CLASS_TYPE_* argument and returns a boolean indicating whether the creature can use the abilities for the class and the creatures class level.  You **must** return both or an assertion will fail.

  **Example**

  .. code-block:: lua

    local function monk(cre, class)
       local level = cre:GetLevelByClass(class)
       if level == 0 then return false, 0 end

       if not cre:GetIsPolymorphed() then
          local chest = cre:GetItemInSlot(INVENTORY_SLOT_CHEST)
          if chest:GetIsValid() and chest:ComputeArmorClass() > 0 then
             return false, level
          end

          local shield = cre:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
          if shield:GetIsValid() and
             (shield:GetBaseType() == BASE_ITEM_SMALLSHIELD
              or shield:GetBaseType() == BASE_ITEM_LARGESHIELD
              or shield:GetBaseType() == BASE_ITEM_TOWERSHIELD)
          then
             return false, level
          end
       end

       return true, level
    end

    Rules.SetCanUseClassAbilitiesOverride(CLASS_TYPE_MONK, monk)
