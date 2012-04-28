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
typedef struct CNWSStats_Level {
    ArrayList                  ls_spells_known[10];
    ArrayList                  ls_spells_removed[10];
    ArrayList                  ls_featlist;

    uint8_t                    *ls_skilllist;
    uint16_t                    ls_skillpoints;              /* 0100 */

    uint8_t                     ls_ability;
    uint8_t                     ls_hp;
    
    uint8_t                     ls_class;                    /* 0104 */
    uint8_t                     unknown_3;                   /* 0105 */
    uint8_t                     unknown_4;                   /* 0106 */
    uint8_t                     unknown_5;                   /* 0107 */
    uint8_t                     ls_epic_level;               /* 0108 */
    uint8_t                     field_0109;                  /* 0109 */
    uint8_t                     field_010A;                  /* 010A */
    uint8_t                     field_010B;                  /* 010B */
} CNWSStats_Level;

typedef struct CNWSCreatureAppearanceInfo {
    uint32_t                    cai_lefthand_obj_id;    /* 0000 */  /* 0C28 in CNWSCreatureStats */
    uint32_t                    cai_righthand_obj_id;   /* 0004 */  /* 0C2C in CNWSCreatureStats */
    uint8_t                     cai_righthand_wpn_vfx;  /* 0008 */  /* 0C30 in CNWSCreatureStats */
    uint8_t                     cai_lefthand_wpn_vfx;   /* 0009 */  /* 0C31 in CNWSCreatureStats */
    uint8_t                     field_A;                /* 000A */  /* 0C32 in CNWSCreatureStats */
    uint8_t                     field_B;                /* 000B */  /* 0C33 in CNWSCreatureStats */
    uint32_t                    cai_chest_obj_id;       /* 000C */  /* 0C34 in CNWSCreatureStats */
    uint32_t                    cai_head_obj_id;        /* 0010 */  /* 0C38 in CNWSCreatureStats */ 
    uint16_t                    cai_appearance;         /* 0014 */  /* 0C3C in CNWSCreatureStats */ 
    uint8_t                     field_16;
    uint8_t                     field_17;
    uint8_t                     field_18;
    uint8_t                     field_19;
    uint8_t                     field_1A;
    uint8_t                     field_1B;
    uint8_t                     field_1C[12];
    uint32_t                    field_28;
    uint8_t                     field_2C;
    uint8_t                     field_2D;
    uint8_t                     field_2E;
    uint8_t                     field_2F;
    uint32_t                    field_30;
    uint32_t                    field_34;
    uint32_t                    field_38;
    uint32_t                    cai_cloak_obj_id;        /* 003C */
} CNWSCreatureAppearanceInfo;

typedef struct CNWSCreatureClass {
    ArrayList        cl_spells_known[10];
    ArrayList        cl_spells_mem[10];      /* CNWSStats_Spell * */

    uint8_t          cl_spells_bonus[10];
    uint8_t          cl_spells_left[10];     /* 0x00FA */
    uint8_t          cl_spells_max[10];      /* 0x0104 */

    uint8_t          cl_class;
    uint8_t          cl_level;

    uint8_t          cl_negative_level;

    uint8_t          cl_specialist;
    uint8_t          cl_domain_1;
    uint8_t          cl_domain_2;

    uint8_t          unknown_2[4];
} CNWSCreatureClass;

typedef struct CNWSCreatureStats {
    ArrayList        cs_feats;               /* 0000 */
    ArrayList        cs_featuses;            /* 000C */         /* CNWSStats_FeatUses * */

    uint32_t                    field_18;
    uint32_t                    field_1C;
    uint32_t                    field_20;

    void                        *cs_original;            /* 0024 */

    ArrayList                   cs_levelstat;           /* 0028 */         /* CNWSStats_Level * */

    CExoLocString               cs_firstname;           /* 0034 */
    CExoLocString               cs_lastname;            /* 003C */

    char                        cs_conv[16];            /* 0044 */
    uint32_t                    cs_conv_interruptable;  /* 0054 */

    CExoLocString               cs_desc_base;           /* 0058 */
    CExoLocString               cs_desc_override;       /* 0060 */

    int32_t                     cs_age;                 /* 0068 */
    uint32_t                    cs_gender;              /* 006C */
    uint32_t                    cs_xp;                  /* 0070 */
    uint32_t                    cs_is_pc;               /* 0074 */
    uint32_t                    cs_is_dm;               /* 0078 */

    uint32_t                    field_7C;
    uint32_t                    field_80;

    uint32_t                    cs_ai_disabled;         /* 0084 */

    uint32_t                    field_88;
    uint32_t                    cs_mclasslevupin;       /* 008C */

    uint32_t                    cs_faction_id;          /* 0090 */
    uint32_t                    cs_faction_orig;        /* 0094 */
    uint32_t                    cs_faction_predom;      /* 0098 */

    float                       cs_cr;                  /* 009C */

    uint8_t                     cs_starting_package;    /* 00A0 */
    int8_t                      cs_classes_len;         /* 00A1 */
    uint8_t                     field_9A;
    uint8_t                     field_9B;

    CNWSCreatureClass           cs_classes[3];          /* 00A4 */

    uint16_t                    cs_race;                /* 03EC */
    uint16_t                    field_3EE;
    char                        *cs_subrace;             /* 03F0 */
    uint32_t                    cs_subrace_len;

    uint8_t                     cs_str;                 /* 03F8 */
    int8_t                      cs_str_mod;             /* 03F9 */
    uint8_t                     cs_dex;                 /* 03FA */
    int8_t                      cs_dex_mod;             /* 03FB */
    uint8_t                     cs_con;                 /* 03FC */
    int8_t                      cs_con_mod;             /* 03FD */
    uint8_t                     cs_int;                 /* 03FE */
    int8_t                      cs_int_mod;             /* 03FF */
    uint8_t                     cs_wis;                 /* 0400 */
    int8_t                      cs_wis_mod;             /* 0401 */
    uint8_t                     cs_cha;                 /* 0402 */
    int8_t                      cs_cha_mod;             /* 0403 */

    uint8_t                     cs_ac_natural_base;     /* 0404 */
    uint8_t                     cs_ac_armour_base;      /* 0405 */
    uint8_t                     cs_ac_shield_base;      /* 0406 */
    uint8_t                     cs_ac_armour_bonus;     /* 0407 */
    uint8_t                     cs_ac_armour_penalty;   /* 0408 */
    uint8_t                     cs_ac_deflection_bonus; /* 0409 */
    uint8_t                     cs_ac_deflection_penalty;
    uint8_t                     cs_ac_shield_bonus;     /* 040B */
    uint8_t                     cs_ac_shield_penalty;   /* 040C */
    uint8_t                     cs_ac_natural_bonus;    /* 040D */
    uint8_t                     cs_ac_natural_penalty;  /* 040E */
    uint8_t                     cs_ac_dodge_bonus;      /* 040F */
    uint8_t                     cs_ac_dodge_penalty;    /* 0410 */

    uint8_t                     cs_override_bab;        /* 0411 */

    uint8_t                     cs_override_atks;       /* 0412 -- Seems to be some onhand attack override. 
                                                                   See SetBaseAttackBonus & RestoreBaseAttackBonus */
    uint8_t                     field_40B;
    uint32_t                    field_40C;
    uint32_t                    field_410;
    uint32_t                    field_414;
    uint32_t                    field_418;
    uint32_t                    field_41C;

    CCombatInformation         *cs_combat_info;         /* 0428 */

    uint32_t                    field_424;
    uint32_t                    field_428;
    uint32_t                    field_42C;
    uint32_t                    field_430;

    void                       *cs_specabil;            /* 043C */

    uint16_t                    field_440;
    uint16_t                    cs_first_ac_eff;
    uint16_t                    cs_first_ab_eff;
    uint16_t                    cs_first_dred_eff;
    uint16_t                    cs_first_dresist_eff;
    uint16_t                    cs_first_dmg_eff;
    uint16_t                    cs_first_aistate_eff;
    uint16_t                    cs_first_icon_eff;
    uint16_t                    field_450;
    uint16_t                    cs_first_conceal_eff;
    uint16_t                    field_454;
    uint16_t                    cs_first_ability_eff;
    uint16_t                    field_458;
    uint16_t                    field_45A;
    uint16_t                    cs_first_misschance_eff;
    uint16_t                    field_45E;
    uint32_t                    field_460;
    uint32_t                    field_464;
    uint16_t                    field_468;
    uint16_t                    cs_first_skill_eff;
    uint16_t                    cs_first_save_eff;
    uint16_t                    field_46E;
    uint16_t                    cs_first_imm_eff;
    uint16_t                    field_472;
    uint16_t                    field_474;

    uint16_t                    cs_skill_points;        /* 0476 */
    uint8_t                    *cs_skills;              /* 0478 */

    int8_t                      cs_acp_armor; 		/* 047C */
    int8_t                      cs_acp_shield;  	/* 047D */

    char                        cs_portrait[16];        /* 047E */

    uint8_t                     cs_al_goodevil;         /* 048E */
    uint8_t                     field_487;
    uint8_t                     cs_al_lawchaos;         /* 0490 */
    uint8_t                     field_489;

    uint8_t                     cs_color_skin;          /* 0492 */
    uint8_t                     cs_color_hair;          /* 0493 */
    uint8_t                     cs_color_tattoo_1;      /* 0494 */
    uint8_t                     cs_color_tattoo_2;      /* 0495 */

    uint16_t                    cs_appearance;          /* 0496 */

    uint8_t                     cs_phenotype;           /* 0498 */
    uint8_t                     cs_appearance_head;     /* 0499 */

    uint8_t                     cs_bodypart_rfoot;      /* 049A */
    uint8_t                     cs_bodypart_lfoot;      /* 049B */
    uint8_t                     cs_bodypart_rshin;      /* 049C */
    uint8_t                     cs_bodypart_lshin;      /* 049D */
    uint8_t                     cs_bodypart_lthigh;     /* 049E */
    uint8_t                     cs_bodypart_rthigh;     /* 049F */
    uint8_t                     cs_bodypart_pelvis;     /* 04A0 */
    uint8_t                     cs_bodypart_torso;      /* 04A1 */
    uint8_t                     cs_bodypart_belt;       /* 04A2 */
    uint8_t                     cs_bodypart_neck;       /* 04A3 */
    uint8_t                     cs_bodypart_rfarm;      /* 04A4 */
    uint8_t                     cs_bodypart_lfarm;      /* 04A5 */
    uint8_t                     cs_bodypart_rbicep;     /* 04A6 */
    uint8_t                     cs_bodypart_lbicep;     /* 04A7 */
    uint8_t                     cs_bodypart_rshoul;     /* 04A8 */
    uint8_t                     cs_bodypart_lshoul;     /* 04A9 */
    uint8_t                     cs_bodypart_rhand;      /* 04AA */
    uint8_t                     cs_bodypart_lhand;      /* 04AB */

    uint8_t                     field_4A4_old;
    uint8_t                     cs_tail_old;            /* 04AD */
    uint8_t                     cs_wings_old;           /* 04AE */
    uint8_t                     field_4A7_old;

    uint32_t                    cs_tail;                /* 04B0 */
    uint32_t                    cs_wings;               /* 04B4 */

    uint32_t                    cs_movement_rate;       /* 04B8 */

    uint32_t                    field_4AC;
    uint32_t                    field_4B0;

    int8_t                      cs_save_fort;           /* 04C4 */
    int8_t                      cs_save_will;           /* 04C5 */
    int8_t                      cs_save_reflex;         /* 04C6 */

    uint8_t                     field_4B7;

    uint32_t                    cs_acomp_type;          /* 04C8 */
    uint32_t                    cs_famil_type;          /* 04CC */

    char                        *cs_acomp_name;          /* 04D0 */
    uint32_t                    cs_acomp_name_len;
    char                        *cs_famil_name;          /* 04D8 */
    uint32_t                    cs_famil_name_len;

    char                        *cs_deity;               /* 04E0 */
} CNWSCreatureStats;

typedef struct CNWSCreature {
    CNWSObject                  obj;

    uint32_t                    cre_ponyride;           /* 01C4 */

    uint16_t                    cre_equipment_index;    /* 01C8 */

    uint16_t                    field_1CA;
    uint32_t                    field_1CC;
    uint32_t                    field_1D0;
    uint32_t                    field_1D4;
    uint32_t                    field_1D8;
    uint32_t                    field_1DC;
    uint32_t                    field_1E0;
    uint32_t                    field_1E4;
    uint32_t                    field_1E8;
    uint32_t                    field_1EC;
    uint32_t                    field_1F0;
    uint32_t                    field_1F4;

    CExoString                  cre_eventhandlers[13];  /* 01F8 */

    uint32_t                    field_260;
    uint32_t                    field_264;
    uint32_t                    field_268;
    uint32_t                    field_26C;
    uint32_t                    field_270;
    uint32_t                    field_274;
    uint32_t                    field_278;
    uint32_t                    field_27C;
    uint32_t                    field_280;
    uint32_t                    field_284;
    uint32_t                    field_288;
    uint32_t                    field_28C;
    uint32_t                    field_290;
    uint32_t                    field_294;
    uint32_t                    field_298;
    uint32_t                    field_29C;
    uint32_t                    field_2A0;
    uint32_t                    field_2A4;
    uint32_t                    field_2A8;
    uint32_t                    field_2AC;
    uint32_t                    field_2B0;
    uint32_t                    field_2B4;
    uint32_t                    field_2B8;
    uint32_t                    field_2BC;
    uint32_t                    field_2C0;
    uint32_t                    field_2C4;

    void                        *cre_quickbar;           /* 02C8 */

    uint32_t                    cre_lootable;           /* 02CC */
    uint32_t                    cre_decaytime;          /* 02D0 */
    uint32_t                    cre_bodybag_id;         /* 02D4 */

    uint32_t                 cre_desired_area;       /* 02D8 */
    Vector                      cre_desired_pos;        /* 02DC */
    uint32_t                    cre_desired_complete;   /* 02E8 */

    ArrayList        cre_aoe_list;           /* 02EC */
    ArrayList        cre_subarea_list;       /* 02F8 */

    uint32_t                 cre_blocked_id;         /* 0304 */
    Vector                     *cre_blocked_pos;        /* 0308 */

    uint32_t                    field_30C;

    uint32_t                    cre_updatecombatinfo;   /* 0310 */
    uint32_t                    cre_charsheetviewers;   /* 0314 */

    uint32_t                    cre_creation_scr_exec;  /* 0318 */

    uint32_t                    cre_last_heart_time_1;  /* 031C */
    uint32_t                    cre_last_heart_time_2;  /* 0320 */

    uint32_t                    field_324;
    uint32_t                    field_328;
    uint32_t                    field_32C;

    uint32_t                 cre_last_trap_detected; /* 0330 */

    uint32_t                    field_334;
    uint32_t                    field_338;
    uint32_t                    field_33C;
    uint32_t                    field_340;

    uint32_t                    cre_excited;            /* 0344 */

    uint32_t                    field_348;
    uint32_t                    field_34C;
    uint32_t                    field_350;
    uint32_t                    field_354;
    uint32_t                    field_358;

    uint32_t                    cre_pending_realization;/* 035C */

    uint32_t                    field_360;
    uint32_t                    field_364;
    uint32_t                    field_368;

    ArrayList        cre_action_queue;       /* 036C */

    uint32_t                    field_378;
    uint32_t                    field_37C;
    uint32_t                    field_380;
    uint32_t                    field_384;
    uint32_t                    field_388;
    uint32_t                    field_38C;
    uint32_t                    field_390;
    uint32_t                    field_394;
    uint32_t                    field_398;
    uint32_t                    field_39C;
    uint32_t                    field_3A0;
    uint32_t                    field_3A4;
    uint32_t                    field_3A8;
    uint32_t                    field_3AC;
    uint32_t                    field_3B0;
    uint32_t                    field_3B4;
    uint32_t                    field_3B8;
    uint32_t                    field_3BC;
    uint32_t                    field_3C0;
    uint32_t                    field_3C4;
    uint32_t                    field_3C8;
    uint32_t                    field_3CC;
    uint32_t                    field_3D0;
    uint32_t                    field_3D4;
    uint32_t                    field_3D8;
    uint32_t                    field_3DC;
    uint32_t                    field_3E0;
    uint32_t                    field_3E4;
    uint32_t                    field_3E8;
    uint32_t                    field_3EC;
    uint32_t                    field_3F0;
    uint32_t                    field_3F4;
    uint32_t                    field_3F8;
    uint32_t                    field_3FC;
    uint32_t                    field_400;
    uint32_t                    field_404;
    uint32_t                    field_408;
    uint32_t                    field_40C;
    uint32_t                    field_410;
    uint32_t                    field_414;
    uint32_t                    field_418;
    uint32_t                    field_41C;
    uint32_t                    field_420;
    uint32_t                    field_424;
    uint32_t                    field_428;
    uint32_t                    field_42C;
    uint32_t                    field_430;
    uint32_t                    field_434;
    uint32_t                    field_438;
    uint32_t                    field_43C;
    uint32_t                    field_440;
    uint32_t                    field_444;
    uint32_t                    field_448;
    uint32_t                    field_44C;
    uint32_t                    field_450;
    uint32_t                    field_454;
    uint32_t                    field_458;
    uint32_t                    field_45C;
    uint32_t                    field_460;
    uint32_t                    field_464;
    uint32_t                    field_468;
    uint32_t                    field_46C;
    uint32_t                    field_470;
    uint32_t                    field_474;
    uint32_t                    field_478;
    uint32_t                    field_47C;
    uint32_t                    field_480;

    uint8_t                     cre_ambient_anim_state; /* 0484 */
    uint8_t                     field_485;
    uint8_t                     field_486;
    uint8_t                     field_487;

    uint32_t                    cre_model_type;         /* 0488 */

    uint32_t                    field_48C;

    uint32_t                    cre_automap_tile_data;  /* 0490 */
    ArrayList        cre_automap_areas;      /* 0494 */
    uint32_t                    cre_num_areas;          /* 04A0 */

    uint32_t                    field_4A4;
    uint32_t                    field_4A8;

    uint8_t                     cre_mode_detect;        /* 04AC */
    uint8_t                     cre_mode_stealth;       /* 04AD */
    uint8_t                     cre_mode_defcast;       /* 04AE */

    uint8_t                     cre_mode_combat;        /* 04AF */
    uint8_t                     cre_mode_desired;       /* 04B0 */

    uint8_t                     field_4B1;
    uint8_t                     field_4B2;
    uint8_t                     field_4B3;

    uint32_t                    cre_counterspell_target;/* 04B4 */

    uint8_t                     cre_initiative_roll;    /* 04B8 */
    uint8_t                     field_4B9;
    uint8_t                     field_4BA;
    uint8_t                     field_4BB;

    uint32_t                    cre_initiative_expired; /* 04BC */

    uint32_t                    cre_combat_state;       /* 04C0 */
    uint32_t                    cre_combat_state_timer; /* 04C4 */

    uint32_t                    cre_passive_attack_beh; /* 04C8 */

    uint32_t                    cre_has_arms;           /* 04CC */
    uint32_t                    cre_has_legs;           /* 04D0 */

    uint32_t                    cre_is_disarmable;      /* 04D4 */

    uint32_t                    cre_size;               /* 04D8 */

    float                       cre_pref_attack_dist;   /* 04D4 */
    uint32_t                    cre_weapon_scale;       /* 04E0 */

    uint32_t                 cre_attack_target;      /* 04E4 */
    uint32_t                 cre_attempted_target;   /* 04E8 */

    uint32_t                    field_4EC;
    uint32_t                    field_4F0;
    uint32_t                    field_4F4;

    uint32_t                 cre_attacker;           /* 04F8 */

    uint32_t                 cre_attempted_spell;    /* 04FC */
    uint32_t                 cre_spell_target;       /* 0500 */

    uint32_t                    cre_last_ammo_warning;  /* 0504 */

    uint32_t                    field_508;
    uint32_t                    field_50C;

    uint32_t                 cre_broadcast_aoo_to;   /* 0510 */

    uint32_t                    field_514;

    uint32_t                    cre_ext_combat_mode;    /* 0518 */

    int32_t                     cre_eff_bon_amt[50];    /* 051C */
    int32_t                     cre_eff_pen_amt[50];    /* 05E4 */

    int32_t                     cre_eff_bon_spid[50];   /* 06AC */
    int32_t                     cre_eff_pen_spid[50];   /* 0774 */

    int32_t                     cre_eff_bon_obj[50];    /* 083C */
    int32_t                     cre_eff_pen_obj[50];    /* 0904 */

    uint32_t                    cre_silent;             /* 09CC */
    uint32_t                    cre_hasted;             /* 09D0 */
    uint32_t                    cre_slowed;             /* 09D4 */
    uint32_t                    cre_taunted;            /* 09D8 */
    uint32_t                    cre_forced_walk;        /* 09DC */

    uint8_t                     cre_vision_type;        /* 09E0 */

    uint8_t                     cre_state;              /* 09E1 */

    uint8_t                     field_9E2;
    uint8_t                     field_9E3;

    uint32_t                    cre_current_spell;      /* 09E4 */

    ArrayList        cre_effect_icons;       /* 09E8 */

    uint32_t                    cre_cutscene_cam_mode;  /* 09F4 */
    float                       cre_cutscene_cam_move;  /* 09F8 */
    uint32_t                    cre_cutscene_invuln;    /* 09FC */
    uint32_t                    cre_cutscene_ghost;     /* 0A00 */

    uint32_t                    cre_last_perceived;     /* 0A04 */
    uint32_t                    cre_last_perc_heard;    /* 0A08 */
    uint32_t                    cre_last_perc_seen;     /* 0A0C */
    uint32_t                    cre_last_perc_inaudible;/* 0A10 */
    uint32_t                    cre_last_perc_vanished; /* 0A14 */

    float                       cre_spot_distance;      /* 0A18 */
    float                       cre_spot_max_distance;  /* 0A1C */
    float                       cre_listen_distance;    /* 0A20 */
    float                       cre_listen_max_distance;/* 0A24 */
    float                       cre_blindsight_distance;/* 0A28 */

    uint8_t                     cre_last_hide_roll;     /* 0A2C */
    uint8_t                     cre_last_movs_roll;     /* 0A2D */
    uint8_t                     cre_last_spot_roll;     /* 0A2E */
    uint8_t                     cre_last_listen_roll;   /* 0A2F */

    ArrayList           cre_percepts;           /* 0A30 */

    uint32_t                    cre_party_inviter;      /* 0A3C */
    uint32_t                    cre_party_invited;      /* 0A40 */
    uint32_t                    cre_party_invite_time_1;/* 0A44 */
    uint32_t                    cre_party_invite_time_2;/* 0A48 */
    ArrayList       *cre_party_invites;      /* 0A4C */

    uint32_t                    field_A50;

    uint32_t                 cre_lock_orientation;   /* 0A54 */

    uint32_t                    cre_counterspell_id;    /* 0A58 */

    uint8_t                     cre_counterspell_class; /* 0A5C */
    uint8_t                     cre_counterspell_meta;  /* 0A5D */
    uint8_t                     cre_counterspell_domain;/* 0A5D */

    uint8_t                     field_A5F;

    ArrayList        cre_spell_identified;   /* 0A60 */

    uint32_t                 cre_item_spell_item;    /* 0A6C */
    uint32_t                    cre_lastspellunreadied; /* 0A70 */
    uint32_t                    cre_item_spell;         /* 0A74 */
    uint32_t                    cre_item_spell_level;   /* 0A78 */
    uint32_t                    cre_item_spell_aoo;     /* 0A7C */

    uint32_t                    cre_sit_object;         /* 0A80 */

    uint32_t                    cre_steal_anim_played;  /* 0A84 */
    uint32_t                    cre_steal_detected;     /* 0A88 */

    uint32_t                    cre_heal_anim_played;   /* 0A8C */
    uint32_t                    cre_trap_anim_played;   /* 0A90 */
    uint32_t                    cre_unlock_anim_played; /* 0A94 */
    uint32_t                    cre_lock_anim_played;   /* 0A98 */
    uint32_t                    cre_drop_anim_played;   /* 0A9C */
    uint32_t                    cre_pickup_anim_played; /* 0AA0 */
    uint32_t                    cre_taunt_anim_played;  /* 0AA4 */

    uint32_t                    field_AA8;
    uint32_t                    field_AAC;
    uint32_t                    field_AB0;
    uint32_t                    field_AB4;

    uint32_t                    cre_facing_done;        /* 0AB8 */

    uint32_t                    cre_ammo_mag_arrows;    /* 0ABC */
    uint32_t                    cre_ammo_mag_bolts;     /* 0AC0 */
    uint32_t                    cre_ammo_mag_bullets;   /* 0AC4 */

    uint32_t                    field_AC8;

    CNWSCombatRound            *cre_combat_round;       /* 0ACC */

    uint32_t                    field_AD0;

    uint32_t                    cre_barter;             /* 0AD4 */
    uint32_t                    cre_gold;               /* 0AD8 */
    uint32_t                    cre_is_pc;              /* 0ADC */

    uint16_t                    cre_soundset;           /* 0AE0 */
    uint16_t                    field_AE2;              /* 0AE2 */
    uint32_t                    cre_footstep;           /* 0AE4 */

    uint8_t                     cre_bodybag;            /* 0AE8 */

    uint8_t                     field_AE9;
    uint8_t                     field_AEA;
    uint8_t                     field_AEB;

    uint32_t                    cre_is_intransit;       /* 0AEC */
    uint32_t                    cre_is_poisoned;        /* 0AF0 */
    uint32_t                    cre_is_diseased;        /* 0AF4 */
    uint32_t                    cre_is_immortal;        /* 0AF8 */
    uint32_t                    cre_is_nopermdeath;     /* 0AFC */

    char                        *cre_display_name;       /* 0B00 */
    uint32_t                    cre_display_name_len;
    uint32_t                    cre_display_name_update;/* 0B08 */

    uint16_t                    cre_aistate;            /* 0B0C */   /* 0x06 = helpless; 0x01 = alive; 0x04 = free will */
    uint16_t                    cre_aistate_action;     /* 0B0E */

    uint32_t                    cre_aistate_actee;      /* 0B10 */

    uint32_t                    field_B14;

    uint16_t                    cre_aistate_activities; /* 0B18 */   /* 0x08 = dialogue; 0x10 = resting */

    uint16_t                    field_B1A;

    uint32_t                    cre_activity_locked;    /* 0B1C */

    float                       cre_move_rate;          /* 0B20 */

    float                       cre_drivemode_factor;   /* 0B24 */

    uint8_t                     cre_walk_animation;     /* 0B28 */
    uint8_t                     field_B29;
    uint8_t                     field_B2A;
    uint8_t                     field_B2B;

    uint32_t                    cre_drivemode;          /* 0B2C */

    uint32_t                    cre_jumped_recently;    /* 0B30 */

    uint32_t                    cre_master_id;          /* 0B34 */

    ArrayList       *cre_associates;         /* 0B38 */

    uint32_t                    cre_associate_type;     /* 0B3C */   /* 3 = familiar; 7 or 8 = dm */
    uint32_t                    cre_associate_command;  /* 0B40 */

    uint32_t                    cre_summoned_acomp;     /* 0B44 */
    uint32_t                    cre_summoned_famil;     /* 0B48 */

    uint32_t                    field_B4C;
    uint32_t                    field_B50;
    uint32_t                    field_B54;
    uint32_t                    field_B58;

    ArrayList       *cre_reputation_personal;/* 0B5C */
    ArrayList       *cre_reputation;         /* 0B60 */

    ArrayList       *cre_pvp;                /* 0B64 */

    uint32_t                    cre_encounter_obj;      /* 0B68 */
    uint32_t                    cre_encounter_already;  /* 0B6C */

    void              *cre_equipment;          /* 0B70 */
    void              *cre_inventory;          /* 0B74 */

    uint16_t                    cre_inventory_index;    /* 0B78 */
    uint16_t                    cre_container_index;    /* 0B7A */

    uint32_t                 cre_current_container;  /* 0B7C */

    uint32_t                    cre_equipped_weight;    /* 0B80 */
    uint32_t                    cre_calc_npc_weight;    /* 0B84 */
    uint32_t                    cre_encumbrance_state;  /* 0B88 */
    uint32_t                    cre_last_pickup_failed; /* 0B8C */
    uint32_t                    cre_total_weight;       /* 0B90 */

    uint32_t                    field_B94;
    uint32_t                    field_B98;
    uint32_t                    field_B9C;
    uint32_t                    field_BA0;
    uint32_t                    field_BA4;
    uint32_t                    field_BA8;
    uint32_t                    field_BAC;
    uint32_t                    field_BB0;
    uint32_t                    field_BB4;
    uint32_t                    field_BB8;
    uint32_t                    field_BBC;
    uint32_t                    field_BC0;
    uint32_t                    field_BC4;
    uint32_t                    field_BC8;
    uint32_t                    field_BCC;
    uint32_t                    field_BD0;
    uint32_t                    field_BD4;
    uint32_t                    field_BD8;

    char                        cre_poly_portrait[16];  /* 0BDC */
    uint16_t                    cre_poly_unknown_1;     /* 0BEC */
    uint16_t                    cre_poly_unknown_2;     /* 0BEE */

    uint32_t                    cre_is_poly;            /* 0BF0 */

    uint16_t                    cre_poly_unknown_3;     /* 0BF4 */

    uint8_t                     cre_poly_pre_str;       /* 0BF6 */
    uint8_t                     cre_poly_pre_con;       /* 0BF7 */
    uint8_t                     cre_poly_pre_dex;       /* 0BF8 */

    uint8_t                     field_BF9;
    uint8_t                     cre_poly_race;          /* 0BFA */
    uint8_t                     field_BFB;

    int16_t                     cre_poly_pre_hp;        /* 0BFC */

    uint32_t                    cre_poly_spellid_1;     /* 0C00 */
    uint32_t                    cre_poly_spellid_2;     /* 0C04 */
    uint32_t                    cre_poly_spellid_3;     /* 0C08 */

    uint64_t                    cre_poly_acbonus;       /* 0C0C */
    uint64_t                    cre_poly_hpbonus;       /* 0C14 */

    uint8_t                     cre_poly_hasprepolycp;  /* 0C1C */

    uint8_t                     field_C1D;
    uint8_t                     field_C1E;
    uint8_t                     field_C1F;

    uint32_t                    cre_is_polymorphing;    /* 0C20 */
    uint32_t                    cre_poly_locked;        /* 0C24 */

    CNWSCreatureAppearanceInfo  cre_appearance_info;
    
    CNWSCreatureStats           *cre_stats;             /* 0C68 */
} CNWSCreature;
]]