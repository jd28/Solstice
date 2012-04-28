--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

require 'nwn.class'

function Creature:CanUseClassAbilities(class)
   return true
--   local f = nwn.GetClassAbilityRequirements()
--   if not f then return true end
--
--   return f(self)
end

---
function Creature:Classes()
   if not self:GetIsValid() then return end
   local i, count, _i = 0, self.stats.cs_classes_len
   return function ()
      while i < count do
         _i, i = i, i + 1
         return self.stats.cs_classes[_i]
      end
   end
end

---
-- @param level
function Creature:GetClassByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = ffi.C.nl_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_class
end

---
-- @param domain
function Creature:GetClericDomain(domain)
   if not self:GetIsValid() then return -1 end

   domain = domain or 1
   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for class in self:Classes() do
      if class.cl_class == nwn.CLASS_TYPE_CLERIC then
         if domain == 1 then
            return class.cl_domain_1
         else
            return class.cl_domain_2
         end
      end
   end
   return -1
end

---
-- @param class
function Creature:GetLevelByClass(class)
   for cl in self:Classes() do
      if cl_class == class then
         return cl.cl_level
      end
   end

   return 0
end

---
-- @param position
function Creature:GetLevelByPosition(position)
   if position < 0 or position > 2 then 
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return 0 end

   local cl = self.stats.cs_classes[position]
   if cl == nil then return 0 end

   return cl.cl_level
end

---
-- @param position
function Creature:GetClassByPosition(position)
   if position < 0 or position > 2 then 
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return 0 end

   local cl = self.stats.cs_classes[position]
   if cl == nil then return 0 end

   return cl.cl_class
end

---
function Creature:GetWizardSpecialization()
   if not self:GetIsValid() then return -1 end

   for class in self:Classes() do
      if class.cl_class == nwn.CLASS_TYPE_WIZARD then
         return class.cl_specialist
      end
   end

   return -1
end

---
-- @param domain
-- @param newdomain
function Creature:SetClericDomain(domain, newdomain)
   if not self:GetIsValid() then return -1 end

   domain = domain or 1
   if not newdomain then 
      error "A new domain must be specified"
   end

   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for class in self:Classes() do
      if class.cl_class == nwn.CLASS_TYPE_CLERIC then
         if domain == 1 then
            class.cl_domain_1 = newdomain
         else
            class.cl_domain_2 = newdomain
         end
         return newdomain
      end
   end
   return -1
end

---
-- @param specilization
function Creature:SetWizardSpecialization(specilization)
   if not self:GetIsValid() then return -1 end

   for class in self:Classes() do
      if class.cl_class == nwn.CLASS_TYPE_WIZARD then
         class.cl_specialist = specilization
         return specilization
      end
   end

   return -1
end

function Creature:UpdateClassCombatBonus(class)
   if not self:CanUseClassAbilities(class) then return end

   local f = nwn.GetClassCombatBonus(class)
   if not f then return end

   f(self)
end