---
title: Laravel ORM Part2
date: 2014-03-03 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: We discussed later how to retrieve rows as objects and perform basic CRUD methods on them. Well,there are other good tasks that eloquent can perform. Let's discuss some of them and the rest will be discussed in subsequent parts.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

We discussed later how to retrieve rows as objects and perform basic CRUD methods on them. Well,there are other good tasks that eloquent can perform. Let's discuss some of them and the rest will be discussed in subsequent parts.

Let's create a sample table. We need first to create migration file with the following command.

```php
$php artisan migrate:make create_users

Created Migration: 2014_03_03_154640_create_users
Generating optimized class loader
```

Then create table structure. You can build any structure.

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
	   //add table schema
           Schema::create('users', function($table){
            $table->increments('id');
            $table->string('username',60)->unique();
            $table->string('email',100)->unique();
            $table->string('biog',200);
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
         //drop table
         Schema::dropIfExists('users');
	}

}
```

Well, Run our migration file to create `users` table.

```php
$php artisan migrate

Migrated: 2014_03_03_154640_create_users
```

Now our table is ready, We need to fill it with some dummy data so let's explore database seeding.

### Database Seeding

Laravel extends a simple class to seed your database tables. Navigate to `app/database/seeds/`.You will find `DatabaseSeeder.php` file. This file contain `DatabaseSeeder` class. All you have to do is to call `UsersTableSeeder` class from `DatabaseSeeder`.The `UsersTableSeeder` class used to insert dummy data. Here's how to seed `users` table.

```php
class DatabaseSeeder extends Seeder {

    /**
     * Run the database seeds.
     *
     * @return void
     */
      public function run()
      {
	Eloquent::unguard();

        //call uses table seeder class
	$this->call('UsersTableSeeder');
        //this message shown in your terminal after running db:seed command
        $this->command->info("Users table seeded:)");
       }

}

class UsersTableSeeder extends Seeder {

       public function run()
       {
         //delete users table records
         DB::table('users')->delete();
         //insert some dummy records
         DB::table('users')->insert(array(
             array('username'=>'john','email'=>'john@clivern.com','biog'=>'PHP Ninga'),
             array('username'=>'mark','email'=>'mark@clivern.com','biog'=>'JS Ninga'),
             array('username'=>'Karl','email'=>'karl@clivern.com','biog'=>'Jquery Ninga'),
             array('username'=>'marl','email'=>'marl@clivern.com','biog'=>'Not Ninga'),
             array('username'=>'mary','email'=>'mary@clivern.com','biog'=>'HTML Ninga'),
             array('username'=>'sels','email'=>'sels@clivern.com','biog'=>'CSS Ninga'),
             array('username'=>'taylor','email'=>'taylor@clivern.com','biog'=>'Ruby Ninga'),

          ));
       }

}
```

Little confused !don't worry,If you aren't familiar with laravel query builder,I will discuss it soon. Now we are ready to fill `users` table with these dummy data. Just run `db:seed` command like that.

```php
$php artisan db:seed

Seeded: UsersTableSeeder
Users table seeded: )
```

Awesome! Check `users` table.

Now we have table with seven records.Don't lose this happy moment and check fetch methods.

### Fetch Methods

#### All

The `all()` method used to return all rows. Here's an example.

```php
Route::get('users', function(){
 //get all users
 return User::all();
});
```

Navigate to `http://localhost/<laravel dir>/public/users`. You should see this.

```json
[{"id":1,"username":"john","email":"john@clivern.com","biog":"PHP Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":2,"username":"mark","email":"mark@clivern.com","biog":"JS Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":3,"username":"Karl","email":"karl@clivern.com","biog":"Jquery Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":4,"username":"marl","email":"marl@clivern.com","biog":"Not Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":5,"username":"mary","email":"mary@clivern.com","biog":"HTML Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":6,"username":"sels","email":"sels@clivern.com","biog":"CSS Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"},
{"id":7,"username":"taylor","email":"taylor@clivern.com","biog":"Ruby Ninga","created_at":"0000-00-00 00:00:00","updated_at":"0000-00-00 00:00:00"}]
```

#### Find

The `find()` method used to retrieve a single or multiple rows. Here's an example.

```php
Route::get('users', function(){
 //get user with id 1
 return User::find(1);
 //get users with ids 1 and 2
 return User::find(array(1,3));
});
```

I think you can guess results. Visit `http://localhost/<laravel dir>/public/users` if you don't.

#### First

The `first()` method used to retrieve the first record of records set. Here's an example.

```php
Route::get('users', function(){
 //get user with id 1
 return User::first();
 //get user with id 1
 return User::all()->first();
 //get user with id 3
 return User::find(array(3,4,5))->first();
 //set all users to variable
 $all_users = User::all();
 //get user with id 1
 return $all_users->first();
});
```

#### Update

The `update()` method used to update row values. This method can't be used without a constraint. Now let's modify `username` of the record with `id=1` to Adele (my favourite singer but others are welcomed).

```php
Route::get('users', function(){
 //change username to Adele
 User::where('id','=',1)->update(array('username'=>'Adele'));
 //return record after update
 return User::find('1');
 //output will be {"id":1,"username":"Adele",...
});
```

#### Delete

This method used to delete rows. If you don't like Adele, fine! delete her.

```php
Route::get('users', function(){
 //get total number of records (return 7)
 echo User::all()->count();
 //delete record with id=1
 User::where('id','=',1)->delete();
 //get total number of records (return 6)
 echo User::all()->count();
});
```

#### Count

We used this method in last example.It is used to get total number of rows like `count()` PHP function.

#### Get

The `get()` method used to return result of a constraint. Here's an example.

```php
Route::get('users', function(){
 //get record with id = 5
 return User::where('id','=','5')
         //return record catched
         ->get();
});
```

#### toSql

This method used at the end of a query chain to return the SQL line used. Here's an example.

```php
Route::get('users', function(){
 //get SQL which selects record with username = mark
 return User::where('username','=','mark')
         ->toSql();
 //outputs:
 //select * from `users` where `username` = ?
 //get SQL which selects record with username = mark or karl
  return User::where('username','=','mark')
          ->orWhere('username','=', 'karl')
          ->toSql();
  //outputs:
  //select * from `users` where `username` = ? or `username` = ?
});
```

#### Lists

The `lists()` return array of values of specific column passed as first parameter. Here's an example.

```php
Route::get('users', function(){
 //get array of all usernames
 return User::lists('username');
});
```