---
title: Understanding Elixir GenServer
date: 2025-08-17 00:00:00
featured_image: https://images.unsplash.com/photo-1494122353634-c310f45a6d3c?q=75&fm=jpg&w=1000&fit=max
excerpt: A GenServer is a process like any other Elixir process and it can be used to store state, execute code asynchronously and so on. Think of it as having many tiny workers, each with their own mailbox and private desk.
keywords: elixir, genserver, phoenix
---

![](https://images.unsplash.com/photo-1494122353634-c310f45a6d3c?q=75&fm=jpg&w=1000&fit=max)

A `GenServer` is a process like any other `Elixir` process and it can be used to store state, execute code `asynchronously` and so on. Think of it as having many tiny workers, each with their own mailbox and private desk.

Let's start with a code example and then explore the available callbacks. Imagine we want to implement a service with a `GenServer` that works like a hashmap,

```elixir
defmodule Hashmap do
  use GenServer

  def start_link(inital_state \\ %{}) do
    GenServer.start_link(__MODULE__, inital_state, name: __MODULE__)
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

Let's use this from `elixir`

```elixir
# Create a new hashmap
{:ok, pid} = Hashmap.start_link(%{"name" => "John", "age" => 30})

# Get value of key equal name
GenServer.call(pid, {:get, "name"})

# Update the name
GenServer.call(pid, {:update, "name", "Doe"})

# Add the gender
GenServer.call(pid, {:put, "gender", "Male"})

# Get all hashmap
GenServer.call(pid, {:get_all})

# Delete the gender
GenServer.cast(pid, {:delete, "gender"})
```

In the above example we have `handle_call/3` and `handle_cast/2`. The difference between them is as follows:

### Synchronous Calls (`GenServer.call/3`)
- Client waits for response
- Use `handle_call/3` to handle
- Good for: getting data, calculations, validation

### Asynchronous Calls (`GenServer.cast/2`)
- Client doesn't wait
- Use `handle_cast/2` to handle
- Good for: updates, notifications, fire-and-forget operations


### How to supervise in Phoenix Application

This section demonstrates how to create a `supervised` `GenServer` service in a `Phoenix` application. The service acts as an in-memory key-value store that persists for the lifetime of the application.

```elixir
defmodule ScutiWeb.Service.Hashmap do
  use GenServer

  def start_link(inital_state \\ %{}) do
    GenServer.start_link(__MODULE__, inital_state, name: __MODULE__)
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

This service is added to the supervision tree in the `Application` module. The supervision tree ensures that if the service crashes, it will be automatically restarted. The initial state is set with some application metadata:

```elixir
defmodule Scuti.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScutiWeb.Telemetry,
      Scuti.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:scuti, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:scuti, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Scuti.PubSub},
      # Start a worker by calling: Scuti.Worker.start_link(arg)
      # {Scuti.Worker, arg},
      # Start to serve requests, typically the last entry
      ScutiWeb.Endpoint,
      {ScutiWeb.Service.Hashmap, %{
        "app_name" => "Scuti",
        "version" => "1.0.0",
        "started_at" => DateTime.utc_now()
      }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScutiWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScutiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
```

To use the Hashmap GenServer from other parts of your `Phoenix` application, you can interact with it directly since it's registered under the module name. Here's how:

```elixir
pid = ScutiWeb.Service.Hashmap
state = GenServer.call(pid, {:get_all})
IO.inspect(state)
```

```elixir
pid = ScutiWeb.Service.Hashmap
GenServer.call(pid, {:update, "gender", "male"})
```
