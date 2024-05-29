---
title: How to Setup a HA Cassandra Cluster
date: 2021-11-01 00:00:00
featured_image: https://images.unsplash.com/photo-1588611845066-f56f220559e9?q=90&fm=jpg&w=1000&fit=max
excerpt: Apache Cassandra is a NoSQL database with flexible deployment options that's highly performant (especially for writes), scalable, fault-tolerant, and proven in production. Alternative NoSQL databases include Amazon DynamoDB, Apache HBase, and MongoDB.
---

![](https://images.unsplash.com/photo-1588611845066-f56f220559e9?q=90&fm=jpg&w=1000&fit=max)

Apache Cassandra is a NoSQL database with flexible deployment options that's highly performant (especially for writes), scalable, fault-tolerant, and proven in production. Alternative NoSQL databases include Amazon DynamoDB, Apache HBase, and MongoDB.

Assuming we have the following servers

```
Hostname             Public IP     Private IP
-----------         -----------    ----------
cassandra01         10.10.10.10     1.1.1.1
cassandra02         11.11.11.11     2.2.2.2
cassandra03         12.12.12.12     3.3.3.3
```

Install Cassandra on the first three servers

```bash
$ sudo apt update
$ sudo apt upgrade -y
$ sudo apt install openjdk-8-jdk apt-transport-https -y
$ java -version
$ sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 40x main" > /etc/apt/sources.list.d/cassandra.list'
$ wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
$ sudo apt update
$ sudo apt install cassandra
$ sudo systemctl enable cassandra
```

Adjust the `/etc/cassandra/cassandra.yaml` on the first three servers.

```
. . .

cluster_name: 'ProdCassandraCluster'

. . .

seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
         - seeds: "1.1.1.1:7000,2.2.2.2:7000,3.3.3.3:7000"

. . .

listen_address: node_private_ip

. . .

rpc_address: node_private_ip

. . .

endpoint_snitch: GossipingPropertyFileSnitch

. . .

auto_bootstrap: false
```

After adjusting the three cassandra nodes, stop the three, delete system files and start them again

```
$ service cassandra stop
$ sudo rm -rf /var/lib/cassandra/data/system/*
$ service cassandra start
```

### Running Behind HAProxy

_**Please note that:** Datastax Cassandra drivers supports connection pooling and load balancing so they are recommended over HAProxy._

_If you still want to run cassandra behind an HAProxy that's part of the nodes private network, please follow the following steps:_

```
$ apt-get install haproxy
$ service haproxy start
```

Edit HAProxy config file `/etc/haproxy/haproxy.cfg` and restart afterwards.

```
defaults
    mode    tcp

frontend stats
    bind *:8404
    stats enable
    mode http
    stats uri /stats
    stats refresh 10s
    stats admin if LOCALHOST

frontend cassandra-cql
    description "Cassandra CQL"
    bind *:9042
    mode tcp
    option tcplog
    default_backend cassandra-cql

backend cassandra-cql
    description "Cassandra CQL"
    balance leastconn
    mode tcp
    server 1.1.1.1 1.1.1.1:9042 check
    server 2.2.2.2 2.2.2.2:9042 check
    server 3.3.3.3 3.3.3.3:9042 check
```

You should be able to reach cassandra nodes through HAProxy (Public IP 13.13.13.13)

```
$ cqlsh 13.13.13.13 9042
```

HAProxy dashboard will be available via this link [http://13.13.13.13:8404/stats](http://13.13.13.13:8404/stats)

References

* [Cassandra The Definitive Guide](https://www.amazon.com/Cassandra-Definitive-Guide-Distributed-Scale/dp/1491933666)
* [Cassandra Docs](https://cassandra.apache.org/_/index.html "Cassandra Docs")
