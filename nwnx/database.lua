-- Name     : Avlis Persistence System include
-- Purpose  : Various APS/NWNX2 related functions
-- Authors  : Ingmar Stieger, Adam Colon, Josh Simon
-- Modified : January 1st, 2005

-- This file is licensed under the terms of the
-- GNU GENERAL PUBLIC LICENSE (GPL) Version 2

local db = {}

local DEFAULT_TABLE = "pwdata"
local DEFAULT_OBJECT_TABLE = "pwobjdata"

-- Return codes
db.SQL_ERROR = 0
db.SQL_SUCCESS = 1

local mod

-- Functions for initializing APS and working with result sets

function db.SQLInit()
   mod = nwn.GetModule()
   mod:SetLocalString("NWNX!ODBC!SPACER", string.rep('.', 8*128))
end

function db.SQLExecDirect(sql)
   mod:SetLocalString("NWNX!ODBC!EXEC", sql)
end

local result_set

function db.SQLFetch()
   -- Reset the result set.
   result_set = nil

   mod:SetLocalString("NWNX!ODBC!FETCH", mod:GetLocalString("NWNX!ODBC!SPACER"))
   local row = mod:GetLocalString("NWNX!ODBC!FETCH");
   if #row > 0 then
      mod:SetLocalString("NWNX_ODBC_CurrentRow", row)
      return db.SQL_SUCCESS
   else
      mod:SetLocalString("NWNX_ODBC_CurrentRow", "");
      return db.SQL_ERROR;
   end
end

function db.SQLGetData(column)
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
function db.SQLEncodeSpecialChars(text)
   return string.gsub(text, "'", "~")
end

function db.SQLDecodeSpecialChars(text)
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
   if is_global and object:GetLocalInt ("pc_is_pc") then
      tag = object:GetLocalString("pc_player_name")
   else
      tag = object:GetTag()
   end
end

function db.GetDbString(object, varname, is_global, table)
   local tag = get_tag(object, is_global)

   tag = SQLEncodeSpecialChars(tag)
   varname = SQLEncodeSpecialChars(varname)

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   db.SQLExecDirect(sql)

   if db.SQLFetch() == db.SQL_SUCCESS then
      return db.SQLDecodeSpecialChars(db.SQLGetData(1))
   end
      
   return ""
end

function db.SetDbString(object, varname, value, expires, is_global, table)
   local tag = get_tag(object, is_global)

   tag = db.SQLEncodeSpecialChars(tag)
   varname = db.SQLEncodeSpecialChars(varname)
   value = db.SQLEncodeSpecialChars(value)

   local sql = "SELECT tag FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   db.SQLExecDirect(sql)

   if db.SQLFetch() == db.SQL_SUCCESS then
      -- row exists
      sql = "UPDATE " .. table .. " SET val='" .. value ..
         "',expire=" .. expires .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   else
      -- row doesn't exist
      sql = "INSERT INTO " .. table .. " (tag,name,val,expire) VALUES" ..
         "('" .. tag .. "','" .. varname .. "','" .. value .. "'," .. expires .. ")"
   end
   db.SQLExecDirect(sql)
end

function db.SetDbInt(object, varname, value, expires, is_global, table)
   db.SetDbString(object, varname, tostring(value), expires, is_global, table)
end

function db.GetDbInt(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = db.SQLEncodeSpecialChars(tag)
   varname = db.SQLEncodeSpecialChars(varname);

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'";
   db.SQLExecDirect(sql)

   mod:SetLocalString("NWNX!ODBC!FETCH", "-2147483647")
   return tonumber(mod:GetLocalString("NWNX!ODBC!FETCH")) or 0
end

function db.SetDbFloat(object, varname, value, expires, is_global, table)
   db.SetDbString(object, varname, tostring(value), expires, is_global, table)
end

function db.GetDbFloat(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = db.SQLEncodeSpecialChars(tag)
   varname = db.SQLEncodeSpecialChars(varname)

   local sql = "SELECT val FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   db.SQLExecDirect(sql)

   mod:SetLocalString("NWNX!ODBC!FETCH", "-340282306073709650000000000000000000000.000000000");
   return tonumber(mod:GetLocalString("NWNX!ODBC!FETCH")) or 0
end

function db.SetDbLocation(object, varname, value, expires, is_global, table)
   db.SetDbString(object, varname, value:tostring(), expires, is_global, table)
end

function db.GetDbLocation(object, varname, is_global, table)
   return Location.FromString(db.GetDbString(object, varname, is_global, table))
end

function db.SetDbVector(object, varname, value, expires, is_global, table)
   db.SetDbString(object, varname, value:tostring(), expires, is_global, table)
end

function db.GetDbVector(object, varname, is_global, table)
   return Vector.FromString(db.GetDbString(object, varname, is_global, table))
end

function db.SetDbObject(owner, varname, object, expires, is_global, table)
   expires = expires or 0
   table = table or DEFAULT_OBJECT_TABLE

   tag = db.SQLEncodeSpecialChars(tag)
   varname = db.SQLEncodeSpecialChars(varname)

   local sql = "SELECT tag FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   db.SQLExecDirect(sql);

   if db.SQLFetch() == SQL_SUCCESS then
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
function db.GetDbObject(object, varname, owner, is_global, table)
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

function db.DeleteDbVariable(object, varname, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = db.SQLEncodeSpecialChars(tag)
   varname = db.SQLEncodeSpecialChars(varname)
   
   local sql = "DELETE FROM " .. table .. " WHERE tag='" .. tag .. "' AND name='" .. varname .. "'"
   db.SQLExecDirect(sql)
end

function db.DeleteAllDbVariables(object, is_global, table)
   table = table or DEFAULT_TABLE
   local tag = get_tag(object, is_global)

   tag = db.SQLEncodeSpecialChars(tag)

   local sql = "DELETE FROM " .. table .. " WHERE tag='" .. tag .. "'"
   db.SQLExecDirect(sql)
end

return db