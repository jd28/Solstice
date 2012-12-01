nwn.ITEM_EVENT_ACTIVATE     = 0
nwn.ITEM_EVENT_EQUIP        = 1
nwn.ITEM_EVENT_UNEQUIP      = 2
nwn.ITEM_EVENT_ONHITCAST    = 3
nwn.ITEM_EVENT_ACQUIRE      = 4
nwn.ITEM_EVENT_UNACQUIRE    = 5
nwn.ITEM_EVENT_SPELLCAST_AT = 6
nwn.ITEM_EVENT_ALL          = 7

nwn.EXECUTE_SCRIPT_CONTINUE = 0
nwn.EXECUTE_SCRIPT_END      = 1

function nwn.GetItemEventScriptName(item)
   local mod = nwn.GetModule()
   local prefix = mod:GetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX")

   if prefix == "" then
      return item:GetTag()
   end

   return prefix .. item:GetTag()
end

function nwn.SetItemEventScriptPrefix(prefix)
   prefix = prefix or ""

   if type(prefix) ~= "string" then
      error "Item event script prefix must be a string!"
   end

   local mod = nwn.GetModule()
   mod:GetLocalString("MODULE_VAR_TAGBASED_SCRIPT_PREFIX", prefix)
end

function nwn.GetItemEventType(obj)
   return obj:GetLocalInt("X2_L_LAST_ITEM_EVENT")
end

function nwn.SetItemEventType(obj, event)
   obj:SetLocalInt("X2_L_LAST_ITEM_EVENT", event)
end

function nwn.ExecuteItemEvent(obj, item, event)
   if NS_OPT_TAGBASED_SCRIPTS then
      nwn.SetItemEventNumber(obj, event)
      local script = nwn.GetItemEventScriptName(item)
      return nwn.ExecuteScriptAndReturnInt(script, object)
   end
end

function nwn.SetExecutedScriptReturnValue(object, value)
    value = value or nwn.EXECUTE_SCRIPT_CONTINUE
    object:SetLocalInt("X2_L_LAST_RETVAR", value)
end

function nwn.ExecuteScriptAndReturnInt(script, object)
   object:DeleteLocalInt("X2_L_LAST_RETVAR")
   nwn.ExecuteScript(script, object)
   
   local result = object:GetLocalInt("X2_L_LAST_RETVAR")
   return result
end