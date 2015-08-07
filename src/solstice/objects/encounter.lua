--- Encounters
-- @module encounter

local ffi = require 'ffi'
local Loc = require 'solstice.location'

local M = require 'solstice.objects.init'

local Encounter = inheritsFrom({}, M.Object)
M.Encounter = Encounter

-- Internal ctype.
M.encounter_t = ffi.metatype("Encounter", { __index = Encounter })

--- Class Encounter
-- @section encounter

--- Gets whether an encounter has spawned as is active.
function Encounter:GetActive()
   if self:GetIsValid() then return false end
   return self.obj.enc_is_active == 1
end

--- Get the difficulty level of the encounter.
-- @return ENCOUNTER_DIFFICULTY_*
function Encounter:GetDifficulty()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_difficulty
end

--- Get number of creatures spawned
function Encounter:GetNumberSpawned()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_number_spawned
end

--- Get the number of times that the encounter has spawned so far.
function Encounter:GetSpawnsCurrent()
   if self:GetIsValid() then return -1 end
   return self.obj.enc_spawns_current
end

--- Get the maximum number of times that an encounter will spawn.
function Encounter:GetSpawnsMax()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawns_max
end

--- Gets the number of spawn points
function Encounter:GetSpawnPointCount()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawn_points_len
end

--- Gets a spawn point location.
-- @param idx Index in the spawn poing list.
-- @return Location instance
function Encounter:GetSpawnPointByIndex(idx)
   if not self:GetIsValid() then return end
   if idx < 0 or idx >= self.obj.enc_spawn_points_len then return end
   local sp = self.obj.enc_spawn_points[idx]

   if sp.position.z < 0 then sp.position.z = 0 end

   return Loc.Create(sp.position, sp.orientation, self:GetArea())
end

--- Sets an encounter to active or inactive.
-- @bool value new value
function Encounter:SetActive(value)
   if not self:GetIsValid() then return end
   self.obj.enc_is_active = value
end

--- Sets the difficulty level of an encounter.
-- @param value ENCOUNTER_DIFFICULTY_*
function Encounter:SetDifficulty(value)
   if not self:GetIsValid() then return end
   self.obj.enc_difficulty = value
end

--- Sets the maximum number of times that an encounter can spawn.
-- @param value The new maximum spawn value.
function Encounter:SetSpawnsMax(value)
   if not self:GetIsValid() then return end
   self.obj.enc_spawns_max = value
end

--- Sets the number of times that an encounter has spawned.
-- @param value The new number of times the encounter has spawned.
function Encounter:SetSpawnsCurrent(value)
   if not self:GetIsValid() then return end
   self.obj.enc_spawns_current = value
end
