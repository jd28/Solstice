.. highlight:: lua
.. default-domain:: lua

class Vector
============

.. class:: Vector

Methods
-------

  .. method:: Vector:Normalize()

    Normalizes vector

  .. method:: Vector:Magnitude()

    Calculates vector's magnitude

  .. method:: Vector:MagnitudeSquared()

    Calculates vector's magnitude squared

  .. method:: Vector:LineOfSight(target)

    Checks if target is in line of sight.

    **Arguments**

    target : :class:`Object`
      Any object

  .. method:: Vector:Subtract(other)

    Subtract vectors.

    **Arguments**

    other : :class:`Vector`
      Vector to subtract.

  .. method:: Vector:ToAngle()

    Converts vector to angle

  .. method:: Vector:ToString()

    Converts Vector to string

Functions
---------

  .. function:: Vector.FromAngle(angle)

    Converts angle to vector

  .. function:: Vector.FromString(str)

    Converts a string to a Vector.
    Format: "<x>, <y>, <z>"
