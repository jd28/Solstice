local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    CNWSObject              obj;                        /* 0000 */
    uint32_t                field_01C4;                 /* 01C4 */
    uint32_t                field_01C8;                 /* 01C8 */
    uint32_t                field_01CC;                 /* 01CC */
    uint32_t                field_01D0;                 /* 01D0 */
    uint32_t                field_01D4;                 /* 01D4 */
    uint32_t                field_01D8;                 /* 01D8 */
    uint32_t                field_01DC;                 /* 01DC */
    uint32_t                field_01E0;                 /* 01E0 */
    uint32_t                field_01E4;                 /* 01E4 */
    uint32_t                field_01E8;                 /* 01E8 */
    uint32_t                field_01EC;                 /* 01EC */
    uint32_t                field_01F0;                 /* 01F0 */
    uint32_t                field_01F4;                 /* 01F4 */
    uint32_t                field_01F8;                 /* 01F8 */
    uint32_t                field_01FC;                 /* 01FC */
    uint32_t                field_0200;                 /* 0200 */
    uint32_t                st_is_blackmarket;          /* 0204 */
    uint32_t                st_bm_markdown;             /* 0208 */
    uint32_t                st_markdown;                /* 020C */
    uint32_t                st_markup;                  /* 0210 */
    uint32_t                field_0214;                 /* 0214 */
    uint32_t                st_gold;                    /* 0218 */
    uint32_t                st_id_price;                /* 021C */
    uint32_t                st_max_buy;                 /* 0220 */
    uint32_t                field_0224;                 /* 0224 */
    uint32_t                field_0228;                 /* 0228 */
    uint32_t                field_022C;                 /* 022C */
    uint32_t                field_0230;                 /* 0230 */
    uint32_t                field_0234;                 /* 0234 */
    uint32_t                field_0238;                 /* 0238 */

} CNWSStore;
]]