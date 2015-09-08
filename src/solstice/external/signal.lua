-- Code from http://lua-users.org/wiki/AlternativeObserverPattern

-- Register
local function register(self, observer, method)
  local t = {}
  t.o = observer
  t.m = method
  table.insert(self, t)
end

-- Deregister
local function deregister(self, observer, method)
  local i
  local n = #self
  for i = n, 1, -1 do
    if (not observer or self[i].o == observer) and
       (not method   or self[i].m == method)
    then
      table.remove( self, i )
    end
  end
end

-- Notify
local function notify(self, ...)
  local res = true
  for i=1, #self do
    if self[i].o then
      res = res and self[i].m(self[i].o, ...)
    else
      -- If there is no observer, just pass the parameters.
      res = res and self[i].m(...)
    end
  end
  return res
end

-- signal metatable
local mt = {
  __call = function(self, ...)
    self:notify(...)
  end
}

local function signal()
  local t = {}
  t.register = register
  t.deregister = deregister
  t.notify = notify
  setmetatable( t, mt )
  return t
end

local M = {}
M.signal = signal
return M