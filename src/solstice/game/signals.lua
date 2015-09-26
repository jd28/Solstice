local M = require 'solstice.game.init'
local Signal = require 'solstice.external.signal'

M.OnPreExportCharacter = Signal.signal()
M.OnPostExportCharacter = Signal.signal()
M.OnObjectClearCacheData = Signal.signal()
M.OnObjectRemovedFromCache = Signal.signal()
