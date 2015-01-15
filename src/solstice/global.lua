---
-- The solstice.global module injects some common functions and types
-- into the global namespace. It is automatically loaded so there
-- is no need to require in user scripts.
-- @module global

--- Inheritance function.
-- This VERY crude.  For some reason I'm not altogther sure why,
-- luajit trace will abort with a bad argument error if there are
-- nested metatables???  So this simply copies all function values.
-- Thus: It should be used before any other functions are added to
-- the class.
-- @param class New class type.
-- @param base Base class type.
function inheritsFrom( class, base )
   for k, v in pairs(base) do
      if type(v) == "function" then
         class[k] = v
      end
   end
   return class
end

local tremove = table.remove
local tinsert = table.insert

require 'solstice.util.fn'

--- Types
-- @section types

require 'solstice.ctypes'

-- Global modules
System   = require 'solstice.system'
Effect   = require 'solstice.effect'
ItemProp = require 'solstice.itemprop'
Game     = require 'solstice.game'
Rules    = require 'solstice.rules'

local Obj       = require 'solstice.object'
Rules.RegisterConstant("OBJECT_INVALID", Obj.INVALID)

local sol_aoe   = require 'solstice.aoe'
local sol_area  = require 'solstice.area'
local sol_cre   = require 'solstice.creature'
local sol_door  = require 'solstice.door'
local sol_enc   = require 'solstice.encounter'
local sol_item  = require 'solstice.item'

local sol_loc   = require 'solstice.location'
Rules.RegisterConstant("LOCATION_INVALID", sol_loc.INVALID)

local sol_lock  = require 'solstice.lock'
local sol_mod   = require 'solstice.module'
local sol_plc   = require 'solstice.placeable'
local sol_snd   = require 'solstice.sound'
local sol_store = require 'solstice.store'
local sol_trap  = require 'solstice.trap'
local sol_trig  = require 'solstice.trigger'
local sol_way   = require 'solstice.waypoint'

local Log = System.GetLogger()

-- 'Private' globals.
local ffi = require 'ffi'
local C = ffi.C

-- Object related functions
-- Functions/Tables that are mainly for internal bookkeeping use.
-- No script would even need use these.

local _OBJECTS = {}

-- Get cached Solstice object.
-- This should, generaly, be considered a private function and used
-- only when necessary.
function _SOL_GET_CACHED_OBJECT(id)
   if type(id) ~= "number" then
      print(debug.traceback())
      error "Expected Object Id"
   end

   if id == nil or id == -1 or id == 0x7F000000 then
      return OBJECT_INVALID
   end

   local obj = C.nwn_GetObjectByID(id)
   if obj == nil then
      _OBJECTS[id] = nil -- ensure this is out of the cache.
      return OBJECT_INVALID
   end

   local type = ffi.cast("CGameObject*", obj).type
   local object

   if _OBJECTS[id] then
      object = _OBJECTS[id]
   else
      if type == OBJECT_TRUETYPE_CREATURE then
         object = sol_cre.creature_t(type, id)
      elseif type == OBJECT_TRUETYPE_MODULE then
         object = sol_mod.module_t(type, id)
      elseif type == OBJECT_TRUETYPE_AREA then
         object = sol_area.area_t(type, id)
      elseif type == OBJECT_TRUETYPE_ITEM then
         object = sol_item.item_t(type, id)
      elseif type == OBJECT_TRUETYPE_TRIGGER then
         object = sol_trig.trigger_t(type, id)
      elseif type == OBJECT_TRUETYPE_PLACEABLE then
         object = sol_plc.placeable_t(type, id)
      elseif type == OBJECT_TRUETYPE_DOOR then
         object = sol_door.door_t(type, id)
      elseif type == OBJECT_TRUETYPE_AREA_OF_EFFECT then
         object = sol_aoe.aoe_t(type, id)
      elseif type == OBJECT_TRUETYPE_WAYPOINT then
         object = sol_way.waypoint_t(type, id)
      elseif type == OBJECT_TRUETYPE_ENCOUNTER then
         object = sol_enc.encounter_t(type, id)
      elseif type == OBJECT_TRUETYPE_STORE then
         object = sol_store.store_t(type, id)
      elseif type == OBJECT_TRUETYPE_SOUND then
         return OBJECT_INVALID
      elseif type == OBJECT_TRUETYPE_PORTAL then
         return OBJECT_INVALID
      elseif type == OBJECT_TRUETYPE_GUI then
         return OBJECT_INVALID
      elseif type == OBJECT_TRUETYPE_PROJECTILE then
         return OBJECT_INVALID
      elseif type == OBJECT_TRUETYPE_TILE then
         return OBJECT_INVALID
      else
         error(string.format("Unknown Object Type: %d \n\n %s!", type, debug.traceback()))
      end
      _OBJECTS[id] = object
   end

   -- Always refresh the cached objects NWN server object.
   if type == OBJECT_TRUETYPE_CREATURE then
      object.obj  = C.nwn_GetCreatureByID(id)
      object.ci   = C.Local_GetCombatInfo(id)
      assert(object.ci ~= nil, "CombatInfo cannot be nil...")
   elseif type == OBJECT_TRUETYPE_MODULE then
      object.obj = C.nwn_GetModule()
   elseif type == OBJECT_TRUETYPE_AREA then
      object.obj = C.nwn_GetAreaByID(id)
   elseif type == OBJECT_TRUETYPE_ITEM then
      object.obj = C.nwn_GetItemByID(id)
   elseif type == OBJECT_TRUETYPE_TRIGGER then
      object.obj = ffi.cast("CNWSTrigger*", obj)
   elseif type == OBJECT_TRUETYPE_PLACEABLE then
      object.obj = ffi.cast("CNWSPlaceable*", obj)
   elseif type == OBJECT_TRUETYPE_DOOR then
      object.obj = ffi.cast("CNWSDoor*", obj)
   elseif type == OBJECT_TRUETYPE_AREA_OF_EFFECT then
      object.obj = ffi.cast("CNWSAreaOfEffectObject*", obj)
   elseif type == OBJECT_TRUETYPE_WAYPOINT then
      object.obj = C.nwn_GetWaypointByID(id)
   elseif type == OBJECT_TRUETYPE_ENCOUNTER then
      object.obj = ffi.cast("CNWSEncounter*", obj)
   elseif type == OBJECT_TRUETYPE_STORE then
      object.obj = ffi.cast("CNWSStore*", obj)
   --[[
   elseif type == OBJECT_TRUETYPE_SOUND then
      object.obj =
   elseif type == OBJECT_TRUETYPE_PORTAL then
      object.obj =
   elseif type == OBJECT_TRUETYPE_GUI then
      object.obj =
   elseif type == OBJECT_TRUETYPE_PROJECTILE then
      object.obj =
   elseif type == OBJECT_TRUETYPE_TILE then
      object.obj =
   --]]
   else
      error(string.format("Unknown Object Type: %d \n\n %s!", type, debug.traceback()))
   end

   return object
end

function _SOL_REMOVE_CACHED_OBJECT(id)
   _OBJECTS[id] = nil
   return 1
end

-- Entry point for nwnx_solstice run script hook.
-- Should never be used directly.
function _SOL_RUN_SCRIPT(script, obj)
   -- See if the function exist in the global namespace
   local f = _G[script]
   if not f or not type(f) == "function" then
      return 0
   end

   local result = f(_SOL_GET_CACHED_OBJECT(obj))
   if result == nil then
      result = -1
   elseif result then
      result = 1
   else
      result = 0
   end

   return 1, result
end

-- Command related functions
-- Table holding stored commands.  See DoCommand, DelayCommand, etc.
_COMMANDS = { }

_COMMANDS.COMMAND_TYPE_DELAY      = 0
_COMMANDS.COMMAND_TYPE_DO         = 1
_COMMANDS.COMMAND_TYPE_REPEAT     = 2

-- Internal Function handling DoCommand
local function _RUN_DO_COMMAND (token)
   if _COMMANDS[token] ~= nil then
      local f = _COMMANDS[token]["f"]
      f(_SOL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
end

-- Internal Function handling DelayCommand
local function _RUN_DELAY_COMMAND (token)
   if _COMMANDS[token] ~= nil then
      print("Delay Token: " .. token)
      local f = _COMMANDS[token]["f"]
      f(_SOL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
end

-- Internal Function handling RepeatCommand
-- @return If nil the command ceases repeating, if true it will continue to repeat
local function _RUN_REPEAT_COMMAND(token)
   if token and _COMMANDS[token] ~= nil then
      local f = _COMMANDS[token]["f"]
      if f(_SOL_GET_CACHED_OBJECT(_COMMANDS[token].id)) then
         local newdelay = _COMMANDS[token]["d"] + _COMMANDS[token]["s"];
         -- Delay can never be a negative or equal to zero.
         if newdelay <= 0 then
            _COMMANDS[token] = nil
         else
            _COMMANDS[token]["d"] = newdelay
            print("Repeat Delay:", newdelay)
            return newdelay
         end
      else
         _COMMANDS[token] = nil
      end
      return 0
   end
end

-- Internal Function handling for running the various
-- command functions.  Entry point for nwnx_solstice
-- RunScriptSituation hook.
function _RUN_COMMAND(ctype, token, objid)
   assert(ctype)
   assert(token)
   assert(objid)

   local res = 0
   if ctype == _COMMANDS.COMMAND_TYPE_DELAY then
      _RUN_DELAY_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_DO then
      _RUN_DO_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_REPEAT then
      res = _RUN_REPEAT_COMMAND(token)
   else
      error(string.format("ERROR: Invalid Command Type %d", ctype))
   end

   return res
end
