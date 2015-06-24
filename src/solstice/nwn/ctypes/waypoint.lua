local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    CNWSObject          obj;
    uint8_t             way_mapnote_has;
    uint8_t             field_1C5;
    uint8_t             field_1C6;
    uint8_t             field_1C7;
    uint8_t             way_mapnote_enabled;
    uint8_t             field_1C9;
    uint8_t             field_1CA;
    uint8_t             field_1CB;
    CExoLocString       way_mapnote;
    CExoLocString       way_name;
} CNWSWaypoint;
]]
