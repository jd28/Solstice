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

local list = {}

local list_mt = { __index = list }

function list.new(max)
	local xs = {}
	local l = { max = max, size = 0}
	setmetatable(l, list_mt)
	return l
end

function list:add(val)
	local node = { value = val }
	self:pushright(node)
	return node
end

function list:moveNodeToTail(node)
	-- the node actually is in the list.
	if node.next or node.prev then
		self:removeNode(node)
	end
	self:pushright(node)
end

function list:removeHead()
	local head = self.list
	if not head then return end
	self:removeNode(head)

	-- remove the dead heads links to the list
	head.next = nil
	head.prev = nil
end

function list:removeNode(node)
	if not node then return end

	self.size = self.size - 1
	local next = node.next
	if self.list == node then
		self.list = next
		return
	end
	local prev = node.prev
	if node == self.last then
		self.last = prev
	end
	if prev then
		prev.next = next
	end
	if next then
		next.prev = prev
	end
end

function list:iterateValues()
	local l, _l = self.list
	return function()
				while l do
					_l, l = l, l.next
					return _l.value
				end
			end
end

function list:printAll()
	for val in self:iterateValues() do
		print (val)
	end
end

function list:pushright(node)
	if not self.list then
		self.list = node
		self.last = node
	else
		local last = self.last
		last.next = node
		node.prev = last
		node.next = nil
		self.last = node
	end
	self.size = self.size + 1
	if self.max and self.size > self.max then
		self:removeHead()
	end
end

return list
