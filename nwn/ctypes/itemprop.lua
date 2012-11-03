local ffi = require 'ffi'

ffi.cdef [[
typedef struct CNWItemProperty {
    uint16_t           ip_type;                /* 0000 */
    uint16_t           ip_subtype;             /* 0002 */
    uint8_t            ip_cost_table;          /* 0004 */
    uint8_t            field_5;                /* 0005 */
    uint16_t           ip_cost_value;          /* 0006 */
    uint8_t            ip_param_table;         /* 0008 */
    uint8_t            ip_param_value;         /* 0009 */
    uint8_t            ip_chance;              /* 000A */
    uint8_t            ip_useable;             /* 000B */
    uint32_t           field_c;                /* 000C */
    uint8_t            ip_uses_per_day;        /* 0010 */
    uint8_t            ip_temporary;           /* 0011 */
    uint8_t            field_12;               /* 0012 */
    uint8_t            field_13;               /* 0013 */
} CNWItemProperty;
]]
