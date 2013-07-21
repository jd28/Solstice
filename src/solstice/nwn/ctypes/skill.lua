local ffi = require 'ffi'

ffi.cdef[[
typedef struct {
    uint32_t                   sk_name_strref;
    uint32_t                   sk_desc_strref;
    uint32_t                   sk_category;
    uint32_t                   sk_max_cr;
    CExoString                 sk_icon;
    uint32_t                   sk_ability;
    uint32_t                   sk_hostile;
    uint32_t                   sk_untrained;
    uint32_t                   sk_armor_check;
    uint32_t                   sk_all_can_use;
} CNWSkill;
]]