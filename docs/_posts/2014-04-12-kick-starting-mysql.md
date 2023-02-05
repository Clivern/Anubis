---
title: Kick-Starting MySQL
date: 2014-04-12 00:00:00
featured_image: https://images.unsplash.com/photo-1706277183560-6d26ffbf1c23?q=5
excerpt: Today MySQL is one of the most popular open source databases as it supports millions of web applications. We will discuss the basics of MySQL like creating databases and tables and interacting with data.
---

![](https://images.unsplash.com/photo-1706277183560-6d26ffbf1c23?q=5)

Today MySQL is one of the most popular open source databases as it supports millions of web applications. We will discuss the basics of MySQL like creating databases and tables and interacting with data.

### Creating and Using Database

The second step after designing a database is to create it. You can create database with `CREATE DATABASE` statement. Suppose you want to create `app` database.

```sql
mysql> CREATE DATABASE app;

Query OK, 1 row affected (0.06 sec)
```

To avoid conflicts with other databases, You should add `IF NOT EXISTS` to statement like that.

```sql
mysql> CREATE DATABASE IF NOT EXISTS app;

Query OK, 1 row affected (0.01 sec)
```

Once you have created the database. You should choose it as the database to work with. Just use the following statement.

```sql
mysql> USE app;

Database changed
```

### Creating Tables

Now we are ready to create our first table. I hope you already familiar with column types to be able to create table structure. By the way, Here's the statement to create `users` table.

```sql
mysql> CREATE TABLE `users` (
    ->    `id` int(11) not null auto_increment,
    ->    `name` varchar(60) not null,
    ->    `email` varchar(60) not null,
    ->    `created_at` timestamp not null default CURRENT_TIMESTAMP,
    ->    PRIMARY KEY (`id`),
    ->    UNIQUE KEY (`email`)
    -> ) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

Query OK, 0 rows affected (0.52 sec)
```

#### The `INSERT` Statement

The `INSERT` statement used to insert new data to tables. Here's how to insert new user.

```sql
mysql> INSERT INTO users VALUES (1,'hele','hele@cl.com','2014-04-12 20:46:53');

Query OK, 1 row affected (0.07 sec)
```

To insert many users with one statement, You can do the following.

```sql
mysql> INSERT INTO users VALUES (2,'mark','m@cl.com','2014-04-12 20:46:53'),
    -> (3,'marl','n@cl.com','2014-04-12 20:46:53'),
    -> (4,'keli','k@cl.com','2014-04-12 20:46:53'),
    -> (5,'john','mo@cl.com','2014-04-12 20:46:53');

Query OK, 4 rows affected (0.07 sec)
Records: 4  Duplicates: 0  Warnings: 0
```

Suppose you need to insert data but without using order. You can insert using an alternative syntax.

```sql
mysql> INSERT INTO users (name,email) VALUES ('slee','se@clivern.com');

Query OK, 1 row affected (0.07 sec)
```

```sql
mysql> INSERT INTO users (name,email) VALUES ('lee','lee@clivern.com'),
    -> ('saw','saw@clivern.com'),
    -> ('kell','kell@clivern.com');

Query OK, 3 rows affected (0.06 sec)
Records: 3  Duplicates: 0  Warnings: 0
```

As you can see, Columns names parentheses included before values parentheses. There's another syntax in which you list column name and value together. Here's an example.

```sql
mysql> INSERT INTO users SET name='sandr',email='sandr@clivern.com';

Query OK, 1 row affected (0.05 sec)
```

#### The `SELECT` Statement

The `SELECT` statement used to read data from a table. Let's retrieve all data from `users` table.

```sql
mysql> SELECT * FROM users;

+----+-------+-------------------+---------------------+
| id | name  | email             | created_at          |
+----+-------+-------------------+---------------------+
|  1 | mark  | m@cl.com          | 2014-04-12 20:46:53 |
|  2 | marl  | n@cl.com          | 2014-04-12 20:46:53 |
|  3 | keli  | k@cl.com          | 2014-04-12 20:46:53 |
|  4 | john  | mo@cl.com         | 2014-04-12 20:46:53 |
|  5 | hele  | hele@cl.com       | 2014-04-12 20:46:53 |
|  6 | slee  | se@clivern.com    | 2014-04-12 21:00:39 |
|  7 | lee   | lee@clivern.com   | 2014-04-12 21:02:18 |
|  8 | saw   | saw@clivern.com   | 2014-04-12 21:02:18 |
|  9 | kell  | kell@clivern.com  | 2014-04-12 21:02:18 |
| 10 | sandr | sandr@clivern.com | 2014-04-12 21:04:15 |
+----+-------+-------------------+---------------------+
10 rows in set (0.00 sec)
```

As you can see, I used `*` wildcard character to retrieve all coulmns in the table. If you want to retrieve custom columns, You can do the following.

```sql
mysql> SELECT name, email FROM users;

+-------+-------------------+
| name  | email             |
+-------+-------------------+
| mark  | m@cl.com          |
| marl  | n@cl.com          |
| keli  | k@cl.com          |
| john  | mo@cl.com         |
| hele  | hele@cl.com       |
| slee  | se@clivern.com    |
| lee   | lee@clivern.com   |
| saw   | saw@clivern.com   |
| kell  | kell@clivern.com  |
| sandr | sandr@clivern.com |
+-------+-------------------+
10 rows in set (0.00 sec)
```

The `WHERE` clause allows us to choose which rows to return from `SELECT` statement which means that returned rows passed the condition created by `WHERE` clause. Here's an example.

```sql
mysql> SELECT name, email FROM users WHERE id=5;

+------+-------------+
| name | email       |
+------+-------------+
| hele | hele@cl.com |
+------+-------------+
1 row in set (0.00 sec)
```

In the previous example, We used equals (`=`) operator but we can also use other operators (`>`, `<`, `>=`, `<=` and `!=`). Also we can combine many conditions using `AND`, `OR`, `NOT` and `XOR` operators. Explore the following examples.

```sql
mysql> SELECT name, email FROM users WHERE id>7;

+-------+-------------------+
| name  | email             |
+-------+-------------------+
| saw   | saw@clivern.com   |
| kell  | kell@clivern.com  |
| sandr | sandr@clivern.com |
+-------+-------------------+
3 rows in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id>7 AND name='saw';

+------+-----------------+
| name | email           |
+------+-----------------+
| saw  | saw@clivern.com |
+------+-----------------+
1 row in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id>10 OR name='saw';

+------+-----------------+
| name | email           |
+------+-----------------+
| saw  | saw@clivern.com |
+------+-----------------+
1 row in set (0.00 sec)
```

The `LIKE` clause is used to match strings. For example, If we used `LIKE 'cli%'`, It will match the string `cli` followed by zero or more characters. Also you can match strings that ends with `ern` with `LIKE '%ern'`. Finally, the `LIKE '%ver%'` will match strings that have `ver` substring in them. Let's explore these examples.

```sql
mysql> SELECT name, email FROM users WHERE id>5 AND name LIKE 'sa%';

+-------+-------------------+
| name  | email             |
+-------+-------------------+
| saw   | saw@clivern.com   |
| sandr | sandr@clivern.com |
+-------+-------------------+
2 rows in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id>5 AND name LIKE '%aw';

+------+-----------------+
| name | email           |
+------+-----------------+
| saw  | saw@clivern.com |
+------+-----------------+
1 row in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id>5 AND name LIKE '%a%';

+-------+-------------------+
| name  | email             |
+-------+-------------------+
| saw   | saw@clivern.com   |
| sandr | sandr@clivern.com |
+-------+-------------------+
2 rows in set (0.00 sec)
```

If you like to match strings that start with `s` letter and has lenght of three or more. You should use underscore character like that.

```sql
mysql> SELECT name, email FROM users WHERE id>5 AND name LIKE 's__%';

+-------+-------------------+
| name  | email             |
+-------+-------------------+
| slee  | se@clivern.com    |
| saw   | saw@clivern.com   |
| sandr | sandr@clivern.com |
+-------+-------------------+
3 rows in set (0.00 sec)
```

The `ORDER BY` clause is used to sort returned rows. It is followed by the column that you want to use as sort key and then the order type (`ASC` or `DESC`). Consider the following examples.

```sql
mysql> SELECT name, email FROM users WHERE id<6 ORDER BY name ASC;

+------+-------------+
| name | email       |
+------+-------------+
| hele | hele@cl.com |
| john | mo@cl.com   |
| keli | k@cl.com    |
| mark | m@cl.com    |
| marl | n@cl.com    |
+------+-------------+
5 rows in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id<6 ORDER BY created_at,name DESC;

+------+-------------+
| name | email       |
+------+-------------+
| marl | n@cl.com    |
| mark | m@cl.com    |
| keli | k@cl.com    |
| john | mo@cl.com   |
| hele | hele@cl.com |
+------+-------------+
5 rows in set (0.00 sec)
```

The `LIMIT` clause used to limit the number of rows returned from `SELECT` statement. Here's an example.

```sql
mysql> SELECT name, email FROM users WHERE id<6 ORDER BY name ASC LIMIT 2;

+------+-------------+
| name | email       |
+------+-------------+
| hele | hele@cl.com |
| john | mo@cl.com   |
+------+-------------+
2 rows in set (0.00 sec)
```

It's also can be used to return specific number of rows with offset. Here's an example.

```sql
mysql> SELECT name, email FROM users WHERE id<6 ORDER BY name ASC LIMIT 2,1;

+------+----------+
| name | email    |
+------+----------+
| keli | k@cl.com |
+------+----------+
1 row in set (0.00 sec)
```

```sql
mysql> SELECT name, email FROM users WHERE id<6 ORDER BY name ASC LIMIT 2,2;

+------+----------+
| name | email    |
+------+----------+
| keli | k@cl.com |
| mark | m@cl.com |
+------+----------+
2 rows in set (0.00 sec)
```

#### The `UPDATE` Statement

The `UPDATE` statement is used to change existing data. Here's an example.

```sql
mysql> UPDATE users SET name='new name' WHERE id=5;

Query OK, 1 row affected (0.06 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

```sql
mysql> SELECT name FROM users WHERE id=5;

+----------+
| name     |
+----------+
| new name |
+----------+
1 row in set (0.00 sec)
```

#### The `DELETE` Statement

The `DELETE` statement is used to remove a whole rows. Explore the following example.

```sql
mysql> DELETE FROM users WHERE id=5;

Query OK, 1 row affected (0.07 sec)
```

```sql
mysql> DELETE FROM users WHERE id<4;

Query OK, 3 rows affected (0.07 sec)
```

### Dropping Tables

To drop table, You can use `DROP TABLE` statement like that.

```sql
mysql> DROP TABLE users;

Query OK, 0 rows affected (0.16 sec)
```

### Dropping Database

Similar to previous statement with a little change. You can use `DROP DATABAE` statement to drop database like that.

```sql
mysql> DROP DATABASE app;

Query OK, 0 rows affected (0.06 sec)
```