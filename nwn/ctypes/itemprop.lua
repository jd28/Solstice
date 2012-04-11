local ffi = require 'ffi'

ffi.cdef [[
typedef struct CNWItemProperty {
    uint16_t           ip_type;                /* 0000 */
    uint16_t           ip_subtype;             /* 0002 */
    uint8_t            ip_chance;              /* 0004 */
    uint8_t            ip_cost_table;          /* 0005 */
    uint16_t           ip_cost_value;          /* 0006 */
    uint8_t            ip_param_table;         /* 0008 */
    uint8_t            ip_param_value;         /* 0009 */
} CNWItemProperty;
]]