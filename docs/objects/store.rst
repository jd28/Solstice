.. highlight:: lua
.. default-domain:: lua

class Store
===========

.. class:: Store

Signals
-------

.. data:: Store.signals

  A Lua table containing signals for store events.

  .. note::

    These signals are shared by **all** :class:`Store` instances.  If special behavior
    is required for a specific store it must be filtered by a signal handler.


  .. data:: Store.signals.OnOpen

  .. data:: Store.signals.OnClose

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
