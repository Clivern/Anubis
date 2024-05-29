---
title: Concurrency in Elixir
date: 2020-01-03 00:00:00
featured_image: https://images.unsplash.com/photo-1445283142063-f4802ea5aac3?q=90&fm=jpg&w=1000&fit=max
excerpt: Concurrency is a fundamental concept in Elixir, a functional programming language built on the Erlang virtual machine (BEAM). Elixir provides powerful tools and abstractions for managing concurrent processes, making it ideal for building scalable and fault-tolerant systems.
---

![](https://images.unsplash.com/photo-1445283142063-f4802ea5aac3?q=90&fm=jpg&w=1000&fit=max)

Concurrency is a fundamental concept in Elixir, a functional programming language built on the Erlang virtual machine (BEAM). Elixir provides powerful tools and abstractions for managing concurrent processes, making it ideal for building scalable and fault-tolerant systems.

Concurrency in Elixir is achieved through lightweight processes called "Elixir processes." These processes are not operating system threads but rather independent units of execution within the Erlang virtual machine. Elixir processes are isolated from each other, meaning that they cannot directly share memory. Instead, they communicate by exchanging immutable messages.

**Processes**

It is easy to create and manage concurrent processes using the `spawn/1` or `spawn/3` functions. These functions create a new Elixir process that runs concurrently with the main process.

```elixir
iex(1)> h spawn/1

def spawn(fun)

  @spec spawn((() -> any())) :: pid()

Spawns the given function and returns its PID.

Typically developers do not use the spawn functions, instead they use
abstractions such as Task, GenServer and Agent, built on top of spawn, that
spawns processes with more conveniences in terms of introspection and
debugging.

Check the Process module for more process-related functions.

The anonymous function receives 0 arguments, and may return any value.

Inlined by the compiler.

## Examples

    current = self()
    child = spawn(fn -> send(current, {self(), 1 + 2}) end)

    receive do
      {^child, 3} -> IO.puts("Received 3 back")
    end
```

```elixir
pid = spawn(fn -> IO.puts("Hello World") end)

IO.inspect pid

# Hello World
# PID<0.109.0>
```

```elixir
iex(1)> h spawn/3

def spawn(module, fun, args)

  @spec spawn(module(), atom(), list()) :: pid()

Spawns the given function fun from the given module passing it the given args
and returns its PID.

Typically developers do not use the spawn functions, instead they use
abstractions such as Task, GenServer and Agent, built on top of spawn, that
spawns processes with more conveniences in terms of introspection and
debugging.

Check the Process module for more process-related functions.

Inlined by the compiler.

## Examples

    spawn(SomeModule, :function, [1, 2, 3])
```

```elixir
defmodule Example do
  def sum(x, y) do
    IO.puts x + y
  end
end

pid = spawn(Example, :sum, [1, 2])

IO.inspect pid
```

**Message Passing**

Processes communicate by sending and receiving messages using the `send/2` and `receive/1` functions. Messages are immutable and can be any Elixir term. When a process receives a message, it pattern matches against the received messages to determine the appropriate action.

```elixir
iex(1)> h send/2

def send(dest, message)

  @spec send(dest :: Process.dest(), message) :: message when message: any()

Sends a message to the given dest and returns the message.

dest may be a remote or local PID, a local port, a locally registered name, or
a tuple in the form of {registered_name, node} for a registered name at another
node.

Inlined by the compiler.

## Examples

    iex> send(self(), :hello)
    :hello
```

```elixir
iex(1)> h receive/1

                             defmacro receive(args)

Checks if there is a message matching the given clauses in the current process
mailbox.

In case there is no such message, the current process hangs until a message
arrives or waits until a given timeout value.

## Examples

    receive do
      {:selector, number, name} when is_integer(number) ->
        name
      name when is_atom(name) ->
        name
      _ ->
        IO.puts(:stderr, "Unexpected message received")
    end

An optional after clause can be given in case the message was not received
after the given timeout period, specified in milliseconds:

    receive do
      {:selector, number, name} when is_integer(number) ->
        name
      name when is_atom(name) ->
        name
      _ ->
        IO.puts(:stderr, "Unexpected message received")
    after
      5000 ->
        IO.puts(:stderr, "No message in 5 seconds")
    end

The after clause can be specified even if there are no match clauses. The
timeout value given to after can be any expression evaluating to one of the
allowed values:

  • :infinity - the process should wait indefinitely for a matching
    message, this is the same as not using the after clause
  • 0 - if there is no matching message in the mailbox, the timeout will
    occur immediately
  • positive integer smaller than or equal to 4_294_967_295 (0xFFFFFFFF in
    hexadecimal notation) - it should be possible to represent the timeout
    value as an unsigned 32-bit integer.

## Variable handling

The receive/1 special form handles variables exactly as the case/2 special
macro. For more information, check the docs for case/2.
```

```elixir
defmodule Example do
  def listen() do
    receive do
      {:debug, msg} -> IO.puts msg
      {:info, msg} -> IO.puts msg
      {:warn, msg} -> IO.puts msg
      {:error, msg} -> IO.puts msg
    end
    listen() # Recursion
  end
end

pid = spawn(Example, :listen, [])

spawn(fn -> send pid, {:error, "[ERROR] log item"} end)
spawn(fn -> send pid, {:info, "[INFO] log item"} end)
spawn(fn -> send pid, {:debug, "[DEBUG] log item"} end)
spawn(fn -> send pid, {:warn, "[WARN] log item"} end)
```

```elixir
defmodule Worker do
  def start do
    spawn(__MODULE__, :sum, [])
  end

  def sum() do
    receive do
      {:calculate_sum, sender, data} ->
        sum = Enum.sum(data)
        send(sender, {:sum_result, sum})
    end
    sum()
  end
end

defmodule Collection do
  def sum(data) do
    worker_pid = Worker.start()
    send(worker_pid, {:calculate_sum, self(), data})
    receive do
      {:sum_result, sum} -> sum
    end
  end
end

IO.puts Collection.sum([2, 3, 5])
IO.puts Collection.sum([21, 3, 7])
IO.puts Collection.sum([2, 9, 5])
```

```elixir
defmodule Worker do
  def start do
    spawn_link(__MODULE__, :sum, [])
  end

  def sum() do
    receive do
      {:calculate_sum, sender, data} ->
        sum = Enum.sum(data)
        send(sender, {:sum_result, sum})
    end
    sum()
  end
end

defmodule Collection do
  def sum(data) do
    worker_pid = Worker.start()
    send(worker_pid, {:calculate_sum, self(), data})
    receive do
      {:sum_result, sum} -> sum
    end
  end
end

IO.puts Collection.sum([2, 3, 5])
IO.puts Collection.sum([21, 3, 7])
IO.puts Collection.sum([2, 9, 5])
```

**Concurrency Primitives**

Elixir provides various concurrency primitives, such as `Task`, `Agent`, and `GenServer`, which abstract away common patterns for managing concurrent processes.

`Task`: The Task module allows you to spawn lightweight asynchronous tasks. It is useful for executing independent computations concurrently.

```elixir
defmodule Example do
  def double(x) do
    :timer.sleep(2000)
    x * 2
  end
end

task = Task.async(Example, :double, [2000])

Task.await(task) # 4000
```

```elixir
defmodule LongTask do
  def start(data) do
    Task.async(fn -> perform_task(data) end)
  end

  defp perform_task(data) do
    :timer.sleep(2000)
    {:ok, Enum.sum(data)}
  end
end

defmodule Collection do
  def sum(data) do
    task = LongTask.start(data)

    result = Task.await(task)

    try do
      {:ok, value} = result
      value
    catch
      :error, _ -> 0
    end
  end
end

IO.puts Collection.sum([3, 2, 1, 8]) # 14
IO.puts Collection.sum([3, 8]) # 11
IO.puts Collection.sum([10, 8]) # 18
```

`Agent`: The Agent module provides a simple shared state abstraction. It allows you to store and retrieve state in a process, providing atomic updates and synchronous access to the state.

`GenServer`: The GenServer behaviour is a generic server implementation that manages state and allows for message-based communication. It provides a client-server model and is widely used for building concurrent and fault-tolerant systems.

**Supervision Trees**

Elixir's supervisor behaviour enables the construction of robust and fault-tolerant systems. A supervision tree manages a hierarchy of processes and automatically restarts failed processes according to predefined restart strategies.

**Asynchronous Programming**

Elixir supports asynchronous programming through the use of asynchronous tasks, which can be created using `Task.async/1` and `Task.await/2`. Asynchronous tasks are useful when performing non-blocking `I/O` operations or parallel computations.