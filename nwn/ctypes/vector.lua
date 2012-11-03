local ffi = require 'ffi'

ffi.cdef [[
typedef struct Vector {
    float       x;
    float       y;
    float       z;
} Vector;
]]