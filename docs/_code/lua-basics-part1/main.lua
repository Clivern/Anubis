-- main.lua
local lib = require("lib")

-- Using functions from mymodule
print(lib.mymodule.greet("Lua Developer"))
print("2 + 3 =", lib.mymodule.add(2, 3))

-- You can also access the module directly if you prefer
local mymodule = require("lib.mymodule")
print(mymodule.greet("Direct Access"))
