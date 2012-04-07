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
typedef struct CNWSPlayer {
    /* CNWSClient */
    uint32_t                    pl_id;				/* 0x0000 */
    uint32_t			cl_lang;			/* 0x0004 */
    uint32_t			vftable;			/* 0x0008 */
    /* end CNWSClient */

    uint32_t			field_0C;			/* 0x000C */
    uint32_t			field_10;			/* 0x0010 */
    uint32_t			field_14;			/* 0x0014 */
    uint32_t			field_18;			/* 0x0018 */
    uint32_t			field_1C;			/* 0x001C */
    uint32_t			field_20;			/* 0x0020 */
    uint32_t			field_24;			/* 0x0024 */
    uint32_t			field_28;			/* 0x0028 */
    uint32_t			field_2C;			/* 0x002C */
    uint32_t			obj_id;				/* 0x0030 */
    
    uint8_t			spacer1[65];                    /* 0x0034 */
    char                        pl_bicfile[19];                 /* 0x0075 */ 
} CNWSPlayer;
]]