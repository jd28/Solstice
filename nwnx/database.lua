-- Name     : Avlis Persistence System include
-- Purpose  : Various APS/NWNX2 related functions
-- Authors  : Ingmar Stieger, Adam Colon, Josh Simon
-- Modified : January 1st, 2005

-- This file is licensed under the terms of the
-- GNU GENERAL PUBLIC LICENSE (GPL) Version 2

NWNXDb = {}

local DEFAULT_TABLE = "pwdata"
local DEFAULT_OBJECT_TABLE = "pwobjdata"

-- Return codes
NWNXDb.SQL_ERROR = 0
NWNXDb.SQL_SUCCESS = 1

local mod

-- Functions for initializing APS and working with result sets

function NWNXDb.SQLInit()
   mod = mod or nwn.GetModule()
   mod:SetLocalString("NWNX!ODBC!SPACER", string.rep('.', 8*128))
end

function NWNXDb.SQLExecDirect(sql)
   mod = mod or nwn.GetModule()
   mod:SetLocalString("NWNX!ODBC!EXEC", sql)
end

local result_set

function NWNXDb.SQLFetch()
   mod = mod or nwn.GetModule()
   -- Reset the result set.
   result_set = nil

   mod:SetLocalString("NWNX!ODBC!FETCH", mod:GetLocalString("NWNX!ODBC!SPACER"))
   local row = mod:GetLocalString("NWNX!ODBC!FETCH");
   if #row > 0 then
      mod:SetLocalString("NWNX_ODBC_CurrentRow", row)
      return NWNXDb.SQL_SUCCESS
   else
      mod:SetLocalString("NWNX_ODBC_CurrentRow", "");
      return NWNXDb.SQL_ERROR;
   end
end

function NWNXDb.SQLGetData(column)
   mod = mod or nwn.GetModule()
   if not result_set then
      result_set = string.split(mod:GetLocalString("NWNX_ODBC_CurrentRow"), "¬")
   end
   if column > #result_set then
      return ""
   end

   return result_set[column]
end

-- Problems can arise with SQL commands if variables or values have single quotes
-- in their names. These functions are a replace these quote with the tilde character
function NWNXDb.SQLEncodeSpecialChars(text)
   return string.gsub(text, "'", "~")
end

function NWNXDb.SQLDecodeSpecialChars(text)
   return string.gsub(text, "~", "'")
end

--[[
void SQLExecStatement(string sql, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="");

void SQLExecStatement(string sql, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="")
{
    int nPos, nCount = 0;

    string sLeft = "", sRight = sql;

    while ((nPos = FindSubString(sRight, "?")) >= 0) {
        string sInsert;

        switch (nCount++) {
            case 0:  sInsert = sStr0; break;
            case 1:  sInsert = sStr1; break;
            case 2:  sInsert = sStr2; break;
            case 3:  sInsert = sStr3; break;
            case 4:  sInsert = sStr4; break;
            case 5:  sInsert = sStr5; break;
            case 6:  sInsert = sStr6; break;
            case 7:  sInsert = sStr7; break;
            case 8:  sInsert = sStr8; break;
            case 9:  sInsert = sStr9; break;
            case 10: sInsert = sStr10; break;
            case 11: sInsert = sStr11; break;
            case 12: sInsert = sStr12; break;
            case 13: sInsert = sStr13; break;
            case 14: sInsert = sStr14; break;
            case 15: sInsert = sStr15; break;
            default: sInsert = "*INVALID*"; break;
        }

        sLeft += GetStringLeft(sRight, nPos) + "'" + SQLEncodeSpecialChars(sInsert) + "'";
        sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
    }

    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sLeft + sRight);
}
   --]]

local function get_tag(object, is_global)
   local tag
   if is_global and object:GetLocalInt ("pc_is_pc") then
      tag = object:GetLocalString("pc_player_name")
   else
      tag = object:GetTag()
   end
   return tag
end

function NWNXDb.GetString(object, varname, is_global, table)
   local tag = get_tag(object, is_global)

   tag = SQLEncodeSpecialChars(tag)
   varname = SQLEncodeSpecialChars(varname)

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   NWNXDb.SQLExecDirect(sql)

   if NWNXDb.SQLFetch() == NWNXDb.SQL_SUCCESS then
      return NWNXDb.SQLDecodeSpecialChars(NWNXDb.SQLGetData(1))
   end
      
   return ""
end

function NWNXDb.SetString(object, varname, value, expires, is_global, table)
   local tag = get_tag(object, is_global)

   tag = NWNXDb.SQLEncodeSpecialChars(tag)
   varname = NWNXDb.SQLEncodeSpecialChars(varname)
   value = NWNXDb.SQLEncodeSpecialChars(value)
   table = table or DEFAULT_TABLE
   expires = expires or 0

   local sql = "SELECT tag FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   NWNXDb.SQLExecDirect(sql)

   if NWNXDb.SQLFetch() == NWNXDb.SQL_SUCCESS then
      -- row exists
      sql = "UPDATE " .. table .. " SET val='" .. value ..
         "',expire=" .. expires .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   else
      -- row doesn't exist
      sql = "INSERT INTO " .. table .. " (tag,name,val,expire) VALUES" ..
         "('" .. tag .. "','" .. varname .. "','" .. value .. "'," .. expires .. ")"
   end
   NWNXDb.SQLExecDirect(sql)
end

function NWNXDb.SetInt(object, varname, value, expires, is_global, table)
   NWNXDb.SetString(object, varname, tostring(value), expires, is_global, table)
end

function NWNXDb.GetInt(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = NWNXDb.SQLEncodeSpecialChars(tag)
   varname = NWNXDb.SQLEncodeSpecialChars(varname);

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'";
   NWNXDb.SQLExecDirect(sql)

   mod:SetLocalString("NWNX!ODBC!FETCH", "-2147483647")
   return tonumber(mod:GetLocalString("NWNX!ODBC!FETCH")) or 0
end

function NWNXDb.SetFloat(object, varname, value, expires, is_global, table)
   NWNXDb.SetString(object, varname, tostring(value), expires, is_global, table)
end

function NWNXDb.GetFloat(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = NWNXDb.SQLEncodeSpecialChars(tag)
   varname = NWNXDb.SQLEncodeSpecialChars(varname)

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   NWNXDb.SQLExecDirect(sql)

   mod:SetLocalString("NWNX!ODBC!FETCH", "-340282306073709650000000000000000000000.000000000");
   return tonumber(mod:GetLocalString("NWNX!ODBC!FETCH")) or 0
end

function NWNXDb.SetLocation(object, varname, value, expires, is_global, table)
   NWNXDb.SetString(object, varname, value:ToString(), expires, is_global, table)
end

function NWNXDb.GetLocation(object, varname, is_global, table)
   return Location.FromString(NWNXDb.GetString(object, varname, is_global, table))
end

function NWNXDb.SetVector(object, varname, value, expires, is_global, table)
   NWNXDb.SetString(object, varname, value:ToString(), expires, is_global, table)
end

function NWNXDb.GetVector(object, varname, is_global, table)
   return Vector.FromString(NWNXDb.GetString(object, varname, is_global, table))
end

function NWNXDb.SetObject(owner, varname, object, expires, is_global, table)
   expires = expires or 0
   table = table or DEFAULT_OBJECT_TABLE

   tag = NWNXDb.SQLEncodeSpecialChars(tag)
   varname = NWNXDb.SQLEncodeSpecialChars(varname)

   local sql = "SELECT tag FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   NWNXDb.SQLExecDirect(sql);

   if NWNXDb.SQLFetch() == SQL_SUCCESS then
      -- row exists
      sql = "UPDATE " .. table .. " SET val=%s,expire=" .. expires ..
         " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   else
      -- row doesn't exist
      sql = "INSERT INTO " .. table .. " (tag,name,val,expire) VALUES" ..
         "('" .. tag .. "','" .. varname .. "',%s," .. expires .. ")"
   end
   mod:SetLocalString("NWNX!ODBC!SETSCORCOSQL", sql);
   nwn.StoreCampaignObject ("NWNX", "-", object);
end

-- TODO MAY NEED TO FIX THIS!!!!!
function NWNXDb.GetObject(object, varname, owner, is_global, table)
   owner = owner or object
   table = table or DEFAULT_OBJECT_TABLE

   local tag = get_tag(object, is_global)
   tag = SQLEncodeSpecialChars(tag)
   varname = SQLEncodeSpecialChars(varname)

    local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
    mod:SetLocalString("NWNX!ODBC!SETSCORCOSQL", sql);

    if not owner:GetIsValid() then
        owner = object
    end

    return nwn.RetrieveCampaignObject ("NWNX", "-", owner:GetLocation(), owner)
end

function NWNXDb.DeleteVariable(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = NWNXDb.SQLEncodeSpecialChars(tag)
   varname = NWNXDb.SQLEncodeSpecialChars(varname)
   
   local sql = "DELETE FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   NWNXDb.SQLExecDirect(sql)
end

function NWNXDb.DeleteAllVariables(object, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = NWNXDb.SQLEncodeSpecialChars(tag)

   local sql = "DELETE FROM " .. table .. " WHERE tag='" .. tag .. "'"
   NWNXDb.SQLExecDirect(sql)
end

-- NWNX functions cannot be JITed.
for name, func in pairs(NWNXDb) do
   if type(func) == "function" then
      jit.off(func)
   end
end