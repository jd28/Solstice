.. highlight:: lua
.. default-domain:: lua

class Store
===========

.. class:: Store

  .. method:: GetGold()

    Get store's gold

  .. method:: GetIdentifyCost()

    Get store's identify price

  .. method:: GetMaxBuyPrice()

    Get store's max buy price

  .. method:: Open(pc, up, down)

    Open store

    :param pc: PC to open the store for.
    :type pc: :class:`Creature`
    :param int up: Bonus markup
    :param int down: Bonus markdown

  .. method:: SetGold(gold)

    Set amount of gold a store has.

  .. method:: SetIdentifyCost(val)

    Set the price to identify items.

  .. method:: SetMaxBuyPrice(val)

    Set the max buy price.
