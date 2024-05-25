---
title: Understanding Elixir Supervisor
date: 2025-08-17 00:00:00
featured_image: https://images.unsplash.com/photo-1560497459-0bcdf9c15c16?q=75&fm=jpg&w=1000&fit=max
excerpt: A Supervisor is a process that supervises other processes (child processes). Supervisors are used to build a hierarchical process structure called a supervision tree.
keywords: elixir, supervisor, phoenix
---

![](https://images.unsplash.com/photo-1560497459-0bcdf9c15c16?q=75&fm=jpg&w=1000&fit=max)

A Supervisor is a process that supervises other processes (child processes). Supervisors are used to build a hierarchical process structure called a supervision tree.

In order to start a supervisor process, we need to create a child process that will be supervised. As an example, we will define a `GenServer` that will store our application state as a hashmap. Other processes can store key/value pairs in this child process.

```elixir
defmodule Hashmap do
  use GenServer

  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    value = Map.get(state, key)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:get, key, default}, _from, state) do
    value = Map.get(state, key, default)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:get_all}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:update, key, value}, _from, state) do
    new_state = Map.put(state, key, value)
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    new_state = Map.put(state, key, value)
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    new_state = Map.delete(state, key)
    {:noreply, new_state}
  end
end
```

We can now start a `supervisor` that will start and supervise our `hashmap` process. The first step is to define a list of child specifications that control how each child behaves. Each child specification is a map, as shown below:

```elixir
children = [
  # The Hashmap is a child started via Hashmap.start_link(%{app_name: "clivern"})
  %{
    id: Hashmap,
    start: {Hashmap, :start_link, [%{app_name: "clivern"}]}
  }
]

# Now we start the supervisor with the children and a strategy
{:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

# After started, we can query the supervisor for information
Supervisor.count_children(pid)
```

Note that when starting the `GenServer`, we are registering it with name `Hashmap` via the name: `__MODULE__` option. This allows us to call it directly.

```elixir
# Get value of key equal to name
GenServer.call(Hashmap, {:get, :app_name})

# Update the name
GenServer.call(Hashmap, {:update, :app_name, "scuti"})

# Add the version
GenServer.call(Hashmap, {:put, :version, "v1.0.0"})

# Get all hashmap
GenServer.call(Hashmap, {:get_all})

# Delete the version
GenServer.cast(Hashmap, {:delete, :version})
```

However, if we send an invalid message, the hashmap server is going to crash:

```elixir
GenServer.call(Hashmap, {:invalid_message})
```

Luckily, since the server is being supervised by a `supervisor`, the `supervisor` will automatically start a new one, reset back to its initial state. We can check the current state as follows:

```elixir
GenServer.call(Hashmap, {:get_all})

# We can query the supervisor for information about current workers
Supervisor.count_children(pid)
```

For more info about the supervisor module, check the [Elixir guide](https://hexdocs.pm/elixir/1.18.4/Supervisor.html)
