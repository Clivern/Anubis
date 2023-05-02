---
title: Laravel Migrations Part1
date: 2014-03-02 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: After building your database schemas ,You should be searching if laravel could give some help and run these schemas .Fortunately laravel migrations come in handy. Laravel use custom table to keep track of all migrations that have already run for your application. You know what ?Let's create a new migration.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

After building your database schemas ,You should be searching if laravel could give some help and run these schemas .Fortunately laravel migrations come in handy. Laravel use custom table to keep track of all migrations that have already run for your application. You know what ?Let's create a new migration.

### Creating Migrations

To create migration files, Open terminal window ,navigate to your project root and run the following artisan command.

```php
$php artisan migrate:make create_tickets

Created Migration: 2014_03_02_023157_create_tickets
Generating optimized class loader
```

The command used is `migrate:make` and then name of our migration. Laravel will create migration template file in `app/database/migrations/2014_03_02_023157_create_tickets.php`. The current time added to file name. Let's check created file first.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTickets extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		//
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		//
	}


}
```

The `up()` method used to provide table creation command while `down()` method used to revert changes that `up()` method create. To make matter simple ,It drop tables. Let's fill `up()` method with our table structure.

```php
/**
 * Run the migrations.
 *
 * @return void
 */
 public function up()
 {
   //use schema builder
   Schema::create('tickets',function($table){
    $table->increments('id');
    $table->string('title',200)->index();
    $table->text('subject');
    $table->timestamps();
   });
  }
```

Now let's tackle the `down()` method.

```php
/**
 * Reverse the migrations.
 *
 * @return void
 */
 public function down()
 {
  //just drop table
  Schema::drop('tickets');
 }
```

### Running Migrations

As i said in introduction that laravel uses custom table to keep track of all migrations. This table name is `migrations` by default but you can change this name from `app/config/database.php`

```php
// Migration Repository Table
'migrations' => 'migrations',
```

Now let's create migrations table by running the following command.

```php
$php artisan migrate:install

Migration table created successfully.
```

When you explore database ,you should find `migrations` table with the defined structure.

Now we are ready to create our tables by running the following command.

```php
$php artisan migrate

Migrated: 2014_03_02_023157_create_tickets
```

When you check your database ,You should see `tickets` table with the defined structure.

### Update Migrations

Sometimes we need to add new column to existing table. You might think to open previously created migrations and add the new column but this should cause problem. Laravel know that you already run these migrations and can't detect any changes performed on them until you rollback these migrations and run them again. To make things simple ,Just create new migration for this column.

```php
$php artisan migrate:make add_notif_col_to_tickets

Created Migration: 2014_03_02_025251_add_notif_col_to_tickets
Generating optimized class loader
```

Open newly created migration `app/database/migrations/2014_03_02_025251_add_notif_col_to_tickets` and add column creation code. I think your code should look like this.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddNotifColToTickets extends Migration {

  /**
   * Run the migrations.
   *
   * @return void
   */
   public function up()
   {
     //add notif col
     Schema::table('tickets',function($table){
      $table->string('notif',10);
     });
   }

   /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
      //drop column
      Schema::table('tickets',function($table){
       $table->dropColumn('notif');
      });
    }

}
```

Then let's run migration command again to apply changes.

```php
$php artisan migrate

Migrated: 2014_03_02_025251_add_notif_col_to_tickets
```
