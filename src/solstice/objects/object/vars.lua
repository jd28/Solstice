--- Object
-- @module object

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local NWE = require 'solstice.nwn.engine'
local Object = M.Object

--- Class Object: Variables
-- @section vars

local function get_var_table(obj)
   if obj.type == OBJECT_TRUETYPE_MODULE then
      return obj.obj.mod_vartable
   elseif obj.type == OBJECT_TRUETYPE_AREA then
      return obj.obj.area_vartable
   else
      return obj.obj.obj.obj_vartable
   end
end

local function get_var_value(var)
   if var.var_type == VARIABLE_TYPE_OBJECT then
      return var.var_value.val_object
   elseif var.var_type == VARIABLE_TYPE_FLOAT then
      return var.var_value.val_float
   elseif var.var_type == VARIABLE_TYPE_INT then
      return var.var_value.val_int
   elseif var.var_type == VARIABLE_TYPE_STRING then
      return ffi.string(var.var_value.val_string.text)
   elseif var.var_type == VARIABLE_TYPE_LOCATION then
      error "Unsupported"
   end

end

function Object:GetLocalVarCount()
   if not self:GetIsValid() then return 0 end
   local vt = get_var_table(self)
   return vt.vt_len
end

function Object:GetLocalVarByIndex(index)
   if not self:GetIsValid() then return end
   local vt = get_var_table(self)
   if index >= vt.vt_len then return end
   return vt.vt_list[index]
end

function Object:GetAllVars(match, type)
   local res = {}
   for i = 0, self:GetLocalVarCount() - 1 do
      local var = self:GetLocalVarByIndex(i)
      local name = ffi.string(var.var_name.text)
      if (not type or var.var_type == type) and
         (not match or string.find(name, match))
      then
         res[name] = get_var_value(var)
      end
   end
   return res
end

function Object:DecrementLocalInt(name, val)
   if not self:GetIsValid() then return end
   val = val or 1

   local newval = self:GetLocalInt(name) - val
   self:SetLocalInt(name, newval)
   return newval
end

function Object:DeleteLocalBool(name)
   self:DeleteLocalInt(name)
end

function Object:DeleteLocalInt(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(265, 2)
end

function Object:DeleteLocalFloat(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(266, 2)
end

function Object:DeleteLocalString(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(267, 2)
end

function Object:DeleteLocalObject(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(268, 2)
end

function Object:DeleteLocalLocation(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(269, 2)
end

function Object:GetLocalBool(name)
   return self:GetLocalInt(name) ~= 0
end

function Object:GetLocalInt(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(51, 2)
   return NWE.StackPopInteger()
end

function Object:GetLocalFloat(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(52, 2)
   return NWE.StackPopFloat()
end

function Object:GetLocalLocation(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(153, 2)
   return NWE.StackPopLocation()
end

function Object:GetLocalObject(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(54, 2)
   return NWE.StackPopObject()
end

function Object:GetLocalString(name)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommandUnsafe(53, 2)
   local s = NWE.StackPopString()
   return s
end

function Object:IncrementLocalInt(name, val)
   val = val or 1

   local newval = self:GetLocalInt(name) + val
   self:SetLocalInt(name, newval)
   return newval
end

function Object:SetLocalBool(name, val)
   self:SetLocalInt(name, val and 1 or 0)
end

function Object:SetLocalFloat(name, val)
   NWE.StackPushFloat(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(56, 3)
end

function Object:SetLocalInt(name, val)
   NWE.StackPushInteger(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(55, 3)
end

function Object:SetLocalLocation(name, val)
   NWE.StackPushLocation(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(152, 3)
end

function Object:SetLocalString(name, val)
   NWE.StackPushString(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(57, 3)
end

function Object:SetLocalObject(name, val)
   NWE.StackPushObject(val)
   NWE.StackPushString(name)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(58, 3)
end
