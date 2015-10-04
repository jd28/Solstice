--- Rules module
-- @module rules

local ffi = require 'ffi'
local C = ffi.C
local _DMG_IMM = {}
local _DMG_RED = {}

--- Damage Modifiers
-- @section

--- Get base damage immunity.
-- @param cre Creature object.
-- @param dmgidx DAMAGE_INDEX_*
local function GetBaseDamageImmunity(cre, dmgidx)
   local f = _DMG_IMM[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage immunity override function.
-- @func func (creature) -> int
-- @param ... DAMAGE_INDEX_*
local function SetBaseDamageImmunityOverride(func, ...)
  local t = table.pack(...)
  for i=1, t.n do
    if not t[i] then
      local Log = System.GetLogger()
      Log:error("Null damage type.  Stack Trace:\n%s", debug.traceback())
    else
      _DMG_IMM[t[i]] = func
    end
  end
end

local function rdd(cre)
   local res = 0
   if cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) >= 10 then
      res = 100
   end
   return res
end

SetBaseDamageImmunityOverride(rdd, DAMAGE_INDEX_FIRE)

--- Get base damage reduction.
-- @param cre Creature object.
local function GetBaseDamageReduction(cre)
   local res = 0
   if cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9) then
      res = res + 9
   elseif cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6) then
      res = res + 6
   elseif cre:GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3) then
      res = res + 3
   end

   local barb = cre:GetLevelByClass(CLASS_TYPE_BARBARIAN)
   if barb > 10 then
      res = res + math.ceil((barb - 10) / 3)
   end

   local dd =  cre:GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER)
   if dd > 5 then
      res = res + 3 + (math.floor((dd - 6) / 4) * 3)
   end
   return res
end

--- Get base damage reduction.
-- @param cre Creature object.
-- @param dmgidx DAMAGE_INDEX_*
local function GetBaseDamageResistance(cre, dmgidx)
   local f = _DMG_RED[dmgidx]
   if not f then return 0 end
   return f(cre)
end

--- Sets a damage resistance override function.
-- @func func (creature) -> int
-- @param ... DAMAGE_INDEX_*
local function SetBaseDamageResistanceOverride(func, ...)
  local t = table.pack(...)
  for i=1, t.n do
    if not t[i] then
      local Log = System.GetLogger()
      Log:error("Null damage type.  Stack Trace:\n%s", debug.traceback())
    else
      _DMG_RED[t[i]] = func
    end
  end
end

local DMG_IMMUNITIES = ffi.new('int32_t[?]', DAMAGE_INDEX_NUM)

local function GetEffectDamageImmunity(obj, dmgidx)
  ffi.fill(DMG_IMMUNITIES, 4 * DAMAGE_INDEX_NUM)
  for i = 0, obj.obj.obj.obj_effects_len - 1 do
    local type = obj.obj.obj.obj_effects[i].eff_type
    if type > EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then break end
    local idx = C.ns_BitScanFFS(obj.obj.obj.obj_effects[i].eff_integers[0])

    if type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
       or type == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE
    then
      local amt = obj.obj.obj.obj_effects[i].eff_integers[1]
      if type == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE then
        amt = -amt
      end
      DMG_IMMUNITIES[idx] = DMG_IMMUNITIES[idx] + amt
    end
  end

  if dmgidx then
    return DMG_IMMUNITIES[dmgidx]
  else
    return DMG_IMMUNITIES
  end
end

local function GetEffectDamageImmunityLimits(obj)
  return -100, 100
end

local function DebugDamageImmunity(cre)
  local t = { "Damage Immunities" }
  local effs = GetEffectDamageImmunity(cre)
  for i=0, DAMAGE_INDEX_NUM - 1 do
    table.insert(t,
      string.format("  %s: Effects: %d; Innate: %d",
                    Rules.GetDamageName(i),
                    effs[i],
                    GetBaseDamageImmunity(cre, i)))
  end
  return table.concat(t, '\n')
end

--- Determines damage immunity adjustment.
-- @param amt Damage amount.
-- @param dmgidx Damage index DAMAGE_INDEX_*
-- @return Both the adjusted damage amt and the amount resisted will
-- be returned.
local function DoDamageImmunity(obj, amt, dmgidx)
  -- If the damage index is invalid... skip it.
  if dmgidx < 0 or dmgidx >= DAMAGE_INDEX_NUM or amt <= 0 then
    return amt, 0
  end
  local min, max = GetEffectDamageImmunityLimits(obj)
  local innate = 0
  if obj.type == OBJECT_TRUETYPE_CREATURE then
    innate = GetBaseDamageImmunity(obj, dmgidx)
  end
  local imm = math.max(GetEffectDamageImmunity(obj, dmgidx) + innate, innate)
  imm = math.clamp(imm, min, max)
  if imm == 100 then return 0, amt end

  local imm_adj = math.floor((imm * amt) / 100)

  return amt - imm_adj, imm_adj
end

--- Determine best damage reduction effect.
-- @param dmgidx DAMAGE_INDEX_*
-- @param[opt=0] start Place in object effect array to start looking.
local function GetBestDamageResistEffect(obj, dmgidx, start)
   start = start or 0

   local cur, camount, climit
   local flag = bit.lshift(1, dmgidx)

   for i = start, obj.obj.obj.obj_effects_len - 1 do
      if obj.obj.obj.obj_effects[i].eff_type > EFFECT_TYPE_DAMAGE_RESISTANCE then
         return cur, i
      end

      if obj.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_RESISTANCE then
         if obj.obj.obj.obj_effects[i].eff_integers[0] > flag then
            return cur, i
         end

         local amount = obj.obj.obj.obj_effects[i].eff_integers[1]
         local limit = obj.obj.obj.obj_effects[i].eff_integers[2]

         if amount > 0 and obj.obj.obj.obj_effects[i].eff_integers[0] == flag then
            if not cur then
               cur, camount, climit = obj.obj.obj.obj_effects[i], amount, limit
            else
               -- If the resist amount is higher, set the resist effect list to the effect index.
               -- If they are equal prefer the one with the highest damage limit.
               if amount > camount or (amount == camount and limit > climit) then
                  cur, camount, climit = obj.obj.obj.obj_effects[i], amount, limit
               end
            end
         end
      end
   end
end

--- Debug damage resistance.
local function DebugDamageResistance(cre)
   local t = {}
   local eff
   local start = cre.obj.cre_stats.cs_first_dmgresist_eff
   if start <= 0 then start = 0 end

   table.insert(t, "Damage Resist:")

   for i = 0, DAMAGE_INDEX_NUM - 1 do
      eff, start = GetBestDamageResistEffect(cre, i, start)

      if eff then
        table.insert(t, string.format('  %s: Innate: %d, Effect: %d/- Limit: %d',
                                      Rules.GetDamageName(i),
                                      GetBaseDamageResistance(cre, dmgidx),
                                      eff.eff_integers[1],
                                      eff.eff_integers[2]))
      else
         table.insert(t, string.format('  %s: Innate: %d',
                                       Rules.GetDamageName(i),
                                       GetBaseDamageResistance(cre, dmgidx)))
      end
   end
   return table.concat(t, '\n')
end


--- Determine best damage reduction effect.
-- @param power Damage power.
-- @param[opt=0] start Place in object effect array to start looking.
local function GetBestDamageReductionEffect(obj, power, start)
   local cur, camount, climit
   start = start or 0

   for i = start, obj.obj.obj.obj_effects_len - 1 do
      -- Only check damage reduction effects.
      if obj.obj.obj.obj_effects[i].eff_type >
         EFFECT_TYPE_DAMAGE_REDUCTION then return cur end

      if obj.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_REDUCTION then
         local amount = obj.obj.obj.obj_effects[i].eff_integers[0]
         local dmg_power = obj.obj.obj.obj_effects[i].eff_integers[1]
         local limit = obj.obj.obj.obj_effects[i].eff_integers[2]

         if dmg_power > power then
            if not cur and amount > 0 then
               cur, camount, climit = obj.obj.obj.obj_effects[i], amount, limit
            else
               -- If the soak amount is higher, set the soak effect list to the effect index.
               -- If they are equal prefer the one with the highest damage limit.
               if amount > camount or (amount == camount and limit > climit) then
                  cur, camount, climit = obj.obj.obj.obj_effects[i], amount, limit
               end
            end
         end
      end
   end
end

--- Debug damage reduction.
local function DebugDamageReduction(cre)
   local t = {}
   local eff
   local start = cre.obj.cre_stats.cs_first_dmgred_eff
   if start <= 0 then start = 0 end

   table.insert(t, "Damage Reduction:")
   table.insert(t, string.format('  Innate: %d', GetBaseDamageReduction(cre)))

   for i=0, DAMAGE_POWER_NUM - 1 do
      eff, start = GetBestDamageReductionEffect(cre, i, start)
      if eff then
         table.insert(t, string.format('  %d: Effect: %d/+%d Limit: %d',
                                       i,
                                       eff.eff_integers[0],
                                       i,
                                       eff.eff_integers[2]))
      end
   end
   return table.concat(t, '\n')
end

--- Resolves damage resistance.
-- @param amt Damage amount.
-- @param eff Damage Resistance effect if any.
-- @param dmgidx DAMAGE_INDEX_*
-- @return Adjusted damage amount.
-- @return Adjustment amount.
local function DoDamageResistance(obj, amt, eff, dmgidx)
   if amt <= 0 then return amt, 0 end

   local resist = GetBaseDamageResistance(obj, dmgidx)
   local total = amt
   local resist_adj = 0
   local remove_effect = false

   -- Innate / Feat resistance.  In the case of damage reduction these stack
   -- with damage resistance effects.
   -- If the resistance is greater than zero, use it.
   if resist > 0 then
      -- Take the minimum of damage and resistance, since you can't resist
      -- more damage than you take.
      resist_adj = min(amt, resist)
      total = amt - resist_adj
   end

   if total > 0 and eff then
      -- Take the minimum of current damage told and effect resistance.
      local eff_resist_adj = min(eff.eff_integers[1], total)
      local eff_limit = eff.eff_integers[2]
      if eff_limit > 0 then
         -- If the remaining damage limit is less than the amount to resist.
         -- then resist only what is left and remove the effect.
         -- Else modifiy the effects damage limit by the resist amount.
         if eff_limit <= eff_resist_adj then
            eff_resist_adj = eff_limit
            C.nwn_RemoveEffectById(obj.obj.obj, eff.eff_id)
            remove_effect = true
         else
            eff.eff_integers[2] = eff_limit - eff_resist_adj
         end
      end
      resist_adj = resist_adj + eff_resist_adj
   end
   return amt - resist_adj, resist_adj, remove_effect
end

--- Resolves damage reduction.
-- @param amt Damage amount.
-- @param eff Damage reduction effect if any.
-- @param power DAMAGE_POWER_*
-- @return Adjusted damage amount.
-- @return Adjustment amount.
local function DoDamageReduction(obj, amt, eff, power)
   if amt <= 0 or power <= 0 then return amt, 0 end
   -- Set highest soak amount to the players innate soak.  E,g their EDR
   -- Dwarven Defender, and/or Barbarian Soak.
   local highest_soak = obj:GetHardness()
   local use_eff
   local remove_effect = false

   if eff then
      use_eff = eff.eff_integers[0] > highest_soak
      highest_soak = max(eff.eff_integers[0], highest_soak)
   end

   -- Now that the highest soak amount has been found, determine the minimum of it and
   -- the base damage.  I.e. you can't soak more than your damamge.
   highest_soak = min(amt, highest_soak)


   -- If using a soak effect determine if the effect has a limit and adjust it if so.
   if use_eff then
      local eff_limit = eff.eff_integers[2]
      if eff_limit > 0 then
         -- If the effect damage limit is less than the highest soak amount then
         -- the effect needs to be remove and the highest soak amount adjusted. I.e.
         -- You can't soak more than the remaing limit on soak damage.
         -- Else the current limit must be adjusted by the highest soak amount.
         if eff_limit <= highest_soak then
            highest_soak = eff_limit
            C.nwn_RemoveEffectById(obj.obj.obj, eff.eff_id)
            remove_effect = true
         else
            eff.eff_integers[2] = eff_limit - highest_soak
         end
      end
   end

   return amt - highest_soak, highest_soak, remove_effect
end


local M = require 'solstice.rules.init'
M.DebugDamageImmunity             = DebugDamageImmunity
M.DebugDamageResistance           = DebugDamageResistance
M.DebugDamageReduction            = DebugDamageReduction
M.DoDamageImmunity                = DoDamageImmunity
M.DoDamageReduction               = DoDamageReduction
M.DoDamageResistance              = DoDamageResistance
M.GetBaseDamageImmunity           = GetBaseDamageImmunity
M.GetBaseDamageReduction          = GetBaseDamageReduction
M.GetBaseDamageResistance         = GetBaseDamageResistance
M.GetBestDamageResistEffect       = GetBestDamageResistEffect
M.GetBestDamageReductionEffect    = GetBestDamageReductionEffect
M.GetEffectDamageImmunity         = GetEffectDamageImmunity
M.GetEffectDamageImmunityLimits   = GetEffectDamageImmunityLimits
M.SetBaseDamageImmunityOverride   = SetBaseDamageImmunityOverride
M.SetBaseDamageResistanceOverride = SetBaseDamageResistanceOverride