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

---
function Store:GetGold()
   return self.obj.st_gold
end

---
function Store:GetIdentifyCost()
   return self.obj.st_id_price
end

---
function Store:GetMaxBuyPrice()
   return self.obj.st_max_buy
end

---
function Store:Open(oPC, nBonusMarkUp, nBonusMarkDown)
   nwn.engine.StackPushInteger(nBonusMarkDown)
   nwn.engine.StackPushInteger(nBonusMarkUp)
   nwn.engine.StackPushObject(oPC)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(378, 4)
end

---
function Store:SetGold(gold)
   self.obj.st_gold = gold
end

---
function Store:SetIdentifyCost(val)
   self.obj.st_id_price = val
end

---
function Store:SetMaxBuyPrice(val)
   self.obj.st_max_buy = val
end