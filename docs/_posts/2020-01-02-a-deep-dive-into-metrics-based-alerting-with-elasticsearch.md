---
title: A Deep Dive into Metrics Based Alerting With Elasticsearch
date: 2020-01-02 00:00:00
featured_image: https://images.unsplash.com/photo-1482444279085-ff5edf603d79?q=5
excerpt: Elasticsearch is an open-source, distributed search and analytics engine based on the Lucene search engine library. It is designed to handle large volumes of data in real-time and provides fast, efficient search and analysis capabilities. Elasticsearch is commonly used for log analysis, full-text search, and business analytics
---

![](https://images.unsplash.com/photo-1482444279085-ff5edf603d79?q=5)

Elasticsearch is an open-source, distributed search and analytics engine based on the Lucene search engine library. It is designed to handle large volumes of data in real-time and provides fast, efficient search and analysis capabilities. Elasticsearch is commonly used for log analysis, full-text search, and business analytics

One of the key features of `Elasticsearch` is its scalability. It can be deployed as a single node or as a cluster of nodes, and new nodes can be added to the cluster to increase its capacity. `Elasticsearch` also provides built-in fault tolerance and replication, which ensures that data is available even if some nodes in the cluster fail.

#### Metrics Based Alerting

`Metrics-based alerting` is a mechanism for monitoring and alerting on specific performance or operational metrics in real-time. It involves defining thresholds or ranges for specific metrics, such as CPU usage or memory consumption, and triggering alerts when these metrics exceeds the defined threshold for a certain period of time.

For example if we store metric `hond.customer_a.cpu_usage` in our elasticsearch cluster. we can query elasticsearch everytime we store a new metric to see if the last metrics stored within x seconds exceeds a certain threshold like the following graph. Also we can have a periodic query to see if the metric `hond.customer_a.cpu_usage` is missing for x seconds.

![](/images/blog/elastic_search_chart.png)

#### Hond Python Package

[Hond](https://github.com/Uptimedog/Hond) is a python package that provides a metrics based alerting based on `elasticsearch` as a datastore. To install `hond`

```bash
pip install hond
```

To create the `elasticsearch` metrics index

```python
from hond.driver.elasticsearch import ElasticSearch
from hond.metric import Metric
from hond.hond import Hond
from hond.trigger import Trigger


driver = ElasticSearch(["http://localhost:9200"], "metrics")
hond = Hond(driver)

# Migrate elasticsearch index
driver.migrate()
```

To insert a new metric:

```python
from hond.driver.elasticsearch import ElasticSearch
from hond.metric import Metric
from hond.hond import Hond
from hond.trigger import Trigger

driver = ElasticSearch(["http://localhost:9200"], "metrics")
hond = Hond(driver)

# Insert a metric
metric = Metric(
    "hond.customer_a.cpu_usage",
    80.2,
    {"agentId": "1bee4e3c-0976-44d9-bf4a-6432857e4f3c"},
)

hond.insert(metric)
```

To evaluate a trigger

```python
from hond.driver.elasticsearch import ElasticSearch
from hond.metric import Metric
from hond.hond import Hond
from hond.trigger import Trigger


driver = ElasticSearch(&#91;"http://localhost:9200"], "metrics")
hond = Hond(driver)

critical_trigger = Trigger(
    "critical_trigger",
    "m{hond.customer_a.cpu_usage>=80}&#91;60s]",
    {"agentId": "1bee4e3c-0976-44d9-bf4a-6432857e4f3c"}
)

hond.evaluate(critical_trigger) # True or False


warning_trigger = Trigger(
    "warning_trigger",
    "m{hond.customer_a.cpu_usage>=60}&#91;60s]",
    {"agentId": "1bee4e3c-0976-44d9-bf4a-6432857e4f3c"}
)

hond.evaluate(warning_trigger) # True or False

ok_trigger = Trigger(
    "ok_trigger",
    "m{hond.customer_a.cpu_usage&lt;60}&#91;60s]",
    {"agentId": "1bee4e3c-0976-44d9-bf4a-6432857e4f3c"}
)

hond.evaluate(ok_trigger) # True or False


missing_trigger = Trigger(
    "missing_trigger",
    "m{hond.customer_a.cpu_usage==nul}&#91;60s]",
    {"agentId": "1bee4e3c-0976-44d9-bf4a-6432857e4f3c"}
)

hond.evaluate(missing_trigger) # True or False
```