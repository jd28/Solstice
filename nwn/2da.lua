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

-- TODO
-- Reading files, caching(?), etc, etc

-- The following code is based on the CSV reader in PiL
local function read2DAline (s)
    s = s .. ' '        -- ending whitespace
    local t = {}        -- table to collect fields
    local fieldstart = 1

    repeat
        -- next field is quoted? (start with `"'?)
        if string.find(s, '^"', fieldstart) then
            local a, c
            local i = fieldstart
            repeat
                -- find closing quote
                a, i, c = string.find(s, '"(.?)', i+1)
            until c ~= '"'    -- quote not followed by quote?
            if not i then error('unmatched "') end
            local f = string.sub(s, fieldstart+1, i-2)
            f = tonumber(f) or f
            table.insert(t, f)
            fieldstart = string.find(s, '[^%s]', i)
        else                -- unquoted; find next comma
            local nexti = string.find(s, '%s', fieldstart)
            local f = string.sub(s, fieldstart, nexti-1)
            f = tonumber(f) or f
            table.insert(t, f)
            fieldstart = string.find(s, '[^%s]', nexti)
        end
    until not fieldstart or fieldstart > string.len(s)
    return t
end

