local ffi = require 'ffi'

ffi.cdef[[
typedef struct CScriptLocation {
    Vector          position;
    Vector          orientation;
    uint32_t        area;
} CScriptLocation;
]]