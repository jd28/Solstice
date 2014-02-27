--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local Obj = require 'solstice.object'
local M = require 'solstice.creature.init'
local Creature = M.Creature

local USE_VERSUS = OPT.USE_VERSUS
local random = math.random

--- Effects
-- @section effects

local ffi = require 'ffi'
local C = ffi.C

function Creature:CreateEffectDebugString()
   for eff in self:EffectsDirect() do
      table.insert(t, eff:ToString())
   end

   return table.concat(t, "\n")
end

--- Determine if creature has an immunity.
-- @param imm_type IMMUNITY_TYPE_*
-- @param[opt] vs Creature's attacker.
function Creature:GetEffectImmunity(imm_type, vs)
   if not self:GetIsValid() or
      imm_type < 0 or imm_type >= IMMUNITY_TYPE_NUM
   then
      return 0
   end

   if USE_VERSUS then
      error "Net yet implimented"
   end

   return self.ci.defense.immunity_misc[imm_type]
end

--- Determins if creature has a feat effect.
-- @param feat FEAT\_*
function Creature:GetHasFeatEffect(feat)
   local f = C.nwn_GetFeat(feat)
   if f == nil then return false end
   return self:GetHasSpellEffect(f.feat_spell_id)
end

--- Determins if target is invisible.
-- @param vs Creature to test again.
function Creature:GetIsInvisible(vs)
   if vs.type == OBJECT_TRUETYPE_CREATURE then
      return C.nwn_GetIsInvisible(self.obj, vs.obj.obj)
   end

   return false
end

--- Gets innate damage immunity.
-- @param dmg_idx damage type index
function Creature:GetInnateDamageImmunity(dmg_idx)
   return Rules.GetBaseDamageImmunity(self, dmg_idx)
end

--- Gets innate damage immunity.
function Creature:GetInnateDamageReduction()
   return Rules.GetBaseDamageReduction()
end

--- Get innate/feat damage resistance.
-- @param dmg_idx
function Creature:GetInnateDamageResistance(dmg_idx)
   return Rules.GetBaseDamageResistance(self, dmg_idx)
end

--- Get if creature has immunity.
-- @param immunity IMMUNITY_TYPE_*
-- @param[opt] versus Versus object.
function Creature:GetIsImmune(immunity, versus)
   local imm = self:GetEffectImmunity(immunity, versus)
   if imm <= 0 then return false
   elseif imm >= 100 then return true
   end

   return random(100) <= imm
end

---
-- TODO: Fix damage count
function Creature:UpdateDamageImmunity()
   if not self:GetIsValid() then return end
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      self.ci.defense.immunity_base[i] = self:GetInnateDamageImmunity(i)
   end
end

---
-- TODO: Fix damage count
function Creature:UpdateDamageResistance()
   if not self:GetIsValid() then return end
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      self.ci.defense.resist[i] = self:GetInnateDamageReduction(i)
   end
end

function Creature:UpdateDamageReduction()
   if not self:GetIsValid() then return end
   self.ci.defense.soak = self:GetInnateDamageReduction()
end

--- Update creature's damage resistance
-- Loops through creatures resistance effects and determines what the highest
-- applying effect is vs any particular damage.
function Creature:UpdateDamageResistanceEffects(index, effect, is_remove)
   if not index then
      for i = 0, DAMAGE_INDEX_NUM - 1 do
         self:SetDamageResistanceEffect(i, -1)
      end
   else
      self:SetDamageResistanceEffect(index, -1)
   end

   for i = self.obj.cre_stats.cs_first_dresist_eff, self.obj.obj.obj_effects_len - 1 do
      local eff_type = self.obj.obj.obj_effects[i].eff_type

      if eff_type ~= EFFECT_TYPE_DAMAGE_RESISTANCE then break end

      local idx = C.ns_BitScanFFS(self.obj.obj.obj_effects[i].eff_integers[0])
      local amount = self.obj.obj.obj_effects[i].eff_integers[1]
      local limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if (not index or dmg_index == index) and
         (not effect or self.obj.obj.obj_effects[i].eff_id ~= effect:GetId())
      then
         local cur_eff = self.ci.defense.resist_eff[idx]
         if cur_eff < 0 and amount > 0 then
            self:SetDamageResistanceEffect(idx, i)
         else
            local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[1]
            local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]

            -- If the resist amount is higher, set the resist effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount or (amount == camount and limit > climit) then
               self:SetDamageResistanceEffect(idx, i)
            end
         end
      end
   end
end

--- Update creature's damage reduction
-- Loops through creatures DR effects and determines what the highest
-- applying effect is at each damage power.
function Creature:UpdateDamageReductionEffects(power)
   -- Reset the soak effect index list.
   if not power then
      for i = 0, DAMAGE_POWER_NUM - 1 do
         self:SetDamageReductionEffect(i, -1)
      end
   else
      self:SetDamageReductionEffect(power, -1)
   end

   for i = self.obj.cre_stats.cs_first_dred_eff, self.obj.obj.obj_effects_len - 1 do
      local eff_type = self.obj.obj.obj_effects[i].eff_type

      -- Only check damage reduction effects.
      if eff_type ~= EFFECT_TYPE_DAMAGE_REDUCTION then break end

      local amount = self.obj.obj.obj_effects[i].eff_integers[0]
      local dmg_power = self.obj.obj.obj_effects[i].eff_integers[1]
      local limit = self.obj.obj.obj_effects[i].eff_integers[2]

      if not power or dmg_power == power then
         local cur_eff = self.ci.defense.soak_eff[dmg_power]
         if cur_eff < 0 and amount > 0 then
            self:SetDamageReductionEffect(dmg_power, i)
         else
            local camount = self.obj.obj.obj_effects[cur_eff].eff_integers[0]
            local climit = self.obj.obj.obj_effects[cur_eff].eff_integers[2]

            -- If the soak amount is higher, set the soak effect list to the effect index.
            -- If they are equal prefer the one with the highest damage limit.
            if amount > camount or (amount == camount and limit > climit) then
               self:SetDamageReductionEffect(dmg_power, i)
            end
         end
      end
   end
end
