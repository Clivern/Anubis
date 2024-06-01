---
title: Understanding Prometheus Metric Types
date: 2024-07-11 00:00:00
featured_image: https://images.unsplash.com/photo-1648822232933-95800d6faed4
excerpt: Here is the four metrics supported by Prometheus, along with their use cases and functions that can be used to query these metric types.
---

![](https://images.unsplash.com/photo-1648822232933-95800d6faed4)

Here is the four metrics supported by Prometheus, along with their use cases and functions that can be used to query these metric types.

### Counters

A Counter represents a single value that can only increase over time or reset to zero (usually due to a restart or reset of the process generating it).

Counters are ideal for monitoring the rate of events like number of requests, tasks completed .. etc

The counter metric name typically ends with "_total" by convention.

Here is the metric format:

```text
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET", api="add_product"} 4633433
```

Do not use a counter to expose a value that can decrease but instead use a gauge.

Here is Some `PromQL` functions commonly used with counter metrics, along with their use cases:

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

Here is the metric format:

```text
# HELP home_temperature_current Current temperature in celsius
# TYPE home_temperature_current gauge
home_temperature_current 25
```

Here is Some `PromQL` functions commonly used with gauge metrics, along with their use cases:

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

### Histogram



### Summary

