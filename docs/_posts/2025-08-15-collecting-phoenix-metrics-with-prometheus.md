---
title: Collecting Phoenix's Metrics with Prometheus
date: 2025-08-15 00:00:00
featured_image: https://images.unsplash.com/photo-1679089391720-dab2bca0ffc5?q=75&fm=jpg&w=1000&fit=max
excerpt: This tutorial walks you through integrating Oak with your Phoenix application step by step. Oak is a high-performance metrics collection and aggregation library written in Elixir that provides Prometheus-compatible metrics.
keywords: elixir, prometheus, phoenix, metrics, observability
---

![](https://images.unsplash.com/photo-1679089391720-dab2bca0ffc5?q=75&fm=jpg&w=1000&fit=max)

This tutorial walks you through integrating [Oak](https://github.com/Clivern/Oak) with your Phoenix application step by step. Oak is a high-performance metrics collection and aggregation library written in Elixir that provides Prometheus-compatible metrics.

### Prerequisites

- A Phoenix application (version 1.7+)
- Elixir 1.15+

### Step 1: Add Oak Dependencies

First, add Oak to your project dependencies. Open your `mix.exs` file and add the Oak dependency:

```elixir
defp deps do
  [
    # ... your existing dependencies
    {:oak, "~> 0.2"}
  ]
end
```

After adding the dependency, install it:

```bash
mix deps.get
```

### Step 2: Start Oak in Your Application

Oak needs to be started as part of your application's supervision tree. Open `lib/your_app/application.ex` and add `Oak.MetricsStore` to your children list:

```elixir
defmodule YourApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      # ... your existing children
      YourAppWeb.Telemetry,
      YourApp.Repo,
      # ... other services

      # Add Oak metrics store
      {Oak.MetricsStore, %{}},

      # ... other children
      YourAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: YourApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

**Important**: Place `Oak.MetricsStore` before your endpoint to ensure it's started before HTTP requests begin.

### Step 3: Create the Route Metrics Plug

This plug automatically tracks HTTP request metrics. Create a new file at `lib/your_app_web/plugs/route_metrics.ex`:

```elixir
defmodule YourAppWeb.Plugs.RouteMetrics do
  @moduledoc """
  Plug that tracks route metrics and pushes them to Oak metrics store.
  """
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    start_time = System.monotonic_time(:millisecond)
    conn
    |> register_before_send(&track_metrics(&1, start_time))
  end

  defp track_metrics(conn, start_time) do
    end_time = System.monotonic_time(:millisecond)
    duration = end_time - start_time

    # Get route information
    route = conn.request_path
    method = conn.method
    status = conn.status || 500

    # Push metrics to Oak
    try do
      # HTTP request counter
      http_requests_total = Oak.Metric.Counter.new("http_requests_total", "HTTP requests total", %{
        method: method,
        route: route,
        status: status
      })

      case Oak.Prometheus.get_metric(Oak.MetricsStore, Oak.Prometheus.get_counter_id(http_requests_total)) do
        nil ->
          Oak.Prometheus.push_metric(Oak.MetricsStore, http_requests_total |> Oak.Metric.Counter.inc(1))

        metric ->
          Oak.Prometheus.push_metric(Oak.MetricsStore, metric |> Oak.Metric.Counter.inc(1))
      end

      # Request duration histogram
      request_duration = Oak.Metric.Histogram.new("request_duration", "Request duration", [
        10, 50, 100, 250, 500, 1000, 2500, 5000
      ], %{
        method: method,
        route: route
      })

      case Oak.Prometheus.get_metric(Oak.MetricsStore, Oak.Prometheus.get_histogram_id(request_duration)) do
        nil ->
          Oak.Prometheus.push_metric(Oak.MetricsStore, request_duration |> Oak.Metric.Histogram.observe(duration))

        metric ->
          Oak.Prometheus.push_metric(Oak.MetricsStore, metric |> Oak.Metric.Histogram.observe(duration))
      end
    rescue
      e -> Logger.warning("Failed to push route metrics: #{inspect(e)}")
    end

    conn
  end
end
```

**What this plug does:**

- Records the start time of each request
- Uses `register_before_send/2` to capture the final response status
- Tracks HTTP request counts by method, route, and status
- Measures request duration and stores it in a histogram
- Handles errors gracefully without breaking the request

### Step 4: Add the Plug to Your Endpoint

**Critical**: The metrics plug must be placed **before** your router to capture actual response statuses. Open `lib/your_app_web/endpoint.ex`:

```elixir
defmodule YourAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :your_app

  # ... other plugs and configuration

  plug Plug.Session, @session_options

  # Route metrics tracking plug - MUST be before router
  plug YourAppWeb.Plugs.RouteMetrics

  plug YourAppWeb.Router
end
```

### Step 5: Create the Metrics Controller

Create a controller to expose metrics for Prometheus scraping. Create `lib/your_app_web/controllers/metrics_controller.ex`:

```elixir
defmodule YourAppWeb.MetricsController do
  use YourAppWeb, :controller

  def metrics(conn, _params) do
    # Collect runtime metrics from Erlang VM
    Oak.Prometheus.collect_runtime_metrics(Oak.MetricsStore)

    # Get all metrics in Prometheus format
    metrics_text = Oak.Prometheus.output_metrics(Oak.MetricsStore)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, metrics_text)
  end
end
```

**What this controller does:**

- Collects runtime metrics from the Erlang VM
- Outputs all metrics in Prometheus-compatible format
- Serves metrics as plain text at the `/metrics` endpoint

### Step 6: Add the Metrics Route

Add the metrics endpoint to your router. Open `lib/your_app_web/router.ex`:

```elixir
defmodule YourAppWeb.Router do
  use YourAppWeb, :router

  # ... your existing routes

  scope "/", YourAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/metrics", MetricsController, :metrics  # Add this line
  end

  # ... other scopes
end
```

**Note**: The `/metrics` path is a common convention for Prometheus scraping, but you can use any path you prefer.

### Step 7: Add Custom Business Metrics

Oak isn't just for HTTP metrics - you can track any business logic. Here's an example of tracking user registrations:

```elixir
defmodule YourApp.Accounts do
  # ... existing code

  def register_user(user_params) do
    case create_user(user_params) do
      {:ok, user} ->
        # Increment user registration counter
        counter = Oak.Metric.Counter.new("user_registrations_total", "Total user registrations", %{})

        case Oak.Prometheus.get_metric(Oak.MetricsStore, Oak.Prometheus.get_counter_id(counter)) do
          nil ->
            Oak.Prometheus.push_metric(Oak.MetricsStore, counter |> Oak.Metric.Counter.inc(1))

          metric ->
            Oak.Prometheus.push_metric(Oak.MetricsStore, metric |> Oak.Metric.Counter.inc(1))
        end

        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
```

**Key points for custom metrics:**

- Always check if the metric exists before creating a new one
- Use descriptive names and help text
- Add relevant labels for filtering and grouping
- Handle errors gracefully

### Step 8: Test Your Integration

Now let's test that everything is working:

Start your application:

```bash
$ mix phx.server
```

Visit your home page to generate some HTTP metrics. Then check the metrics endpoint

```bash
$ curl http://localhost:4000/metrics
```

Look for your metrics** in the output. You should see:

- `http_requests_total` counters
- `request_duration` histograms
- Erlang VM metrics
- Your custom business metrics


### Production Considerations

Consider protecting your metrics endpoint in production with basic auth:

```elixir
# Add basic authentication
plug :basic_auth

defp basic_auth(conn, _opts) do
  case get_req_header(conn, "authorization") do
    ["Basic " <> credentials] ->
      # Verify credentials
      conn
    _ ->
      conn
      |> put_status(401)
      |> put_resp_header("www-authenticate", "Basic realm=\"Metrics\"")
      |> halt()
  end
end
```

## Resources

- [Oak GitHub Repository](https://github.com/Clivern/Oak)
- [Integrating Oak with Phoenix Applications](https://github.com/Clivern/Oak/blob/main/Phoenix_Integration.md)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Phoenix Framework](https://phoenixframework.org/)
- [Elixir Documentation](https://elixir-lang.org/docs.html)

[Oak](https://github.com/Clivern/Oak) provides a solid foundation for monitoring and observability in your Phoenix applications. Start with the basics and gradually add more sophisticated metrics as your needs grow.
