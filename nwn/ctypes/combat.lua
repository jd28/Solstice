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
typedef struct CCombatInformation {
    uint8_t com_attacks;
    uint8_t com_onhand_ab_mod;
    uint8_t com_onhand_dmg_mod;
    uint8_t com_offhand_ab_mod;
    uint8_t com_offhand_dmg_mod;
    uint8_t com_spell_resistance;
    uint8_t com_arcane_failure;
    uint8_t com_armor_check_pen;
    uint8_t com_unarmed_dam_dice;
    uint8_t com_unarmed_dam_sides;
    uint8_t field_0A;  // Creature attack dice...
    uint8_t field_0B;
    uint8_t field_0C;
    uint8_t field_0D;
    uint8_t field_0E;
    uint8_t field_0F;
    uint8_t field_10;
    uint8_t field_11;
    uint8_t field_12;
    uint8_t OnHandCritRng;
    uint8_t OnHandCritMult;
    uint8_t field_15;
    uint8_t field_16;
    uint8_t field_17;
    uint32_t OffHandWeaponEq;
    uint8_t OffHandCritRng;
    uint8_t OffHandCritMult;
    uint8_t field_1E;
    uint8_t field_1F;
    ArrayList           ci_atk_mod_list; // CCombatInformationNode
    ArrayList           ci_dmg_mod_list; // CCombatInformationNode
    uint32_t                ci_right_equip;
    uint32_t                ci_left_equip;
    CExoString RightString;
    CExoString LeftString;
    uint8_t DamageDice;
    uint8_t DamageDie;
    uint8_t field_52;
    uint8_t field_53;
    uint8_t field_54;
} CCombatInformation;

typedef struct CNWSCombatAttackData {
    uint8_t  cad_attack_group;        /* 0000 */
    uint8_t  field_01;                /* 0001 */
    uint16_t cad_anim_length;         /* 0002 */
    uint32_t cad_target;              /* 0004 */
    uint16_t cad_react_delay;         /* 0008 */
    uint16_t cad_react_anim;          /* 000A */
    uint16_t cad_react_anim_len;      /* 000C */
    uint8_t  cad_attack_roll;         /* 000E */
    uint8_t  cad_threat_roll;         /* 000F */
    uint32_t cad_attack_mod;          /* 0010 */
    uint8_t  cad_missed;              /* 0014 */
    uint8_t  field_15;                /* 0015 */
    uint16_t cad_dmg_bludge;          /* 0016 */
    uint16_t cad_dmg_pierce;          /* 0018 */
    uint16_t cad_dmg_slash;           /* 001A */
    uint16_t cad_dmg_magical;         /* 001C */
    uint16_t cad_dmg_acid;            /* 001E */
    uint16_t cad_dmg_cold;            /* 0020 */
    uint16_t cad_dmg_divine;          /* 0022 */
    uint16_t cad_dmg_electrical;      /* 0024 */
    uint16_t cad_dmg_Fire;            /* 0026 */
    uint16_t cad_dmg_negative;        /* 0028 */
    uint16_t cad_dmg_positive;        /* 002A */
    uint16_t cad_dmg_sonic;           /* 002C */
    uint16_t cad_base_damage;         /* 002E */
    uint8_t cad_attack_type;          /* 0030 */
    uint8_t cad_attack_mode;          /* 0031 */
    uint8_t cad_concealment;          /* 0032 */
    uint8_t field_33;                 /* 0033 */
    uint32_t cad_ranged_attack;       /* 0034 */
    uint32_t cad_sneak_attack;        /* 0038 */
    uint32_t cad_death_attack;        /* 003C */
    uint32_t cad_killing_blow;        /* 0040 */
    uint32_t cad_coupdegrace;         /* 0044 */
    uint32_t cad_critical_hit;        /* 0048 */
    uint32_t cad_attack_deflected;    /* 004C */
    uint8_t cad_attack_result;        /* 0050 */
    uint8_t field_51;                 /* 0051 */
    uint16_t cad_special_attack;      /* 0052 */
    uint16_t field_54;                /* 0054 */
    uint16_t field_56;                /* 0056 */
    Vector cad_ranged_target_loc;
    uint32_t cad_ammo_id;             /* 0064 */
    CExoString cad_debug_attack;
    CExoString cad_debug_dmg;
    uint32_t field_78;
    uint32_t field_7C_a12;
    uint32_t field_80;
    uint32_t field_84;
    uint32_t field_88_a12;
    uint32_t field_8C;
    uint32_t field_90;
    uint32_t field_94_a12;
    uint32_t field_98;
    uint32_t field_9C;
    uint32_t field_A0_a12;
    uint32_t field_A4;
} CNWSCombatAttackData;

typedef struct CNWSCombatRound {
    CNWSCombatAttackData AttackData[50];              /* 0x0000 - 0x20CC*/
    uint16_t            *cr_special_attack;           /* 20D0 */
    uint32_t             cr_special_attack_len;       /* 20D0 */
    uint32_t             cr_special_attack_alloc;     /* 20D4 */
    uint16_t            *cr_special_attack_id;        /* 20D8 */
    uint32_t             cr_special_attack_id_len;    /* 20E0 */
    uint32_t             cr_special_attack_id_alloc;  /* 20E4 */
    int16_t AttackID[2];
    uint8_t RoundStarted;             /* 0x20EC */
    uint8_t field_30;
    uint8_t field_31;
    uint8_t field_32;
    uint8_t SpellCastRound;           /* 0x20f0 */
    uint8_t field_34;
    uint8_t field_35;
    uint8_t field_36;
    uint32_t Timer;
    uint32_t RoundLength;
    uint32_t OverlapAmount;
    uint32_t BleedTimer;               /* 0x2100 */
    uint8_t RoundPaused;
    uint8_t field_54;
    uint8_t field_55;
    uint8_t field_56;
    uint32_t RoundPausedBy;
    uint32_t PauseTimer;
    uint8_t InfinitePause;
    uint8_t field_66;
    uint8_t field_67;
    uint8_t field_68;
    uint8_t              cr_current_attack;             /* 0x2114 */
    uint8_t AttackGroup;
    uint8_t field_71;
    uint8_t field_72;
    uint8_t DeflectArrow;              /* 0x2118 */
    uint8_t field_74;
    uint8_t field_75;
    uint8_t field_76;
    uint8_t WeaponSucks;               /* 0x211c */
    uint8_t field_78;
    uint8_t field_79;
    uint8_t field_80;
    uint8_t EpicDodgeUsed;             /* 0x2120 */
    uint8_t field_82;
    uint8_t field_83;
    uint8_t field_84;
    uint32_t ParryIndex;               /* 0x2124 */
    uint32_t NumAOOs;                  /* 0x2128 */
    uint32_t NumCleaves;               /* 0x212C */
    uint32_t NumCircleKicks;           /* 0x2130 */
    uint32_t NewAttackTarget;
    uint32_t cr_onhand_atks;            /* 0x2138 */
    uint32_t cr_offhand_atks;           /* 0x213C */
    uint32_t cr_offhand_taken;          /* 0x2140 */
    uint32_t cr_extra_taken;               /* 0x2144 */
    uint32_t cr_additional_atks;       /* 0x2148 */
    uint32_t cr_effect_atks;         /* 0x214C */
    uint8_t ParryActions;              /* 0x2150 */
    uint8_t field_130;                 /* 0x2151 */
    uint8_t field_131;                 /* 0x2152 */
    uint8_t field_132;                 /* 0x2153 */
    uint32_t cr_dodge_target;              /* 0x2154 */ 
    uint32_t **SchedActionList;        /* 0x2158 */
    void    *org_nwcreature;      /* 0x215C */
} CNWSCombatRound;
]]