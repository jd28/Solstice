local ffi = require 'ffi'

ffi.cdef [[

typedef struct {
    uint32_t                 type;
    ArrayList_int32      integers;
    ArrayList_float      floats;
    ArrayList_string     strings;
    ArrayList_uint32     objects;
} CNWCCMessageData;

]]
