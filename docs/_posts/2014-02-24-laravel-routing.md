---
title: Laravel Routing
date: 2014-02-24 00:00:00
featured_image: https://images.unsplash.com/photo-1452979081267-f541411cb48e?q=75&fm=jpg&w=1000&fit=max
excerpt: Laravel 4.1 provides us with a handful routing API which can be used for both small and large application .Also with this API you can define RESTful controllers ,and controllers can have predefined methods to receive requests via GET,PUT,DELETE,POST and UPDATE .we will see this later in subsequent tutorials but now we will discus basic routing API.
---

![](https://images.unsplash.com/photo-1452979081267-f541411cb48e?q=75&fm=jpg&w=1000&fit=max)

Laravel 4.1 provides us with a handful routing API which can be used for both small and large application .Also with this API you can define RESTful controllers ,and controllers can have predefined methods to receive requests via GET,PUT,DELETE,POST and UPDATE. we will see this later in subsequent tutorials but now we will discuss basic routing API.

Behind the scenes, If you open `app/routes.php` you will find the following code.

```php
Route::get('/', function()
{
	return View::make('hello');
});
```

his code tell Laravel the URI it should respond to and give it the closure to execute when that URI is requested .The first parameter passed `/` means default url `http://localhost/<laravel dir>/public/` and the second parameter is the view file `app/views/hello.php`.

Let's go ahead and create our first route.

```php
Route::get('about',function(){
        return "Hello World";
});
```

Now when you hit `http://localhost/<laravel dir>/public/about` ,you will see hello world message .Laravel routing API support other HTTP verbs .Here are some of them.

```php
Route::get($uri, $action);
Route::post($uri, $action);
Route::put($uri, $action);
Route::any($uri, $action);
Route::delete($uri, $action);
```

All of these methods have the same parameters .The first parameter is the URL and the second parameter is the action closure .Closures can be assigned to variables and passed to function like that.

```php
$message = function(){
 return "Hello World";
};
Route::get('about',$message);
```

Lets's create a collection of routes for digital products store application.

```php
/* http://localhost/<laravel dir>/public/store/cameras */
Route::get('store/cameras',function(){
 return "Cameras Section";
});
/* http://localhost/<laravel dir>/public/store/laptops */
Route::get('store/laptops',function(){
 return "Laptops Section";
});
/* http://localhost/<laravel dir>/public/store/accessories */
Route::get('store/accessories',function(){
 return "Accessories Section";
});
```

This might be a little confusing because of repetition .Route parameters can reduce this.

### Route Parameters

Route parameters used to insert placeholders in your routes .These placeholders can be accessed again in your application logic. Let's reduce last example repetition.

```php
/* http://localhost/<laravel dir>/public/store/cameras */
/* http://localhost/<laravel dir>/public/store/laptops */
/* http://localhost/<laravel dir>/public/store/accessories */
Route::get('/store/{product}',function($product){
 return "{$product} Section";
});
```

Route parameters can be optional by using `?` after route parameter like that.

```php
/* http://localhost/<laravel dir>/public/clients */
/* http://localhost/<laravel dir>/public/clients/mike */
/* http://localhost/<laravel dir>/public/clients/john */
Route::get('/clients/{name?}',function($name = 'clif'){
 return "{$name}";
});
```

### Named Routes

Laravel has provided ability to name your routes .How useful is this ? well ,when your application has many routes ,it may be hard to remember them.So ,you can simply assign a nickname to each route .Also when you change route URL ,you don't have to change route resources in views as it select route by its nickname not URL. You may specify a name for a route like so:

```php
Route::get('blog/about', array('as' => 'about', function(){
		//
}));
```

### Secure Routes

Secure routes allow your application to respond to secure HTTP URLs .This can be done by adding the `https` index to your routing.

```php
Route::get('blog/about', array('https','as' => 'about', function(){
	//
}));
```

Our route will respond to requests made to route using HTTPS protocol.

### Parameter Constraints

In all previous routes .Clients can assign any value to route parameters .What if your clients visit `http://localhost/<laravel dir>/public/clients/2568` ,laravel will respond with `2568` message .So ,you need to validate route parameters to respond only to names.

```php
Route::get('/clients/{name?}',function($name = 'clif'){
 return "{$name}";
})
->where('name', '[A-Za-z]+');
```

### Route Groups

Route groups can encapsulate our routes and apply a filter, custom url prefix or change host url to a group of routes. Here's an example.

```php
Route::group(array('before' => 'auth'), function()
{
   Route::get('/pages/{page}', function()
   {
     // Has Auth Filter
   });
   Route::get('/posts/{post}', function()
   {
     // Has Auth Filter
   });
});
```

In the above example we apply the same filter to a group of routes .Filters is another feature we will explore later.

If many routes share a common URL structure .You can put them in a group and provide the common prefix to avoid repetition.

```php
Route::group(array('prefix' => 'site'), function()
{
   Route::get('page', function()
   {
     return "../site/page";
   });
   Route::get('post', function()
   {
     return "../site/post";
   });
});
```

You can change the hostname of a group of routes by supplying this hostname to route grouping array. Here's an example.

```php
Route::group(array('domain' => '{demo}.clivern.com'), function()
{
 Route::get('app/{id}', function($demo, $id)
 {
  //render view
 });
 Route::get('plugins/{pid}', function($demo, $pid)
 {
  //render view
 });
});
```