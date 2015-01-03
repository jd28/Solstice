--- Class
-- @module creature

local M = require 'solstice.creature.init'
local Creature = M.Creature

--- Class
-- @section class

--- Iterator over creature's classes
function Creature:Classes()
   if not self:GetIsValid() then return end
   local i, count, _i = 0, self.obj.cre_stats.cs_classes_len
   return function ()
      while i < count do
         _i, i = i, i + 1
         return self.obj.cre_stats.cs_classes[_i]
      end
   end
end

--- Determines class that was chosen at a particular level.
-- @param level Level to get class at.
-- @return CLASS\_TYPE\_* constant or -1 on error.
function Creature:GetClassByLevel(level)
   if not self:GetIsValid() then return -1 end

   local ls = self:GetLevelStats(level)
   if ls == nil then return -1 end

   return ls.ls_class
end

--- Determines a cleric's domain.
-- @param domain Cleric's first or second domain
function Creature:GetClericDomain(domain)
   if not self:GetIsValid() then return -1 end
   if domain ~= 1 and domain ~= 2 then
      error "Invalid domain."
      return -1
   end

   domain = domain or 1
   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      if self.obj.cre_stats.cs_classes[i].cl_class == CLASS_TYPE_CLERIC then
         if domain == 1 then
            return self.obj.cre_stats.cs_classes[i].cl_domain_1
         else
            return self.obj.cre_stats.cs_classes[i].cl_domain_2
         end
      end
   end

   return -1
end

--- Get number of levels a creature by class
-- @param class CLASS\_TYPE\_* type constant.
function Creature:GetLevelByClass(class)
   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      if self.obj.cre_stats.cs_classes[i].cl_class == class then
         return self.obj.cre_stats.cs_classes[i].cl_level
      end
   end
   return 0
end

--- Get number of levels a creature by position
-- @param position Valid values: 0, 1, or 2
function Creature:GetLevelByPosition(position)
   if position < 0 or position > 2 then
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return 0 end

   local cl = self.obj.cre_stats.cs_classes[position]
   if cl == nil then return 0 end

   return cl.cl_level
end

function Creature:GetLevelStats(level)
   if level < 1 or level > self.obj.cre_stats.cs_levelstat_len then
      return
   end

   return self.obj.cre_stats.cs_levelstat[level - 1];
end

--- Get class type by position
-- @param position Valid values: 0, 1, or 2
-- @return -1 on error.
function Creature:GetClassByPosition(position)
   if position < 0 or position > 2 then
      error("Invalid class position: " .. position)
   end

   if not self:GetIsValid() then return -1 end

   local cl = self.obj.cre_stats.cs_classes[position]
   if cl == nil then return -1 end

   return cl.cl_class
end

--- Determins class postion by class type.
-- @param class CLASS\_TYPE\_*
-- @return 0, 1, 2, or -1 on error.
function Creature:GetPositionByClass(class)
   if self:GetClassByPosition(0) == class then
      return 0
   elseif self:GetClassByPosition(1) == class then
      return 1
   elseif self:GetClassByPosition(2) == class then
      return 2
   end

   return -1
end

--- Gets a creature's wizard specialization.
function Creature:GetWizardSpecialization()
   if not self:GetIsValid() then return -1 end

   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      if self.obj.cre_stats.cs_classes[i].cl_class == CLASS_TYPE_WIZARD then
         return self.obj.cre_stats.cs_classes[i].cl_specialist
      end
   end
   return -1
end

--- Sets a cleric's domain.
-- @param domain Cleric's first or second domain
-- @param newdomain See domains.2da
function Creature:SetClericDomain(domain, newdomain)
   if not self:GetIsValid() then return -1 end

   domain = domain or 1
   if not newdomain then
      error "A new domain must be specified"
   end

   if domain ~= 1 or domain ~= 2 then
      return -1
   end

   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      if self.obj.cre_stats.cs_classes[i].cl_class == CLASS_TYPE_CLERIC then
         if domain == 1 then
            self.obj.cre_stats.cs_classes[i].cl_domain_1 = newdomain
         else
            self.obj.cre_stats.cs_classes[i].cl_domain_2 = newdomain
         end
      end
      return newdomain
   end
   return -1
end

--- Set a wizard's specialization.
-- @param specialization see schools.2da
function Creature:SetWizardSpecialization(specialization)
   if not self:GetIsValid() then return -1 end

   for i=0, self.obj.cre_stats.cs_classes_len -1 do
      if self.obj.cre_stats.cs_classes[i].cl_class == CLASS_TYPE_WIZARD then
         self.obj.cre_stats.cs_classes[i].cl_specialist = specialization
         return specialization
      end
   end

   return -1
end

--- Determins creatures highest class level
-- @return CLASS\_TYPE\_*, level
function Creature:GetHighestLevelClass()
   local hclass, hlevel = -1, -1
   for class in self:Classes() do
      if class.cl_level > hlevel then
         hclass, hlevel = class.cl_class, class.cl_level
      end
   end
   return hclass, hlevel
end
