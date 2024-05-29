---
title: Working With MySQL Unions
date: 2014-03-11 00:00:00
featured_image: https://images.unsplash.com/photo-1660023218127-3c44fd9132ae?q=90&fm=jpg&w=1000&fit=max
excerpt: MySQL unions used to combine the results of multiple `SELECT` statements into one result. MySQL supports both `UNION` and `UNION ALL` for joining `SELECT` results.
---

![](https://images.unsplash.com/photo-1660023218127-3c44fd9132ae?q=90&fm=jpg&w=1000&fit=max)

MySQL unions used to combine the results of multiple `SELECT` statements into one result. MySQL supports both `UNION` and `UNION ALL` for joining `SELECT` results.

Before learning to use `UNION`, We need to create tables and records to work with. Just run the following SQL statement.

```sql
CREATE TABLE `other_users` (
   `id` int(11) not null,
   `username` varchar(50) not null,
   `email` varchar(100) not null,
   `status` enum('1','2','3') not null default '1',
   PRIMARY KEY (`id`),
   UNIQUE KEY (`username`),
   UNIQUE KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `other_users` (`id`, `username`, `email`, `status`) VALUES
('1', 'helen', 'helen@clivern.com', '1'),
('2', 'jenny', 'jenny@clivern.com', '1'),
('3', 'maya', 'maya@clivern.com', '2'),
('4', 'selen', 'selen@clivern.com', '3'),
('5', 'owlif', 'owlif@clivern.com', '1');

CREATE TABLE `other_users_meta` (
   `id` int(11) not null auto_increment,
   `user_id` int(11) not null,
   `key` varchar(50) not null,
   `value` varchar(200) not null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=11;

INSERT INTO `other_users_meta` (`id`, `user_id`, `key`, `value`) VALUES
('1', '1', 'visits', '58'),
('2', '2', 'visits', '30'),
('3', '3', 'visits', '600'),
('4', '4', 'visits', '405'),
('5', '5', 'visits', '275'),
('6', '1', 'book', 'learn wp'),
('7', '2', 'book', 'learn laravel'),
('8', '3', 'book', 'learn design'),
('9', '4', 'book', 'learn develop'),
('10', '5', 'book', 'learn dash');

CREATE TABLE `users` (
   `id` int(11) not null,
   `username` varchar(50) not null,
   `email` varchar(100) not null,
   `status` enum('1','2','3') not null default '1',
   PRIMARY KEY (`id`),
   UNIQUE KEY (`username`),
   UNIQUE KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `users` (`id`, `username`, `email`, `status`) VALUES
('1', 'hjohn', 'john@clivern.com', '1'),
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
('1', '1', 'visits', '52'),
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

Well. Let's select user data and user meta data for user exist in `users` table and join result with user data and user meta data for user exist in `other_users` table.

```sql
mysql> SELECT u.username, u.email, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id=1 AND m.key='visits'
    -> UNION
    -> SELECT ou.username, ou.email, om.value
    -> FROM other_users ou
    -> INNER JOIN other_users_meta om ON ou.id=om.user_id
    -> WHERE ou.id=1 AND om.key='visits';
+----------+-------------------+-------+
| username | email             | value |
+----------+-------------------+-------+
| hjohn    | john@clivern.com  | 52    |
| helen    | helen@clivern.com | 58    |
+----------+-------------------+-------+
2 rows in set (0.00 sec)
```

For valid `UNION` statement, All select statements must select the same columns. By default `UNION` remove any duplicates while the the `UNION ALL` return all rows. To better understand the difference, check the following examples.

```sql
mysql> SELECT u.username, u.email, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id<3 AND m.key='visits'
    -> UNION
    -> SELECT u.username, u.email, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id<1 AND m.key='visits';
+----------+------------------+-------+
| username | email            | value |
+----------+------------------+-------+
| hjohn    | john@clivern.com | 52    |
| mark     | mark@clivern.com | 300   |
+----------+------------------+-------+
2 rows in set (0.00 sec)
```

```sql
mysql> SELECT u.username, u.email, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id<3 AND m.key='visits'
    -> UNION ALL
    -> SELECT u.username, u.email, m.value
    -> FROM users u
    -> INNER JOIN users_meta m ON u.id=m.user_id
    -> WHERE u.id<3 AND m.key='visits';
+----------+------------------+-------+
| username | email            | value |
+----------+------------------+-------+
| hjohn    | john@clivern.com | 52    |
| mark     | mark@clivern.com | 300   |
| hjohn    | john@clivern.com | 52    |
| mark     | mark@clivern.com | 300   |
+----------+------------------+-------+
4 rows in set (0.00 sec)
```