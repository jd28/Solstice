local M = {}

M.const = {
   ANIMAL_COMPANION_BADGER   = 0,
   ANIMAL_COMPANION_WOLF     = 1,
   ANIMAL_COMPANION_BEAR     = 2,
   ANIMAL_COMPANION_BOAR     = 3,
   ANIMAL_COMPANION_HAWK     = 4,
   ANIMAL_COMPANION_PANTHER  = 5,
   ANIMAL_COMPANION_SPIDER   = 6,
   ANIMAL_COMPANION_DIREWOLF = 7,
   ANIMAL_COMPANION_DIRERAT  = 8,
   ANIMAL_COMPANION_NONE     = 255,
   
   FAMILIAR_BAT        = 0,
   FAMILIAR_CRAGCAT    = 1,
   FAMILIAR_HELLHOUND  = 2,
   FAMILIAR_IMP        = 3,
   FAMILIAR_FIREMEPHIT = 4,
   FAMILIAR_ICEMEPHIT  = 5,
   FAMILIAR_PIXIE      = 6,
   FAMILIAR_RAVEN           = 7,
   FAMILIAR_FAIRY_DRAGON    = 8,
   FAMILIAR_PSEUDO_DRAGON    = 9,
   FAMILIAR_EYEBALL          = 10,
   FAMILIAR_NONE       = 255,

   -- These must match the values in nwscreature.h and nwccreaturemenu.cpp
   -- Cannot use the value -1 because that is used to start a conversation
   COMMAND_STANDGROUND             = -2,
   COMMAND_ATTACKNEAREST           = -3,
   COMMAND_HEALMASTER              = -4,
   COMMAND_FOLLOWMASTER            = -5,
   COMMAND_MASTERFAILEDLOCKPICK    = -6,
   COMMAND_GUARDMASTER             = -7,
   COMMAND_UNSUMMONFAMILIAR        = -8,
   COMMAND_UNSUMMONANIMALCOMPANION = -9,
   COMMAND_UNSUMMONSUMMONED        = -10,
   COMMAND_MASTERUNDERATTACK       = -11,
   COMMAND_RELEASEDOMINATION       = -12,
   COMMAND_UNPOSSESSFAMILIAR       = -13,
   COMMAND_MASTERSAWTRAP           = -14,
   COMMAND_MASTERATTACKEDOTHER     = -15,
   COMMAND_MASTERGOINGTOBEATTACKED = -16,
   COMMAND_LEAVEPARTY              = -17,
   COMMAND_PICKLOCK                = -18,
   COMMAND_INVENTORY               = -19,
   COMMAND_DISARMTRAP              = -20,
   COMMAND_TOGGLECASTING           = -21,
   COMMAND_TOGGLESTEALTH           = -22,
   COMMAND_TOGGLESEARCH            = -23,

   -- These match the values in nwscreature.h
   NONE             = 0,
   HENCHMAN         = 1,
   ANIMALCOMPANION  = 2,
   FAMILIAR         = 3,
   SUMMONED         = 4,
   DOMINATED        = 5,
}

setmetatable(M, { __index = M.const })

return M