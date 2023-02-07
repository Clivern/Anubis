---
title: Laravel ORM Part3
date: 2014-03-06 00:00:00
featured_image: https://images.unsplash.com/photo-1515767175197-2c7c3e3a3959?q=75&fm=jpg&w=1000&fit=max
excerpt: We have discovered eloquent fetching methods in previous parts. It's time to fine tune query constraints as they add custom rules to our queries.
---

![](https://images.unsplash.com/photo-1515767175197-2c7c3e3a3959?q=75&fm=jpg&w=1000&fit=max)

We have discovered eloquent fetching methods in previous parts. It's time to fine tune query constraints as they add custom rules to our queries.

I hope, You already read collection from start to be familiar with methods discussed here.

### Constraints

#### Where

The `where()` method used to retrieve table rows by matching value of columns. For example.

```php
Route::get('users', function(){
 //get user where username is mary
 return User::where('username','=','mary')
         ->get();
 //outputs: [{"id":5,"username":"mary",...
});
```

This method takes three parameters. The first parameter is column name. The second parameter is comparison operator (`<` , `>` , `=>` , `=<`). The third parameter is the value of column. Let's lead with another example but this time i will match part of `username`.

```php
Route::get('users', function(){
 //get user where username begin with m and id more than 1
 return User::where('username','LIKE','m%')
         ->where('id','>','1')
         ->get();
 //outputs: [{"id":2,"username":"mark",..},{"id":5,"username":"mary"...}]
});
```

#### WhereBetween

The `whereBetween()` method used to retrieve table rows in which column value between two provided values.

```php
Route::get('users', function(){
 //get user where id between 2 and 4
 return User::whereBetween('id',array(2,4))
         ->get();
 //outputs: [{"id":2,..},{"id":3,..},{"id":4,..}]
});
```

There's also `whereNotBetween()` method which is the reverse of `whereBetween()` method.

#### WhereRaw

The `whereRaw()` method used to apply many WHERE conditions to SQL string. For example.

```php
Route::get('users', function(){
 //get user where id is 2  and username begin with m
 return User::whereRaw('id = ? and username LIKE ?',array('2','m%'))
         ->get();
 //outputs: [{"id":2,"username":"mark",...}]
});
```

#### OrWhere

This method used as chained to allow another condition to match. here's an example.

```php
Route::get('users', function(){
 //get user where id is 1 or 2
 return User::where('id','=',1)
         ->orwhere('id','=',2)
         ->get();
 //outputs: [{"id":2,..}]
 //because there is no user with id =2
});
```

#### WhereNested

The `whereNested()` used to apply multiple `where()` constraints. It is similar to chained `where()` constraints.

```php
Route::get('users', function(){
 //get user where id > 1 and username begin with m
 return User::whereNested(function($sQL){
  $sQL->where('id','>',1);
  $sQL->where('username','LIKE','m%');
 })
         ->get();
 //outputs: [{"id":2,..},{"id":4,..},{"id":5,..}]
});
```

#### WhereNull

The `whereNull()` method used to retrieve rows in which provided coulumn has null values. For example.

```php
Route::get('users', function(){
 //get user with username = null
 return User::whereNull('username')
         ->get();
 //outputs: []
});
```

The `whereNotNull()` is the reverse.If you used it in this example,you will get all users.

#### WhereIn

This method is similar to `in_array()` PHP function but needle will be column values. For example.

```php
Route::get('users', function(){
 //get user with username is mary or john or mike
 return User::whereIn('username', array('mary','john','mike'))
         ->get();
 //outputs: [{"id":5,"username":"mary",..}]
});
```

The `whereNotIn()` is the reverse of this method.

#### OrderBy

This method used to order returned results by value of provided column. The first parameter is the name of the column and the second one is `asc` or `desc`.

```php
Route::get('users', function(){
 //get users where id > 1 in desc order
 return User::where('id','>',1)
        ->orderBy('id','desc')
        ->get();
 //outputs: [{"id":7,...},{"id":6,...}...]
});
```

#### Take

This method used to limit returned rows.Let's use this method with last example.

```php
Route::get('users', function(){
 //get users where id > 1 in desc order
 //then get only result
 return User::where('id','>',1)
        ->orderBy('id','desc')
        ->take(1)
        ->get();
 //outputs: [{"id":7,...}]
});
```

#### Skip

This method used to provide an offset to returned results.for example

```php
Route::get('users', function(){
 //get users where id > 1 in desc order
 //then get only result after skipping first result
 return User::where('id','>',1)
        ->orderBy('id','desc')
        ->take(1)
        ->skip(1)
        ->get();
 //outputs: [{"id":6,...}]
});
```

As you can see the first row skipped and second one returned.