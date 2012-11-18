local ffi = require 'ffi'
local C = ffi.C

--- Versus Info ctype
-- @name VersusInfo
-- @field race Test
-- @field goodevil Test
-- @field lawchaos Test
-- @field deity_id Test
-- @field subrace_id Test
-- @field obj_id Test
ffi.cdef[[
typedef struct VersusInfo {
   int32_t race;
   int32_t goodevil;
   int32_t lawchaos;
   int32_t deity_id;
   int32_t subrace_id;
   uint32_t target;
   int32_t type;
   int32_t subtype;
   uint32_t dmg_flags;
} VersusInfo;
]]

ffi.cdef[[
typedef struct EffectInfo {
   int32_t type_dec;
   int32_t type_inc;
   bool stack;
   bool item_stack;
   bool spell_stack;
} EffectInfo;
]]

versus_info_t = ffi.typeof("VersusInfo")
effect_info_t = ffi.typeof("EffectInfo")

local eff_bonus
local eff_penalty
local eff_bonus_idx = 0
local eff_penalty_idx = 0

function nwn.GetVersusInfo(vs, typ, subtype, dmg_flags)
   if not vs or not vs:GetIsValid() or vs.type ~= nwn.GAME_OBJECT_TYPE_CREATURE then
      return versus_info_t(nwn.RACIAL_TYPE_INVALID,
			   0,
			   0,
			   0,
			   0,
			   nwn.OBJECT_INVALID.id,
			   typ or -1,
			   subtype or -1,
			   dmg_flags or 0)
   else
      return versus_info_t(vs:GetRacialType(),
			   vs:GetGoodEvilValue(),
			   vs:GetLawChaosValue(),
			   vs:GetDeityId(),
			   vs:GetSubraceId(),
			   vs.id,
			   typ or -1,
			   subtype or -1,
			   dmg_flags or 0)
   end
end

function Creature:CreateEffectDebugString()
   for eff in self:EffectsDirect() do
      table.insert(t, eff:ToString())
   end

   return table.concat(t, "\n")
end

--- Deterimines total effect bonus for a particular type.
-- @param vs_info ...
-- @param eff_info EffectInfo ctype
-- @param range_check Function that takes effect type and determines if the current effect
--    is in the proper range.
-- @param validity_check Function that takes the effect and a VersusInfo ctype to determine if the
--    effect is applicable versus the target passed in vs.
-- @param get_amount Function which takes the effect and returns it's respective 'amount' which 
--    differs depending on effect type.
function Creature:GetEffectArrays(bonus, penalty, vs_info, eff_info, range_check, validity_check, get_amount, effect_max, index)
   vs_info = vs_info or nwn.GetVersusInfo(nwn.OBJECT_INVALID)

   local eff_type, eff, amount
   local bon_idx = 0
   local pen_idx = 0

   -- Tables for spell bonus/penalities.
   -- Key: Spell ID, Value: Index into bonus/penalty arrays
   local spell_bonus, spell_pen
   if not spell_stack then
      spell_bonus = {}
      spell_pen = {}
   end

   -- Tables for item bonus/penalities.
   -- Key: Object ID, Value: Index into bonus/penalty arrays
   local item_bonus, item_pen
   if not item_stack then
      item_bonus = {}
      item_pen = {}
   end

   for i = index, self:GetEffectCount() do
      eff = self:GetEffectAtIndex(i)
      eff_type = eff:GetTrueType()
      
      amount = get_amount(eff)

      -- If the effect is not in the effect type range then there is nothing left to do.
      if not range_check(eff_type) then break end

      -- Check if this effect is applicable versus the target.
      if validity_check(eff, vs_info) then
	 local add_effect = false

	 -- Don't call Effect:GetCreator because we only want the ID, not the object.
	 local eff_cre = eff.eff.eff_creator
	 local sp_id = eff:GetSpellId()

         if eff_type == eff_info.type_dec then
            if not item_stack and not C.nwn_GetItemById(eff_cre) == nil then
	       -- If effects from items do not stack and the effect was applied by an item,
	       -- find the highest applying

	       local item_idx = item_pen[eff_cre]

	       if not item_pen[eff.eff_creator] then
		  -- If a item already has an effect in the array then replace it with
		  -- the max of the two.
		  penalty[item_idx] = effect_max(penalty[item_idx], amount)
	       else
		  item_pen[eff_cre] = pen_idx
		  add_effect = true
	       end
	    elseif not spell_stack and sp_id ~= -1 then
	       local sp_idx = spell_pen[sp_id]
	       if sp_idx then
		  -- If a spell already has an effect in the array then replace it with
		  -- the max of the two.
		  penalty[sp_idx] = effect_max(penalty[sp_idx], amount)
	       else
		  -- No effect from a spell.  Added it to the array and set the spell table.
		  spell_pen[sp_id] = pen_idx
		  add_effect = true
	       end
	    else
	       add_effect = true
	    end
	    
	    if add_effect then
	       penalty[pen_idx] = amount
	       pen_idx = pen_idx + 1
	    end
      elseif eff_type == eff_info.type_inc then
            -- If effects from items do not stack and the effect was applied by an item,
            -- find the highest applying
            if not item_stack and not C.nwn_GetItemById(eff_cre) == nil then 
	       local item_idx = item_bonus[eff_cre]

               -- If the effect was applied by an item and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if item_idx then
                  bonus[item_idx] = effect_max(bonus[item_idx], amount)
               else
		  bonus[item_idx] = bon_idx
		  add_effect = true
               end
            -- If spells do not stack and the effect was applied via a spell, find the hightest
            -- applying
            elseif not spell_stack and sp_id ~= -1 then
	       local sp_idx = spell_pen[sp_id]
               -- If the effect was applied by a spell and an effect from that item has already
               -- been applied then take the highest of the two.  Otherwise set the adjustment.
               if sp_idx then
                  spell_bonus[sp_idx] = math.max(bonus[sp_idx], amount)
               else
                  spell_bonus[sp_id] = bon_idx
		  add_effect = true
               end
	    else
	       add_effect = true
	    end
	    
	    if add_effect then
	       bonus[bon_idx] = amount
	       bon_idx = bon_idx + 1
	    end
         end
      end
   end

   return bon_idx, pen_idx
end

--- Get effect bonus from critical hit multiplier.
-- @param vs Creature's target.
function Creature:GetEffectCritMultBonus()
   local amount, percent
   local eff_type
   local total = 0

   for i = self.ci.first_cm_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_CUSTOM or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE)
      then
         break
      end

      eff_type = self.obj.obj.obj_effects[i].eff_integers[0]
      amount   = self.obj.obj.obj_effects[i].eff_integers[1]
      percent  = self.obj.obj.obj_effects[i].eff_integers[2]

      if eff_type == nwn.EFFECT_CUSTOM_CRIT_MULT_DECREASE then
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      else
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      end
   end
   return total
end

--- Get effect bonus from critical range multiplier.
-- @param vs Creature's target
function Creature:GetEffectCritRangeBonus()
   local amount, percent
   local total = 0

   for i = self.ci.first_cr_effect, self.obj.obj.obj_effects_len - 1 do
      if self.obj.obj.obj_effects[i].eff_type > nwn.EFFECT_TRUETYPE_CUSTOM or
         (self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_INCREASE and
          self.obj.obj.obj_effects[i].eff_integers[0] ~= nwn.EFFECT_CUSTOM_CRIT_RANGE_DECREASE)
      then
         break
      end

      eff_type = self.obj.obj.obj_effects[i].eff_integers[0]
      amount   = self.obj.obj.obj_effects[i].eff_integers[1]
      percent  = self.obj.obj.obj_effects[i].eff_integers[2]

      if eff_type == nwn.EFFECT_CUSTOM_CRIT_RANGE_DECREASE then
	 if math.random(100) <= percent then
	    total = total - amount
	 end
      else
	 if math.random(100) <= percent then
	    total = total + amount
	 end
      end 
   end
   return total
end

--- Determine if creature has an immunity.
-- @param vs Creature's attacker.
-- @param imm_type nwn.IMMUNITY_TYPE_*
function Creature:GetEffectImmunity(vs, imm_type)
   local race, lawchaos, goodevil, subrace, deity, immunity, percent
   local trace, tgoodevil, tlawchaos, tdeity_id, tsubrace_id, target

   local total = 0
   local eff_type

   local vs_info = nwn.GetVersusInfo(vs)

   for i = self.stats.cs_first_imm_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_IMMUNITY then
         break
      end
      
      immunity  = self.obj.obj.obj_effects[i].eff_integers[0]
      race      = self.obj.obj.obj_effects[i].eff_integers[1]
      lawchaos  = self.obj.obj.obj_effects[i].eff_integers[2]
      goodevil  = self.obj.obj.obj_effects[i].eff_integers[3]
      percent   = self.obj.obj.obj_effects[i].eff_integers[4]
      subrace   = self.obj.obj.obj_effects[i].eff_integers[5]
      deity     = self.obj.obj.obj_effects[i].eff_integers[6]
      target    = self.obj.obj.obj_effects[i].eff_integers[6]
            
      if immunity == imm_type
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
      then
         total = total + percent
      end
   end

   if total >= 100 then 
      return true
   elseif total <= 0 then
      return false
   elseif total > math.random(100) then
      return true
   end

   return false
end

--- Determins if creature has a feat effect.
-- @param nwn.FEAT_*
function Creature:GetHasFeatEffect(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then 
      error "Invalid feat."
      return false 
   end
   return self:GetHasSpellEffect(f.feat_spell_id)
end

--- Determins if target is invisible.
-- @param vs Creature to test again.
function Creature:GetIsInvisible(vs)
   if vs.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, vs.obj.obj)
   end

   return false
end

--- Gets innate damage immunity.
-- @param dmg_idx damage type index
function Creature:GetDamageImmunity(dmg_idx)
   return self.ci.immunity[dmg_idx]
end

--- Gets innate damage immunity.
function Creature:GetInnateDamageReduction()
   return self.ci.soak
end

--- Get innate/feat damage resistance.
-- @param dmg_idx
function Creature:GetInnateDamageResistance(dmg_idx)
   return self.ci.resist[dmg_idx]
end

--- Get if creature has immunity.
-- @param immunity nwn.IMMUNITY_TYPE_*
-- @param versus (Default: nwn.OBJECT_INVALID)
function Creature:GetIsImmune(immunity, versus)
   versus = versus or nwn.OBJECT_INVALID
   return self:GetEffectImmunity(versus, immunity)
end

--- Update creature's damage resistance
-- Loops through creatures resistance effects and determines what the highest
-- applying effect is vs any particular damage.
function Creature:UpdateDamageResistance()
   local eff_type, amount, dmg_flg, idx
   local cur_eff

   for i = 0, NS_OPT_NUM_DAMAGES - 1 do
      self.ci.eff_resist[i] = -1
   end

   for i = self.stats.cs_first_dresist_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_RESISTANCE then
         break
      end

      dmg_flag = self.obj.obj.obj_effects[i].eff_integers[0]
      amount = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if dmg_flag > 0 then
         idx = nwn.GetDamageIndexFromFlag(dmg_flag)
         cur_eff = self.ci.eff_resist[idx]
         if cur_eff < 0 then
            self.ci.eff_resist[idx] = i
         else
            local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[1]
            local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
            
            -- If the resist amount is higher, set the resist effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount 
               or (amount == camount and limit > climit)
            then
               self.ci.eff_resist[idx] = i
            end
         end
      end
   end
end

--- Update creature's damage reduction
-- Loops through creatures DR effects and determines what the highest
-- applying effect is at each damage power.
function Creature:UpdateDamageReduction()
   local eff_type, amount, dmg_power, dur_type, limit
   local cur_eff
   
   -- Reset the soak effect index list.
   for i = 0, 20 do
      self.ci.eff_soak[i] = -1
   end

   for i = self.stats.cs_first_dred_eff, self.obj.obj.obj_effects_len - 1 do
      eff_type = self.obj.obj.obj_effects[i].eff_type

      -- Only check damage reduction effects.
      if eff_type ~= nwn.EFFECT_TRUETYPE_DAMAGE_REDUCTION then
         break
      end

      amount = self.obj.obj.obj_effects[i].eff_integers[0]
      dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
      limit = self.obj.obj.obj_effects[i].eff_integers[2]
      
      cur_eff = self.ci.eff_soak[dmg_power]
      if cur_eff < 0 then
         self.ci.eff_soak[dmg_power] = i
      else
         local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[0]
         local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]
         
         -- If the soak amount is higher, set the soak effect list to the effect index.
         -- If they are equal prefer the one with the highest damage limit.
         if amount > camount 
            or (amount == camount and limit > climit)
         then
            self.ci.eff_soak[dmg_power] = i
         end
      end
   end
end

--------------------------------------------------------------------------------
-- Bridge functions to/from nwnx_solstice plugin.

--- Internal GetEffectImmunity function.
-- Called from the nwnx_solstice plugin.
-- @param cre Creature to test for immunity.
-- @param vs Creature to test versus.
-- @param imm_type nwn.IMMUNITY_TYPE_*
function NSGetEffectImmunity(cre, vs, imm_type)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)
   return cre:GetEffectImmunity(vs, imm_type)
end

--- Internal SetDamageImmunity function.
-- Called from the nwnx_solstice plugin.
-- @param obj Object
-- @param dmg_flag nwn.DAMAGE_TYPE_*
-- @param amount Immunity percent.
function NSSetDamageImmunity(obj, dmg_flag, amount)
   obj = _NL_GET_CACHED_OBJECT(obj)
   local idx = nwn.GetDamageIndexFromFlag(dmg_flag)
   if obj.type == nwn.GAME_OBJECT_TYPE_CREATURE then
      obj.ci.immunity[idx] = amount
   end
end
