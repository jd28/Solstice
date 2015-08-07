.. default-domain:: lua

.. module:: color
.. highlight:: lua

Color
-----

.. warning::
  It's not wise to use strings taken from NWN scripts.  There are are number of
  text encoding issues that will cause undesirable results.

.. function:: Encode(r, g, b)

  Encodes RGB values.

  **Arguments:**

  r : ``int``
    Red
  g : ``int``
    Green
  b : ``int``
    Blue

.. function:: EncodeHex(hex)

  Encodes a hex color string.

  hex : ``string``
    Same format as HTML: "#000000"

.. code-block:: lua

  local C = require 'solstice.color'
  assert(C.EncodeHex('#FF0000') == C.Enocde(255, 0, 0))

Constants
~~~~~~~~~

.. data:: BLUE

  RGB(102, 204, 254)

.. data:: DARK_BLUE

  RGB(32, 102, 254)

.. data:: GRAY

  RGB(153, 153, 153)

.. data:: GREEN

  RGB(32, 254, 32)

.. data:: LIGHT_BLUE

  RGB(153, 254, 254)

.. data:: LIGHT_GRAY

  RGB(176, 176, 176)

.. data:: LIGHT_ORANGE

  RGB(254, 153, 32)

.. data:: LIGHT_PURPLE

  RGB(204, 153, 204)

.. data:: ORANGE

  RGB(254, 102, 32)

.. data:: PURPLE

  RGB(204, 119, 254)

.. data:: RED

  RGB(254, 32, 32)

.. data:: WHITE

  RGB(254, 254, 254)
.. data:: YELLOW

  RGB(254, 254, 32)

.. data:: END

  Colored text terminator.
