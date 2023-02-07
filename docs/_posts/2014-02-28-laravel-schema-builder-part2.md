---
title: Laravel Schema Builder Part2
date: 2014-02-28 00:00:00
featured_image: https://images.unsplash.com/photo-1542613556-1338e812a138?q=75&fm=jpg&w=1000&fit=max
excerpt: Laravel `Schema` class have several methods that have varied uses. Let's take a look at them.
---

![](https://images.unsplash.com/photo-1542613556-1338e812a138?q=75&fm=jpg&w=1000&fit=max)

Laravel `Schema` class have several methods that have varied uses. Let's take a look at them.

The `timestamps()` method used to create `created_at` and `updated_at` columns which used to indicate when row created and updated .Here's how to use this method.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->timestamps();
});
```

The `unique()` method used to make values of provided column unique.

```php
Schema::create('clients',function($table){
  //table structure here
  $table->string('email','150')->unique();
});
```

Now the `email` column will accept only unique values.

Another interesting method is `primary()` which used to make column primary. This method could be used single or chained.

```php
Schema::create('clients',function($table){
  //chained form
  $table->string('username')->primary();
  //single form
  $table->string('username');
  $table->primary('username');
});
```

`index()` method is like `primary()` method. here's an example.

```php
Schema::create('clients',function($table){
  $table->integer('id');
  $table->primary('id');
  $table->index('id');
});
```

Once you pass data to any table ,any column that don't have value will use `null` as its value  .So we always set our column to be nullable .With laravel you set `nullable()` method to `false` to prevent `null` values like that.

```php
Schema::create('clients',function($table){
  $table->string('name')->nullable(false);
});
```

Also you can set default value for a column used if no value passed to this column like that.

```php
Schema::create('clients',function($table){
  $table->string('name')->default('clivern');
});
```

We can use the `unsigned()` method on integer column to make it accept only positive integers. Here's an example.

```php
Schema::create('clients',function($table){
  $table->integer('visits')->unsigned();
});
```
