---
title: Laravel ORM Part1
date: 2014-03-03 00:00:00
featured_image: https://images.unsplash.com/photo-1535567512880-4ce202f3e3b2
excerpt: Laravel is a MVC PHP framework so it ships with its own ORM component called "Eloquent". Eloquent will take care of records retrieval for us. We don't have to write any SQL line. Let's explore eloquent basic CRUD methods.
---

![](https://images.unsplash.com/photo-1535567512880-4ce202f3e3b2)

Laravel is a MVC PHP framework so it ships with its own ORM component called "Eloquent". Eloquent will take care of records retrieval for us. We don't have to write any SQL line. Let's explore eloquent basic CRUD methods.

### Creating Models

Before we create our model, we need to create table to interact with. Open your terminal and create migration file.

```php
$ php artisan migrate:make creat_tickets

Created Migration: 2014_03_03_184213_creat_tickets
Generating optimized class loader
```

Now let's fill migration file `app/database/migrations/2014_03_03_184213_creat_tickets.php`. I will work with the following structure.

```php
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatTickets extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
     //add tickets table schema
     Schema::create('tickets',function($table){
      $table->increments('id');
      $table->string('title',150);
      $table->text('subject');
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
      Schema::drop('tickets');
	}

}
```

Let's run `migrate` command to and create `tickets` table.

```php
$php artisan migrate

Migrated: 2014_03_03_184213_creat_tickets
```

Well, we can get started. Create new file in `app/models/` and call it `Ticket.php`.

```php
//app/models/Ticket.php
class Ticket extends Eloquent
{
  //done!
}
```

That's all, Eloquent will do the rest. Now let's explort CRUD methods.

### Creating Records

To insert new record, Create instance of `Ticket` class then set columns values then execute `save()` method. Here's an example attached to `new` route.

```php
Route::get('new', function(){
 	//insert ticket
 	$ticket = new Ticket;
 	$ticket->title = 'new issue';
 	$ticket->subject = 'issue details here';
 	$ticket->save();
 	//insert another ticket
 	$ticket = new Ticket;
 	$ticket->title = 'another issue';
 	$ticket->subject = 'issue details here';
 	$ticket->save();
});
```

Let's visit `http://localhost/<laravel dir>/public/new` and then check `tickets` table records.

### Retrieving Records

We will use `find()` method to retrieve instance of a record .It accepts one parameter (`id`). Here's an example.

```php
Route::get('get', function(){
 	//get ticket with id = 1
 	$ticket = Ticket::find('1');
 	echo $ticket->title . '<br/>';
 	echo $ticket->subject . '<br/>';
 	echo $ticket->created_at . '<br/>';
 	echo $ticket->updated_at . '<br/>';
});
```

### Updating Records

Similar to retrieving except that we set values to properties and then call `save()` method. Take a look at the following example.

```php
Route::get('update', function(){
 	//get ticket with id = 1
 	$ticket = Ticket::find('1');
 	//change its data
 	$ticket->title = 'new title';
 	$ticket->subject = 'new subject';
 	//update ticket data
 	$ticket->save();
});
```

### Deleting Records

We could use find method to retrieve record and then call `delete()` method to delete record.

```php
Route::get('delete', function(){
 //get ticket with id = 1
 $ticket = Ticket::find('1');
 //delete it
 $ticket->delete();
});
```

Also we can delete records using `destroy()` method.It accepts single id or array of ids.

```php
Route::get('delete', function(){
 	//delete ticket with id = 2
 	Ticket::destroy('2');
 	//delete some tickets
 	Ticket::destroy(array('2','4','5'));
});
```

It is worth noting that if you don't like to create `created_at` and `updated_at` columns.You must set `timestamps` property to `false` in table model class. Model will look like this.

```php
//app/models/Ticket.php
class Ticket extends Eloquent
{
  //if created_at and updated_at columns
  //not exist
  public $timestamps = false;
}
```