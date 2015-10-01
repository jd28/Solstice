local _PLUGINS = {}
local _ACTIVE_PLUGINS = {}

local function RegisterPlugin(name, enforcer)
  _PLUGINS[name] = enforcer or true
end

local function LoadPlugin(name, interface)
  local e = _PLUGINS[name]
  if not e then
    error(string.format("Plugin '%s' has not been registered!", name), 2)
  elseif type(e) == "function" and not e(interface) then
    error(string.format("Plugin does not satisfy the interface for '%s'!", name), 2)
  else
    _ACTIVE_PLUGINS[name] = interface
    if interface.OnLoad then
      interface.OnLoad(interface)
    end
  end
end

local function GetPlugin(name)
  local p = _ACTIVE_PLUGINS[name]
  if not p then
    error(string.format("No active plugin for '%s'!", name), 2)
  end
  return p
end

local function UnloadPlugin(name)
  local p = _ACTIVE_PLUGINS[name]
  if not p then
    error(string.format("No active plugin for '%s'!", name), 2)
  end
  if p.OnUnload then
    p.OnUnload(p)
  end
  _ACTIVE_PLUGINS[name] = nil
end

local function IsPluginLoaded(name)
  local p = _ACTIVE_PLUGINS[name]
  return not not p
end

local PLUGIN_COMBAT_ENGINE = "_SOL_PLUGIN_COMBAT_ENGINE"

RegisterPlugin(
  PLUGIN_COMBAT_ENGINE,
  function(interface)
    if not interface.DoRangedAttack then
      return false
    elseif not interface.DoMeleeAttack then
      return false
    elseif not interface.DoPreAttack then
      return false
    end
    return true
  end)

local M = require 'solstice.game.init'
M.RegisterPlugin = RegisterPlugin
M.LoadPlugin = LoadPlugin
M.GetPlugin = GetPlugin
M.UnloadPlugin = UnloadPlugin
M.IsPluginLoaded = IsPluginLoaded

M.PLUGIN_COMBAT_ENGINE = PLUGIN_COMBAT_ENGINE
