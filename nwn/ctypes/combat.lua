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
    uint8_t NumAttacks;
    uint8_t OnHandAttackMod;
    uint8_t OnHandDamageMod;
    uint8_t OffHandAttackMod;
    uint8_t OffHandDamageMod;
    uint8_t SpellResistance;
    uint8_t ArcaneSpellFail;
    uint8_t ArmorCheckPen;
    uint8_t UnarmedDamDice;
    uint8_t UnarmedDamDie;
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
    uint8_t cad_attack_group;         /* 0000 */
    uint8_t field_01;                 /* 0001 */
    uint16_t AnimationLength;         /* 0002 */
    uint32_t cad_target;              /* 0004 */
    uint16_t ReaxnDelay;              /* 0008 */
    uint16_t ReaxnAnimation;          /* 000A */
    uint16_t ReaxnAnimLength;         /* 000C */
    uint8_t ToHitRoll;                /* 000E */
    uint8_t ThreatRoll;               /* 000F */
    uint32_t ToHitMod;                /* 0010 */
    uint8_t MissedBy;                 /* 0014 */
    uint8_t field_15;                 /* 0015 */
    uint16_t Damage_Bludgeoning;      /* 0016 */
    uint16_t Damage_Piercing;         /* 0018 */
    uint16_t Damage_Slashing;         /* 001A */
    uint16_t Damage_Magical;          /* 001C */
    uint16_t Damage_Acid;             /* 001E */
    uint16_t Damage_cold;             /* 0020 */
    uint16_t Damage_Divine;           /* 0022 */
    uint16_t Damage_Electrical;       /* 0024 */
    uint16_t Damage_Fire;             /* 0026 */
    uint16_t Damage_Negative;         /* 0028 */
    uint16_t Damage_Positive;         /* 002A */
    uint16_t Damage_Sonic;            /* 002C */
    uint16_t BaseDamage;              /* 002E */
    uint8_t cad_weapon_type;          /* 0030 */
    uint8_t cad_attack_mode;          /* 0031 */
    uint8_t Concealment;              /* 0032 */
    uint8_t field_33;                 /* 0033 */
    uint32_t RangedAttack;            /* 0034 */
    uint32_t SneakAttack;             /* 0038 */
    uint32_t field_3C;                /* 003C */
    uint32_t KillingBlow;             /* 0040 */
    uint32_t cad_coupdegrace;         /* 0044 */
    uint32_t CriticalThreat;          /* 0048 */
    uint32_t AttackDeflected;         /* 004C */
    uint8_t cad_attack_result;        /* 0050 */
    uint8_t field_51;                 /* 0051 */
    uint16_t cad_attack_type;         /* 0052 */
    uint16_t field_54;                /* 0054 */
    uint16_t field_56;                /* 0056 */
    float RangedTargetX;              /* 0058 */
    float RangedTargetY;              /* 005C */
    float RangedTargetZ;              /* 0060 */
    uint32_t AmmoItem;                /* 0064 */
    CExoString AttackDebugText;
    CExoString DamageDebugText;
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
    CNWSCombatAttackData AttackData[50]; /* 0x0000 - 0x20CC*/
    uint16_t *SpecialAttack;
    int32_t SpecAttackList;
    uint8_t field_9;
    uint8_t field_10;
    uint8_t field_11;
    uint8_t field_12;
    uint16_t *SpecialAttackId;
    int32_t SpecAttackIdList;
    uint8_t field_21;
    uint8_t field_22;
    uint8_t field_23;
    uint8_t field_24;
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
    uint8_t cr_current_attack;             /* 0x2114 */
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
    uint32_t OnHandAttacks;            /* 0x2138 */
    uint32_t OffHandAttacks;           /* 0x213C */
    uint32_t OffHandTaken;             /* 0x2140 */
    uint32_t ExtraTaken;               /* 0x2144 */
    uint32_t AdditAttacks;             /* 0x2148 */
    uint32_t EffectAttacks;            /* 0x214C */
    uint8_t ParryActions;              /* 0x2150 */
    uint8_t field_130;                 /* 0x2151 */
    uint8_t field_131;                 /* 0x2152 */
    uint8_t field_132;                 /* 0x2153 */
    uint32_t DodgeTarget;              /* 0x2154 */ 
    uint32_t **SchedActionList;        /* 0x2158 */
    void    *org_nwcreature;      /* 0x215C */
} CNWSCombatRound;
]]