--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

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