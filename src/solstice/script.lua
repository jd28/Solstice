--- Script
-- @module script

local NWE = require 'solstice.nwn.engine'

local M = {}

M.CONTINUE = 0
M.END      = 1

--- Executes a script on a specified target
-- The following operates like the NWScript ExecuteScriptAndReturnInt
-- rather than ExecuteScript.
-- @param script Script to call.
-- @param target Object to run the script on.
function M.Execute(script, target)
   if target:GetIsValid() then
      target:DeleteLocalInt("X2_L_LAST_RETVAR")
   end

   NWE.StackPushObject(target)
   NWE.StackPushString(script)
   NWE.ExecuteCommand(8, 2)

   if target:GetIsValid() then
      return object:GetLocalInt("X2_L_LAST_RETVAR")
   end
end

--- Gets the item event script name.
-- The following function is compatible with NWN tag based
-- scripting.
-- @param item Item that caused the event.
function solstice.nwn.GetItemEventName(item)
   local mod = Mod.Get()
   local prefix = mod:GetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX")

   if prefix == "" then
      return item:GetTag()
   end

   return prefix .. item:GetTag()
end

--- Set item event prefix.
-- The following function is compatible with NWN tag based
-- scripting.
function solstice.nwn.SetItemEventPrefix(prefix)
   prefix = prefix or ""

   if type(prefix) ~= "string" then
      error "Item event script prefix must be a string!"
   end

   local mod = Mod.Get()
   mod:SetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX", prefix)
end

--- Set script return value.
-- @param object 
-- @int[opt=solstice.script.CONTINUE] value Return value.
function M.SetReturnValue(object, value)
    value = value or M.CONTINUE
    object:SetLocalInt("X2_L_LAST_RETVAR", value)
end

return M

--[[
solstice.nwn.ITEM_EVENT_ACTIVATE     = 0
solstice.nwn.ITEM_EVENT_EQUIP        = 1
solstice.nwn.ITEM_EVENT_UNEQUIP      = 2
solstice.nwn.ITEM_EVENT_ONHITCAST    = 3
solstice.nwn.ITEM_EVENT_ACQUIRE      = 4
solstice.nwn.ITEM_EVENT_UNACQUIRE    = 5
solstice.nwn.ITEM_EVENT_SPELLCAST_AT = 6
solstice.nwn.ITEM_EVENT_ALL          = 7

function solstice.nwn.GetItemEventType(obj)
   return obj:GetLocalInt("X2_L_LAST_ITEM_EVENT")
end

function solstice.nwn.SetItemEventType(obj, event)
   obj:SetLocalInt("X2_L_LAST_ITEM_EVENT", event)
end

function solstice.nwn.ExecuteItemEvent(obj, item, event)
   if NS_OPT_TAGBASED_SCRIPTS then
      solstice.nwn.SetItemEventNumber(obj, event)
      local script = solstice.nwn.GetItemEventScriptName(item)
      return solstice.nwn.ExecuteScriptAndReturnInt(script, object)
   end
end

--]]