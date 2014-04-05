local M = {}

local IP_HANDLERS = {}

function M.GetItempropInfo()
   local e = C.Local_GetLastNWNXEventItemprop()
   if e == nil then return end

   return { type = e.ip.ip_type,
            object = _SOL_GET_CACHED_OBJECT(e.obj.obj.obj_id),
            item = _SOL_GET_CACHED_OBJECT(e.item.obj.obj_id),
          }
end

--- Register NWNXEvent event handler.
-- @param ip_type
-- @param f A function
function M.RegisterItempropHandler(ip_type, f)
   IP_HANDLERS[ip_type] = f
end


-- Bridge function to hand NWNXEvent events
function NWNXEffects_HandleItemPropEvent(ip_type)
   -- If there isn't an event handler than return 0 so that some other plugin
   -- or script can handle the event.
   local f = IP_HANDLERS[ip_type]
   if not f then return 0 end

   local info = solstice.nwnx.GetItemproptInfo()
   if not info then return 0 end

   f(info)

   return 1
end

return M
