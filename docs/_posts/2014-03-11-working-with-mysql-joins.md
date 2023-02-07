---
title: Working With MySQL Joins
date: 2014-03-11 00:00:00
featured_image: https://images.unsplash.com/photo-1582105665743-5f7e6ad6d24a?q=75&fm=jpg&w=1000&fit=max
excerpt: In PHP applications, Retrieving data from relational tables generally require the use of joins. MySQL joins enable developers to select data from multiple tables with a single SQL statement. Let's explore MYSQL joins.
---

![](https://images.unsplash.com/photo-1582105665743-5f7e6ad6d24a?q=75&fm=jpg&w=1000&fit=max)

In PHP applications, Retrieving data from relational tables generally require the use of joins. MySQL joins enable developers to select data from multiple tables with a single SQL statement. Let's explore MYSQL joins.

To understand joins, Run the following SQL statement to create `users` and `users_meta` tables.

```sql
CREATE TABLE `users` (
   `id` int(11) not null auto_increment,
   `username` varchar(50) not null,
   `email` varchar(100) not null,
   `status` enum('1','2','3') not null default '1',
   PRIMARY KEY (`id`),
   UNIQUE KEY (`username`),
   UNIQUE KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=6;

INSERT INTO `users` (`id`, `username`, `email`, `status`) VALUES
('1', 'john', 'john@clivern.com', '1'),
('2', 'mark', 'mark@clivern.com', '1'),
('3', 'marl', 'marl@clivern.com', '2'),
('4', 'kim', 'kim@clivern.com', '3'),
('5', 'taylor', 'taylor@clivern.com', '1');

CREATE TABLE `users_meta` (
   `id` int(11) not null auto_increment,
   `user_id` int(11) not null,
   `key` varchar(50) not null,
   `value` varchar(200) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=11;

INSERT INTO `users_meta` (`id`, `user_id`, `key`, `value`) VALUES
('1', '1', 'visits', '50'),
('2', '2', 'visits', '300'),
('3', '3', 'visits', '60'),
('4', '4', 'visits', '40'),
('5', '5', 'visits', '245'),
('6', '1', 'book', 'learn php'),
('7', '2', 'book', 'learn perl'),
('8', '3', 'book', 'learn seo'),
('9', '4', 'book', 'learn js'),
('10', '5', 'book', 'learn css');
```

Well. Imagine you need to retrieve user data and meta data using `user_id`. You could write two SQL lines, One to select user data and another to select user meta data. But with MySQL joins, you can select both with single line. You know what! code better than words.

### Inner Join

Inner join allows us to select data from two tables share the same column with a single SQL line. Let's retrieve data and meta data of user with `id=1`.

```sql
mysql> SELECT users.username, users.email, users_meta.key, users_meta.value
    -> FROM users
    -> INNER JOIN users_meta ON users.id = users_meta.user_id
    -> WHERE users.id = 1;
+----------+------------------+--------+-----------+
| username | email            | key    | value     |
+----------+------------------+--------+-----------+
| john     | john@clivern.com | visits | 50        |
| john     | john@clivern.com | book   | learn php |
+----------+------------------+--------+-----------+
2 rows in set (0.29 sec)
```

Note the following:

- Line 1 selects needed columns from both tables.
- Line 2 provides the default table.
- Line 3 provides inner join with another table and states the column that both tables join.
- Line 4 provides the criteria.

#### Table Alias

It is common to alias tables, Just specify alias after table. Let's create aliases for our tables.

```sql
mysql> SELECT u.username, u.email, m.key, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id = m.user_id
    -> WHERE u.id = 1;
+----------+------------------+--------+-----------+
| username | email            | key    | value     |
+----------+------------------+--------+-----------+
| john     | john@clivern.com | visits | 50        |
| john     | john@clivern.com | book   | learn php |
+----------+------------------+--------+-----------+
2 rows in set (0.00 sec)
```

As you can see, I create alias `u` for `users` table and `m` alias for `users_meta` table.

#### Similar Join

Imagine i renamed `id` column of `users` table to `user_id`, Still you can use the last syntax but another idea can save some time.

```sql
mysql> SELECT u.username, u.email, m.key, m.value
    -> FROM users u
    -> INNER JOIN users_meta m USING (user_id)
    -> WHERE user_id=1;
+----------+------------------+--------+-----------+
| username | email            | key    | value     |
+----------+------------------+--------+-----------+
| john     | john@clivern.com | visits | 50        |
| john     | john@clivern.com | book   | learn php |
+----------+------------------+--------+-----------+
2 rows in set (0.00 sec)
```

As you can see, I used `USING` syntax because the join column has the same name.

### Update and Delete Join

MySQL joins aren't limited to `SELECT` syntax but we can use it in `UPDATE` and `DELETE`. To update user name and visits meta key, do the following.

```sql
mysql> UPDATE users INNER JOIN users_meta ON users.id = users_meta.user_id
    -> SET users.username = 'hjohn', users_meta.value=52
    -> WHERE users.id=1 AND users_meta.key='visits';
Query OK, 2 rows affected (0.35 sec)
Rows matched: 2  Changed: 2  Warnings: 0
```

Well. Let's delete user and his meta data.

```sql
mysql> DELETE u, m
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id=3;
Query OK, 3 rows affected (0.33 sec)
```