---
-- The solstice.global module injects some common functions and types
-- into the global namespace. It is automatically loaded so there
-- is no need to require in user scripts.
-- @module global

local tremove = table.remove
local tinsert = table.insert

--===================================================
--=  Niklas Frykholm
-- basically if user tries to create global variable
-- the system will not let them!!
-- call GLOBAL_lock(_G)
--
--===================================================

local function lock_new_index(t, k, v)
   if (k~="_" and string.sub(k,1,2) ~= "__") then
      --GLOBAL_unlock(_G)
      error("GLOBALS are locked -- " .. k ..
         " must be declared local or prefix with '__' for globals.", 2)
   else
      rawset(t, k, v)
   end
end

local function unlock_new_index(t, k, v)
  rawset(t, k, v)
end

--- Locks table from adding new global variables.
-- @param t Table.
function GLOBAL_lock(t)
   local mt = getmetatable(t) or {}
   mt.__newindex = lock_new_index
   setmetatable(t, mt)
end

--- Unlocks table from adding new global variables.
-- @param t Table.
function GLOBAL_unlock(t)
   local mt = getmetatable(t) or {}
   mt.__newindex = unlock_new_index
   setmetatable(t, mt)
end


--- Types
-- @section types

require 'solstice.ctypes'

-- Global modules
System   = require 'solstice.system'
Game     = require 'solstice.game'
Effect   = require 'solstice.effect'
ItemProp = require 'solstice.itemprop'
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

local sol_mod   = require 'solstice.module'
local sol_plc   = require 'solstice.placeable'
local sol_snd   = require 'solstice.sound'
local sol_store = require 'solstice.store'
local sol_sound = require 'solstice.sound'
local sol_trap  = require 'solstice.trap'
local sol_trig  = require 'solstice.trigger'
local sol_way   = require 'solstice.waypoint'

local Log = System.GetLogger()
_SOL_LOG_INTERNAL = System.FileLogger(OPT.LOG_DIR .. "/solstice_internal.txt", "[%Y-%m-%d %X]")


-- 'Private' globals.
local ffi = require 'ffi'
local C = ffi.C

-- Object related functions
-- Functions/Tables that are mainly for internal bookkeeping use.
-- No script would even need use these.

local _OBJECTS = {}
local _PCS = {}

function _GET_CANONICAL_ID(cre)
   local id = cre.id
   if cre:GetIsPC() and not cre.load_char_finished then
      local name = cre:GetPCPlayerName()
      if #name == 0 then
         name = cre:GetLocalString('pc_player_name')
      end
      name = name..cre:GetName()
      if not _PCS[name] then
         _PCS[name] = cre.id
      else
         id = _PCS[name]
      end
   end
   return id
end

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
      object = sol_sound.sound_t(type, id)
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
      object.id   = id
      object.obj  = C.nwn_GetCreatureByID(id)
      id = _GET_CANONICAL_ID(object)

      -- When the canonical and current id are the same we know a) the player just logged in
      -- or b) the character really has been reloaded after relogging.
      if object.id == id then
         object.load_char_finished = true
      end
      local ci = Game.GetProperty(id, "SOL_COMBAT_INFO")
      if not ci then
         ci = combat_info_t()
         Game.SetProperty(id, "SOL_COMBAT_INFO", ci)
      end
      object.ci = ci
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
   elseif type == OBJECT_TRUETYPE_SOUND then
      object.obj = ffi.cast("CNWSSoundObject*", obj)
   --[[
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
   local found, result = Game.RunScript(script, obj)
   if not found then return 0 end

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
      local f = _COMMANDS[token]["f"]
      f(_SOL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
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
   else
      error(string.format("ERROR: Invalid Command Type %d", ctype))
   end

   return res
end

-- Lock _G after all globals have been inserted.
GLOBAL_lock(_G)
