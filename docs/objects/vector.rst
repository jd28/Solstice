.. highlight:: lua
.. default-domain:: lua

class Vector
============

.. class:: Vector

  .. function:: Vector.FromAngle(angle)

    Converts angle to vector

  .. function:: Vector.FromString(str)

    Converts a string to a Vector.  Format: "<x>, <y>, <z>"

  .. method:: Vector:Normalize()

    Normalizes vector

  .. method:: Vector:Magnitude()

    Calculates vector's magnitude

  .. method:: Vector:MagnitudeSquared()

    Calculates vector's magnitude squared

  .. method:: Vector:LineOfSight(target)

    Checks if target is in line of sight.

    **Arguments**

    :param target: Any object
    :type target: :class:`Object`

  .. method:: Vector:Subtract(other)

    Subtract vectors.

    :param other: Vector to subtract.
    :type other: :class:`Vector`

  .. method:: Vector:ToAngle()

    Converts vector to angle

  .. method:: Vector:ToString()

    Converts Vector to string
