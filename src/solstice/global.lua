--- 
-- The solstice.global module injects some common functions and types
-- into the global namespace. It is automatically loaded so there
-- is no need to require in user scripts.
-- @module global

--- Inheritance function
-- @param baseClass Base class.
-- @string typename String identifying type.
function inheritsFrom( baseClass, typename )
   local new_class = {
      _type = typename
   }
   local class_mt = { __index = new_class }

   function new_class:new( obj_id, obj_pointer )
      local new_inst = { id = obj_id, pointer = obj_pointer }
      setmetatable( new_inst, class_mt)
      return new_inst
   end

   if baseClass then
      setmetatable( new_class, { __index = baseClass } )
   end

   return new_class
end

--- Checks if object is class instance.
-- @param inst Instance.
-- @param class Class type
function isinstance(inst, class)
   return inst._type and inst._type == class._type
end

--- Checks if object is an instance of a list of Classes.
-- @param inst Instance
-- @param ... List of class types.
function anyinstance(inst, ...)
   for _, C in ipairs(...) do
      if isinstance(inst, C) then
	 return true
      end
   end
   return false
end

--- Types
-- @section types

require 'solstice.ctypes'

local Obj       = require 'solstice.object'
local sol_aoe   = require 'solstice.aoe'
local sol_area  = require 'solstice.area'
local sol_cre   = require 'solstice.creature'
local sol_door  = require 'solstice.door'
local sol_eff   = require 'solstice.effect'
local sol_enc   = require 'solstice.encounter'
local sol_item  = require 'solstice.item'
local sol_ip    = require 'solstice.itemprop'
local sol_loc   = require 'solstice.location'
local sol_lock  = require 'solstice.lock'
local sol_mod   = require 'solstice.module'
local sol_plc   = require 'solstice.placeable'
local sol_snd   = require 'solstice.sound'
local sol_store = require 'solstice.store'
local sol_trap  = require 'solstice.trap'
local sol_trig  = require 'solstice.trigger'
local sol_way   = require 'solstice.waypoint'

--- Alias of solstice.aoe.AoE
AoE = assert(sol_aoe.AoE)
--- Alias of solstice.area.Area
Area = assert(sol_area.Area)
--- Alias of solstice.creature.Creature
Creature = assert(sol_cre.Creature)
--- Alias of solstice.door.Door
Door = assert(sol_door.Door)
--- Alias of solstice.effect.Effect
Effect = assert(sol_eff.Effect)
--- Alias of solstice.encounter.Encounter
Encounter = assert(sol_enc.Encounter)
--- Alias of solstice.item.Item
Item = assert(sol_item.Item)
--- Alias of solstice.itemprop.Itemprop
Itemprop = assert(sol_ip.Itemprop)
--- Alias of solstice.location.Location
Location = assert(sol_loc.Location)
--- Alias of solstice.lock.Lock
Lock = assert(sol_lock.Lock)
--- Alias of solstice.module.Module
Module = assert(sol_mod.Module)
--- Alias of solstice.object.Object
Object = assert(Obj.Object)
--- Alias of solstice.placeable.Placeable
Placeable = assert(sol_plc.Placeable)
--- Alias of solstice.sound.Sound
Sound = assert(sol_snd.Sound)
--- Alias of solstice.store.Store
Store = assert(sol_store.Store)
--- Alias of solstice.trap.Trap
Trap = assert(sol_trap.Trap)
--- Alias of solstice.trigger.Trigger
Trigger = assert(sol_trig.Trigger)
--- Alias of solstice.waypoint.Waypoint
Waypoint = assert(sol_way.Waypoint)

-- Private globals.
local ffi = require 'ffi'
local C = ffi.C

-- Object related functions
-- Functions/Tables that are mainly for internal bookkeeping use.
-- No script would even need use these.

-- Table to cache NWN objects in.  You should never need to modify
-- this directly.
local _OBJECTS = { }

-- Get cached Solstice object.
-- This should, generaly, be considered a private function and used
-- only when necessary.
function _SOL_GET_CACHED_OBJECT(id)
   if type(id) ~= "number" then
      print(debug.traceback())
      error "Expected Object Id"
   end

   if id == nil or id == -1 or id == 0x7F000000 then
      return Obj.INVALID
   end

   local cache = _OBJECTS[id]
   if cache then return cache end

   local obj = C.nwn_GetObjectByID(id)
   if obj == nil then
      return Obj.INVALID
   end

   local type = ffi.cast("CGameObject*", obj).type

   local object
   if type == Obj.internal.CREATURE then
      obj = ffi.cast("CNWSCreature*", obj)
      object = sol_cre.creature_t(type, id, obj, obj.cre_stats)
   elseif type == Obj.internal.MODULE then
      object = sol_mod.module_t(type, id, C.nwn_GetModule())
   elseif type == Obj.internal.AREA then 
      object = sol_area.area_t(type, id, C.nwn_GetAreaByID(id))
   elseif type == Obj.internal.ITEM then 
      object = sol_item.item_t(type, id, C.nwn_GetItemByID(id))
   elseif type == Obj.internal.TRIGGER then 
      obj = ffi.cast("CNWSTrigger*", obj)
      object = sol_trig.trigger_t(type, id, obj)
   elseif type == Obj.internal.PLACEABLE then 
      obj = ffi.cast("CNWSPlaceable*", obj)
      object = sol_plc.placeable_t(type, id, obj)
   elseif type == Obj.internal.DOOR then
      obj = ffi.cast("CNWSDoor*", obj)
      object = sol_door.door_t(type, id, obj)
   elseif type == Obj.internal.AREA_OF_EFFECT then 
      obj = ffi.cast("CNWSAreaOfEffectObject*", obj)
      object = sol_aoe.aoe_t(type, id, obj)
   elseif type == Obj.internal.WAYPOINT then 
      object = sol_way.waypoint_t(type, id, C.nwn_GetWaypointByID(id))
   elseif type == Obj.internal.ENCOUNTER then
      obj = ffi.cast("CNWSEncounter*", obj)
      object = sol_enc.encounter_t(type, id, obj)
   elseif type == Obj.internal.STORE then
      obj = ffi.cast("CNWSStore*", obj)
      object = sol_store.store_t(type, id, obj)
   end

   _OBJECTS[id] = object

   return _OBJECTS[id]
end

function _SOL_REMOVE_CACHED_OBJECT(id)
   _OBJECTS[id] = nil
   return 1
end

-- Entry point for nwnx_solstice run script hook.
-- Should never be used directly.
function _SOL_RUN_SCRIPT(script, obj)
   script = script:lower()
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
local _COMMANDS = { }

_COMMANDS.COMMAND_TYPE_DELAY      = 0
_COMMANDS.COMMAND_TYPE_DO         = 1
_COMMANDS.COMMAND_TYPE_REPEAT     = 2

-- Internal Function handling DoCommand 
local function _RUN_DO_COMMAND (token)
   if not token then return end
   if _COMMANDS[token] ~= nil then
      local f = _COMMANDS[token]["f"]
      f(_SOL_GET_CACHED_OBJECT(_COMMANDS[token].id))
   end
   _COMMANDS[token] = nil
end

-- Internal Function handling DelayCommand
local function _RUN_DELAY_COMMAND (token)
   if not token then return end
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
   local res = 0
   if ctype == _COMMANDS.COMMAND_TYPE_DELAY then
      _RUN_DELAY_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_DO then
      _RUN_DO_COMMAND(token)
   elseif ctype == _COMMANDS.COMMAND_TYPE_REPEAT then
      res = _RUN_REPEAT_COMMAND(token)
   end
   
   return res
end