local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    CNWSObject                  obj;
    CExoLocString              *plc_firstname;
    uint32_t                    field_1C8;

    CExoString                  plc_displayname;        /* 01CC */
    uint32_t                    plc_displayname_update; /* 01D4 */

    uint32_t                    plc_appearance;         /* 01D8 */

    CExoLocString               plc_desc_base;          /* 01DC */
    CExoLocString               plc_desc_override;      /* 01E4 */

    uint32_t                    plc_faction;            /* 01EC */
    char                        plc_conv[16];           /* 01F0 */

    uint8_t                     plc_type;               /* 0200 */
    uint8_t                     field_201;
    uint8_t                     field_202;
    uint8_t                     field_203;

    uint32_t                    plc_is_ground_pile;     /* 0204 */
    uint32_t                    plc_sitter;             /* 0208 */
    uint32_t                    plc_hardness;           /* 020C */
    float                       plc_bearing;            /* 0210 */
    uint32_t                    lock_locked;            /* 0214 */
    uint32_t                    lock_key_name;          /* 0218 */
    uint32_t                    field_21C;              /* 021C */
    uint32_t                    lock_key_required_msg;  /* 0220 */
    uint32_t                    field_224;              /* 0224 */
    uint32_t                    lock_key_required;      /* 0228 */
    uint32_t                    lock_key_remove;        /* 022C */

    uint8_t                     lock_open_dc;            /* 0230 */
    uint8_t                     lock_lock_dc;          /* 0231 */
    uint8_t                     field_232;
    uint8_t                     field_233;

    uint32_t                    trap_creator;           /* 0234 */

    uint8_t                     trap_detect_dc;          /* 0238 */
    uint8_t                     field_239;
    uint8_t                     field_23A;
    uint8_t                     field_23B;

    uint32_t                    plc_trapped;            /* 023C */
    uint32_t                    trap_disarm_dc;         /* 0240 */
    uint32_t                    trap_disarmable;        /* 0244 */
    uint32_t                    trap_detectable;        /* 0248 */
    uint32_t                    trap_oneshot;           /* 024C */
    uint32_t                    trap_recoverable;       /* 0250 */
    uint32_t                    trap_flagged;           /* 0254 */

    uint8_t                     trap_basetype;          /* 0258 */
    uint8_t                     field_259;
    uint8_t                     field_25A;
    uint8_t                     field_25B;

    uint32_t                    trap_active;            /* 025C */
    uint32_t                    trap_faction;           /* 0260 */

    uint32_t                    plc_event_scripts;      /* 0264 */
    uint32_t                    field_268;              /* 0268 */
    uint32_t                    field_26C;              /* 026C */
    uint32_t                    field_270;              /* 0270 */
    uint32_t                    field_274;              /* 0274 */
    uint32_t                    field_278;              /* 0278 */
    uint32_t                    field_27C;              /* 027C */
    uint32_t                    field_280;              /* 0280 */
    uint32_t                    field_284;              /* 0284 */
    uint32_t                    field_288;              /* 0288 */
    uint32_t                    field_28C;              /* 028C */
    uint32_t                    field_290;              /* 0290 */
    uint32_t                    field_294;              /* 0294 */
    uint32_t                    field_298;              /* 0298 */
    uint32_t                    field_29C;              /* 029C */
    uint32_t                    field_2A0;              /* 02A0 */
    uint32_t                    field_2A4;              /* 02A4 */
    uint32_t                    field_2A8;              /* 02A8 */
    uint32_t                    field_2AC;              /* 02AC */
    uint32_t                    field_2B0;              /* 02B0 */
    uint32_t                    field_2B4;              /* 02B4 */
    uint32_t                    field_2B8;              /* 02B8 */
    uint32_t                    field_2BC;              /* 02BC */
    uint32_t                    field_2C0;              /* 02C0 */
    uint32_t                    field_2C4;              /* 02C4 */
    uint32_t                    field_2C8;              /* 02C8 */
    uint32_t                    field_2CC;              /* 02CC */
    uint32_t                    field_2D0;              /* 02D0 */
    uint32_t                    field_2D4;              /* 02D4 */
    uint32_t                    field_2D8;              /* 02D8 */
    uint32_t                    field_2DC;              /* 02DC */
    uint32_t                    field_2E0;              /* 02E0 */

    uint8_t                     plc_save_fort;          /* 02E4 */
    uint8_t                     plc_save_will;
    uint8_t                     plc_save_reflex;
    uint8_t                     field_2E7;

    uint32_t                    plc_creature_list;      /* 02E8 */
    uint32_t                    field_2EC;              /* 02EC */
    uint32_t                    field_2F0;              /* 02F0 */
    uint32_t                    plc_has_inventory;      /* 02F4 */
    uint32_t                    plc_usable;             /* 02F8 */
    uint32_t                    plc_pickable;           /* 02FC */
    uint32_t                    lock_lockable;           /* 0300 */
    uint32_t                    plc_die_when_empty;     /* 0304 */
    uint32_t                    field_308;              /* 0308 */
    uint32_t                    field_30C;              /* 030C */
    uint32_t                    plc_lootable_creature;  /* 0310 */
    uint32_t                    plc_is_bodybag;         /* 0314 */
    uint32_t                    field_318;              /* 0318 */
    uint32_t                    field_31C;              /* 031C */
    uint32_t                    plc_last_opener;        /* 0320 */
    uint32_t                    plc_last_closer;        /* 0324 */
    uint32_t                    plc_last_user;          /* 0328 */
    uint32_t                    plc_last_clicker;       /* 032C */
    uint32_t                    plc_last_triggerer;     /* 0330 */
    uint32_t                   plc_last_disarmer;      /* 0334 */
    uint32_t                 plc_last_locker;        /* 0338 */
    uint32_t                 plc_last_unlocker;      /* 033C */

    void                        *plc_inventory;          /* 0340 */

    uint32_t                    field_344;              /* 0344 */
    uint32_t                    field_348;              /* 0348 */
    uint32_t                    field_34C;              /* 034C */
    uint32_t                    field_350;              /* 0350 */
    uint32_t                    field_354;              /* 0354 */
    uint32_t                    field_358;              /* 0358 */
    uint32_t                    field_35C;              /* 035C */
    uint32_t                    field_360;              /* 0360 */
    uint32_t                    field_364;              /* 0364 */
    uint32_t                    field_368;              /* 0368 */
    uint32_t                    field_36C;              /* 036C */
    uint32_t                    field_370;              /* 0370 */
    uint32_t                    field_374;              /* 0374 */
    uint32_t                    field_378;              /* 0378 */
    uint32_t                    field_37C;              /* 037C */
    uint32_t                    field_380;              /* 0380 */
    uint32_t                    plc_light_state_change; /* 0384 */

    uint8_t                     plc_bodybag;            /* 0388 */
    uint8_t                     field_389;
    uint8_t                     field_38A;
    uint8_t                     field_38B;

    uint32_t                    plc_static;             /* 038C */
    uint32_t                    plc_never_static;       /* 0390 */
    uint32_t                    field_394;              /* 0394 */
    uint32_t                    field_398;              /* 0398 */
    uint32_t                    field_39C;              /* 039C */
} CNWSPlaceable;
]]