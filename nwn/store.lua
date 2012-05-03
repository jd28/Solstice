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

require 'nwn.ctypes.store'

local ffi = require 'ffi'

ffi.cdef[[
typedef struct Store {
    uint32_t        type;
    uint32_t        id;
    CNWSStore      *obj;
} Store;

]]

local store_mt = { __index = Store }
store_t = ffi.metatype("Store", store_mt)

--- Get store's gold
function Store:GetGold()
   return self.obj.st_gold
end

--- Get store's identify price
function Store:GetIdentifyCost()
   return self.obj.st_id_price
end

--- Get store's max buy price
function Store:GetMaxBuyPrice()
   return self.obj.st_max_buy
end

--- Open store
-- @param pc PC to open the store for.
-- @param up Bonus markup
-- @param down Bonus markdown
function Store:Open(pc, up, down)
   nwn.engine.StackPushInteger(down)
   nwn.engine.StackPushInteger(up)
   nwn.engine.StackPushObject(pc)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(378, 4)
end

--- Set amount of gold a store has.
function Store:SetGold(gold)
   self.obj.st_gold = gold
end

--- Set the price to identify items.
function Store:SetIdentifyCost(val)
   self.obj.st_id_price = val
end

--- Set the max buy price.
function Store:SetMaxBuyPrice(val)
   self.obj.st_max_buy = val
end