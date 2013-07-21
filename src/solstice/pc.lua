--- Player Character
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module pc

local NWE = require 'solstice.nwn.engine'

local M = {}

--- Export all characters.
function M.ExportAllCharacters()
   NWE.ExecuteCommand(557, 0)
end

--- Export single character.
-- @param player Object to export.
function M.ExportSingleCharacter(player)
   NWE.StackPushObject(player)
   NWE.ExecuteCommand(719, 1)
end

--- Gets first PC
--     This function should probably be passed over in favor
--     of the M.PCs iterator.
-- @return solstice.object.INVALID if no PCs are logged into the server.
-- @see solstice.pc.PCs
function M.GetFirstPC()
   NWE.ExecuteCommand(548, 0)
   return NWE.StackPopObject()
end

--- Get next PC
-- @return solstice.object.INVALID if there are no furter PC
-- @see solstice.pc.PCs
function M.GetNext()
   NWE.ExecuteCommand(549, 0)
   return NWE.StackPopObject()
end

--- Gets the PC speaker.
function M.GetPCSpeaker()
   NWE.ExecuteCommand(238, 0)
   return NWE.StackPopObject()
end

--- Iterator over all PCs
function M.PCs() end
M.PCs = iter_first_next_isvalid(M.GetFirstPC, M.GetNextPC)

