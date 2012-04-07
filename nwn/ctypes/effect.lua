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
typedef struct CGameEffect {
    uint32_t            eff_id;                 /* 00 */

    uint32_t            field_04;               /* 04 */

    uint16_t            eff_type;               /* 08 */
    uint16_t            eff_dursubtype;         /* 0A */

    float               eff_duration;           /* 0C */

    uint32_t            eff_expire_day;         /* 10 */
    uint32_t            eff_expire_time;        /* 14 */

    uint32_t            eff_creator;            /* 18 */
    int32_t             eff_spellid;            /* 1C */

    uint32_t            eff_is_exposed;         /* 20 */
    uint32_t            eff_is_iconshown;       /* 24 */

    uint32_t            field_28;               /* 28 */

    uint32_t            eff_link_id1;           /* 2C */
    uint32_t            eff_link_id2;           /* 30 */

    uint32_t            eff_num_integers;       /* 34 */
    int32_t            *eff_integers;           /* 38 */

    float               eff_floats[4];          /* 3C */
    CExoString          eff_strings[6];         /* 40 */
    uint32_t            eff_objects[4];         /* 44 */

    uint32_t            eff_skiponload;         /* 48 */
    uint32_t            field_4C;               /* 4C */	
    uint32_t            field_50;               /* 50 */
    uint32_t            field_54;               /* 54 */
    uint32_t            field_58;               /* 58 */
    uint32_t            field_5C;               /* 5C */
    uint32_t            field_60;               /* 60 */
    uint32_t            field_64;               /* 64 */
    uint32_t            field_68;               /* 68 */
    uint32_t            field_6C;               /* 6C */
    uint32_t            field_70;               /* 70 */
    uint32_t            field_74;               /* 74 */
    uint32_t            field_78;               /* 78 */
    uint32_t            field_7C;               /* 7C */
    uint32_t            field_80;               /* 80 */
    uint32_t            field_84;               /* 84 */
    uint32_t            field_88;               /* 88 */
    uint32_t            field_8C;               /* 8C */
    uint32_t            field_90;               /* 90 */

} CGameEffect;
]]