local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    uint32_t  field_0000;       /* 0000 */
    uint32_t  field_0004;       /* 0004 */
    uint32_t  field_0008;       /* 0008 */
    uint32_t  field_000C;       /* 000C */
    uint32_t  ra_description;   /* 0010 */
    uint32_t  ra_biography;     /* 0014 */
    uint8_t   ra_str_adjust;    /* 0018 */
    uint8_t   ra_dex_adjust;    /* 0019 */
    uint8_t   ra_int_adjust;    /* 001A */
    uint8_t   ra_cha_adjust;    /* 001B */
    uint8_t   ra_wis_adjust;    /* 001C */
    uint8_t   ra_con_adjust;    /* 001D */
    uint8_t   ra_endurance;     /* 001E */
    uint8_t   padding_001F;     /* 001F */
    uint32_t  field_0020;       /* 0020 */
    uint32_t  field_0024;       /* 0024 */
    uint16_t *ra_feat_table;    /* 0028 */
    uint32_t  ra_age;           /* 002C */
    uint32_t  ra_appearance;    /* 0030 */
} CNWRace;
]]
