---
title: How To Build Forms With Laravel
date: 2014-03-11 00:00:00
featured_image: https://images.unsplash.com/photo-1511533910568-be3ffdc229bb?q=90&fm=jpg&w=1000&fit=max
excerpt: In fact, Laravel supports a bunch of handy methods that can handle form creation with ease. We are going to explore these methods.
---

![](https://images.unsplash.com/photo-1511533910568-be3ffdc229bb?q=90&fm=jpg&w=1000&fit=max)

In fact, Laravel supports a bunch of handy methods that can handle form creation with ease. We are going to explore these methods.

Before creating form fields, We need to create two routes. One for our form view and another for form submittion and validation.

```php
Route::get('form', function(){
 //render app/views/form.blade.php
 return View::make('form');
});

Route::post('form-submit', array('before'=>'csrf',function(){
 //form validation come here
}));
```

Then let's create our form, Just create new file `app/views/form.blade.php` and write the following.

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

  {{ Form::close() }}
 </body>
</html>
```

Well. Let's explore resulting source file.

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
  <form method="POST" action="http://localhost/<laravel dir>/public/form-submit" accept-charset="UTF-8">
   <input name="_token" type="hidden" value="h7xNdTaJXwLz5v0lkBolVPelpxldoiDR5gcKWkku">
  </form>
 </body>
</html>
```

Perhaps you don't like laravel defaults so let's provide our options.

```html
{{ Form::open(array(
         'url'=>'form-submit',
          <!--POST or GET or DELETE-->
          'method'=>'POST',
          'accept-charset'=>'UTF-8',
          <!--IF form contain file upload input-->
          'files'=>true
            )) }}
```

Now we are ready to submit fields to our form.

### Text Inputs

Text inputs used to collect string data, Here's how to create text inputs.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- text input field -->
{{ Form::label('username','Username',array('id'=>'','class'=>'')) }}
{{ Form::text('username','clivern',array('id'=>'','class'=>'')) }}

{{ Form::close() }}
```

### Textarea Inputs

Similar to text inputs except that we will use `textarea()` method. Here's an example.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- textarea field -->
{{ Form::label('biog','Biog.',array('id'=>'','class'=>'')) }}
{{ Form::textarea('biog','biog here',array('id'=>'','class'=>'')) }}

{{ Form::close() }}
```

### Password Inputs

You know, Password inputs used to hide data and here's how to create them.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- password inputs -->
{{ Form::label('password','Password',array('id'=>'','class'=>'')) }}
{{ Form::password('password','',array('id'=>'','class'=>'')) }}

{{ Form::close() }}
```

### Email Inputs

Actually it's similar to text inputs except that modern browser (typically which support HTML5) will validate user inputs.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- email input -->
{{ Form::label('email','Email',array('id'=>'','class'=>'')) }}
{{ Form::email('email','hello@clivern.com',array('id'=>'','class'=>'')) }}

{{ Form::close() }}
```

### Selectboxes

We can use `select()` method to create selectboxes. This method take optional parameter which is the key of the value that appear as selected. Here's an example.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- select box -->
{{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
{{ Form::select('status',array('enabled'=>'Enabled','disabled'=>'Disabled'),'enabled') }}

{{ Form::close() }}
```

### Radio Buttons

Radio buttons can be created with `radio()` method like that.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- radio buttons -->
{{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
{{ Form::radio('status','enabled',true) }} Enabled
{{ Form::radio('status','disabled') }} Disabled

{{ Form::close() }}
```

### CheckBoxes

Checkboxes can be created with `checkbox()` method like that.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- checkbox -->
{{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
{{ Form::checkbox('status','1',true) }} Enabled

{{ Form::close() }}
```

### Hidden Inputs

Sometimes we need to submit extra data with our forms. Hidden inputs are perfect for this mission.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- hidden field -->
{{ Form::hidden('record_to_update','1') }}

{{ Form::close() }}
```

### Buttons

Let's take a look at the buttons that laravel provides.

```html
{{ Form::open(array('url'=>'form-submit')) }}

<!-- submit buttons -->
{{ Form::submit('Save') }}

<!-- reset buttons -->
{{ Form::reset('Reset') }}

<!-- normal buttons -->
{{ Form::button('Normal') }}

{{ Form::close() }}
```

Well. I summarized all inputs that we created through article in the following snippet and then source file result.

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
  {{ Form::text('username','clivern',array('id'=>'','class'=>'')) }}

  <!-- textarea field -->
  {{ Form::label('biog','Biog.',array('id'=>'','class'=>'')) }}
  {{ Form::textarea('biog','biog here',array('id'=>'','class'=>'')) }}

  <!-- password inputs -->
  {{ Form::label('password','Password',array('id'=>'','class'=>'')) }}
  {{ Form::password('password','',array('id'=>'','class'=>'')) }}

  <!-- email input -->
  {{ Form::label('email','Email',array('id'=>'','class'=>'')) }}
  {{ Form::email('email','hello@clivern.com',array('id'=>'','class'=>'')) }}

  <!-- select box -->
  {{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
  {{ Form::select('status',array('enabled'=>'Enabled','disabled'=>'Disabled'),'enabled') }}

  <!-- radio buttons -->
  {{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
  {{ Form::radio('status','enabled',true) }} Enabled
  {{ Form::radio('status','disabled') }} Disabled

  <!-- checkbox -->
  {{ Form::label('status','Status',array('id'=>'','class'=>'')) }}
  {{ Form::checkbox('status','1',true) }} Enabled

  <!-- hidden field -->
  {{ Form::hidden('record_to_update','1') }}

  <!-- submit buttons -->
  {{ Form::submit('Save') }}

  <!-- reset buttons -->
  {{ Form::reset('Reset') }}

  <!-- normal buttons -->
  {{ Form::button('Normal') }}

  {{ Form::close() }}
 </body>
</html>
```

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
  <form method="POST" action="http://localhost/<laravel dir>/public/form-submit" accept-charset="UTF-8">
   <input name="_token" type="hidden" value="h7xNdTaJXwLz5v0lkBolVPelpxldoiDR5gcKWkku">
   <!-- text input field -->
   <label for="username" id="" class="">Username</label>
   <input id="" class="" name="username" type="text" value="clivern">
   <!-- textarea field -->
   <label for="biog" id="" class="">Biog.</label>
   <textarea id="" class="" name="biog" cols="50" rows="10">biog here</textarea>
   <!-- password inputs -->
   <label for="password" id="" class="">Password</label>
   <input name="password" type="password" value="" id="password">
   <!-- email input -->
   <label for="email" id="" class="">Email</label>
   <input id="" class="" name="email" type="email" value="hello@clivern.com">
   <!-- select box -->
   <label for="status" id="" class="">Status</label>
   <select id="status" name="status">
    <option value="enabled" selected="selected">Enabled</option>
    <option value="disabled">Disabled</option>
   </select>
   <!-- radio buttons -->
   <label for="status" id="" class="">Status</label>
   <input checked="checked" name="status" type="radio" value="enabled" id="status"> Enabled
   <input name="status" type="radio" value="disabled" id="status"> Disabled
   <!-- checkbox -->
   <label for="status" id="" class="">Status</label>
   <input checked="checked" name="status" type="checkbox" value="1" id="status"> Enabled
   <!-- hidden field -->
   <input name="record_to_update" type="hidden" value="1">
   <!-- submit buttons -->
   <input type="submit" value="Save">
   <!-- reset buttons -->
   <input type="reset" value="Reset">
   <!-- normal buttons -->
   <button type="button">Normal</button>
  </form>
 </body>
</html>
```