local ffi = require 'ffi'

ffi.cdef[[
typedef struct CNWSTrigger {
    CNWSObject                  obj;
    uint32_t                    field_1C4;           /* 01C4 01C4 */
    uint32_t                    field_1C8;           /* 01C8 01C8 */
    uint32_t                    field_1CC;           /* 01CC 01CC */
    uint32_t                    field_1D0;           /* 01D0 01D0 */
    uint32_t                    field_1D4;           /* 01D4 01D4 */
    uint32_t                    field_1D8;           /* 01D8 01D8 */
    uint32_t                    field_1DC;           /* 01DC 01DC */
    uint32_t                    field_1E0;           /* 01E0 01E0 */
    uint32_t                    field_1E4;           /* 01E4 01E4 */
    uint32_t                    field_1E8;           /* 01E8 01E8 */
    uint32_t                    field_1EC;           /* 01EC 01EC */
    uint32_t                    field_1F0;           /* 01F0 01F0 */
    uint32_t                    field_1F4;           /* 01F4 01F4 */
    uint32_t                    field_1F8;           /* 01F8 01F8 */
    uint32_t                    field_1FC;           /* 01FC 01FC */
    uint32_t                    field_200;           /* 0200 0200 */
    uint32_t                    field_204;           /* 0204 0204 */
    uint32_t                    field_208;           /* 0208 0208 */
    uint32_t                    field_20C;           /* 020C 020C */
    uint32_t                    field_210;           /* 0210 0210 */
    uint32_t                    field_214;           /* 0214 0214 */
    uint32_t                    field_218;           /* 0218 0218 */
    uint32_t                    field_21C;           /* 021C 021C */
    uint32_t                    field_220;           /* 0220 0220 */
    uint32_t                    field_224;           /* 0224 0224 */
    uint32_t                    field_228;           /* 0228 0228 */
    uint32_t                    field_22C;           /* 022C 022C */
    uint32_t                    field_230;           /* 0230 0230 */
    uint32_t                    field_234;           /* 0234 0234 */
    uint32_t                    field_238;           /* 0238 0238 */
    uint32_t                    field_23C;           /* 023C 023C */
    uint32_t                    field_240;           /* 0240 0240 */
    uint32_t                    field_244;           /* 0244 0244 */
    uint32_t                    field_248;           /* 0248 0248 */
    uint32_t                    field_24C;           /* 024C 024C */
    uint32_t                    field_250;           /* 0250 0250 */
    uint32_t                    field_254;           /* 0254 0254 */
    uint32_t                    tr_is_trap;          /* 0258 0258 */
    uint32_t                    trap_detectable;     /* 025C 025C */
    uint32_t                    trap_disarmable;     /* 0260 0260 */
    uint32_t                    trap_flagged;        /* 0264 0264 */
    uint32_t                    field_268;           /* 0268 0268 */
    uint32_t                    trap_oneshot;        /* 026C 026C */
    uint8_t                     trap_basetype;       /* 0270 0270 */
    uint8_t                     field_271;           /* 0271 0271 */
    uint8_t                     field_272;           /* 0272 0272 */
    uint8_t                     field_273;           /* 0273 0273 */
    uint32_t                    trap_detect_dc;      /* 0274 0274 */
    uint32_t                    trap_disarm_dc;      /* 0278 0278 */
    uint32_t                    trap_recoverable;    /* 027C 027C */
    uint32_t                    trap_active;         /* 0280 0280 */

    uint32_t                    field_284;           /* 0284 0284 */
    uint32_t                    field_288;           /* 0288 0288 */

    uint32_t                    trap_creator;        /* 0284 028C */
} CNWSTrigger;
]]