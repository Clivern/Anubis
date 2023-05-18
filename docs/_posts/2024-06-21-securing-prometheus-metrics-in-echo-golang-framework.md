---
title: Securing Prometheus Metrics in Echo Golang Framework
date: 2024-06-21 00:00:00
featured_image: https://images.unsplash.com/photo-1593433514364-8db94732d06d
excerpt: Echo golang framework supports Prometheus Metrics middleware, but the middleware itself doesn't support authentication. We can use the basic authentication middleware to secure the metrics endpoint.
---

![](https://images.unsplash.com/photo-1593433514364-8db94732d06d)

[Echo](https://echo.labstack.com/) golang framework supports Prometheus Metrics middleware, but the middleware itself doesn't support authentication. We can use the basic authentication middleware to secure the metrics endpoint.

In your application, you should enable the basic auth middleware only for the `/metrics` endpoint. `BasicAuthConfig` takes two functions:

- `Skipper` to define when to skip the middleware
- `Validator` to validate the credentials, as follows:

```golang
BasicAuthConfig struct {
  // Skipper defines a function to skip middleware.
  Skipper Skipper

  // Validator is a function to validate BasicAuth credentials.
  // Required.
  Validator BasicAuthValidator

  // Realm is a string to define realm attribute of BasicAuth.
  // Default value "Restricted".
  Realm string
}
```

Here is how you can implement it

```golang
import (
    "crypto/subtle"

    "github.com/labstack/echo-contrib/echoprometheus"
    "github.com/labstack/echo/v4"
    "github.com/labstack/echo/v4/middleware"
)

e := echo.New()

e.Use(middleware.BasicAuthWithConfig(middleware.BasicAuthConfig{
    Skipper: func(c echo.Context) bool {
        // Skip basic auth for other routes
        if c.Path() != "/metrics" {
            return true
        }

        return false
    },
    Validator: func(username, password string, c echo.Context) (bool, error) {
        if subtle.ConstantTimeCompare([]byte(username), []byte(/** configured username goes here **/)) == 1 &&
            subtle.ConstantTimeCompare([]byte(password), []byte(/** configured secret goes here **/)) == 1 {
            return true, nil
        }

        return false, nil
    },
}))
e.Use(echoprometheus.NewMiddleware(/**application name**/))

e.GET("/metrics", echoprometheus.NewHandler())
```

In the above example, I used `subtle.ConstantTimeCompare` instead of a simple comparison operator `==`. While you could use the `==` operator, it's better to use `subtle.ConstantTimeCompare` when protecting sensitive routes to avoid [a timing attack](https://en.wikipedia.org/wiki/Timing_attack).

Here is the timing attack in a nutshell. Imaging the following code

```golang
if username == provided_username && secret == provided_secret {
    /** allow access */
}
```

The system will perform a `byte-by-byte` comparison, stopping at the first mismatch. The comparison takes longer when more initial bytes match between the provided inputs and the correct ones. In timing attacks, the attacker can guess the correct value, one byte at a time, by measuring the response time.

Anyways In [prometheus](https://prometheus.io/), you can set the `Authorization` header on every scrape request with the configured username and password. Check the [scrape_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) configuration

```yaml
scrape_configs:
  - job_name: prometheus
    basic_auth:
        username: admin!
        password: secret!
    static_configs:
        - targets:
            - 'localhost:9090'
```
