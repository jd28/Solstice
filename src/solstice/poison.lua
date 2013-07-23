--- Poison
-- @module poison

local M = {}

M.const = {
   -- these constants must match those in poison.2da
   NIGHTSHADE                    = 0,
   SMALL_CENTIPEDE_POISON        = 1,
   BLADE_BANE                    = 2,
   GREENBLOOD_OIL                = 3,
   BLOODROOT                     = 4,
   PURPLE_WORM_POISON            = 5,
   LARGE_SCORPION_VENOM          = 6,
   WYVERN_POISON                 = 7,
   BLUE_WHINNIS                  = 8,
   GIANT_WASP_POISON             = 9,
   SHADOW_ESSENCE                = 10,
   BLACK_ADDER_VENOM             = 11,
   DEATHBLADE                    = 12,
   MALYSS_ROOT_PASTE             = 13,
   NITHARIT                      = 14,
   DRAGON_BILE                   = 15,
   SASSONE_LEAF_RESIDUE          = 16,
   TERINAV_ROOT                  = 17,
   CARRION_CRAWLER_BRAIN_JUICE   = 18,
   BLACK_LOTUS_EXTRACT           = 19,
   OIL_OF_TAGGIT                 = 20,
   ID_MOSS                       = 21,
   STRIPED_TOADSTOOL             = 22,
   ARSENIC                       = 23,
   LICH_DUST                     = 24,
   DARK_REAVER_POWDER            = 25,
   UNGOL_DUST                    = 26,
   BURNT_OTHUR_FUMES             = 27,
   CHAOS_MIST                    = 28,
   BEBILITH_VENOM                = 29,
   QUASIT_VENOM                  = 30,
   PIT_FIEND_ICHOR               = 31,
   ETTERCAP_VENOM                = 32,
   ARANEA_VENOM                  = 33,
   TINY_SPIDER_VENOM             = 34,
   SMALL_SPIDER_VENOM            = 35,
   MEDIUM_SPIDER_VENOM           = 36,
   LARGE_SPIDER_VENOM            = 37,
   HUGE_SPIDER_VENOM             = 38,
   GARGANTUAN_SPIDER_VENOM       = 39,
   COLOSSAL_SPIDER_VENOM         = 40,
   PHASE_SPIDER_VENOM            = 41,
   WRAITH_SPIDER_VENOM           = 42,
   IRON_GOLEM                    = 43,
}

setmetatable(M, { __index = M.const })

return M