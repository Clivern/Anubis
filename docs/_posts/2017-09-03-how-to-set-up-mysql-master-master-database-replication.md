---
title: How To Set Up MySQL Master-Master Database Replication
date: 2017-09-03 00:00:00
featured_image: https://images.unsplash.com/photo-1525120334885-38cc03a6ec77
excerpt: One of the most difficult tasks for software engineers is scaling out the databases incase of large traffic applications. Today we will discuss one of the horizontal scaling techniques which is the Master-Master replication. Master-Master replication adds speed and redundancy and also distribute the writes load over many servers.
---

![](https://images.unsplash.com/photo-1525120334885-38cc03a6ec77)

One of the most difficult tasks for software engineers is scaling out the databases incase of large traffic applications. Today we will discuss one of the horizontal scaling techniques which is the Master-Master replication. Master-Master replication adds speed and redundancy and also distribute the writes load over many servers.

**Please note that our server is Ubuntu 16.04 and MySQL Server is 5.7**

##### Install MySQL

First we need to install MySQL on two servers and keep the Private IP address:

```
sudo apt-get update
sudo apt-get install mysql-server mysql-client
sudo mysql_secure_installation
```

Let's assume that the private IP of `Server 1` is `x.x.x.x` and the Private IP of `Server 2` is `y.y.y.y`.

##### MySQL’s Configuration

###### Server 1 (x.x.x.x)

Open `/etc/mysql/mysql.conf.d/mysqld.cnf` for `Server 1` (`x.x.x.x`) and modify to be look like:

```
server-id              		= 1
log_bin                		= /var/log/mysql/mysql-bin.log
expire_logs_days        	= 10
max_binlog_size   	        = 100M
bind-address    		= x.x.x.x
```

Then Restart the MySQL Server

```
sudo service mysql restart
```

###### Server 2 (y.y.y.y)

Open `/etc/mysql/mysql.conf.d/mysqld.cnf` for `Server 2` (`y.y.y.y`) and modify to be look like:

```
server-id              		= 2
log_bin                		= /var/log/mysql/mysql-bin.log
expire_logs_days        	= 10
max_binlog_size   		= 100M
bind-address    		= y.y.y.y
```

Then Restart the MySQL Server

```
sudo service mysql restart
```

##### Replication Users

No we need to create users used for replication on the two MySQL Servers

###### Server 1 (x.x.x.x)

Log into Server 1

```
mysql -u root -p
```

And create replication user. Replace password with a strong password

```
create user 'replicator'@'%' identified by 'password';
grant replication slave on *.* to 'replicator'@'%';
```

###### Server 2 (y.y.y.y)

Log into Server 2

```
mysql -u root -p
```

And create replication user. Replace password with a strong password

```
create user 'replicator'@'%' identified by 'password';
grant replication slave on *.* to 'replicator'@'%';
```

##### Configure Replication

###### Server 1 (x.x.x.x)

Log into Server 1

```
mysql -u root -p
```

And get Master Status (`master_log_file`, `master_log_pos`)

```
SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000002 |      413 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.01 sec)
```

###### Server 2 (y.y.y.y)

Log into Server 2

```
mysql -u root -p
```

And get Master Status (`master_log_file`, `master_log_pos`)

```
SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000002 |      751 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

###### Server 1 (x.x.x.x)

Log into Server 1

```
mysql -u root -p
```

And Set the `Server 2` (`y.y.y.y`) user, password, master log file and master log pos.

```
STOP SLAVE;
CHANGE MASTER TO master_host='y.y.y.y', master_port=3306, master_user='replication', master_password='password', master_log_file='mysql-bin.000002', master_log_pos=751;
START SLAVE;
```

###### Server 2 (y.y.y.y)

Log into Server 2

```
mysql -u root -p
```

And Set the `Server 1` (`x.x.x.x`) user, password, master log file and master log pos.

```
STOP SLAVE;
CHANGE MASTER TO master_host='x.x.x.x', master_port=3306, master_user='replication', master_password='password', master_log_file='mysql-bin.000002', master_log_pos=413;
START SLAVE;
```

Now We finished! Test by creating database & table on one server and check if it is replicated to the other server. Also the reverse

```
create database repdb;
create table repdb.test (`id` varchar(10));
```