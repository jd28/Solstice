--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )

local class_ability_reqs = {}

--- Get class ability requirements
function nwn.GetClassAbilityRequirements(class)
   return class_ability_reqs[class]
end

--- Set class ability requirements
-- @param class nwn.CLASS_TYPE_*
-- @param f A function that takes an object and a class type and returns true
--    if the object can use the class abilities, false if not.
function nwn.SetClassAbilityRequirements(class, f)
   class_ability_reqs[class] = f
end