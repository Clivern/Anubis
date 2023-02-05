---
title: Laravel Requests and Inputs Part1
date: 2014-03-08 00:00:00
featured_image: https://images.unsplash.com/photo-1544411047-c491e34a24e0?q=5
excerpt: Laravel has awesome methods to retrieve, change, create and store request data. It allows you to handle both `$_GET` and `$_POST` data and store in session or cookies. Let's look at some methods of accessing request data.
---

![](https://images.unsplash.com/photo-1544411047-c491e34a24e0?q=5)

Laravel has awesome methods to retrieve, change, create and store request data. It allows you to handle both `$_GET` and `$_POST` data and store in session or cookies. Let's look at some methods of accessing request data.

### Basic Input

The `Input::all()` method used to return array of both `$_GET` and `$_POST` data within current request. Let's create a route that will output all request data.

```php
Route::any('get', function(){
   //return current request data
   var_dump(Input::all());
});
```

Visit `http://localhost/<laravel dir>/public/get?var1=hello&var2=clivern` to see reply.

```php
array (size=2)
  'var1' => string 'hello' (length=5)
  'var2' => string 'clivern' (length=7)
```

As you can see, laravel return array of `$_GET` data. The request data can come from another source, the `$_POST` data. To demonstrate this we need to create simple form and its route.

```php
//app/routes.php
Route::get('form',function(){
   //return app/views/form.blade.php
   return View::make('form');
});
```

```html
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>
   Laravel
  </title>
 </head>
 <body>
  <form action="{{ url('get') }}" method="POST">
   <input type='hidden' name='var3' value='hello' />
   <input type='hidden' name='var4' value='clivern' />
   <input type='submit' value='Submit' />
  </form>
 </body>
</html>
```

Visit `http://localhost/<laravel dir>/public/form` and hit submit button to see reply.

```php
array (size=2)
  'var3' => string 'hello' (length=5)
  'var4' => string 'clivern' (length=7)
```

Laravel return array of the `$_POST` data.

Retrieving complete request data is useful but sometimes we want to retrieve single input data. To retrieve single input with its key, you can use `Input::get()` method.

```php
Route::any('get', function(){
   //return values of var1 and var2 only
   var_dump(Input::get('var1','var2'));
   //also return values of var1 and var2 only
   var_dump(Input::only('var1','var2'));
});
```

Well, if you want to check if specific input exists or not, you can use the `Input::has()` method.

```php
Route::any('get', function(){
   //check if request data contain var1
   var_dump(Input::has('var1'));
});
```

The `Input::except()` method will return all request data and exclude the keys we have provided. For example.

```php
Route::any('get', function(){
   //get all request data except var4 and var5
   var_dump(Input::except('var4','var5'));
});
```

### Old Input

Sometimes we need to store our request data because `$_POST` and `$_GET` data are available only for current request and can't be retrieved in subsequent requests. To demonstrate this, we need to store request data in session or cookies. You can use `withInput()` method to redirect client to new route with old `$_POST` and `$_GET` data.

```php
//app/routes.php
Route::any('get', function(){
   //redirect to new route with current $_GET data
   return Redirect::to('new')->withInput();
});

Route::any('new', function(){
   //Render old $_GET data
   var_dump(Input::old());
});

Route::get('form',function(){
   //return app/views/form.blade.php
   return View::make('form');
});
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
  <form action="{{ url('get') }}" method="POST">
   <input type='hidden' name='var3' value='hello' />
   <input type='hidden' name='var4' value='clivern' />
   <input type='submit' value='Submit' />
  </form>
 </body>
</html>
```

Well. Let's visit `http://localhost/<laravel dir>/public/get?var1=2&var2=56`. Also visit `http://localhost/<laravel dir>/public/form` and hit submit button.You should see this.

```php
// http://localhost/<laravel dir>/public/get?var1=2&var2=56
array (size=2)
  'var1' => string '2' (length=1)
  'var2' => string '56' (length=2)

// http://localhost/<laravel dir>/public/form
array (size=2)
  'var3' => string 'hello' (length=5)
  'var4' => string 'clivern' (length=7)
```

Actually last example shows how to store all data of requests. Let's explore how to store custom list of data.

```php
Route::any('get', function(){
   //redirect to new route with current $_GET['var1']
   return Redirect::to('new')->withInput(Input::only('var1'));
});
Route::any('new', function(){
   //Render old $_GET data
   var_dump(Input::old());
});
```

### Cookies

Laravel provides handy methods to create and retrieve cookies. we can use `Cookie::make()` to create cookie. This method accepts three parameters. The first parameter is the key, the second parameter is the value and the third parameter is the expiry time in minutes. laravel encrypts cookies so don't worry about security. Here's how to create your first cookie.

```php
Route::get('set', function(){
   //create cookie for 30 min
  $Cookie = Cookie::make('CookieKey', 'CookieValue', 30);
});
```

Well, Let's test our cookie by attaching it to route response using `withCookie()` method like that.

```php
Route::get('set', function(){
   //create cookie for 30 min
   $cookie = Cookie::make('Key','value1',30);
   //get cookie value
   return Response::make('value2')->withCookie($cookie);
   //output: value2
});
```

The `get` will retrieve cookie value using `Cookie::get()` method like that.

```php
Route::get('get', function(){
   //get cookie
   var_dump(Cookie::get('Key'));
   //output: string 'value' (length=5)
});
```

Perhaps you need method to check existance of cookie to remove it. Explore the following code.

```php
Route::get('get', function(){
   //check if cookie exist
   if(Cookie::has('Key')){
      //forget cookie
      Cookie::forget('key');
   }
});
```