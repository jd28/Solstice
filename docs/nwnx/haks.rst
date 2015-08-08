.. highlight:: lua
.. default-domain:: lua

.. module:: nwnx.haks

nwnx.haks
=========

nwnx_haks allows a server to control the visibility of HAKs and
custom TLK on player login.  You can do so at various levels.

The main impetus was to allow a new player to login to a safe loading area
without having to download a massive amount of haks before deciding
if they feel the server was right for them.

It's also useful if you've built a world with default/CEP/Q resources
and then chose later to add tilesets or your own top hak.

Example: Imagine you have a CEP world with many areas and you add
some of the great tilesets greated by the community.

.. code-block:: lua

  local Haks = require 'solstice.nwnx.haks'
  Haks.SetFallBackTLK('cep_tlk_v26')
  Haks.SetHakHidden('mytophak', 1)
  Haks.SetHakHidden('mytileset', 2)
  ...

When a new player enters, the server will only require CEP 2.6 to
login.  You can then flag players based on which HAKs the have via
some dialog and store in your DB.  They will have to relog/ActivatePortal
in order to have their client load the HAKs, from then on they can
enter as normal.

Note: If you hide tilesets, you need to control who can enter
areas that use those tilesets or it will cause the client to crash.


Functions
---------

.. function:: DumpHakList()

.. function:: DumpHiddenHakList()

.. function:: SetHakHidden(hak, level)

.. function:: SetFallBackTLK(tlk)

.. function:: SetEnhanceScript(script)

.. function:: SetPlayerEnhanced(pc, enhanced)