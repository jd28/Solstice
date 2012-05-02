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
typedef struct CNWFeat {
    uint32_t                    field_0000;                     /* 00 */
    uint32_t                    field_0004;                     /* 04 */
    uint32_t                    field_0008;                     /* 08 */
    uint32_t                    field_000C;                     /* 0C */
    uint32_t                    field_0010;                     /* 10 */
    uint32_t                    field_0014;                     /* 14 */
    uint32_t                    field_0018;                     /* 18 */
    uint32_t                    field_001C;                     /* 1C */
    uint32_t                    field_0020;                     /* 20 */
    uint32_t                    field_0024;                     /* 24 */
    uint32_t                    field_0028;                     /* 28 */
    uint32_t                    field_002C;                     /* 2C */
    uint32_t                    field_0030;                     /* 30 */
    uint32_t                    field_0034;                     /* 34 */
    uint32_t                    field_0038;                     /* 38 */
    uint32_t                    field_003C;                     /* 3C */
    uint32_t                    field_0040;                     /* 40 */
    uint32_t                    field_0044;                     /* 44 */
    uint32_t                    field_0048;                     /* 48 */
    uint32_t                    field_004C;                     /* 4C */
    uint32_t                    field_0050;                     /* 50 */
    uint32_t                    field_0054;                     /* 54 */
    uint32_t                    field_0058;                     /* 58 */
    uint16_t                    feat_spell_id;                  /* 5C */
    uint16_t                    field_005E;                     /* 5E */
    uint8_t                     feat_uses;                      /* 60 */
    uint8_t                     field_0061;                     /* 61 */
    uint8_t                     field_0062;                     /* 62 */
    uint8_t                     field_0063;                     /* 63 */
    uint32_t                    field_0064;                     /* 64 */
    uint32_t                    field_0068;                     /* 68 */
    uint32_t                    field_006C;                     /* 6C */
    uint32_t                    field_0070;                     /* 70 */
} CNWFeat;
]]