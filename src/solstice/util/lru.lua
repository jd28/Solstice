-- Copyright (C) 2012 jmd ( jmd2028 at gmail dot com )

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
