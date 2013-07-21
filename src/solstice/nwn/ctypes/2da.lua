local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    uint32_t            field_00;

    void               *tda_resource;
    char                tda_name[16];
    void               *tda_class;

    uint32_t            field_1C;
    uint32_t            field_20;

    CExoString         *tda_ids;
    CExoString         *tda_cols;
    CExoString        **tda_rows;

    int32_t             tda_rows_len;
    int32_t             tda_cols_len;

    uint32_t            field_38;

} C2DA;
]]