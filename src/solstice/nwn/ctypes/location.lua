local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    Vector          position;
    Vector          orientation;
    uint32_t        area;
} CScriptLocation;
]]