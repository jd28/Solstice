require 'fun' ()

function irange(start, step)
   step = step or 1
   return tabulate(function(n) return start + step * n end)
end

function make_iter_valid(f1, f2)
   local function it(n)
      return n == 0 and f1() or f2()
   end

   return take_while(function (x) return x ~= OBJECT_INVALID end, tabulate(it))
end

function bind1st(f, val)
   return function (second) return f(val, second) end
end

function bind2nd(f, val)
   return function (first) return f(first, val) end
end
