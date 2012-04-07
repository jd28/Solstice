--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local ffi = require 'ffi'

ffi.cdef[[
typedef struct CNWSModule {
    uint32_t                    obj_type;
    nwn_objid_t                 obj_id;                                                                 /* 0x0004 */
    uint32_t                    field_08;                                                               /* 0x0008 */
    uint32_t                    field_0C;                                                               /* 0x000C */
    uint32_t                    field_10;                                                               /* 0x0010 */
    uint32_t                    field_14;                                                               /* 0x0014 */
    uint32_t                    field_18;                                                               /* 0x0018 */
    uint32_t                    field_1C;                                                               /* 0x001C */
    uint32_t                    field_20;                                                               /* 0x0020 */
    uint32_t                    field_24;                                                               /* 0x0024 */
    uint32_t                    field_28;                                                               /* 0x0028 */
    uint32_t                    field_2C;                                                               /* 0x002C */
    uint32_t                    field_30;                                                       /* 0x0030 */
    uint32_t                    field_34;                                                               /* 0x0034 */
    nwn_objid_t                 *mod_areas;                                                     /* 0x0038 */
    uint32_t                    mod_areas_len;                                                  /* 0x003C */
    uint32_t                    mod_areas_alloc;                                                /* 0x0040 */
    uint32_t                    field_44;                                                               /* 0x0044 */
    uint32_t                    field_48;                                                               /* 0x0048 */
    ArrayList                   mod_PlayerTURDList;                                             /* 0x004C-50 */
    
    CExoLocString               *mod_description;                                               /* 0x0050-54 */
    CExoString                  mod_custom_tlk;                                                 /* 0x0058-5C */

    uint32_t                    field_60;                                                       /* 0x0060 */
    uint32_t                    field_64;                                                       /* 0x0064 */
    CExoString                  mod_current_game;                                               /* 0x0068 */
    uint32_t                    field_70;                                                       /* 0x0070 */
    uint32_t                    field_74;                                                       /* 0x0074 */
    uint32_t                    field_78;                                                       /* 0x0078 */
    uint32_t                    mod_is_demo;                                                    /* 0x007C */
    uint32_t                    mod_1;                                                          /* 0x0080 */
    CExoLocString               mod_name;                                                       /* 0x0084 */
    ArrayList                   mod_haks;                                                               /* 0x008C */
    CResRef                     mod_dunno;                              /* 0x0098 */
    uint32_t                    field_9C;                               /* 0x009C */
    uint32_t                    field_A0;                               /* 0x00A0 */
    uint32_t                    field_A4;                               /* 0x00A4 */    
    CNWSScriptVarTable          mod_vartable;                           /* 0x00A8 */
    uint32_t                    field_B0;                               /* 0x00B0 */    
    uint32_t                    field_B4;                               /* 0x00B4 */    
    CExoString                  Mod_OnHeartbeat;                        /* 0x00B8 */
    CExoString                  Mod_OnUsrDefined;                       /* 0x00C0 */
    CExoString                  Mod_OnModLoad;                          /* 0x00C8 */
    CExoString                  Mod_OnModStart;                         /* 0x00D0 */
    CExoString                  Mod_OnClientEntr;                       /* 0x00D8 */
    CExoString                  Mod_OnClientLeav;                       /* 0x00E0 */
    CExoString                  Mod_OnActvtItem;                        /* 0x00E8 */
    CExoString                  Mod_OnAcquirItem;                       /* 0x00F0 */
    CExoString                  Mod_OnUnAqreItem;                       /* 0x00F8 */
    CExoString                  Mod_OnPlrDeath;                         /* 0x0100 */
    CExoString                  Mod_OnPlrDying;                         /* 0x0108 */
    CExoString                  Mod_OnSpawnBtnDn;                       /* 0x0110 */
    CExoString                  Mod_OnPlrRest;                          /* 0x0118 */
    CExoString                  Mod_OnPlrLvlUp;                         /* 0x0120 */
    CExoString                  Mod_OnCutsnAbort;                       /* 0x0128 */
    CExoString                  Mod_OnPlrEqItm;                         /* 0x0130 */
    CExoString                  Mod_OnPlrUnEqItm;                       /* 0x0138 */
    CExoString                  Mod_OnPlrChat;                          /* 0x0140 */    
    uint32_t                    field_144;                              /* 0x0144 */    
    uint32_t                    field_148;                              /* 0x0148 */
    uint32_t                    field_14C;                              /* 0x014C */
    uint32_t                    field_150;                              /* 0x0150 */
    ArrayList                   mod_lookuptable;                        /* 0x0154 */



    uint32_t                    field_160;                              /* 0x0160 */
    uint32_t                    field_164;                              /* 0x0164 */
    nwn_objid_t                 mod_last_enter;                                 /* 0x016C */
    nwn_objid_t                 mod_last_exit;                                  /* 0x0170 */    
    nwn_objid_t                 mod_last_item_aquired;                          /* 0x0174 */    
    nwn_objid_t                 mod_last_item_aquired_from;                     /* 0x0178 */    
    nwn_objid_t                 mod_last_item_aquired_by;                       /* 0x017C */    
    uint32_t                    field_180;                                      /* 0x0180 */    
    uint32_t                    field_184;                                      /* 0x0184 */
    uint32_t                    mod_last_item_aquired_stack_size;               /* 0x0188 */    
    uint32_t                    field_18C;                                      /* 0x018C */
    uint32_t                    field_190;                                      /* 0x0190 */
    uint32_t                    field_194;                                      /* 0x0194 */
    uint32_t                    field_198;                                      /* 0x0198 */
    uint32_t                    field_19C;                                      /* 0x019C */
    nwn_objid_t                 mod_last_rested;                                /* 0x01A0 */
    uint32_t                    field_1A4;                                      /* 0x01A4 */
    nwn_objid_t                 mod_last_player_died;                           /* 0x01A8 */
    nwn_objid_t                 mod_last_player_dying;                          /* 0x01AC */
    uint32_t                    field_1B0;                                      /* 0x01B0 */
    uint32_t                    field_1B4;                                      /* 0x01B4 */
    uint32_t                    field_1B8;                                      /* 0x01B8 */
    uint32_t                    field_1BC;                                      /* 0x01BC */
    uint32_t                    mod_date_year;                                                  /* 0x01C0 */
    uint32_t                    mod_date_month;                                                 /* 0x01C4 */
    uint32_t                    mod_date_day;                                                   /* 0x01C8 */
    uint32_t                    mod_time_hour;                                                  /* 0x01CC */
    uint32_t                    field_1D0;                                      /* 0x01D0 */
    uint32_t                    field_1D4;                                      /* 0x01D4 */    
    uint8_t                     mod_min_per_hour;                               /* 0x01D8 */
    uint8_t                     mod_dawnhour;                                   /* 0x01D9 */
    uint8_t                     mod_duskhour;                                   /* 0x01DA */
    uint8_t                     mod_start_month;                                /* 0x01DB */
    uint8_t                     mod_start_day;                                                  /* 0x01DC */
    uint8_t                     mod_start_hour;                                                 /* 0x01DD */    
    uint8_t                     mod_xp_scale;                                                   /* 0x01DE */    
    uint8_t                     field_1DF;                                                              /* 0x01DF */
    uint32_t                    mod_start_year;                                 /* 0x01E0 */
    uint32_t                    field_1E4;                                      /* 0x01E4 */
    uint32_t                    field_1E8;                                      /* 0x01E8 */
    uint32_t                    field_1EC;                                      /* 0x01EC */
    uint32_t                    field_1F0;                                      /* 0x01F0 */
    uint32_t                    field_1F4;                                      /* 0x01F4 */
    uint32_t                    field_1F8;                                      /* 0x01F8 */
    uint32_t                    field_1FC;                                      /* 0x01FC */
    uint32_t                    field_200;                                      /* 0x0200 */
    ArrayList                   mod_world_journal_entry;                                /* 0x0204 */
    uint8_t                     field_210;                                                              /* 0x0210 */    
    uint32_t                    mod_max_henchmen;                               /* 0x0214 */
    nwn_objid_t                 *mod_limbo_list;                                                /* 0x0218 */
    uint32_t                    mod_limbo_list_len;                                             /* 0x021C */
    uint32_t                    mod_limbo_list_alloc;                                   /* 0x0220 */
    uint32_t                    field_224;                                      /* 0x0224 */
    //  uint32_t                field_228;                                  /* 0x0228 */
    //  uint32_t                field_22C;                                  /* 0x022C */
    //  uint32_t                field_230;                                  /* 0x0230 */
    CExoString                  mod_tag;                                        /* 0x0234 */

    uint32_t                    mod_is_official_campaign;                       /* 0x023C */
    CExoString                  mod_nwm_res_name;                               /* 0x0240 */
    uint32_t                    mod_table_count;                                /* 0x0248 */
    uint8_t                     mod_pc_pathfind_rule;                           /* 0x024C */
    uint8_t                     mod_enable_script_debugger;                     /* 0x024D */
    uint8_t                     field_24E;                                              /* 0x024E */
    uint8_t                     field_24F;                                              /* 0x024F */    
    nwn_objid_t                 mod_last_pc_chat_obj;                           /* 0x0250 */
    CExoString                  mod_last_pc_chat;                               /* 0x0254 */
    uint32_t                    mod_last_pc_chat_type;                          /* 0x025C */
} CNWSModule;

]]