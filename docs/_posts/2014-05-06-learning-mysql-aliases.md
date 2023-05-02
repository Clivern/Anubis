---
title: Learning MySQL Aliases
date: 2014-05-06 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: MySQL aliases are simply nicknames used to express tables, columns and functions' names. These nicknames can be used in your queries to make them short and neat. Let's explore this feature.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

MySQL aliases are simply nicknames used to express tables, columns and functions' names. These nicknames can be used in your queries to make them short and neat. Let's explore this feature.

Before digging into MySQL aliases, we need to create test database, two tables and insert some dummy data.

```sql
CREATE TABLE `posts` (
   `post_id` int(11) not null auto_increment,
   `post_title` varchar(150) not null,
   `user_id` int(11) not null,
   PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

CREATE TABLE `users` (
   `user_id` int(11) not null auto_increment,
   `first_name` varchar(50) not null,
   `last_name` varchar(50) not null,
   `username` varchar(60) not null,
   PRIMARY KEY (`user_id`),
   UNIQUE KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `username`) VALUES
('1', 'mark', 'josh', 'marjo'),
('2', 'selen', 'john', 'selejo'),
('3', 'helen', 'john', 'helejo'),
('4', 'sandra', 'delen', 'sandele'),
('5', 'taylor', 'semoz', 'taysem');

INSERT INTO `posts` (`post_id`, `post_title`, `user_id`) VALUES
('1', 'PHP cURL', '1'),
('2', 'PHP cURL', '2'),
('3', 'PHP stdClass', '3'),
('4', 'PHP strings', '4'),
('5', 'PHP arrays', '5'),
('6', 'PHP & MySQL', '3'),
('7', 'PHP mysqli', '4');
```

### Table Aliases

Table aliases are used to express tables' names in shorter form. You can set table alias using `AS` keyword or without it. This means that

```sql
mysql> SELECT user_id, username FROM users AS usr;
```

is similar to

```sql
mysql> SELECT user_id, username FROM users AS usr;
```

Explore the following example to understand table aliases.

```sql
mysql> SELECT usr.username, pos.post_title FROM
    -> users AS usr INNER JOIN posts AS pos
    -> USING (user_id) WHERE usr.user_id > 3;

+----------+-------------+
| username | post_title  |
+----------+-------------+
| sandele  | PHP strings |
| taysem   | PHP arrays  |
| sandele  | PHP mysqli  |
+----------+-------------+
3 rows in set (0.00 sec)
```

As you can see, the `users` table is aliased as `usr` and `posts` table is aliased as `pos`. This allows you to express columns in more compact form (`usr.column_name`).

Actually the previous example is simple and doesn't show the power of this feature so let's make things a bit difficult. Suppose you want to select posts which have the same title and the corresponding user id. To do this you might try a query like the following.

```sql
mysql> SELECT pos1.user_id, pos2.post_title
    -> FROM posts AS pos1, posts AS pos2
    -> WHERE pos1.post_title = pos2.post_title
    -> AND pos1.user_id != pos2.user_id;

+---------+------------+
| user_id | post_title |
+---------+------------+
|       2 | PHP cURL   |
|       1 | PHP cURL   |
+---------+------------+
2 rows in set (0.00 sec)
```

As you can see, The previous query do the following:

- It selects user id and post title (`SELECT pos1.user_id, pos2.post_title`).
- ..then specifies tables and their aliases (`FROM posts AS pos1, posts AS pos2`).
- ..then put the condition (post name equal and corresponding user id not equal) (`WHERE pos1.post_title = pos2.post_title AND pos1.user_id != pos2.user_id;`)


### Column Aliases

Column aliases are similar to table aliases but the `AS` keyword is required and mustn't be omitted. Consider the following example.

```sql
mysql> SELECT username AS usnam FROM users;

+---------+
| usnam   |
+---------+
| helejo  |
| marjo   |
| sandele |
| selejo  |
| taysem  |
+---------+
5 rows in set (0.00 sec)
```

As you can see, the column `username` is aliased as `usnam`. You can see that in the output. Let's explore another advanced example.

```sql
mysql> SELECT CONCAT(first_name," ",last_name) AS full_name
    -> FROM users ORDER BY full_name;

+--------------+
| full_name    |
+--------------+
| helen john   |
| mark josh    |
| sandra delen |
| selen john   |
| taylor semoz |
+--------------+
5 rows in set (0.00 sec)
```

Well, I used `CONCAT()` function to concate the `first_name` and `last_name` of users and aliased them as `full_name`. Let's explore another example for further understanding.

```sql
mysql> SELECT CONCAT(first_name," ",last_name," posted ",post_title)
    -> AS full_data FROM users INNER JOIN posts USING (user_id)
    -> ORDER BY full_data;

+---------------------------------+
| full_data                       |
+---------------------------------+
| helen john posted PHP & MySQL   |
| helen john posted PHP stdClass  |
| mark josh posted PHP cURL       |
| sandra delen posted PHP mysqli  |
| sandra delen posted PHP strings |
| selen john posted PHP cURL      |
| taylor semoz posted PHP arrays  |
+---------------------------------+
7 rows in set (0.00 sec)
```