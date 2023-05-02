---
title: Laravel URL Generation
date: 2014-05-06 00:00:00
featured_image: https://images.unsplash.com/photo-1657085126049-25349bcde5a2
excerpt: In order to build hyperlinks in our applications. We might do this by hand but laravel provides a number of helpers to build URLs. Let's explore them.
---

![](https://images.unsplash.com/photo-1657085126049-25349bcde5a2)

In order to build hyperlinks in our applications. We might do this by hand but laravel provides a number of helpers to build URLs. Let's explore them.

### Routes URLs

`URL::current()`: It returns the current URL. consider the following example.

```php
Route::get('test/route',function(){
   return URL::current();
});

//outputs
//http://<laravel dir>/public/test/route
```

`URL::full()`: It returns the current URL with request data as `GET` parameters. It differs from `URL::current()` as `URL::current()` strips off request data.

```php
Route::get('test/route',function(){
   return URL::full();
});

//visit http://<laravel dir>/public/test/route?foo=1&bar=3
//outputs
//http://<laravel dir>/public/test/route?bar=3&foo=1
```

`URL::previous()`: It returns the URL of the previous request. Consider the following example.

```php
Route::get('first_test/route',function(){
   return Redirect::to('second_test/route');
});
Route::get('second_test/route',function(){
   return URL::previous();
});

//visit http://<laravel dir>/public/first_test/route
//outputs
//http://<laravel dir>/public
```

As you can see, the first route redirects to the second route. Then the second route returns the previous request URL (referer).

`URL::to()`: It returns the URL of specific route passed as parameter. You should note that this method doesn't verify if the route exists or not.

```php
Route::get('test/route',function(){
   return URL::to('another/route');
});

// outputs
//http://<laravel dir>/public/another/route
```

You can provide additional parameters to URL in the form of an array. The parameters will be inserted at the end of the route.

```php
Route::get('test/route',function(){
   return URL::to('another/route', array('foo','2','bar','8'));
});

// outputs
//http://<laravel dir>/public/another/route/foo/2/bar/8
```

`URL::secure()`: It returns the URL to route which uses HTTPS protocol. It accepts two parameters. The first parameter is the route and the second parameter is an optional array of parameters to append at the end of the URL.

```php
Route::get('test/route',function(){
   return URL::secure('another/route', array());
});

// outputs
//https://<laravel dir>/public/another/route
```

It is worth noting that `URL::to()` can be used to generate URLs using HTTPS protocol by passing `true` as third parameter like that.

```php
Route::get('test/route',function(){
   return URL::to('another/route', array(),true);
});
// outputs
//https://<laravel dir>/public/another/route
```

`URL::route()`: It returns the URL of routes using their nicknames. It accepts two parameters. The first parameter is a string representing route nickname and the second parameter is an optional array of parameters to append at the end of the URL. Let's take a look at this in action.

```php
Route::get('test/route',array( 'as' => 'test_route',
 function(){
   return;
 }));
Route::get('another/route',function(){
   return URL::route('test_route', array());
});

//visit
//http://<laravel dir>/public/another/route
// outputs
//http://<laravel dir>/public/test/route
```

`URL::action()`: It returns the URL of controller action. It accepts two parameters. The first parameter is a controller action and the second parameter is an optional array of parameters to append at the end of the URL. Consider the following example.

```php
class BlogUsers extends BaseController
{
 public function AddUser(){

 }
}

Route::get('users/add','AddUser@BlogUsers');
Route::get('users/test',function(){
   return URL::action('AddUser@BlogUsers', array());
});
```

In this example, We created a new controller called `BlogUsers` with method `AddUser`. We attach `users/add` route to controller action. We created a new route which returns the URL of controller action so when you visit `/users/test` URL, You should receive the following.

```php
http://<laravel dir>/public/users/add
```

As i said before, This function accepts an optional array of parameters to append at the end of the URL. Let's see this in action.

```php
/* ... */
Route::get('users/test',function(){
   return URL::action('AddUser@BlogUsers', array('foo'=>8,'bar'=>9));
});
```

When you visit `/users/test` URL, Laravel returns the URL with parameters like this.

```php
http://localhost/laravel/public/users/add?foo=8&bar=9
```

### Assets URLs

URLs to assets such as css files, javascript files and images need to be absolute URLs so Let's take a look at some of the methods used to get assets URLs:

`URL::asset()`: It returns the absolute URL to asset. It accepts two parameters. The first parameter is the relative path to the asset from laravel root and the second parameter is a boolean value representing whether URL is secure or not.

```php
Route::get('asset', function(){
 return URL::asset('/app/public/assets/css/main.css');
});

//visit
//http://<laravel dir>/public/asset
//outputs
//http://<laravel dir>/public/app/public/assets/css/main.css

Route::get('secured_asset', function(){
 return URL::asset('/app/public/assets/css/main.css',true);
});

//visit
//http://<laravel dir>/public/secured_asset
//outputs
//https://<laravel dir>/public/app/public/assets/css/main.css
```

### URLs Generators Shortcuts

All methods discussed before are available to be used in views. However it is good practice to use URL generators shortcuts in your views to make them short and neat.

`url()`: It is identical to `URL::to()` method. consider the following example.

```php
//app/routes.php
Route::get('another/route', function(){
 return View::make('test');
});
```

```html
//app/views/test.blade.php
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>
     Laravel
  </title>
 </head>
 <body>
  <div class="welcome">
   <p>{{ url('another/route') }}</p>
  </div>
 </body>
</html>
```

When you visit `/public/another/route`, you should get the following output.

```html
http://<laravel dir>/public/another/route
```

`secure_url()`: It returns secured URL to the route. It accepts the same parameters as `URL::secure()`. Consider the following example.

```html
<div class="welcome">
 <p>{{ secure_url('another/route') }}</p>
</div>
```

`route()`: It is a shortcut to the `URL::route()` method. It accepts the nickname of the route and returns the URL.

```html
<div class="welcome">
  <p>{{ route('route_nickname') }}</p>
</div>
```

`action()`: It is a shortcut to the `URL::action()` method. It generates links to controller actions.

```html
<div class="welcome">
 <p>{{ action('method_name@controller_name') }}</p>
</div>
```

`asset()`: It is a shortcut to the `URL::asset()` method. It accepts identical parameters. Consider the following example.

```html
<div class="welcome">
 <p>{{ asset('/app/public/assets/css/main.css') }}</p>
</div>
```

`secure_asset()`: It is similar to `asset()` except that it returns secured URL. You can use `asset()` function to return secured URLs by passing `true` as second parameter.

```html
<div class="welcome">
 <p>{{ secure_asset('/app/public/assets/css/main.css') }}</p>
</div>
```

```html
<div class="welcome">
 <p>{{ asset('/app/public/assets/css/main.css', true) }}</p>
</div>
```