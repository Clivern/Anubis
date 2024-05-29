---
title: How To Create Custom Validation Rules With Laravel
date: 2014-03-27 00:00:00
featured_image: https://images.unsplash.com/photo-1460794418188-1bb7dba2720d?q=90&fm=jpg&w=1000&fit=max
excerpt: You don't need laravel built in validation rules and wish if you could create your own validation rules. Well, fortunately laravel is very flexible as it allows you to build your own validation rules and with a bunch of ways.
---

![](https://images.unsplash.com/photo-1460794418188-1bb7dba2720d?q=90&fm=jpg&w=1000&fit=max)

You don't need laravel built in validation rules and wish if you could create your own validation rules. Well, fortunately laravel is very flexible as it allows you to build your own validation rules and with a bunch of ways.

The first way to build you own validation rules is to extend validator class with new rules in `routes.php` file. But first we need to create our form.

```html
<!--app/views/form.blade.php-->
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>
   Laravel
  </title>
 </head>
 <body>
  {{ Form::open(array('url'=>'form-submit')) }}

  <!-- text input field -->
  <ul class="errors">
   @foreach($errors->get('username') as $error)
   <li>{{ $error }}</li>
   @endforeach
  </ul>
  {{ Form::label('username','Username',array('id'=>'','class'=>'')) }}
  {{ Form::text('username','',array('id'=>'','class'=>'')) }}
  <br/>
  <!-- email input -->
  <ul class="errors">
   @foreach($errors->get('email') as $error)
   <li>{{ $error }}</li>
   @endforeach
  </ul>
  {{ Form::label('email','Email',array('id'=>'','class'=>'')) }}
  {{ Form::email('email','',array('id'=>'','class'=>'')) }}
  <br/>
  <!-- submit buttons -->
  {{ Form::submit('Save') }}

  <!-- reset buttons -->
  {{ Form::reset('Reset') }}

  {{ Form::close() }}
 </body>
</html>
```

Then let's extend validator class with new rule.

```php
//create foo validation rule
Validator::extend('foo', function($field,$value,$parameters){
 //return true if field value is foo
 return $value == 'foo';
});
Route::get('form', function(){
 //render app/views/form.blade.php
 return View::make('form');
});

Route::post('form-submit', function(){
 //get all inputs
 $inputs = Input::all();
 //create array of validation rules
 $rules = array('username'=>'required|foo|min:4|max:35','email'=>'required|email');
 //set custom error messages
 $messages = array(
     'foo'=>'Field value must be foo'
 );
 //validate inputs
 $validator = Validator::make($inputs,$rules,$messages);
 if($validator->passes()){
  //inputs valid
  echo 'Well';
 }else{
  //return to form view with errors
  return Redirect::to('form')->withErrors($validator);
 }
});
```

As you can see I used `Validator::extend()` method to create custom validation rule. The first parameter is the field name, The second parameter is the field value and third is an array of any parameters that have been passed to the rule. If a boolean `false` returned, Validation fail and error message appear.Then i created two routes, One for form view and another for form validation.

You may also create stand alone class in `app/validators/` and pass class name and method to `extend()` method instead of closure. You will need to create `app/validators` directory as it doesn't exist by default, create `customValidation.php` file then create `customValidation` class. Each class method represent new validation rule and should passed later to `Validator::extend('rule_name','class@method')` in `routes.php` file.

```php
// app/validators/customValidation.php
 class customValidation
 {
    public function foo($field, $value, $parameters){
    //return true if field value is foo
    return $value == 'foo';
  }
 }
```

```php
//app/routes.php
//create foo validation rule
Validator::extend('foo', 'customValidation@foo');
```

Well, Remember that you will need to update `composer.json` classmap to include new directory (`validators`).

```php
"autoload": {
 "classmap": [
  "app/commands",
  "app/controllers",
  "app/models",
  "app/database/migrations",
  "app/database/seeds",
  "app/tests/TestCase.php",
  "app/validators"
 ]
},
```

Then run the following command in your terminals to update autoloading (`vendor/composer/autoload_classmap.php`). I hope you already have a global install of composer.

```bash
$composer dump-autoload

Generating autoload files
```

Let's open `vendor/composer/autoload_classmap.php` to check changes made.

```php
return array(
  BaseController' => $baseDir . '/app/controllers/BaseController.php',
  /*....*/
  'UsersTableSeeder' => $baseDir . '/app/database/seeds/DatabaseSeeder.php',
  'customValidation' => $baseDir . '/app/validators/customValidation.php',
);
```

Now you can use `foo` rule and add new rules to `customValidation` class but don't forget to extend validator class with these rules.