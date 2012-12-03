--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local ffi = require 'ffi'

ffi.cdef[[
typedef struct Trigger {
    uint32_t        type;
    uint32_t        id;
    CNWSTrigger    *obj;
} Trigger;
]]

local trigger_mt = { __index = Trigger }
trigger_t = ffi.metatype("Trigger", trigger_mt)
