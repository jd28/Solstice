function nwnx.NWNXWeaponsZero (oObject, sFunc) 
   oObject:SetLocalString(sFunc, "          ")
   return tonumber(object:GetLocalString(sFunc))
end

function nwnx.NWNXWeaponsOne (oObject, sFunc, nVal1) 
   oObject:SetLocalString(sFunc, nVal1 .. "          ")
   return tonumber(oObject:GetLocalString(sFunc))
end

function nwnx.NWNXWeaponsTwo (oObject, sFunc, nVal1, nVal2) 
   oObject:SetLocalString(sFunc, nVal1 .. " " .. nVal2 .. "          ")
   return tonumber(oObject:GetLocalString(sFunc))
end

function nwnx.NWNXWeaponsThree (oObject, sFunc, nVal1, nVal2, nVal3) 
   SetLocalString(oObject, sFunc, nVal1 .. " " .. nVal2 ..
                  " " .. nVal3 .. "          ")
   return tonumber(GetLocalString(oObject, sFunc))
end

function nwnx.GetWeaponOption (nOption) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONOPTION", nOption)
end

function nwnx.SetWeaponOption (nOption, nValue) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONOPTION", nOption, nValue)
end


function nwnx.GetAttackBonusAdjustment (oCreature, oWeapon, bRanged) 
   oCreature:SetLocalString("NWNX!WEAPONS!GETATTACKBONUSADJUSTMENT",
                            bRanged .. " " .. oWeapon:ToString() .. "         ")

   nAdj = tonumber(oCreature:GetLocalString("NWNX!WEAPONS!GETATTACKBONUSADJUSTMENT"))
   oCreature:DeleteLocalString("NWNX!WEAPONS!GETATTACKBONUSADJUSTMENT")

   return nAdj
end

function nwnx.GetWeaponIsMonkWeapon (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONISMONKWEAPON", nBaseItem)
end

function nwnx.SetWeaponIsMonkWeapon (nBaseItem, nMonkLevelsRequired) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONISMONKWEAPON", nBaseItem, nMonkLevelsRequired)
end


function nwnx.GetWeaponAbilityFeat (nBaseItem, nAbility) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONABILITYFEAT", nBaseItem, nAbility)
end

function nwnx.SetWeaponAbilityFeat (nBaseItem, nAbility, nFeat) 
   return NWNXWeaponsThree(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONABILITYFEAT", nBaseItem, nAbility, nFeat)
end


function nwnx.GetWeaponFinesseSize (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONFINESSESIZE", nBaseItem)
end

function nwnx.SetWeaponFinesseSize (nBaseItem, nSize) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONFINESSESIZE", nBaseItem, nSize)
end


function nwnx.GetWeaponDevastatingCriticalFeat            (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONDEVASTATINGCRITICALFEAT",  nBaseItem)
end

function nwnx.GetWeaponEpicFocusFeat                      (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONEPICFOCUSFEAT",                  nBaseItem)
end

function nwnx.GetWeaponEpicSpecializationFeat             (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONEPICSPECIALIZATIONFEAT",         nBaseItem)
end

function nwnx.GetWeaponFocusFeat                          (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONFOCUSFEAT",                      nBaseItem)
end

function nwnx.GetWeaponGreaterFocusFeat                   (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONGREATERFOCUSFEAT",               nBaseItem)
end

function nwnx.GetWeaponGreaterSpecializationFeat          (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONGREATERSPECIALIZATIONFEAT",      nBaseItem)
end

function nwnx.GetWeaponImprovedCriticalFeat               (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONIMPROVEDCRITICALFEAT",           nBaseItem)
end

function nwnx.GetWeaponLegendaryFocusFeat                 (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONLEGENDARYFOCUSFEAT",             nBaseItem)
end

function nwnx.GetWeaponLegendarySpecializationFeat        (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONLEGENDARYSPECIALIZATIONFEAT",    nBaseItem)
end

function nwnx.GetWeaponOfChoiceFeat                       (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONOFCHOICEFEAT",                   nBaseItem)
end

function nwnx.GetWeaponOverwhelmingCriticalFeat           (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONOVERWHELMINGCRITICALFEAT",       nBaseItem)
end

function nwnx.GetWeaponParagonFocusFeat                   (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONPARAGONFOCUSFEAT",               nBaseItem)
end

function nwnx.GetWeaponParagonSpecializationFeat          (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONPARAGONSPECIALIZATIONFEAT",      nBaseItem)
end

function nwnx.GetWeaponPowerCriticalFeat                  (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONPOWERCRITICALFEAT",              nBaseItem)
end

function nwnx.GetWeaponSpecializationFeat                 (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONSPECIALIZATIONFEAT",             nBaseItem)
end

function nwnx.GetWeaponSuperiorCriticalFeat               (nBaseItem) 
   return NWNXWeaponsOne(nwn.GetModule(), "NWNX!WEAPONS!GETWEAPONSUPERIORCRITICALFEAT",           nBaseItem)
end


function nwnx.SetWeaponDevastatingCriticalFeat            (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONDEVASTATINGCRITICALFEAT",        nBaseItem, nFeat)
end

function nwnx.SetWeaponEpicFocusFeat                      (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONEPICFOCUSFEAT",                  nBaseItem, nFeat)
end

function nwnx.SetWeaponEpicSpecializationFeat             (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONEPICSPECIALIZATIONFEAT",         nBaseItem, nFeat)
end

function nwnx.SetWeaponFocusFeat                          (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONFOCUSFEAT",                      nBaseItem, nFeat)
end

function nwnx.SetWeaponGreaterFocusFeat                   (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONGREATERFOCUSFEAT",               nBaseItem, nFeat)
end

function nwnx.SetWeaponGreaterSpecializationFeat          (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONGREATERSPECIALIZATIONFEAT",      nBaseItem, nFeat)
end

function nwnx.SetWeaponImprovedCriticalFeat               (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONIMPROVEDCRITICALFEAT",           nBaseItem, nFeat)
end

function nwnx.SetWeaponLegendaryFocusFeat                 (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONLEGENDARYFOCUSFEAT",             nBaseItem, nFeat)
end

function nwnx.SetWeaponLegendarySpecializationFeat        (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONLEGENDARYSPECIALIZATIONFEAT",    nBaseItem, nFeat)
end

function nwnx.SetWeaponOfChoiceFeat                       (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONOFCHOICEFEAT",                   nBaseItem, nFeat)
end

function nwnx.SetWeaponOverwhelmingCriticalFeat           (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONOVERWHELMINGCRITICALFEAT",       nBaseItem, nFeat)
end

function nwnx.SetWeaponParagonFocusFeat                   (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONPARAGONFOCUSFEAT",               nBaseItem, nFeat)
end

function nwnx.SetWeaponParagonSpecializationFeat          (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONPARAGONSPECIALIZATIONFEAT",      nBaseItem, nFeat)
end

function nwnx.SetWeaponPowerCriticalFeat                  (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONPOWERCRITICALFEAT",              nBaseItem, nFeat)
end

function nwnx.SetWeaponSpecializationFeat                 (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONSPECIALIZATIONFEAT",             nBaseItem, nFeat)
end

function nwnx.SetWeaponSuperiorCriticalFeat               (nBaseItem, nFeat) 
   return NWNXWeaponsTwo(nwn.GetModule(), "NWNX!WEAPONS!SETWEAPONSUPERIORCRITICALFEAT",           nBaseItem, nFeat)
end
