local ffi = require 'ffi'

ffi.cdef[[

struct GffStructEntry {
    uint32_t  type;
    uint32_t  field_index;
    uint32_t  field_count;
};

struct GffHeader {
   char     type[4];
   char     version[4];
   uint32_t struct_offset;
   uint32_t struct_count;
   uint32_t field_offset;
   uint32_t field_count;
   uint32_t label_offset;
   uint32_t label_count;
   uint32_t field_data_offset;
   uint32_t field_data_count;
   uint32_t field_idx_offset;
   uint32_t field_idx_count;
   uint32_t list_idx_offset;
   uint32_t list_idx_count;
};

struct GffField {
    uint32_t  type;
    uint32_t  label_idx;
    uint32_t  data_or_offset;
};
]]

local uint32 = ffi.new("uint32_t[1]")
local uint64 = ffi.new("uint64_t[1]")
local int64  = ffi.new("int64_t[1]")
local double = ffi.new("double[1]")

local INVALID       = -1
local BYTE          = 0
local CHAR          = 1
local WORD          = 2
local SHORT         = 3
local DWORD         = 4
local INT           = 5
local DWORD64       = 6
local INT64         = 7
local FLOAT         = 8
local DOUBLE        = 9
local CEXOSTRING    = 10
local RESREF        = 11
local CEXOLOCSTRING = 12
local VOID          = 13
local STRUCT        = 14
local LIST          = 15

local function strip_null(str)
   for i = 1, #str do
      if string.byte(str, i) == 0 then
         return string.sub(str, 1, i-1)
      end
   end
   return str
end

function tohexstring(str, spacer)
   spacer = spacer or ""
   return (string.gsub(str, "(.)",
                       function (c)
                          return string.format("%02X%s", string.byte(c),
                                               spacer)
                       end))
end

local GffFieldInvalid
local GffStructInvalid

local struct_mt = {
   __index = function (t, k)
      if not t.parent then return GffFieldInvalid end

      local label_idx = t.parent.labels[k]
      if not label_idx then return GffFieldInvalid end
      for i=1, #t.fields do
         if t.fields[i].label_idx == label_idx then
            return t.fields[i]
         end
      end

      return GffFieldInvalid
   end
}

local field_mt = {
   __index = function(t,k)
      if type(k) == "string" and rawget(t, 'type') == STRUCT then
         local p = rawget(t, 'parent')
         return p.structs[rawget(t, 'data_or_offset') + 1][k]
      elseif type(k) == "number" and rawget(t, 'type') == LIST then
         local p = rawget(t, 'parent')
         local list_idx = rawget(t, 'data_or_offset') / 4 + 1
         local size = p.list_indices[list_idx]
         if k < size then
            local struct_idx = p.list_indices[list_idx + k + 1]
            return p.structs[struct_idx+1]
         end
      end
      return GffStructInvalid
   end
}

local gff_mt = {
   __index = function(t, k)
      return t.structs[1][k] or GffFieldInvalid
   end
}

local function Size(field)
   if field.type ~= LIST then return 0 end
   local list_idx = field.data_or_offset / 4 + 1
   local size = field.parent.list_indices[list_idx]
   return size
end

local function Value(field, raw)
   if field.data then
      return field.data
   elseif field.type == BYTE or
      field.type == CHAR     or
      field.type == WORD     or
      field.type == SHORT    or
      field.type == DWORD    or
      field.type == INT      or
      field.type == FLOAT
   then
      return field.data_or_offset
   elseif field.type == DWORD64 then
      ffi.copy(uint64, string.sub(field.parent.data, start, start + 8), 8)
      return raw and uint64[0] or tonumber(uint64[0])
   elseif field.type == INT64 then
      ffi.copy(int64, string.sub(field.parent.data, start, start + 8), 8)
      return raw and int64[0] or tonumber(int64[0])
   elseif field.type == DOUBLE then
      ffi.copy(double, string.sub(field.parent.data, start, start + 8), 8)
      return double[0]
   elseif field.type == CEXOSTRING then
      local start = field.data_or_offset + 1
      ffi.copy(uint32, string.sub(field.parent.data, start, start + 4), 4)
      local size = tonumber(uint32[0])
      return string.sub(field.parent.data, field.data_or_offset + 5,
                        field.data_or_offset + size + 4)
   elseif field.type == VOID then
      local start = field.data_or_offset + 1
      ffi.copy(uint32, string.sub(field.parent.data, start, start + 4), 4)
      local size = tonumber(uint32[0])
      return tohexstring(string.sub(field.parent.data, field.data_or_offset + 5,
                                    field.data_or_offset + size + 4))

   elseif field.type == RESREF then
      local size = string.byte(field.parent.data, field.data_or_offset + 1)
      return string.sub(field.parent.data, field.data_or_offset + 2,
                        field.data_or_offset + size + 1)
   elseif field.type == CEXOLOCSTRING then
      return
   end
end

local function SetValue(field, value)
   field.data = value
end

local function create_struct(type, parent)
   return setmetatable({ type = tonumber(type),
                         parent = parent,
                         fields = {} },
                       struct_mt)
end

local function create_field(type, label_idx, data_or_offset, parent)
   return setmetatable({ type = tonumber(type),
                         label_idx = tonumber(label_idx),
                         data_or_offset = tonumber(data_or_offset),
                         parent = parent,
                         data = false,
                         value = Value,
                         size = Size },
                       field_mt)
end

GffFieldInvalid = create_field()
GffStructInvalid = create_struct()

local entry = ffi.new("struct GffStructEntry")
local field = ffi.new("struct GffField")

local function parse(str)
   local gff = {}
   gff.header = ffi.new("struct GffHeader")
   gff.structs = {}
   gff.labels = {}
   gff.field_indices = {}
   gff.list_indices = {}

   local start = 1
   local size  = ffi.sizeof("struct GffHeader")

   ffi.copy(gff.header, str:sub(start, size + start), size)

   start = gff.header.field_idx_offset + 1
   size  = gff.header.field_idx_count

   for i = 0, (size / 4) - 1 do
      ffi.copy(uint32, str:sub(start, start + 4), 4)

      local t = tonumber(uint32[0])

      table.insert(gff.field_indices, t)
      start = start + 4
   end

   start = gff.header.label_offset + 1
   size = 16

   for i = 0, gff.header.label_count - 1 do
      local res = strip_null(str:sub(start, start + size))
      gff.labels[res] = i
      start = start + 16
   end


   local entry_start = gff.header.struct_offset + 1
   local entry_size  = ffi.sizeof("struct GffStructEntry")

   size = ffi.sizeof("struct GffField")

   for i = 0, gff.header.struct_count - 1 do
      ffi.copy(entry, str:sub(entry_start, entry_start + entry_size), entry_size)
      entry_start = entry_start + entry_size

      local s = create_struct(entry.type, gff)
      --print("i", i)
      --print("entries[i].field_count", entries[i].field_count)
      if entry.field_count == 1 then
         local start = 1 + gff.header.field_offset + entry.field_index * 12
         ffi.copy(field, str:sub(start, start+size), 12)
         table.insert(s.fields, create_field(field.type, field.label_idx,
                                             field.data_or_offset, gff))
      else
         local fi = entry.field_index / 4
         for j = 0, entry.field_count - 1 do
            local start = gff.header.field_offset + 1
               + (gff.field_indices[fi+1] * 12)

            --print(gff.field_indices[fi+1])
            --print(start, size)

            ffi.copy(field, str:sub(start, start+size), 12)
            --print(field.type, field.label_idx, field.data_or_offset)
            table.insert(s.fields, create_field(field.type, field.label_idx,
                                                field.data_or_offset, gff))
            fi = fi + 1
         end
      end

      table.insert(gff.structs, s)
   end

   size = gff.header.list_idx_count
   start = gff.header.list_idx_offset + 1

   for i = 0, (size / 4) - 1 do
      ffi.copy(uint32, str:sub(start, start + 4), 4)
      local t = tonumber(uint32[0])
      --print(t)
      table.insert(gff.list_indices, t)
      start = start + 4

   end

   start = gff.header.field_data_offset + 1
   gff.data = str:sub(start, start + gff.header.field_data_count)

   return setmetatable(gff, gff_mt)
end

local function load(file)
   local f = io.open(file, "rb")
   local str = f:read("*all")
   f:close()
   return parse(str)
end

local M = {
   load  = load,
   parse = parse,
   Value = Value
}

return M
