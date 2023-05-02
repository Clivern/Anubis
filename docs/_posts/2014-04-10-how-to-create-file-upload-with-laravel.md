---
title: How To Create File Upload With Laravel
date: 2014-04-10 00:00:00
featured_image: https://images.unsplash.com/photo-1642488055316-31ef66363823
excerpt: We discussed before form creation and validation but file upload input is a bit different. Let's create our first file upload with laravel.
---

![](https://images.unsplash.com/photo-1642488055316-31ef66363823)

We discussed before form creation and validation but file upload input is a bit different. Let's create our first file upload with laravel.

Before retrieving uploaded file data, We need to setup a simple form and two routes. The first route is for form view and the other route for form submission.

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
  {{ Form::open(array('url'=>'form-submit','files'=>true)) }}

  {{ Form::label('file','File',array('id'=>'','class'=>'')) }}
  {{ Form::file('file','',array('id'=>'','class'=>'')) }}
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
//app/routes.php
Route::get('form', function(){
 return View::make('form');
});

Route::any('form-submit', function(){
 var_dump(Input::file('file'));
});
```

Basically, Uploaded files aren't stored in the `$_GET` or `$_POST` array but they stored in the `$_FILES` array. Fortunately laravel provide a great API to access `$_FILES` array. To retrieve data of uploaded files, You can use `Input::file()` method. Let's dump the value of `Input::file()` and explore the resulted object.

```php
object(Symfony\Component\HttpFoundation\File\UploadedFile)[9]
  private 'test' => boolean false
  private 'originalName' => string 'test.jpg' (length=22)
  private 'mimeType' => string 'image/jpeg' (length=10)
  private 'size' => int 667220
  private 'error' => int 0
```

Well. You can interact with these data by a bunch of methods. The `getFilename()` method used to get temporary file name given to our file on temporary location. Let's try this method.

```php
Route::any('form-submit', function(){
 return Input::file('file')->getFilename();
});
```
The `getClientOriginalName()` method used to get the actual name of the file when it was uploaded.

```php
Route::any('form-submit', function(){
 return Input::file('file')->getClientOriginalName();
});
```

The `getClientSize()` method used to get the size of the uploaded file in bytes.

```php
Route::any('form-submit', function(){
 return Input::file('file')->getClientSize();
});
```

The `getClientMimeType()` method used to get the mime type of uploaded file.

```php
Route::any('form-submit', function(){
 return Input::file('file')->getClientMimeType();
});
```

The `guessClientExtension()` method used to get extension of uploaded file.

```php
Route::any('form-submit', function(){
 return Input::file('file')->guessClientExtension();
});
```

The `getRealPath()` method used to get current location of uploaded file.

```php
Route::any('form-submit', function(){
 return Input::file('file')->getRealPath();
});
```

The `move()` method used used to move uploaded file to another location. The first parameter is the new destination while the second parameter is the new name. Let's see how method work.

```php
Route::any('form-submit', function(){
 return Input::file('file')->move(__DIR__.'/storage/',Input::file('file')->getClientOriginalName());
});
```