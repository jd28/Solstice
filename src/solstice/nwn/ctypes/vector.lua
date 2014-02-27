local ffi = require 'ffi'

ffi.cdef [[
typedef struct {
    float       x;
    float       y;
    float       z;
} Vector;

typedef struct {
    float       x;
    float       y;
} Vector2;
]]

vector3_t = ffi.typeof("Vector")
vector2_t = ffi.typeof("Vector2")
