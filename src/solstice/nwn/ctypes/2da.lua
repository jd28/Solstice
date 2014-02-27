local ffi = require 'ffi'

require 'solstice.nwn.ctypes.foundation'

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

C2DA *nwn_GetCached2da(const char *file);
int32_t nwn_Get2daColumnCount(C2DA *tda);
int32_t nwn_Get2daRowCount(C2DA *tda);
char * nwn_Get2daString(C2DA *tda, const char* col, uint32_t row);
char * nwn_Get2daStringIdx(C2DA *tda, int32_t col, uint32_t row);
int32_t nwn_Get2daInt(C2DA *tda, const char* col, uint32_t row);
int32_t nwn_Get2daIntIdx(C2DA *tda, int32_t col, uint32_t row);
float nwn_Get2daFloat(C2DA *tda, const char* col, uint32_t row);
float nwn_Get2daFloatIdx(C2DA *tda, int32_t col, uint32_t row);
]]
