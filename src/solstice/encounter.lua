--- Encounters
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module encounter

local ffi = require 'ffi'
local Obj = require 'solstice.object'

local M = {
   -- These represent the row in the difficulty 2da, rather than
   -- a difficulty value.
   DIFFICULTY_VERY_EASY  = 0,
   DIFFICULTY_EASY       = 1,
   DIFFICULTY_NORMAL     = 2,
   DIFFICULTY_HARD       = 3,
   DIFFICULTY_IMPOSSIBLE = 4,

}

M.Encounter = inheritsFrom(Obj.Object, 'solstice.encounter.Encounter')

--- Internal ctype.
M.encounter_t = ffi.metatype("Encounter", { __index = M.Encounter })

--- Class Encounter
-- @section encounter

--- Gets whether an encounter has spawned as is active.
function M.Encounter:GetActive()
   if self:GetIsValid() then return false end
   return self.obj.enc_is_active == 1
end

--- Get the difficulty level of the encounter.
-- @return solstice.encounter.DIFFICULTY_*
function M.Encounter:GetDifficulty()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_difficulty
end

--- Get number of creatures spawned
function M.Encounter:GetNumberSpawned()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_number_spawned
end

--- Get the number of times that the encounter has spawned so far.
function M.Encounter:GetSpawnsCurrent()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_spawns_current
end

--- Get the maximum number of times that oEncounter will spawn.
function M.Encounter:GetSpawnsMax()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawns_max
end

--- Gets the number of spawn points
function M.Encounter:GetSpawnPointCount()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawn_points_len
end

--- Gets a spawn point location.
-- @param idx Index in the spawn poing list.
-- @return solstice.location.Location instance
function M.Encounter:GetSpawnPointByIndex(idx)
   if not self:GetIsValid() then return end
   if idx < 0 or idx >= self.obj.enc_spawn_points_len then return end
   local sp = self.obj.enc_spawn_points[idx]
   
   if sp.position.z < 0 then sp.position.z = 0 end

   return solstice.nwn.Location(sp.position, sp.orientation, self:GetArea())
end

--- Sets an encounter to active or inactive.
-- @bool value new value
function M.Encounter:SetActive(value)
   if not self:GetIsValid() then return end
   self.obj.enc_is_active = value
end

--- Sets the difficulty level of an encounter.
-- @param value solstice.encounter.DIFFICULTY_*
function M.Encounter:SetDifficulty(value)
   if not self:GetIsValid() then return end
   self.obj.enc_difficulty = value
end

--- Sets the maximum number of times that an encounter can spawn.
-- @param value The new maximum spawn value.
function M.Encounter:SetSpawnsMax(value)
   if not self:GetIsValid() then return end
   self.obj.enc_spawns_max = value
end

--- Sets the number of times that an encounter has spawned.
-- @param value The new number of times the encounter has spawned.
function M.Encounter:SetSpawnsCurrent(value)
   if not self:GetIsValid() then return end
   self.obj.enc_spawns_current = value
end

return M