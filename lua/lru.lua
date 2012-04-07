--[[
    ------------------------------------------------------------------------
    Copyright (C) 2012 jmd ( jmd2028 at gmail dot com )

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    -------------------------------------------------------------------------
--]]

local list = require 'list'
local lru = {}
local lru_mt = { __index = lru }

function lru.new(max)
   local t = { table = {}, list = list.new(max) }
   setmetatable(t.table, { __mode = 'v' })
   setmetatable(t, lru_mt)
   return t
end

function lru:get(key)
   local val = self.table[key]
   if not val then return end

   local l = self.list
   l:moveNodeToTail(val)

   return val.value
end

function lru:insert(key, value)
   local l = self.list
   local n = l:add(value)
   self.table[key] = n
   return n
end

return lru
