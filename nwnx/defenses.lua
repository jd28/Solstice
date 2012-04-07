--[[

-- interface functions for nwnx_defenses plugin

-- Set minimum/maximum alignment values for paladin/blackguard saves.
NWNX_DEFENSES_OPT_PALADIN_SAVES_MIN_ALIGN_GE    =   0
NWNX_DEFENSES_OPT_PALADIN_SAVES_MIN_ALIGN_LC    =   1
NWNX_DEFENSES_OPT_BLACKGUARD_SAVES_MAX_ALIGN_GE =   2
NWNX_DEFENSES_OPT_BLACKGUARD_SAVES_MAX_ALIGN_LC =   3

-- Set whether or not Death Attack and Sneak Attack should ignore immunity to
-- critical hits.

NWNX_DEFENSES_OPT_DEATHATT_IGNORE_CRIT_IMM      =   4
NWNX_DEFENSES_OPT_SNEAKATT_IGNORE_CRIT_IMM      =   5

-- AC type constants for GetACByType().
nwnx.AC_STRENGTH_BONUS                               = -15
nwnx.AC_DEXTERITY_BONUS                              = -14
nwnx.AC_CONSTITUTION_BONUS                           = -13
nwnx.AC_INTELLIGENCE_BONUS                           = -12
nwnx.AC_CHARISMA_BONUS                               = -11
nwnx.AC_EQUIP_BONUS                                  = -10
nwnx.AC_SKILL_BONUS                                  =  -9
nwnx.AC_CLASS_BONUS                                  =  -8
nwnx.AC_FEAT_BONUS                                   =  -7
nwnx.AC_WISDOM_BONUS                                 =  -6
nwnx.AC_OTHER_BONUS                                  =  -5
nwnx.AC_TOUCH_BASE                                   =  -4
nwnx.AC_SHIELD_BASE                                  =  -3
nwnx.AC_ARMOUR_BASE                                  =  -2
nwnx.AC_NATURAL_BASE                                 =  -1

function NWNXDefensesZero (object oObject, string sFunc) {
    oObject:SetLocalString(sFunc, "          ")
    return tonumber(oObject:GetLocalString(sFunc))
}

int NWNXDefensesOne (object oObject, string sFunc, int nVal1) {
    SetLocalString(sFunc, IntToString(nVal1) + "          ")
    return tonumber(GetLocalString(oObject, sFunc))
}

int NWNXDefensesTwo (object oObject, string sFunc, int nVal1, int nVal2) {
    SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) + "          ")
    return tonumber(GetLocalString(oObject, sFunc))
}

int NWNXDefensesThree (object oObject, string sFunc, int nVal1, int nVal2, int nVal3) {
    SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) +
      " " + IntToString(nVal3) + "          ")
    return tonumber(GetLocalString(oObject, sFunc))
}

int NWNXDefensesFour (object oObject, string sFunc, int nVal1, int nVal2, int nVal3, int nVal4) {
    SetLocalString(oObject, sFunc, IntToString(nVal1) + " " + IntToString(nVal2) +
      " " + IntToString(nVal3) + " " + IntToString(nVal4) + "          ")
    return tonumber(GetLocalString(oObject, sFunc))
}


function nwnx.GetDefenseOption (...) {
    return nwnx.ApplyNumber(GetModule(), "NWNX!DEFENSES!GETDEFENSEOPTION", args)
}

int SetDefenseOption (int nOption, int nValue) {
    return nwnx.ApplyNumber(GetModule(), "NWNX!DEFENSES!SETDEFENSEOPTION", nOption, nValue)
}

function nwnx.GetACByType (object oCreature, int nACType=AC_DODGE_BONUS) {
    return nwnx.ApplyNumber(oCreature, "NWNX!DEFENSES!GETACBYTYPE", nACType)
}

function nwnx.GetACVersus (object oAttacker, object oTarget=OBJECT_SELF) {
    if (!GetIsObjectValid(oAttacker) || !GetIsObjectValid(oTarget))
        return 0

    SetLocalString(oTarget, "NWNX!DEFENSES!GETACVERSUS",
                   oAttacker:ToString(oAttacker) + "          ")
    return tonumber(GetLocalString(oTarget, "NWNX!DEFENSES!GETACVERSUS"))
end

function nwnx.GetAllSpellImmunities (object oCreature) {
    string sImms = GetLocalString(GetModule(), "NWNX!ODBC!SPACER")

    SetLocalString(oCreature, "NWNX!DEFENSES!GETALLSPELLIMMUNITIES", sImms + sImms + sImms + sImms)
    sImms = GetLocalString(oCreature, "NWNX!DEFENSES!GETALLSPELLIMMUNITIES")
    DeleteLocalString(oCreature, "NWNX!DEFENSES!GETALLSPELLIMMUNITIES")

    return sImms
end

function nwnx.GetEffectDamageReduction (object oCreature, int nDamPower, int nDurType=-1) {
    return nwnx.ApplyNumber(oCreature, "NWNX!DEFENSES!GETEFFECTDAMAGEREDUCTION", nDamPower, nDurType)
end

function nwnx.GetEffectDamageResistance (object oCreature, ...) {
    return nwnx.ApplyNumber(oCreature, "NWNX!DEFENSES!GETEFFECTDAMAGERESISTANCE", nDamType, nDurType)
end

function nwnx.GetHasSpellImmunity (object, ...) --int nSpellId, object oCreature=OBJECT_SELF, int nSpellSchool=-1, int nSpellLevel=-1, int nDurType=-1) {
   return nwnx.ApplyBool(oCreature, "NWNX!DEFENSES!GETHASSPELLIMMUNITY", arg)
end

function nwnx.GetTrueDamageImmunity (object oCreature, ...) {
    return nwnx.ApplyNumber(oCreature, "NWNX!DEFENSES!GETTRUEDAMAGEIMMUNITY", arg)
end
--]]