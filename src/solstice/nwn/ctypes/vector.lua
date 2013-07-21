local ffi = require 'ffi'

ffi.cdef [[
typedef struct {
    float       x;
    float       y;
    float       z;
} Vector;
]]