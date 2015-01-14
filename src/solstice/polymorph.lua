local TDA = require 'solstice.2da'
local ffi = require 'ffi'
local C   = ffi.C

local Eff = require 'solstice.effect'

local function unequip(cre, it)
   C.nwn_UnequipItem(cre.obj, it.obj, 0)
end

local function equip(cre, it, slot)
   C.nwn_EquipItem(cre.obj, slot, it.obj, 1, 0)
end

local function postpoly(cre, ignore_pos, is_apply)
   C.ns_PostPolymorph(cre.obj, ignore_pos, is_apply)
end

local function CreateItemAndEquip(cre, resref, slot)
   C.nwn_CreateItemAndEquip(cre.obj, resref, slot)
end

jit.off(unequip)
jit.off(equip)
jit.off(postpoly)
jit.off(CreateItemAndEquip)

function NWNXSolstice_Polymorph(cre, polyid, ignore_pos)
   cre = _SOL_GET_CACHED_OBJECT(cre)
   local poly_2da = C.Local_GetPoly2da()
   local poly_eff = C.Local_GetPolyEffect()

   local appear = TDA.GetInt(poly_2da, "AppearanceType", polyid)
   if appear == 0 then return 0 end

   cre.obj.cre_poly_appearance = cre.obj.cre_stats.cs_appearance;

   cre.obj.cre_poly_portrait_id = cre.obj.obj.obj_portrait_id
   ffi.copy(cre.obj.cre_poly_portrait,
            cre.obj.cre_stats.cs_portrait,
            16)

   cre.obj.cre_poly_pre_str = cre.obj.cre_stats.cs_str
   cre.obj.cre_poly_pre_con = cre.obj.cre_stats.cs_con
   cre.obj.cre_poly_pre_dex = cre.obj.cre_stats.cs_dex
   cre.obj.cre_poly_race = cre.obj.cre_stats.cs_race
   cre.obj.cre_poly_hpbonus = 0LL
   cre.obj.cre_poly_acbonus = 0LL
   cre.obj.cre_poly_pre_hp = cre:GetCurrentHitPoints()
   cre.obj.cre_poly_spellid_1 = -1;
   cre.obj.cre_poly_spellid_2 = -1;
   cre.obj.cre_poly_spellid_3 = -1;
   cre.obj.cre_stats.cs_appearance = appear
   cre.obj.cre_appearance_info.cai_appearance = appear

   local race = TDA.GetInt(poly_2da, "RacialType", polyid)
   if race > 0 then
      cre.obj.cre_stats.cs_race = race
   end

   local port_id = TDA.GetInt(poly_2da, "PortraitId", polyid)
   if port_id > 0 and port_id ~= 65535 then
      cre.obj.obj.obj_portrait_id = port_id
   else
      local port = TDA.GetString(poly_2da, "Portrait", polyid)
      if #port > 0 then
         ffi.copy(cre.obj.cre_stats.cs_portrait,
                  port,
                  math.min(16, #port))
      end
   end

   local str = TDA.GetInt(poly_2da, "STR", polyid)
   local dex = TDA.GetInt(poly_2da, "DEX", polyid)
   local con = TDA.GetInt(poly_2da, "CON", polyid)

   if str > 0 then
      cre:SetAbilityScore(ABILITY_STRENGTH, str)
   end

   if dex > 0 then
      cre:SetAbilityScore(ABILITY_DEXTERITY, dex)
   end

   if con > 0 then
      cre:SetAbilityScore(ABILITY_CONSTITUTION, con)
   end

   -- Instead of adding the feat directly, use a bonus feat and
   -- add it to the link.
   local eff_bonus_feat
   cre.obj.cre_poly_hasprepolycp = 1
   if not cre:GetHasFeat(0x121) then
      --cre.obj.cre_poly_hasprepolycp = 0
      eff_bonus_feat = Eff.BonusFeat(0x121)
   end

   local eff_bonus_ac
   local ac = TDA.GetInt(poly_2da, "NATURALACBONUS", polyid)
   if ac > 0 then
      eff_bonus_ac = Eff.AC(ac, AC_DODGE_BONUS)
   end

   local eff_bonus_hp
   local hp = TDA.GetInt(poly_2da, "HPBONUS", polyid)
   if hp > 0 then
      eff_bonus_hp = Eff.TemporaryHitpoints(hp)
   end

   for i=0, 17 do
      local it = cre:GetItemInSlot(i)
      cre.obj.cre_poly_item_id[i] = OBJECT_INVALID.id
   end

   local eff
   if eff_bonus_feat then
      eff = eff and Eff.LinkEffects(eff, eff_bonus_feat) or eff_bonus_feat
   end

   if eff_bonus_ac then
      eff = eff and Eff.LinkEffects(eff, eff_bonus_ac) or eff_bonus_ac
   end

   if eff_bonus_hp then
      eff = eff and Eff.LinkEffects(eff, eff_bonus_hp) or eff_bonus_hp
   end

   -- Note that I'm only using the acbonus effect id slot,
   -- as all they have all been linked together.  This will be
   -- auto removed when polymorph is cancelled.
   cre.obj.cre_poly_hpbonus = eff:GetId()
   eff:SetSpellId(-1)
   cre:ApplyEffect(4, eff)
   local mask = TDA.GetInt(poly_2da, "UnequipMask", polyid)
   for i=0, 17 do
      if bit.band(mask, bit.lshift(1, i)) ~= 0 then
         local it = cre:GetItemInSlot(i)
         if it:GetIsValid() then
            cre.obj.cre_poly_item_id[i] = it.id
            unequip(cre, it)
         end
      end
   end

   local creweap = true
   local t = TDA.GetString(poly_2da, "Equipped", polyid)
   if #t > 0 then
      CreateItemAndEquip(cre, t, INVENTORY_SLOT_RIGHTHAND)
      creweap = false
   end

   if creweap then
      t = TDA.GetString(poly_2da, "CreatureWeapon1", polyid)
      if #t > 0 then
         CreateItemAndEquip(cre, t, INVENTORY_SLOT_CWEAPON_L)
      end

      t = TDA.GetString(poly_2da, "CreatureWeapon2", polyid)
      if #t > 0 then
         CreateItemAndEquip(cre, t, INVENTORY_SLOT_CWEAPON_R)
      end

      t = TDA.GetString(poly_2da, "CreatureWeapon3", polyid)
      if #t > 0 then
         CreateItemAndEquip(cre, t, INVENTORY_SLOT_CWEAPON_B)
      end
   end

   local sp1 = TDA.GetInt(poly_2da, "Spell1", polyid)
   if sp1 > 0 then
      cre.obj.cre_poly_spellid_1 = sp1
   end

   local sp2 = TDA.GetInt(poly_2da, "Spell2", polyid)
   if sp2 > 0 then
      cre.obj.cre_poly_spellid_2 = sp2
   end

   local sp3 = TDA.GetInt(poly_2da, "Spell3", polyid)
   if sp3 > 0 then
      cre.obj.cre_poly_spellid_3 = sp3
   end

   -- Remove an current EffectRacialType.
   for i=0, cre.obj.obj.obj_effects_len - 1 do
      if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_RACIAL_TYPE then
         cre:RemoveEffectByID(cre.obj.obj.obj_effects[i].eff_id)
         break
      end
   end

   cre:ApplyEffect(4, Eff.RacialType(cre.obj.cre_stats.cs_race))

   postpoly(cre, ignore_pos, true)

   if cre:GetCurrentHitPoints() <= 0 then
      cre:SetCurrentHitPoints(1)
   end

   return 1
end

function NWNXSolstice_Unpolymorph(cre)
   print("NWNXSolstice_Unpolymorph")
   cre = _SOL_GET_CACHED_OBJECT(cre)
   local poly_eff = C.Local_GetPolyEffect()

   if cre.obj.cre_is_poly == 0 then return end
   cre.obj.cre_is_poly = 0

   if cre.obj.cre_poly_hpbonus ~= 0LL then
      cre:RemoveEffectByID(cre.obj.cre_poly_hpbonus)
      cre.obj.cre_poly_hpbonus = 0LL
   end

   if cre.obj.cre_poly_acbonus ~= 0LL then
      cre:RemoveEffectByID(cre.obj.cre_poly_acbonus)
      cre.obj.cre_poly_acbonus = 0LL
   end

   -- Destory creature stuff...
   local it = cre:GetItemInSlot(INVENTORY_SLOT_CWEAPON_L)
   if it:GetIsValid() then
      unequip(cre, it)
      C.nwn_DestroyItem(it.obj)
      _SOL_REMOVE_CACHED_OBJECT(it.id)
   end

   it = cre:GetItemInSlot(INVENTORY_SLOT_CWEAPON_R)
   if it:GetIsValid() then
      unequip(cre, it)
      C.nwn_DestroyItem(it.obj)
      _SOL_REMOVE_CACHED_OBJECT(it.id)
   end

   it = cre:GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)
   if it:GetIsValid() then
      unequip(cre, it)
      C.nwn_DestroyItem(it.obj)
      _SOL_REMOVE_CACHED_OBJECT(it.id)
   end

   it = cre:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if it:GetIsValid() then
      unequip(cre, it)
      C.nwn_DestroyItem(it.obj)
      _SOL_REMOVE_CACHED_OBJECT(it.id)
   end

   for i=0, 17 do
      if cre.obj.cre_poly_item_id[i] ~= OBJECT_INVALID.id then
         local it = _SOL_GET_CACHED_OBJECT(cre.obj.cre_poly_item_id[i])
         equip(cre, it, i)
         cre.obj.cre_poly_item_id[i] = OBJECT_INVALID.id
      end
   end

   cre.obj.cre_stats.cs_appearance = cre.obj.cre_poly_appearance
   cre.obj.cre_appearance_info.cai_appearance = cre.obj.cre_poly_appearance
   cre.obj.cre_stats.cs_race = cre.obj.cre_poly_race
   cre.obj.cre_poly_race = 0
   cre.obj.cre_poly_appearance = -1

   cre.obj.obj.obj_portrait_id = cre.obj.cre_poly_portrait_id
   cre.obj.cre_poly_portrait_id = 0
   ffi.copy(cre.obj.cre_stats.cs_portrait,
            cre.obj.cre_poly_portrait,
            16)
   ffi.fill(cre.obj.cre_poly_portrait, 16)

   cre:SetAbilityScore(ABILITY_STRENGTH, cre.obj.cre_poly_pre_str)
   cre.obj.cre_poly_pre_str = 0

   cre:SetAbilityScore(ABILITY_DEXTERITY, cre.obj.cre_poly_pre_dex)
   cre.obj.cre_poly_pre_dex = 0

   cre:SetAbilityScore(ABILITY_CONSTITUTION, cre.obj.cre_poly_pre_con)
   cre.obj.cre_poly_pre_con = 0

   if poly_eff == nil then
      -- Remove an current EffectRacialType.
      for i=0, cre.obj.obj.obj_effects_len - 1 do
         if cre.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_RACIAL_TYPE then
            cre:RemoveEffectByID(cre.obj.obj.obj_effects[i].eff_id)
            break
         end
      end
   end

   cre:ApplyEffect(4, Eff.RacialType(cre.obj.cre_stats.cs_race))

   postpoly(cre, 1, false)

   return 1
end
