-- Copyright (C) 2012 jmd ( jmd2028 at gmail dot com )

local fn = {}

function fn.map(f, iter, ...)
   for x in iter(unpack(...)) do
      table.insert(result, f(x))
   end
   return result
end

function fn.compose (f, g)
    return function (...)
              return f(g(unpack(...)))
           end
end

function fn.any(f, list)
    for _, ele in ipairs(list) do
       if f(ele) then return true end
    end
    return false
end

return fn