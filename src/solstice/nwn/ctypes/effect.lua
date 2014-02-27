local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    uint32_t            eff_id;                 /* 00 */

    uint32_t            field_04;               /* 04 */

    uint16_t            eff_type;               /* 08 */
    uint16_t            eff_dursubtype;         /* 0A */

    float               eff_duration;           /* 0C */

    uint32_t            eff_expire_day;         /* 10 */
    uint32_t            eff_expire_time;        /* 14 */

    uint32_t            eff_creator;            /* 18 */
    int32_t             eff_spellid;            /* 1C */

    uint32_t            eff_is_exposed;         /* 20 */
    uint32_t            eff_is_iconshown;       /* 24 */

    uint32_t            field_28;               /* 28 */

    uint32_t            eff_link_id1;           /* 2C */
    uint32_t            eff_link_id2;           /* 30 */

    uint32_t            eff_num_integers;       /* 34 */
    int32_t            *eff_integers;           /* 38 */

    float               eff_floats[4];          /* 3C */
    CExoString          eff_strings[6];         /* 40 */
    uint32_t            eff_objects[4];         /* 44 */

    uint32_t            eff_skiponload;         /* 48 */
    uint32_t            field_4C;               /* 4C */	
    uint32_t            field_50;               /* 50 */
    uint32_t            field_54;               /* 54 */
    uint32_t            field_58;               /* 58 */
    uint32_t            field_5C;               /* 5C */
    uint32_t            field_60;               /* 60 */
    uint32_t            field_64;               /* 64 */
    uint32_t            field_68;               /* 68 */
    uint32_t            field_6C;               /* 6C */
    uint32_t            field_70;               /* 70 */
    uint32_t            field_74;               /* 74 */
    uint32_t            field_78;               /* 78 */
    uint32_t            field_7C;               /* 7C */
    uint32_t            field_80;               /* 80 */
    uint32_t            field_84;               /* 84 */
    uint32_t            field_88;               /* 88 */
    uint32_t            field_8C;               /* 8C */
    uint32_t            field_90;               /* 90 */

} CGameEffect;
]]