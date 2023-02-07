---
title: Working With Laravel Caching
date: 2014-04-10 00:00:00
featured_image: https://images.unsplash.com/photo-1706277183539-abdfffc59b12?q=75&fm=jpg&w=1000&fit=max
excerpt: Caching is a temporary data storage used to store data for a while and can be retrieved quickly. It is often used to reduce the times we need to access database or other remote services. It can be a wonderful tool to keep your application fast and responsive.
---

![](https://images.unsplash.com/photo-1706277183539-abdfffc59b12?q=75&fm=jpg&w=1000&fit=max)

Caching is a temporary data storage used to store data for a while and can be retrieved quickly. It is often used to reduce the times we need to access database or other remote services. It can be a wonderful tool to keep your application fast and responsive.

Laravel provides various caching drivers. To explore supported drivers, Open `app/config/cache.php` and you will find a list of supported drivers and other options. By default, laravel use file driver which store cached data in `app/storage/cache`.

```php
//app/config/cache.php
return array(
 //Default Cache Driver
 'driver' => 'file',

 //File Cache Location
 'path' => storage_path().'/cache',

 //Database Cache Connection
 'connection' => null,
 //Database Cache Table
 'table' => 'cache',

 //Memcached Servers
 'memcached' => array(
   array('host' => '127.0.0.1', 'port' => 11211, 'weight' => 100),
  ),

 //Cache Key Prefix
 'prefix' => 'laravel',
);
```

To store an item in the cache, You can use `Cache::put()` method. This method accepts 3 parameters.

- `$key`: Item key used as identifier.
- `$value`: Item value.
- `$minutes`: Expire time in minutes.


Here's an example.

```php
//app/routes.php
Route::get('test', function(){
 Cache::put('title', 'Clivern', 30);
});
```
To store item in the cache if it doesn't exist, You can use `Cache::add()`. This method has the same parameters of `Cache::put()`. It returns `true` if item added and `false` otherwise. Here's an example.

```php
//app/routes.php
Route::get('test', function(){
 Cache::put('title', 'Clivern', 30);
});
```

To retrieve previously created items, You might use `Cache::has()` method to check if item exist and then retrieve it's value with `Cache::get()`.

```php
//app/routes.php
Route::get('test', function(){
 if(Cache::has('title')){
  return Cache::get('title');
 }
});
```

The `Cache::get()` method can accept second parameter which is the value to return if cached item not exist or expired. You can call it default value.

```php
//app/routes.php
Route::get('test', function(){
  return Cache::get('unknown_key','default value');
});
```

To store cached items forever, You can use `Cache::forever()`. This method has only two parameters. The first is the item key and the second is the value.

```php
//app/routes.php
Route::get('test', function(){
   Cache::forever('keywords', 'laravel,php,frameworks');
});
```

To remove an item from cache, You can use `Cache::forget()` method. This method accepts one parameter which is the item key.

```php
Route::get('test', function(){
  Cache::forget('keywords');
  Cache::forget('title');
});
```

### Database Cache

You may need to create custom table to hold all caching data. You will need first to create migration file by running the following command in your terminals.

```php
$php artisan migrate:make create_cache_table

Created Migration: 2014_04_09_234537_create_cache_table
Generating optimized class loader
```

Now we are ready to build table schema. It should be look like this.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCacheTable extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
           //create table
           Schema::create('cache', function($table){
            $table->string('key')->unique();
            $table->text('value');
            $table->integer('expiration');
           });
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
         //drop table
         Schema::drop('cache');
	}

}
```

Let's run our migrations to create `cache`table.

```zsh
$php artisan migrate:install

Migration table created successfully.
```

```zsh
$php artisan migrate

Migrated: 2014_04_09_234537_create_cache_table
```

Open `app/config/cache.php` and change cache driver into database like that.

```php
//app/config/cache.php
return array(
 //Default Cache Driver
 'driver' => 'database',

 //File Cache Location
 'path' => storage_path().'/cache',

 //Database Cache Connection
 'connection' => null,
 //Database Cache Table
 'table' => 'cache',

 //Memcached Servers
 'memcached' => array(
   array('host' => '127.0.0.1', 'port' => 11211, 'weight' => 100),
  ),

 //Cache Key Prefix
 'prefix' => 'laravel',
);
```

Well Done! Now our cached data will be saved in `cache` table.