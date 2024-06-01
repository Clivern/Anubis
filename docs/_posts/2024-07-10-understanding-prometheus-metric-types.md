---
title: Understanding Prometheus Metric Types
date: 2024-07-10 00:00:00
featured_image: https://images.unsplash.com/photo-1598979571071-758633e652eb
excerpt: Here is the four metrics supported by Prometheus, along with their use cases and functions that can be used to query these metric types.
---

![](https://images.unsplash.com/photo-1598979571071-758633e652eb)

Here is the four metrics supported by Prometheus, along with their use cases and functions that can be used to query these metric types.

### Counters

A Counter represents a single value that can only increase over time or reset to zero (usually due to a restart or reset of the process generating it).

Counters are ideal for monitoring the rate of events like number of requests, tasks completed .. etc

The counter metric name typically ends with `_total` by convention.

Here is an example:

```text
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET", api="add_product"} 4633433
```

NOTE: Do not use a counter to expose a value that can decrease but instead use a gauge.

Some `PromQL` functions commonly used with counter metrics, along with their use cases:

- `rate()`: calculates the per-second average rate of increase of a counter over a specified time range.
- `increase()`: calculates the total increase in a counter's value over a specified time range.
- `sum()`: aggregation operator can be used to sum counter values across multiple time series.
- `irate()`: calculates the instant rate of increase, based on the last two data points.

```
# the per-second rate of HTTP requests over the last 5 minutes.
rate(http_requests_total[5m])

# the total number of HTTP requests in the last hour.
increase(http_requests_total[1h])

# sums the request rates across all instances, grouped by endpoint.
sum(rate(http_requests_total[5m])) by (endpoint)

# calculate the instantaneous per-second rate of change over the last 5 minutes.
irate(http_requests_total[5m])
```

### Gauges

Gauges represent a metric value that can increase or decrease. It can be used to measure values like memory usage, humidity, temperature and queue sizes.

Gauges are often visualized using line graphs to show their value changes over time. They can show the current value rather than the rate of change.

Here is an example:

```text
# HELP home_temperature_current Current temperature in celsius
# TYPE home_temperature_current gauge
home_temperature_current 25
```

Some `PromQL` functions commonly used with gauge metrics, along with their use cases:

- `avg_over_time()`: for computing the average
- `max_over_time()`: for finding the maximum value
- `min_over_time()`: for the minimum value
- `quantile_over_time()`: for determining percentiles within the specified period
- `delta()`: for the difference in the gauge value over the time series

```
# Calculates the average temperature over the last 24 hours.
avg_over_time(home_temperature_current[24h])

# Finds the highest temperature recorded in the last 24 hours.
max_over_time(home_temperature_current[24h])

# Finds the lowest temperature recorded in the last 24 hours.
min_over_time(home_temperature_current[24h])

# Calculates the 95th percentile of temperatures over the last 24 hours.
quantile_over_time(0.95, home_temperature_current[24h])

# Overall change in temperature over the 24-hour period.
delta(home_temperature_current[24h])
```

### Summary

`Summary` metrics are used to measure the sum and count of events. It is ideal for calculating quantiles and averages. They are used for metrics where aggregating over time and space is essential, like request latency or transaction duration.

A `Summary` metric automatically calculates and stores quantiles (e.g., `50th`, `90th`, `95th` percentiles) over time window. This means it tracks both the number of observations (like requests) and their sizes (like latency), and then computes the quantiles of these observations.

For example a metric with a base name `<basename>` exposes multiple time series during a scrape:

- `<basename>{quantile="<x>"}`: Shows the calculated x-quantiles
- `<basename>_sum`: Sum of all observed values
- `<basename>_count`: Total count of observations

Here is an example:

```text
# HELP http_request_duration_seconds The duration of HTTP requests in seconds
# TYPE http_request_duration_seconds summary
http_request_duration_seconds{quantile="0.5"} 0.055
http_request_duration_seconds{quantile="0.9"} 0.098
http_request_duration_seconds{quantile="0.95"} 0.108
http_request_duration_seconds{quantile="0.99"} 0.15
http_request_duration_seconds_sum 600
http_request_duration_seconds_count 10000
```

Some `PromQL` functions commonly used with summary metrics, along with their use cases:

- `summary_over_time()`: Calculates the specified quantiles over a time range for each series in the input vector.
- `quantile()`: Calculates the specified quantile across the input vector.

```text
# Calculates the 99th percentile of request durations over the last 5 minutes
quantile_over_time(0.99, http_request_duration_seconds[5m])

# Calculates the 99th percentile across all request duration time series at the current moment
quantile(0.99, http_request_duration_seconds)
```

You can measure the above percentiles with `numpy` like the following

```python
import numpy as np

a = np.array([1, 2, 3, 4, 5])

print(np.percentile(a, 50))
print(np.percentile(a, 90))
print(np.percentile(a, 95))
print(np.percentile(a, 99))
```

### Histogram

`Histograms` are used to sample and aggregate distributions, such as latencies. `Histograms` categorize measurement data into defined intervals, known as buckets, and count the number of measurements that fit into each of these buckets. These buckets are pre-defined during the instrumentation stage.

For example a metric with a base name `<basename>` exposes multiple time series during a scrape:

- `<basename>_bucket{le=<upper inclusive bound>}`: These are the individual bucket time series, where `<basename>` is the name of the `histogram` metric and `<upper inclusive bound>` is the upper bound of each bucket. The values in these time series represent the cumulative count of observations that fall into each bucket.
- `<basename>_sum`: This time series represents the sum of all observed values.
- `<basename>_count`: This time series represents the total count of all observations. It is identical to the `<basename>_bucket{le=+Inf}` time series.

For example, if we had a `histogram` metric named `http_request_duration_seconds` with buckets at `0.1`, `0.5`, `1.0`, `2.5`, `5.0`, and `10.0` seconds, the following time series would be exposed:

```text
http_request_duration_seconds_bucket{le="0.1"} 100
http_request_duration_seconds_bucket{le="0.5"} 200
http_request_duration_seconds_bucket{le="1.0"} 350
http_request_duration_seconds_bucket{le="2.5"} 500
http_request_duration_seconds_bucket{le="5.0"} 700
http_request_duration_seconds_bucket{le="10.0"} 900
http_request_duration_seconds_bucket{le="+Inf"} 1000
http_request_duration_seconds_sum 5000
http_request_duration_seconds_count 1000
```

Some `PromQL` functions commonly used with histogram metrics, along with their use cases:

- `histogram_quantile()`:  Calculates the specified quantile over a time range for each series in the input vector

```text
# Calculates the 99th percentile of request durations over the last 5 minutes
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

NOTE: `Histograms` are useful when you need to calculate arbitrary quantiles, have lower client overhead, and can tolerate some quantile error. `Summaries` are better when you only need a fixed set of quantiles, have higher client overhead, and need precise quantile error bounds
