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

ffi.cdef [[
typedef struct CNWSAreaOfEffectObject { 
    CNWSObject          obj;                 /* 0000-01C0 */
    uint32_t            field_01C0;          /* 01C0 */
    uint32_t            field_01C4;          /* 01C4 */
    uint32_t            aoe_effect_id;       /* 01C8 */
    uint8_t             aoe_shape;           /* 01CC */
    uint8_t             field_01CD;          /* 01CD */
    uint8_t             field_01CE;          /* 01CE */
    uint8_t             field_01CF;          /* 01CF */
    uint32_t            aoe_spell_id;        /* 01D0 */
    float               aoe_radius;          /* 01D4 */
    float               aoe_length;          /* 01D8 */
    float               aoe_width;           /* 01DC */
    uint32_t            field_01E0;          /* 01E0 */
    nwn_objid_t         aoe_creator;         /* 01E4 */
    nwn_objid_t         aoe_linked_obj;      /* 01E8 */
    nwn_objid_t         aoe_last_entered;    /* 01EC */
    nwn_objid_t         aoe_last_exit;       /* 01F0 */
    uint32_t            aoe_spell_dc;        /* 01F4 */
    uint32_t            aoe_spell_level;     /* 01F8 */
    CExoString          aoe_heartbeat;       /* 01FC */
    CExoString          aoe_user_defined;    /* 0204 */
    CExoString          aoe_enter;           /* 020C */
    CExoString          aoe_exit;            /* 0214 */
    uint32_t            field_0218;          /* 0218 */
    uint32_t            aoe_last_hb_day;     /* 021C */
    uint32_t            aoe_last_hb_time;    /* 0220 */
    uint32_t            aoe_duration;        /* 0224 */
    uint8_t             aoe_duration_tyoe;   /* 0228 */
    uint8_t             field_0229;          /* 0229 */
    uint8_t             field_022A;          /* 022A */
    uint8_t             field_022B;          /* 022B */
} CNWSAreaOfEffectObject;
]]