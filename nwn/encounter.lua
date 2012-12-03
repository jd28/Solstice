--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

require 'nwn.ctypes.encounter'
local ffi = require 'ffi'

ffi.cdef[[
typedef struct Encounter {
    uint32_t        type;
    uint32_t        id;
    CNWSEncounter  *obj;
} Encounter;
]]

local encounter_mt = { __index = Encounter }
encounter_t = ffi.metatype("Encounter", encounter_mt)

--- Gets whether an encounter has spawned as is active.
function Encounter:GetActive()
   if self:GetIsValid() then return false end
   return self.obj.enc_is_active == 1
end

--- Get the difficulty level of the encounter.
-- @return nwn.ENCOUNTER_DIFFICULTY_*
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

--- Get the maximum number of times that oEncounter will spawn.
function Encounter:GetSpawnsMax()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawns_max
end

--- Gets the number of spawn points
function Encounter:GetSpawnPointCount()
   if not self:GetIsValid() then return -1 end
   return self.obj.enc_spawn_points_len
end

--- Gets a spawn point.
-- @param idx Index in the spawn poing list.
function Encounter:GetSpawnPointByIndex(idx)
   if not self:GetIsValid() then return end
   if idx < 0 or idx >= self.obj.enc_spawn_points_len then return end
   local sp = self.obj.enc_spawn_points[idx]
   
   if sp.position.z < 0 then sp.position.z = 0 end

   return nwn.Location(sp.position, sp.orientation, self:GetArea())
end

--- Sets an encounter to active or inactive.
-- @param value <em>true</em> for active, <em>false</em> for inactive
function Encounter:SetActive(value)
   if not self:GetIsValid() then return end
   self.obj.enc_is_active = value
end

--- Sets the difficulty level of an encounter.
-- @param value nwn.ENCOUNTER_DIFFICULTY_*
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
