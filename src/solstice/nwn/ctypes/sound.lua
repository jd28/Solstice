local ffi = require 'ffi'

ffi.cdef [[
typedef struct CNWSSoundObject {
    CNWSObject            obj;
    uint32_t              field_01C4;          /* 01C4 */
    uint32_t              field_01C8;          /* 01C8 */
    uint32_t              field_01CC;          /* 01CC */
    uint32_t              field_01D0;          /* 01D0 */
    uint32_t              field_01D4;          /* 01D4 */
    uint32_t              field_01D8;          /* 01D8 */
    uint32_t              field_01DC;          /* 01DC */
    uint32_t              field_01E0;          /* 01E0 */
    uint32_t              field_01E4;          /* 01E4 */
    uint32_t              field_01E8;          /* 01E8 */
    uint32_t              field_01EC;          /* 01EC */
    uint32_t              field_01F0;          /* 01F0 */
    uint32_t              field_01F4;          /* 01F4 */
    uint32_t              field_01F8;          /* 01F8 */
    uint32_t              field_01FC;          /* 01FC */
    uint32_t              field_0200;          /* 0200 */
    uint32_t              field_0204;          /* 0204 */
    uint32_t              field_0208;          /* 0208 */
    uint32_t              field_020C;          /* 020C */
    uint32_t              field_0210;          /* 0210 */
    uint32_t              field_0214;          /* 0214 */
} CNWSSoundObject;
]]