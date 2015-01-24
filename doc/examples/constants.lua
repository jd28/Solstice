-- The following defines all your constants.  You can set them
-- manually or read them from 2DA files.  This particular file is
-- what I've made for my PW and I've added and extended a number of
-- 2DAs to make constant loading as painless as possible.  These
-- will all be made available in the 2da folder that's distributed
-- with Solstice, however they'll be from my PW.  So wpnfeats.2da and
--
--
-- This may not be the best way, but it would be easy to parse an
-- nss file for constant declarations instead.
--
-- The vast bulk of these are required.  Imagine if all the constants
-- in nwscript.nss were removed.

local Rules = require 'solstice.rules.constants'

Rules.RegisterConstants("abilities", "ID") -- Included 2da
Rules.RegisterConstant("ABILITY_NUM", 6)

Rules.RegisterConstant("GENDER_MALE", 0)
Rules.RegisterConstant("GENDER_FEMALE", 1)

Rules.RegisterConstant("VARIABLE_TYPE_INT", 1)
Rules.RegisterConstant("VARIABLE_TYPE_FLOAT", 2)
Rules.RegisterConstant("VARIABLE_TYPE_STRING", 3)
Rules.RegisterConstant("VARIABLE_TYPE_OBJECT", 4)
Rules.RegisterConstant("VARIABLE_TYPE_LOCATION", 5)

Rules.RegisterConstant("VOLUME_PARTY", 5)
Rules.RegisterConstant("VOLUME_SHOUT", 2)
Rules.RegisterConstant("VOLUME_SILENT_SHOUT", 4)
Rules.RegisterConstant("VOLUME_SILENT_TALK", 3)
Rules.RegisterConstant("VOLUME_TALK", 0)
Rules.RegisterConstant("VOLUME_TELL", 6)
Rules.RegisterConstant("VOLUME_WHISPER", 1)

Rules.RegisterConstants("actions", "Constant")
Rules.RegisterConstants("actionmodes", "ID") -- Included 2da
Rules.RegisterConstants("ambientsound", "Constant")
Rules.RegisterConstants("animations", "ID", nil, "Value", "int")
Rules.RegisterConstants("appearance", "Constant")
Rules.RegisterConstants("area_const", "Constant", nil, "Value", "int")
Rules.RegisterConstants("attacktypes", "ID") -- Included 2da
Rules.RegisterConstants("armorclass", "ID") -- Included 2da
Rules.RegisterConstants("baseitems", "Constant")
Rules.RegisterConstants("classes", "Constant")
Rules.RegisterConstants("combatmods", "ID") -- Included 2da
Rules.RegisterConstants("combatmodes", "ID") -- Included 2da

Rules.RegisterConstants("combatupd", "ID", nil, "Value", "int") -- Obsolete?
Rules.RegisterConstant("COMBAT_UPDATE_ALL", 0xFFFFFFFF) -- Obsolete?

Rules.RegisterConstants("const_object", "Constant", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("const_saves", "Constant", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("creaturesize", "Constant")
Rules.RegisterConstants("creaturespeed", "Constant")
Rules.RegisterConstants("customeffects", "ID") -- Included 2da

Rules.RegisterConstants("damages", "ID", nil, "Mask", "int") -- Included 2da
Rules.RegisterConstants("damages", "ID_INDEX") -- Included 2da
Rules.RegisterConstant("DAMAGE_INDEX_NUM", 13)
Rules.RegisterConstant("DAMAGE_POWER_NUM", 21)

Rules.RegisterConstants("durtypes", "ID") -- Included 2da
Rules.RegisterConstants("disease", "Constant")
Rules.RegisterConstants("door_const", "Constant", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("effects", "Constant") -- Included 2da
Rules.RegisterConstants("effectsubtypes", "ID", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("encdifficulty", "Constant")
Rules.RegisterConstants("equiptypes", "ID") -- Included 2da
Rules.RegisterConstants("feat", "Constant")
Rules.RegisterConstants("hen_familiar", "Constant")

Rules.RegisterConstants("immunities", "Constant") -- Included 2da
Rules.RegisterConstant("IMMUNITY_TYPE_NUM", 33)

Rules.RegisterConstants("invslots", "ID") -- Included 2da
Rules.RegisterConstants("iprp_alignment", "Constant")
Rules.RegisterConstants("iprp_ammocost", "Constant")
Rules.RegisterConstants("iprp_ammotype", "Constant")
Rules.RegisterConstants("iprp_arcspell", "Constant")
Rules.RegisterConstants("iprp_chargecost", "Constant")
Rules.RegisterConstants("iprp_color", "Constant")
Rules.RegisterConstants("iprp_damagecost", "Constant")
Rules.RegisterConstants("iprp_damagetype", "Constant")
Rules.RegisterConstants("iprp_feats", "Constant")
Rules.RegisterConstants("iprp_immuncost", "Constant")
Rules.RegisterConstants("iprp_immunity", "Constant")
Rules.RegisterConstants("iprp_lightcost", "Constant")
Rules.RegisterConstants("iprp_monstcost", "Constant")
Rules.RegisterConstants("iprp_monsterhit", "Constant")
Rules.RegisterConstants("iprp_onhit", "Constant")
Rules.RegisterConstants("iprp_onhitcost", "Constant")
Rules.RegisterConstants("iprp_onhitdur", "Constant")
Rules.RegisterConstants("iprp_onhitspell", "Constant")
Rules.RegisterConstants("iprp_poison", "Constant")
Rules.RegisterConstants("iprp_protection", "Constant")
Rules.RegisterConstants("iprp_quality", "Constant")
Rules.RegisterConstants("iprp_redcost", "Constant")
Rules.RegisterConstants("iprp_resistcost", "Constant")
Rules.RegisterConstants("iprp_saveelement", "Constant")
Rules.RegisterConstants("iprp_savingthrow", "Constant")
Rules.RegisterConstants("iprp_soakcost", "Constant")
Rules.RegisterConstants("iprp_spells", "Constant")
Rules.RegisterConstants("iprp_spellshl", "Constant")
Rules.RegisterConstants("iprp_srcost", "Constant")
Rules.RegisterConstants("iprp_trapcost", "Constant")
Rules.RegisterConstants("iprp_traps", "Constant")
Rules.RegisterConstants("iprp_visualfx", "Constant")
Rules.RegisterConstants("iprp_soakcost", "Constant")
Rules.RegisterConstants("iprp_weightcost", "Constant")
Rules.RegisterConstants("iprp_weightinc", "Constant")
Rules.RegisterConstants("itempropdef", "Constant")
Rules.RegisterConstants("itemevents", "ID") -- Included 2da
Rules.RegisterConstants("masterfeats", "Constant")
Rules.RegisterConstants("misschtypes", "ID") -- Included 2da
Rules.RegisterConstants("mstrwpnfeats", "Constant") -- Included 2da
Rules.RegisterConstants("metamagic", "Constant", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("phenotype", "Constant")
Rules.RegisterConstants("poison", "Constant")
Rules.RegisterConstants("polymorph", "Name")
Rules.RegisterConstants("racialtypes", "Constant")
Rules.RegisterConstants("radius", "Constant", nil, "Value", "float") -- Included 2da
Rules.RegisterConstants("rangedwpns", "ID") -- Included 2da

Rules.RegisterConstants("skills", "Constant")
Rules.RegisterConstant("SKILL_LAST", 27)
Rules.RegisterConstant("SKILL_NUM", 28)

Rules.RegisterConstants("scriptreturn", "ID") -- Included 2da
Rules.RegisterConstants("skyboxes", "Constant")
Rules.RegisterConstants("shapes", "Constant") -- Included 2da
Rules.RegisterConstants("situations", "ID") -- Included 2da
Rules.RegisterConstants("situations", "Flag", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("specattack", "ID", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("spells", "Constant")
Rules.RegisterConstants("spellschools", "Constant")
Rules.RegisterConstants("targetstates", "ID", nil, "Value", "int") -- Included 2da
Rules.RegisterConstants("traps", "Constant")
Rules.RegisterConstants("vfx_persistent", "LABEL")
Rules.RegisterConstants("visualeffects", "Label")