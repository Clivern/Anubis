-- lib/mymodule.lua
local mymodule = {}

function mymodule.greet(name)
    return "Hello, " .. name .. "!"
end

function mymodule.add(a, b)
    return a + b
end

return mymodule


