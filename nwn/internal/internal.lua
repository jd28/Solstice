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

-- TODO object casting.

require 'nwn.internal.commands'
require 'nwn.internal.damage'
require 'nwn.internal.inventory'
require 'nwn.internal.specattack'

--- Functions/Tables that are mainly for internal bookkeeping use.
-- No script would even need use these.
local ffi = require ("ffi")
local C = ffi.C

local nl_internal = {}

--- Table to cache NWN objects in.  You should never need to modify
-- this directly.
_OBJECTS = { }

nl_internal.NL_CACHE = true

function _NL_GET_CACHED_OBJECT(id)
   if type(id) ~= "number" then
      print(debug.traceback())
      error "Expected Object Id"
   end

   if id == nil or id == -1 or id == 0x7F000000 then
      return nwn.OBJECT_INVALID
   end

   local cache = _OBJECTS[id]
   if cache then return cache end

   local obj = C.nwn_GetObjectByID(id)
   if obj == nil then
      return nwn.OBJECT_INVALID
   end

   local type = ffi.cast("CGameObject*", obj).type
   --print (obj, type, id)

   local object
   if type == nwn.GAME_OBJECT_TYPE_CREATURE then
      obj = ffi.cast("CNWSCreature*", obj)
      object = creature_t(type, id, obj, obj.cre_stats)
   elseif type == nwn.GAME_OBJECT_TYPE_MODULE then
      object = module_t(type, id, C.nwn_GetModule())
   elseif type == nwn.GAME_OBJECT_TYPE_AREA then 
      object = area_t(type, id, C.nwn_GetAreaById(id))
   elseif type == nwn.GAME_OBJECT_TYPE_ITEM then 
      object = item_t(type, id, C.nwn_GetItemById(id))
   elseif type == nwn.GAME_OBJECT_TYPE_TRIGGER then 
      obj = ffi.cast("CNWSTrigger*", obj)
      object = trigger_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_PLACEABLE then 
      object = placeable_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_DOOR then 
      object = door_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_AREA_OF_EFFECT then 
      object = aoe_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_WAYPOINT then 
      object = waypoint_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_ENCOUNTER then 
      object = encounter_t(type, id, obj)
   elseif type == nwn.GAME_OBJECT_TYPE_STORE then 
      object = store_t(type, id, obj)
   end

   if not nl_internal.NL_CACHE then 
      return object
   end

   _OBJECTS[id] = object

   return _OBJECTS[id]
end

function _NL_REMOVE_CACHED_OBJECT(id)
   --print ("Removing:", _OBJECTS[id], id)
   _OBJECTS[id] = nil
   return 1
end

function _NL_RUN_SCRIPT(script, obj)
   -- See if the function exist in the global namespace
   local f = _G[script]
   if not f or not type(f) == "function" then
      return 0
   end

   local result = f(_NL_GET_CACHED_OBJECT(obj))
   if result == nil then
      result = -1
   elseif result then
      result = 1
   else
      result = 0
   end

   return 1, result
end

function nl_internal.CheckGameObjectType(obj, ...)
   if not arg then
      error "No GAME_OBJECT_TYPE_* specified"
      return false
   end
   for _, typ in ipairs(arg) do
      if obj.type == typ then
         return true
      end
   end
   return false
end


return nl_internal