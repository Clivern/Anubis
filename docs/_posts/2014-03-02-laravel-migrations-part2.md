---
title: Laravel Migrations Part2
date: 2014-03-02 00:00:00
featured_image: https://images.unsplash.com/photo-1603084325971-9590a5e873c6
excerpt: In Laravel Migrations Part1, I discussed how to create, run and update your migrations. It seems you need more and fortunately laravel still have many features to enhance your application migrations. Let's explore some of them.
---

![](https://images.unsplash.com/photo-1603084325971-9590a5e873c6)

In Laravel Migrations Part1, I discussed how to create, run and update your migrations. It seems you need more and fortunately laravel still have many features to enhance your application migrations. Let's explore some of them.

When we created our migrations and explored migration template file. I told you to fill `down()` method with the code that will dump your table .Well ,laravel need this method right now. If for some reason we need to alter one of our migration files ,We can run `migrate:refresh` artisan command. This command will run `down()`method of all migrations and then run them once more.

```php
$ php artisan migrate:refresh

Rolled back: 2014_03_02_025251_add_notif_col_to_tickets
Rolled back: 2014_03_02_023157_create_tickets
Nothing to rollback.
Migrated: 2014_03_02_023157_create_tickets
Migrated: 2014_03_02_025251_add_notif_col_to_tickets
```

Another interesting feature is that using `--create` and switch on `migrate:make` artisan command can save some time. It indicates that your migrations for creating table and laravel will add default code for tables like that.

```php
$ php artisan migrate:make create_projects --create=projects

Created Migration: 2014_03_02_123404_create_projects
Generating optimized class loader
```

Open `app/database/migrations/2014_03_02_123404_create_projects.php` and check created template. This should be like the following.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProjects extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('projects', function(Blueprint $table)
		{
			$table->increments('id');
			$table->timestamps();
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('projects');
	}

}
```

As you can see ,It create `Schema::create()` and `Schema::drop()` and add some defaults to these methods.

We learned before how to update table structure by adding new column. An interesting switch is `--table` which add default code to migration file related to changing table structure. Here's an example.

```php
$ php artisan migrate:make create_users --table=users

Created Migration: 2014_03_02_125214_create_users
Generating optimized class loader
```

When you check newly created migration file `app/database/migrations/2014_03_02_125214_create_users.php`. It should be like that.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsers extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::table('users', function(Blueprint $table)
		{
			//
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::table('users', function(Blueprint $table)
		{
			//
		});
	}

}
```

By using `migrate:rollback` command ,laravel will revert last migration file run.

```php
$ php artisan migrate:rollback

Rolled back: 2014_03_02_025251_add_notif_col_to_tickets
Rolled back: 2014_03_02_023157_create_tickets
```

But if you want to revert all migrations ,You should used `migrate:reset` command.

```php
$ php artisan migrate:reset

Rolled back: 2014_03_02_125214_create_users
Rolled back: 2014_03_02_124731_create_projects
Rolled back: 2014_03_02_025251_add_notif_col_to_tickets
Rolled back: 2014_03_02_023157_create_tickets
Nothing to rollback.
```

You have an application that works with multi databases. Well ,I'm going to rock you with `--database` switch. It can create migrations for specific database. Here's how to use this command.

```php
$ php artisan migrate --database=mysqldb2
```
