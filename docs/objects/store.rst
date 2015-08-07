.. highlight:: lua
.. default-domain:: lua

class Store
===========

.. class:: Store

Methods
-------

  .. method:: GetGold()

    Get store's gold

  .. method:: GetIdentifyCost()

    Get store's identify price

  .. method:: GetMaxBuyPrice()

    Get store's max buy price

  .. method:: Open(pc, up, down)

    Open store

    **Arguments:**

    pc : :class:`Creature`
      PC to open the store for.
    up
      Bonus markup
    down
      Bonus markdown

  .. method:: SetGold(gold)

    Set amount of gold a store has.

  .. method:: SetIdentifyCost(val)

    Set the price to identify items.

  .. method:: SetMaxBuyPrice(val)

    Set the max buy price.
