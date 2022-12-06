-- This is a single line comment

--[[
  This is a
  multi-line comment
]]

-- Variables and Data Types
local number = 42
local float = 3.14
local string = "Hello, Neovim!"
local boolean = true
local nil_value = nil

-- String concatenation
local full_greeting = "Greetings: " .. string

-- Tables (Lua's primary data structure, similar to arrays and dictionaries)
local simple_array = {1, 2, 3, 4, 5}
local mixed_table = {10, "string", true, {nested = "value"}}
local dictionary = {
  key1 = "value1",
  key2 = "value2",
  ["key with spaces"] = "value3"
}

-- Accessing table elements
print(simple_array[1])  -- Prints: 1 (Lua arrays are 1-indexed)
print(mixed_table[4].nested)  -- Prints: value
print(dictionary.key1)  -- Prints: value1
print(dictionary["key with spaces"])  -- Prints: value3


-- Functions
local function greet(name)
  return "Hello, " .. name .. "!"
end

print(greet("Lua"))  -- Prints: Hello, Lua!

-- Anonymous functions
local multiply = function(a, b)
  return a * b
end

print(multiply(5, 3))  -- Prints: 15

-- Conditionals
local age = 25

if age < 18 then
  print("You are underage")
elseif age >= 18 and age < 65 then
  print("You are an adult")
else
  print("You are a senior")
end

-- Loops
-- For loop
for i = 1, 5 do
  print(i)
end

-- Generic for loop with ipairs (for arrays)
for index, value in ipairs(simple_array) do
  print(index, value)
end

-- Generic for loop with pairs (for tables)
for key, value in pairs(dictionary) do
  print(key, value)
end

-- While loop
local counter = 0
while counter < 5 do
  print(counter)
  counter = counter + 1
end

-- Repeat-until loop
repeat
  print("This will execute at least once")
until true

-- Error handling
local success, error = pcall(function()
  error("This is an error")
end)

if not success then
  print("Caught an error: " .. error)
end

-- Metatables and OOP-like behavior
local Person = {name = "Unknown"}

function Person:new(name)
  local instance = setmetatable({}, self)
  self.__index = self
  instance.name = name
  return instance
end

function Person:greet()
  print("Hello, I'm " .. self.name)
end

local john = Person:new("John")
john:greet()  -- Prints: Hello, I'm John

-- Closures
function counter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end

local my_counter = counter()
print(my_counter())  -- Prints: 1
print(my_counter())  -- Prints: 2

-- Varargs
local function sum(...)
  local total = 0
  for _, v in ipairs({...}) do
    total = total + v
  end
  return total
end

print(sum(1, 2, 3, 4))  -- Prints: 10
