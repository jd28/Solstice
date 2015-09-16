local ffi = require 'ffi'

ffi.cdef [[
typedef void* HANDLE;
typedef int (*NWNXHOOK)(void *);
HANDLE HookEvent(const char *name, NWNXHOOK hookProc);
]]


local EVENT_CORE_PLUGINSLOADED = "Core/PluginsLoaded"

local EVENT_CORE_RUNSCRIPT = "Core/RunScript"
local EVENT_CORE_RUNSCRIPT_AFTER = "Core/RunScriptAfter"

ffi.cdef [[
struct CoreRunScriptEvent {
  const char* resref;
  const uint32_t objectId;
  const int recursionLevel;
  bool suppress;
  int returnValue;
};
]]

local EVENT_CORE_RUNSCRIPT_SITUATION = "Core/RunScriptSituation"
local EVENT_CORE_RUNSCRIPT_SITUATION_AFTER = "Core/RunScriptSituationAfter"

ffi.cdef [[
struct CoreRunScriptSituationEvent {
  char* marker;
  uint32_t token;
  uint32_t objectId;
  bool suppress;
};
]]

local EVENT_CORE_MAINLOOP_BEFORE = "Core/MainLoopBefore"
local EVENT_CORE_MAINLOOP_AFTER = "Core/MainLoopAfter"

local EVENT_CORE_OBJECT_CREATED = "Core/CNWSObject/Created"
ffi.cdef [[
struct ObjectCreatedEvent {
  const void *object;
  const uint32_t requestedId;
};
]]

local EVENT_CORE_OBJECT_DESTROYED = "Core/CNWSObject/Destroyed"
ffi.cdef [[
struct ObjectDestroyedEvent {
  const void *object;
};
]]

local function HookEvent(name, func)
  return ffi.C.HookEvent(name, func) ~= nil
end

local M = {}
M.HookEvent = HookEvent

M.EVENT_CORE_PLUGINSLOADED = EVENT_CORE_PLUGINSLOADED
M.EVENT_CORE_RUNSCRIPT = EVENT_CORE_RUNSCRIPT
M.EVENT_CORE_RUNSCRIPT_AFTER = EVENT_CORE_RUNSCRIPT_AFTER
M.EVENT_CORE_RUNSCRIPT_SITUATION = EVENT_CORE_RUNSCRIPT_SITUATION
M.EVENT_CORE_RUNSCRIPT_SITUATION_AFTER = EVENT_CORE_RUNSCRIPT_SITUATION_AFTER
M.EVENT_CORE_MAINLOOP_BEFORE = EVENT_CORE_MAINLOOP_BEFORE
M.EVENT_CORE_MAINLOOP_AFTER = EVENT_CORE_MAINLOOP_AFTER
M.EVENT_CORE_OBJECT_CREATED = EVENT_CORE_OBJECT_CREATED
M.EVENT_CORE_OBJECT_DESTROYED = EVENT_CORE_OBJECT_DESTROYED

return M