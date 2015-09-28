--- Game
-- @module game

--- Scripts
-- @section scripts

local NWE = require 'solstice.nwn.engine'
local Log = System.GetLogger()
local M = require 'solstice.game.init'

local __SCRIPT_ENV = {}
setmetatable(__SCRIPT_ENV, {__index = _G})

local function LoadScript(fname)
   local f = loadfile(fname)
   if not f then
      Log:error("Unable to load file: %s", fname)
   end
   setfenv(f, __SCRIPT_ENV)
   local result, err = pcall(f)
   if not result then
      Log:error("Unable to load file: %s.  Error: %s", fname, err)
   end
end

local function RegisterScript(name, func)
   if #name > 16 then
      error("Script name is too long!", 2)
   end
   __SCRIPT_ENV[name] = func
end

local function RunScript(script, target)
   if not __SCRIPT_ENV[script] then return end
   if type(target) == "number" then
      target = M.GetObjectByID(target)
   end
   _SOL_LOG_INTERNAL:debug("Running Script: '%s' on 0x%x", script, target.id)
   return true, __SCRIPT_ENV[script](target)
end

local function LockScriptEnvironment()
   GLOBAL_lock(__SCRIPT_ENV)
end

local function UnlockScriptEnvironment()
   GLOBAL_unlock(__SCRIPT_ENV)
end

local function ExecuteScript(script, target)
   if target:GetIsValid() then
      target:DeleteLocalInt("X2_L_LAST_RETVAR")
   end

   if not RunScript(script, target) then
      NWE.StackPushObject(target)
      NWE.StackPushString(script)
      NWE.ExecuteCommand(8, 2)
   end

   if target:GetIsValid() then
      return target:GetLocalInt("X2_L_LAST_RETVAR")
   end
end

local function GetItemEventName(item)
   local mod = Game.GetModule()
   local prefix = mod:GetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX")

   if #prefix == 0 then
      return item:GetTag()
   end

   return prefix .. item:GetTag()
end

local function SetItemEventPrefix(prefix)
   prefix = prefix or ""

   if type(prefix) ~= "string" then
      error "Item event script prefix must be a string!"
   end

   local mod = Game.GetModule()
   mod:SetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX", prefix)
end

local function SetScriptReturnValue(object, value)
   value = value or SCRIPT_RETURN_CONTINUE
   object:SetLocalInt("X2_L_LAST_RETVAR", value)
end

local function GetItemEventType(obj)
   return obj:GetLocalInt("X2_L_LAST_ITEM_EVENT")
end

local function SetItemEventType(obj, event)
   obj:SetLocalInt("X2_L_LAST_ITEM_EVENT", event)
end

local function ExecuteItemEvent(obj, item, event)
   if Game.GetModule():GetLocalBool("X2_SWITCH_ENABLE_TAGBASED_SCRIPTS") then
      SetItemEventNumber(obj, event)
      return ExecuteScript(GetItemEventScriptName(item), object)
   end
end

local inspect = require('solstice.external.inspect')
local function DumpScriptEnvironment()
   return inspect(__SCRIPT_ENV)
end

M.ExecuteScript           = ExecuteScript
M.GetItemEventName        = GetItemEventName
M.SetItemEventPrefix      = SetItemEventPrefix
M.SetScriptReturnValue    = SetScriptReturnValue
M.GetItemEventType        = GetItemEventType
M.LoadScript              = LoadScript
M.RegisterScript          = RegisterScript
M.SetItemEventType        = SetItemEventType
M.ExecuteItemEvent        = ExecuteItemEvent
M.RunScript               = RunScript
M.LockScriptEnvironment   = LockScriptEnvironment
M.UnlockScriptEnvironment = UnlockScriptEnvironment
M.DumpScriptEnvironment   = DumpScriptEnvironment
