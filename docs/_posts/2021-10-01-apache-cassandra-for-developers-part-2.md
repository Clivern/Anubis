---
title: Apache Cassandra for Developers Part 2
date: 2021-10-01 00:00:00
featured_image: https://images.unsplash.com/photo-1503961371391-3b99f64f0b0b
excerpt: In Cassandra for Developers Part 1, I explained how to run cassandra cluster with docker, replication and consistency strategies. Here i will explain CQL statements, data types and multi-row partitions
---

![](https://images.unsplash.com/photo-1503961371391-3b99f64f0b0b)

In [Cassandra for Developers Part 1](https://clivern.com/apache-cassandra-for-developers-part-1/ "https://clivern.com/apache-cassandra-for-developers-part-1/"), I explained how to run cassandra cluster with docker, replication and consistency strategies. Here i will explain CQL statements, data types and multi-row partitions

### Getting Started

Install Docker and docker-compose for testing purposes

```bash
$ apt-get update
$ apt install docker.io
$ systemctl enable docker
$ apt install docker-compose
```

### Setup a Node Cluster

Let’s create a `docker-compose.yml` file for a single node

```yaml
version: '3'

services:
  n1:
    build: .
    image: cassandra-with-cqlshrc
    networks:
      - cluster

networks:
  cluster: null
```

And create `Dockerfile`

```
FROM cassandra:4.0

COPY cqlshrc /root/.cqlshrc
and create cqlshrc file
```

And create `cqlshrc` file

```
[connection]

;; a timeout in seconds for opening a new connection
timeout = 60

;; a timeout in seconds to execute queries
request_timeout = 60
Bring up the cluster node and wait
```

Bring up the cluster node and wait

```
$ docker-compose up -d
```

Get cluster nodes status

```
$ docker-compose exec n1 nodetool status
```

Use `cqlsh` command line tool

```
$ docker-compose exec n1 cqlsh

cqlsh> create keyspace clivern with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

cqlsh> use clivern;
```

### CQL statements

To create a table

```
cqlsh:clivern> create table if not exists user (id uuid primary key, username varchar);

cqlsh:clivern> alter table user add firstname varchar;

cqlsh:clivern> desc table user;

CREATE TABLE clivern.user (
    id uuid PRIMARY KEY,
    firstname text,
    username text
) WITH additional_write_policy = '99p'
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';
```

To insert rows

```
cqlsh:clivern> insert into user (id, username) values (92d99616-a899-487a-852c-40bee1d9b6eb, 'joe');

cqlsh:clivern> insert into user (id, username) values (92d9962e-9710-4c63-81c7-fc7fb31b3162, 'doe');
```

To select rows

```
cqlsh:clivern> select * from user where id = 92d99616-a899-487a-852c-40bee1d9b6eb limit 1;

cqlsh:clivern> select * from user where username = 'joe' limit 1;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING"

cqlsh:clivern> select * from user where username = 'joe' ALLOW FILTERING;
```

To update rows

```
cqlsh:clivern> update user set firstname = 'Joe' where id = 92d99616-a899-487a-852c-40bee1d9b6eb;

cqlsh:clivern> select * from user where id = 92d99616-a899-487a-852c-40bee1d9b6eb limit 1;

 id                                   | firstname | username
--------------------------------------+-----------+----------
 92d99616-a899-487a-852c-40bee1d9b6eb |       Joe |      joe
```

To delete rows

```
cqlsh:clivern> delete from user where id = 92d99616-a899-487a-852c-40bee1d9b6eb;

cqlsh:clivern> select * from user where id = 92d99616-a899-487a-852c-40bee1d9b6eb limit 1;

 id | firstname | username
----+-----------+----------

(0 rows)
```
