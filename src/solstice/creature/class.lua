--- Class
-- @module creature

local M = require 'solstice.creature.init'

--- Class
-- @section class

--- Determine's if a creature can use a classes abilities.
-- @param class CLASS\_TYPE\_* constant
function M.Creature:CanUseClassAbilities(class)
   return true
--   local f = solstice.nwn.GetClassAbilityRequirements()
--   if not f then return true end
--
--   return f(self)
end

--- Iterator over creature's classes
function M.Creature:Classes()
   if not self:GetIsValid() then return end
   local i, count, _i = 0, self.stats.cs_classes_len
   return function ()
      while i < count do
         _i, i = i, i + 1
         return self.stats.cs_classes[_i]
      end
   end
end

--- Determines class that was chosen at a particular level.
-- @param level Level to get class at.
-- @return CLASS\_TYPE\_* constant or -1 on error.
function M.Creature:GetClassByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return -1 end

   return ls.ls_class
end

--- Determines a cleric's domain.
-- @param domain Cleric's first or second domain
function M.Creature:GetClericDomain(domain)
   if not self:GetIsValid() then return -1 end
   if domain ~= 1 and domain ~= 2 then
      error "Invalid domain."
      return -1
   end

   domain = domain or 1
   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for class in self:Classes() do
      if class.cl_class == CLASS_TYPE_CLERIC then
         if domain == 1 then
            return class.cl_domain_1
         else
            return class.cl_domain_2
         end
      end
   end
   return -1
end

--- Get number of levels a creature by class
-- @param class CLASS\_TYPE\_* type constant.
function M.Creature:GetLevelByClass(class)
   for cl in self:Classes() do
      if cl.cl_class == class then
         return cl.cl_level
      end
   end

   return 0
end

--- Get number of levels a creature by position
-- @param position Valid values: 0, 1, or 2
function M.Creature:GetLevelByPosition(position)
   if position < 0 or position > 2 then
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return 0 end

   local cl = self.stats.cs_classes[position]
   if cl == nil then return 0 end

   return cl.cl_level
end

function M.Creature:GetLevelStats(level)
   if level < 1 or level > self.stats.cs_levelstat_len then
      return
   end

   return self.stats.cs_levelstat[level - 1];
end

--- Get class type by position
-- @param position Valid values: 0, 1, or 2
function M.Creature:GetClassByPosition(position)
   if position < 0 or position > 2 then
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return 0 end

   local cl = self.stats.cs_classes[position]
   if cl == nil then return 0 end

   return cl.cl_class
end

--- Gets a creature's wizard specialization.
function M.Creature:GetWizardSpecialization()
   if not self:GetIsValid() then return -1 end

   for class in self:Classes() do
      if class.cl_class == CLASS_TYPE_WIZARD then
         return class.cl_specialist
      end
   end

   return -1
end

--- Sets a cleric's domain.
-- @param domain Cleric's first or second domain
-- @param newdomain See domains.2da
function M.Creature:SetClericDomain(domain, newdomain)
   if not self:GetIsValid() then return -1 end

   domain = domain or 1
   if not newdomain then
      error "A new domain must be specified"
   end

   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for class in self:Classes() do
      if class.cl_class == CLASS_TYPE_CLERIC then
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

--- Set a wizard's specialization.
-- @param specialization see schools.2da
function M.Creature:SetWizardSpecialization(specialization)
   if not self:GetIsValid() then return -1 end

   for class in self:Classes() do
      if class.cl_class == CLASS_TYPE_WIZARD then
         class.cl_specialist = specilization
         return specilization
      end
   end

   return -1
end
