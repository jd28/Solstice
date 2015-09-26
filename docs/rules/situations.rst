.. highlight:: lua
.. default-domain:: lua

.. module:: Rules

Situations
----------

.. function:: GetSituationModifier(situ, modifier, cre)

  :param int situ: SITUATION_*
  :param int modifier: ATTACK_MODIFIER_*
  :param cre: Creature.
  :type cre: :class:`Creature`

.. function:: RegisterSituation(situation, func)

  :param int situ: SITUATION_*
  :param function func: A function taking two parameters: an ATTACK_MODIFIER_* and a :class:`Creature` instance.  The return type is dependent on the attack modifier type.