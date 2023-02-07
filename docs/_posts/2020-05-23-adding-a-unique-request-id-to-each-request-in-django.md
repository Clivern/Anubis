---
title: Adding a Unique Request ID to Each Request in Django
date: 2020-05-23 00:00:00
featured_image: https://images.unsplash.com/photo-1630083132742-a1708141abb9?q=75&fm=jpg&w=1000&fit=max
excerpt: You can do that in Django using a middleware. The middleware needs to generate a unique request id (e.g. using UUID) and associate that id with the request.
---

![](https://images.unsplash.com/photo-1630083132742-a1708141abb9?q=75&fm=jpg&w=1000&fit=max)

You can do that in Django using a middleware. The middleware needs to generate a unique request id (e.g. using UUID) and associate that id with the request.

First way is to attach that id to the `request.META` in the middleware. the only problem is that you have to fetch that id from the request object and pass it as argument to every function in the application layers (service or domain layer), which complicates the function signatures.

Another way is to attach that id to the `request.META` in the middleware. and then create a logging filter which has access to the request object. but somehow not all log records have the `record.request` available especially some of django internal loggers.

I also have seen some who update django logger filters and formatters at runtime to make it work but i didn't like it either.

An alternative is to use thread local variables. These variables are similar to global variables, but their scope is limited within the thread of execution. So in our middleware, we add request id to the thread local variables, and create a filter that access that variable and attach it to any log record.

Here is the code

```python
# file app.middleware.correlation.py

# Standard Library
import logging

# Local Library
from threading import local

_locals = local()


class Correlation():

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        request.META["X-Correlation-ID"] = "XXXX-XXX-XXX-XXX"
        _locals.correlation_id = request.META["X-Correlation-ID"]
        response = self.get_response(request)
        return response


class CorrelationFilter(logging.Filter):

    def filter(self, record):
        if not hasattr(record, 'correlation_id'):
            record.correlation_id = ""
        if hasattr(_locals, 'correlation_id'):
            record.correlation_id = _locals.correlation_id
        return True</pre>
```

```python
# settings.py file

MIDDLEWARE = [
    # ....
    'app.middleware.correlation.Correlation',
    # ....
]

LOGGING = {
    # ....

    'formatters': {
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(filename)s %(module)s %(process)d %(thread)d %(message)s'
        },
        'simple': {
            'format': '%(levelname)s %(asctime)s %(message)s {\'correlationId\':\'%(correlation_id)s\'}'
        },
    },
    'filters': {
        'correlation_filter': {
            '()': 'app.middleware.correlation.CorrelationFilter',
        }
    },
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'filters': ['correlation_filter'],
            'class': 'logging.FileHandler',
            'filename': "/path/to/file.log",
            'formatter': 'simple'
        },
        'console': {
            'level': 'DEBUG',
            'filters': ['correlation_filter'],
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
    },
    # ....

}
```