---
title: Early Returns in Elixir
date: 2024-06-07 00:00:00
featured_image: https://images.unsplash.com/photo-1508497864986-88d94fe6c5fe?q=90&fm=jpg&w=1000&fit=max
excerpt: Early returns is often employed to exit a function as soon as an exceptional or negative condition is met. It won't take much time when learning elixir to figure out that early returns are missing!
keywords: elixir, elixir-early-returns
---

![](https://images.unsplash.com/photo-1508497864986-88d94fe6c5fe?q=90&fm=jpg&w=1000&fit=max)

Early returns is often employed to exit a function as soon as an exceptional or negative condition is met. It won't take much time when learning `elixir` to figure out that early returns are missing!

In `Elixir`, the concept of "early returns" is not present as it is in some other programming languages. `Elixir` functions are designed to return the value of the last expression evaluated within the function body.

However, `Elixir` provides a functional programming approach that allows you to achieve similar behavior through pattern matching and control flow constructs. We will go through them


### Pattern Matching

Pattern matching allows functions to have multiple clauses, each one is handling different kind of inputs. this achieves early return by immediately matching and handling specific conditions. It is similar to method overloading in `OOP` languages

```elixir
defmodule Example do
    def find_element([], _), do: false
    def find_element([head | _], target) when head == target, do: true
    def find_element([_ | tail], target), do: find_element(tail, target)
end

IO.puts Example.find_element([], 20)           # Output: false
IO.puts Example.find_element([10, 20, 30], 20) # Output: true
IO.puts Example.find_element([20, 30, 40], 20) # Output: true
IO.puts Example.find_element([10, 20], 20)     # Output: true
IO.puts Example.find_element([30, 40, 50], 20) # Output: false
```

Well if the above code seems hard to understand, here is the naive implementation

```elixir
defmodule Example do
  def find_element(lst, target) do
    if length(lst) == 0 do
      false
    else
      [head | tail] = lst

      if head == target do
        true
      else
        find_element(tail, target)
      end
    end
  end
end

IO.puts Example.find_element([], 20)           # Output: false
IO.puts Example.find_element([10, 20, 30], 20) # Output: true
IO.puts Example.find_element([20, 30, 40], 20) # Output: true
IO.puts Example.find_element([10, 20], 20)     # Output: true
IO.puts Example.find_element([30, 40, 50], 20) # Output: false
```

Here is also how I would do it in `python` since it doesn't support `pattern matching`

```python
def find_element(lst, target):
    if not lst:
        return False
    elif lst[0] == target:
        return True
    else:
        return find_element(lst[1:], target)

print(find_element([1, 2, 3, 4], 3))  # Output: True
print(find_element([1, 2, 3, 4], 5))  # Output: False
```


### Guard Clauses

Guard Clauses are used in functions to specifiy additional conditons that must be met for the function to be executed. Imagine that some functions needs only positive values to run so you better do it with guard clauses

```elixir
def process_value(value) when value < 0, do: {:error, "Negative value"}
def process_value(value), do: {:ok, value * 2}
```

or something like that

```elixir
def is_negative_int?(x) when x < 0, do: true
def is_negative_int?(_), do: false
```


### `case` and `cond` Statement

`case` and `cond` statements provide a way to handle multiple conditions within a function. It can do some pattern matching for the value used in `case` statement. here is few examples.

```elixir
defmodule Example do
  def create_entity(params \\ %{}) do
    result = {:ok, %{ID: 1}}
    case result do
      {:ok, %{ID: id}} -> IO.puts "Entity with id #{id} created"
      {:error, message} -> IO.puts "Error #{message} raised"
    end
  end
end

IO.puts Example.create_entity(%{}) # Output: Entity with id 1 created
```


### `with` Statement

The `with` statement is used for chaining multiple operations that may fail, I used this one alot in input validation within phoenix framework. When i started doing elixir i was using `throw` and `catch` statement alot for input validation but then I switched fully to use with statement. Here is an example.

```elixir
defmodule Example do
  def validate_inputs(inputs) do
    with {:ok, _} <- is_string?("Username", inputs.name),
         {:ok, _} <- is_not_empty?("Username", inputs.name),
         {:ok, _} <- is_between?("Username", inputs.name, 3, 60) do
      {:ok, inputs}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp is_string?(name, value) do
    if is_binary(value) do
      {:ok, value}
    else
      {:error, "#{name} is not a valid string"}
    end
  end

  defp is_not_empty?(name, value) do
    value = String.trim(value)

    if String.length(value) == 0 do
      {:error, "#{name} can't be empty"}
    else
      {:ok, value}
    end
  end

  defp is_between?(name, value, min, max) do
    value = String.trim(value)

    if String.length(value) >= min and String.length(value) <= max do
      {:ok, value}
    else
      {:error, "#{name} must be between #{min} and #{max}"}
    end
  end
end

IO.inspect Example.validate_inputs(%{name: "Joe"}) // {:ok, %{name: "Joe"}}
IO.inspect Example.validate_inputs(%{name: ""})    // {:error, "Username can't be empty"}
IO.inspect Example.validate_inputs(%{name: "  J"}) // {:error, "Username must be between 3 and 60"}

```


### `throw` and `catch` Statement

Elixir supports also throw and catch for early exits, which can be used to implement early return-like behavior. I used to do the above example like the following to get the return-like behavior.

```elixir
defmodule Example do
  def validate_inputs(inputs) do
    try do
      if not is_binary(inputs.name) do
        throw({:error, "Name must be a string"})
      end

      if String.length(inputs.name) == 0 do
        throw({:error, "Name must not be empty"})
      end

      if String.length(inputs.name) > 60 do
        throw({:error, "Name must not exceed 60 characters"})
      end

      {:ok, inputs}
    catch
      {:error, message} -> {:error, message}
    end
  end
end

IO.inspect Example.validate_inputs(%{name: "Joe"}) # {:ok, %{name: "Joe"}}
IO.inspect Example.validate_inputs(%{name: ""}) # {:error, "Name must not be empty"}
```

I figured out that it's not idiomatic in Elixir to use `throw` and `catch` for this kind of validation. Typically, pattern matching and guard clauses are preferred. However, if you want to stick with throw and catch, the implementation is mostly correct.

In elixir `throw` and `catch` constructs used to raise unexpected errors or exceptional situations like system crashes or divide by zero these sort of things.
