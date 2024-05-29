---
title: Laravel Schema Builder Part1
date: 2014-02-28 00:00:00
featured_image: https://images.unsplash.com/photo-1531210194434-2bc4d24185a8?q=90&fm=jpg&w=1000&fit=max
excerpt: Does your application need to store data in a database? Well let's see if laravel will give help. Laravel support MySQL, SQLite, PostgreSQL and SQL Server Platforms. Also it has very flexible abstraction layer. It can work with multi database applications. Secured as it escape value for you .Let's explore how laravel take care of you.
---

![](https://images.unsplash.com/photo-1531210194434-2bc4d24185a8?q=90&fm=jpg&w=1000&fit=max)

Does your application need to store data in a database? Well let's see if laravel will give help. Laravel support MySQL, SQLite, PostgreSQL and SQL Server Platforms. Also it has very flexible abstraction layer. It can work with multi database applications. Secured as it escape value for you .Let's explore how laravel take care of you.

### Configuartions

All database configuarations exist in `app/config/database.php`. Let's check some of them.

```php
/* head over to app/config/database.php to check complete configs */
return array(
    'fetch' => PDO::FETCH_CLASS,
    'default' => 'mysql',
    'connections' => array(/*...*/)
);
```

By default, database results returned as instances of the PHP stdClass object but you can retrieve records in array format by using `PDO::FETCH_ASSOC` fetch mode .Also you can use other PDO fetch modes.

Then you will need to set database connections for your application and default database connection name like that.

```php
/* .... */
'default' => 'mysql',
'connections' => array(
/*......*/
   'mysql' => array(
          'driver'    => 'mysql',
	  'host'      => 'localhost',
	  'database'  => 'laravel',
          'username'  => 'root',
	  'password'  => '',
	  'charset'   => 'utf8',
	  'collation' => 'utf8_unicode_ci',
	  'prefix'    => '',
    ),
/* .... */
),
/* .... */
```

I provided connection configurations (driver, host, database ...) to `mysql` connection and then used as my default database connection.

Your application doesn't have to work with a single database. You can provide a number of different database connections and switch between them later. Here's an example.

```php
/* ..... */
'connections' => array(
	    'mysql' => array(
	           'driver'    => 'mysql',
	           'host'      => 'localhost',
	           'database'  => 'laravel',
	           'username'  => 'root',
	           'password'  => '',
	           'charset'   => 'utf8',
	           'collation' => 'utf8_unicode_ci',
	           'prefix'    => '',
	     ),
             'mysql_1'=>array(/*connection data*/),
             'mysql_2'=>array(/*connection data*/),
             'mysql_3'=>array(/*connection data*/),
/* ... */
```

It is worth noting that prefix option add common prefix to your database tables.

### Schema Builder

The `Schema` class support different data types and can define the structure of your tables with ease .Before working with `Schema` class ,I'd like to provide our traditional way to create database tables.

```sql
CREATE TABLE `clients` (
   `id` int(11) not null auto_increment,
   `name` varchar(100) not null,
   `email` varchar(150) not null,
   `biography` mediumtext not null,
   `created_at` datetime not null,
   `updated_at` datetime not null,
   `status` enum('on','off') default 'on',
   PRIMARY KEY (`id`),
   UNIQUE KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
```

To create `clients` table with `Schema` class ,use `create()` method like that.

```php
Schema::create('clients',function($table){
  //table structure here
});
```

Then add auto incrementing primary key `id` using `increments()` method.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
});
```

If the `increments()` method not big enough, You can use `bigIncrements()`. It  creates big integers.

To add `name` column use `string()` method like that.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
  $table->string('name',100);
});
```

`email` column is like `name` column except that its value must be unique .You can use chain `unique()` method to make column unique like that.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
  $table->string('name',100);
  $table->string('email',150)->unique();
});
```

The `text()` method can be used to create columns which store large data like blog posts .It accepts only one parameter .The name of the column .Let's create `biography` column.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
  $table->string('name',100);
  $table->string('email',150)->unique();
  $table->text('biography');
});
```

The `dateTime()` can create `created_at` and `updated_at` columns like that.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
  $table->string('name',100);
  $table->string('email',150)->unique();
  $table->text('biography');
  $table->dateTime('created_at');
  $table->dateTime('updated_at');
});
```

The last column in `clients` table can be created like that.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->increments('id');
  $table->string('name',100);
  $table->string('email',150)->unique();
  $table->text('biography');
  $table->dateTime('created_at');
  $table->dateTime('updated_at');
  $table->enum('status',array('on','off'));
});
```

The last code is the complete code that can create `clients` table and replace our traditional SQL Query.

Actually `Schema` class has much more methods for column types .Feel free to check documentations for further methods.