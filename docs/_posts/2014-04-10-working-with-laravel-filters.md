---
title: Working With Laravel Filters
date: 2014-04-10 00:00:00
featured_image: https://images.unsplash.com/photo-1520721080161-b4c6a6454306?q=5
excerpt: Laravel filters are a set of rules that can be applied before and after routes to change application actions. Also there is global filters that executed before and after every request. Let's explore laravel filters.
---

![](https://images.unsplash.com/photo-1520721080161-b4c6a6454306?q=5)

Laravel filters are a set of rules that can be applied before and after routes to change application actions. Also there is global filters that executed before and after every request. Let's explore laravel filters.

### Global Filters

Take a look at `app/filters.php`, You will find two filters like the following. These filters applied before and after every request in your application and called global filters. No need to add these filters in your routes as they applied by default to all routes.

```php
//app/filters.php
App::before(function($request)
{
	//
});


App::after(function($request, $response)
{
	//
});
```

### Route Filters

To create filters, Open `app/filters.php` and use `Route::filter()` method. This method accepts 2 parameters, the first parameter is filter name while the second parameter is the closure. Let's create our first filter.

```php
//app/filters.php
//before route
Route::filter('access_perm', function(){
    if(!Cookie::has('__ne_clivern')){
        //send to 404 route
        return Redirect::to('404');
    }
});

// after route
Route::filter('log', function(){
    //used to save logs
});
```

After creating the filter, We can assign it to routes to run before or after route or both like that.

```php
//app/routes.php
Route::get('404', function(){
    return '404 Page';
});

Route::get('profile', array(
    //add before filter
    'before'=>'access_perm',
    //add after filter
    'after'=>'log',
    function(){
        //render app/views/hello.blade.php
        return View::make('hello');
    })
);
```

Each route can accept multiple filters like that.

```php
Route::get('profile',array(
    'before'=>'access_perm|another_filter',
    function(){
   //render app/views/hello.blade.php
    return View::make('hello');
}));
//OR
Route::get('profile',array(
    'before' => array('access_perm','another_filter'),
    function(){
   //render app/views/hello.blade.php
    return View::make('hello');
}));
```

As you can see, The `|` character used to separate filters or you can put filters in an array.

### Filter Parameters

Laravel provides a set of parameters to before and after filters. Let's take a look at these parameters.

```php
//app/filters.php
//before filter
Route::filter('access_perm', function($route,$request){
    var_dump($route);
    var_dump($request);
});

//after filter
Route::filter('log', function($route,$request,$response){
    var_dump($route);
    var_dump($request);
    var_dump($response);
});
```
As you can see, laravel provides a different parameters to before and after filters. both filters have `$route` and `$request` parameters and after filter receives an additional parameter (`$response`). `$route` is an instance of `Illuminate\Routing\Route` object, `$request` is an instance of `Illuminate\Http\Request` object and `$response` is an instance of `Illuminate\Http\Response` object. You should take a look through source code to get a deeper understanding of methods available. The following example shows why you should fine-tune these parameters.

```php
//app/routes.php
Route::get('profile/{view}',array(
    'before' =>"change_view",
    function(){
    return 'defualt view';
}));
```

```php
//app/filters.php
 Route::filter('change_view', function($route,$request){
  if(in_array($route->getParameter('view'), array('first','second','third'))){
   return $route->getParameter('view');
  }
 });
```

As you can see, You can access data about route and request from within filters through these parameters.

### Filter Classes

For advanced filtering, You may wish to create classes that holds filters closures. You might store filters classes file in existing directory but I prefer to create a separate directory like `app/filters` to store filters classes file inside. First we need to update `composer.json` classmap to include `filters` directory.

```json
"classmap": [
	"app/commands",
	"app/controllers",
	"app/models",
	"app/database/migrations",
	"app/database/seeds",
	"app/tests/TestCase.php",
        "app/filters"
]
```

Now we are ready to create our first filter class (`AppFilters.php`).

```php
//app/filters/AppFilters.php
 class ChangeViewFilter {

  public function filter($route, $request) {
   if (in_array($route->getParameter('view'), array('first', 'second', 'third'))) {
    return $route->getParameter('view');
   }
  }

 }
```

Run the following command in your terminal to update autoloading so laravel will be able to read filter class inside `app/filters` directory.

```php
$composer dump-autoload

Generating autoload files
```

Let's include `change_view` filter to be run before `test` route.

```php
//app/filters.php
Route::filter('change_view', 'ChangeViewFilter');
```

```php
//app/routes.php
Route::get('test/{view}',array(
    'before' =>"change_view",
    function(){
    return 'default view';
}));
```

### Pattern Filters

Pattern filters used to match routes by supplying route pattern with a wildcard. For example if you like to run filter for all pages begin with `users/` like `users/create` and `users/update/{$id}`, use `users/*` filter in route like that.

```php
//app/routes.php
Route::when('users/*', 'test_filter');
```