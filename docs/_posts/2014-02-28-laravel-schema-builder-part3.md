---
title: Laravel Schema Builder Part3
date: 2014-02-28 00:00:00
featured_image: https://images.unsplash.com/photo-1580873317709-31f73ee56ead?q=75&fm=jpg&w=1000&fit=max
excerpt: Once you database tables created ,it is a complex task to update these tables names and their structure .But i think laravel has another opinion .Let's get started and i will show you how laravel take care of you.
---

![](https://images.unsplash.com/photo-1580873317709-31f73ee56ead?q=75&fm=jpg&w=1000&fit=max)

Once you database tables created, it is a complex task to update these tables names and their structure. But i think laravel has another opinion .Let's get started and i will show you how laravel take care of you.

The first thing we need is to change table name. Here's an example.

```php
Schema::create('clients',function($table){
  //add clients table structure
  $table->integer('id')->primary();
 });
 //change clients table name to customers
Schema::rename('clients','customers');
```

Also if you like to drop table ,You can use `dropIfExists()` like that.

```php
//drop customers table if exists
Schema::dropIfExists('customers');
```

If you like to drop column .You can provide column name to `dropColumn()` method .This method accepts array if you like to drop many columns. Here's an example.

```php
Schema::table('clients',function($table){
 //drop name column
 $table->dropColumn('name');
 //drop username,email and pwd columns
 $table->dropColumn(array('username','email','pwd'));
});
```

We can simply rename any column with `renameColumn()` method. Here's an example.

```php
Schema::table('clients',function($table){
 //rename name column to username
 $table->renameColumn('name','usename');
});
```

Do you remember primary keys that we explored in part1 of this series. Here's simple example of primary keys.

```php
Schema::create('clients',function($table){
 //add clients table structure
 $table->integer('id')->primary();
});
```

Now we can drop primary attribute of `id` column using `dropPrimary()` method like that.

```php
Schema::table('clients',function($table){
 	$table->dropPrimary('id');
});
```

`dropUnique()` and `dropIndex()` is same as `dropPrimary()` except that they accept single parameter, which consists of table name ,column name and unique or index separated by underscores . first let's create table with columns holding these attributes.

```php
Schema::create('clients',function($table){
  //add clients table structure
  $table->integer('id')->index();
  $table->string('email',150)->unique();
});
```

Here's how to remove these attributes.

```php
Schema::table('clients',function($table){
  //drop unique attribute from email column
  $table->dropUnique('clients_email_unique');
  //drop index attribute from id coulmn
  $table->dropIndex('clients_id_index');
});
```