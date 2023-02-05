---
title: How To Validate Forms With Laravel Part2
date: 2014-03-22 00:00:00
featured_image: https://images.unsplash.com/photo-1568990600861-038159d19fce?q=5
excerpt: We discussed before how to create forms with laravel and then how to build validation rules. Now let's see how to access error messages from form view.
---

![](https://images.unsplash.com/photo-1568990600861-038159d19fce?q=5)

We discussed before how to create forms with laravel and then how to build validation rules. Now let's see how to access error messages from form view.

We need to create simple form so create new file in `app/views/` and name it `form.blade.php` then create two routes, One for form view and another for form submission. You can explore the following code.

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
  {{ Form::label('username','Username',array('id'=>'','class'=>'')) }}
  {{ Form::text('username','',array('id'=>'','class'=>'')) }}
  <br/>
  <!-- email input -->
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

```php
Route::get('form', function(){
    //render app/views/form.blade.php
    return View::make('form');
});

Route::post('form-submit', function(){
    //get all inputs
    $inputs = Input::all();
    //create array of validation rules
    $rules = array(
        'username'=>'required|alpha_dash|min:4|max:35',
        'email'=>'required|email'
    );

    //validate inputs
    $validator = Validator::make($inputs,$rules);

    if($validator->passes()){
        //inputs valid
        echo 'Well';
    }else{
        //return to form view with errors
        return Redirect::to('form')->withErrors($validator);
    }
});
```

All error messages exist in `$errors` variable. You don't have to check for its existance as it automatically added to our form view. As you can see i used `withErrors()` method to add form errors to errors object in form view. Here's how to access errors in form view.

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
  <ul class="errors">
   @foreach($errors->all() as $error)
   <li>{{ $error }}</li>
   @endforeach
  </ul>
  <!-- text input field -->
  {{ Form::label('username','Username',array('id'=>'','class'=>'')) }}
  {{ Form::text('username','',array('id'=>'','class'=>'')) }}
  <br/>
  <!-- email input -->
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

Go a head and visit `http://localhost/<laravel dir>/public/form` and submit form to check how errors shown.

We can use `get()` method to retrieve array of errors for single field. Here's how to access email field errors and username field errors separately.

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

Go a head and visit `http://localhost/<laravel dir>/public/form` and submit form to check how errors shown.
