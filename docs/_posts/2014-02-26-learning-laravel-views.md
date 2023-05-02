---
title: Learning Laravel Views
date: 2014-02-26 00:00:00
featured_image: https://images.unsplash.com/photo-1492500318351-274a118407c2
excerpt: Laravel like any php framework separate visual aspects of your application from business logic .Before we get started to explore templating syntax . I will show you how to render view files from a route or controller.
---

![](https://images.unsplash.com/photo-1492500318351-274a118407c2)

Laravel like any php framework separate visual aspects of your application from business logic .Before we get started to explore templating syntax . I will show you how to render view files from a route or controller.

```php
/* render app/views/hello.php */
Route::get('/', function()
{
	return View::make('hello');
});
```

As you can see, I used `View::make('hello')` which will render `app/views/hello.blade.php`. Now let's explore templating syntax.

### Output Data

You probably use `echo` function to output data in PHP .In laravel ,just surround variables by curly brackets.

```php
<div class="welcome">
 <h1>{{ date('d/m/y') }}</h1>
</div>
```

### Control Structures

Laravel has alternative syntax for control structures .Now i will pass array of data to `app/views/posts.blade.php`.

```php
/* app/routes.php */
Route::get('posts', function()
{
 $posts=array(
     'total'=>'2',
     'data'=>array(
         'laravel routes'=>array(
             'date'=>'2/24/2014',
             'author'=>'Mark',
             'category'=>'php'
         ),
         'laravel views'=>array(
             'date'=>'2/22/2014',
             'author'=>'John',
             'category'=>'php'
         )
         //.....
     )
     //...
 );

 return View::make('posts',array('posts' => $posts,'var' => 0));
});
```

These data will be available `app/views/posts.blade.php` .Let's explore laravel control structure syntax.

```html
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>
   Posts
 </title>
</head>
<body>
 {{-- output data --}}
 <h1>{{ $posts['total'] }}</h1>

 {{-- control structures --}}
 @if ($posts['total'] > 3)
 <p>Posts more than 3</p>
 @elseif ($posts['total'] == 3)
  <p>Posts equal 3</p>
 @else
 <p>Posts less than 3</p>
 @endif

 @foreach ($posts['data'] as $key=>$value)
 <p>Post Title:{{ $key }}</p>
 <p>Date:{{ $value['date'] }}</p>
 <p>Author:{{ $value['author'] }}</p>
 <p>Category:{{ $value['category'] }}</p>
 <br/><br/>
 @endforeach

 @for ($i = 0;$i < $posts['total'];$i++)
 <p>{{ $i }}</p>
 @endfor

 @while ($var == 1)
 <p>stop loop</p>
 @endwhile
</body>
</html>
```

### Simple Templating

You could break views into separate files for organisational purposes and minimizing repetition .For example ,if page header don't change in your views files ,you could create file for header `app/views/header.blade.php`.

```html
<head>
 <meta charset="UTF-8">
 <title>
  Posts
 </title>
</head>
```

Now you can include this header in other view files for example `app/views/posts.blade.php` like that.

```html
<html lang="en">
@include('header')
<body>
</body>
</html>
```

### Advanced Templating

Let's imagine you create a portfolio with two layouts (left sidebar layout and right sidebar layout) and overall page structure of two layouts is similar except two sections (header and projects div) .Let's define these words into code.

```html
<!-- app/views/layouts/LeftSidebar.blade.php -->
<head>
 <meta charset="UTF-8">
 <title>
  Portfolio
 </title>
 @section ('header')
 <link rel='stylesheet' href='style.css' />
 @show
</head>
<body>
 <div class='leftsidebar'>
  @yield('projects')
 </div>
</body>
```

```html
<!-- app/views/layouts/RightSidebar.blade.php -->
<head>
 <meta charset="UTF-8">
 <title>
  Portfolio
 </title>
 @section ('header')
 <link rel='stylesheet' href='style.css' />
 @show
</head>
<body>
 <div class='rightsidebar'>
  @yield('projects')
 </div>
</body>
```

We created two layouts and defined the two sections which change .we used `@yield()` method to create a section that we can fill with content later .The other method `@section()` is similar to `@yield()` except that the content provided between `@section` and `@show` tags used as default value for header section.

Now let's create two pages .One for each layout.

```html
@extends('layouts.leftsidebar')

@section('header')
  <link rel='stylesheet' href='anotherstylesheet.css' />
@stop

@section('projects')
<h3>Left sidebar projects</h3>
@stop
```

```html
@extends('layouts.rightsidebar')

@section('projects')
<h3>Right sidebar projects</h3>
@stop
```

The complete source code of two pages will look like this.

```html
<!-- app/views/layouts/leftsidebar.blade.php -->
<!doctype html>
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>
  Portfolio
 </title>
   <link rel='stylesheet' href='anotherstylesheet.css' />
</head>
<body>
 <div class='leftsidebar'>
  <h3>Left sidebar projects</h3>
 </div>
</body>
</html>
```

```html
<!-- app/views/layouts/rightsidebar.blade.php -->
<!doctype html>
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>
  Portfolio
 </title>
  <link rel='stylesheet' href='style.css' />
 </head>
<body>
 <div class='rightsidebar'>
  <h3>Right sidebar projects</h3>
 </div>
</body>
</html>
```

As you can see ,when you provide content for header section ,this content will override default value .When you don't provide value to header section ,default value will be used .What if i need to provide value for header section and insert default value ..! just use `@parent` like that.

```html
@extends('layouts.leftsidebar')

@section('header')
  @parent
  <link rel='stylesheet' href='anotherstylesheet.css' />
@stop

@section('projects')
<h3>Left sidebar projects</h3>
@stop
```

So source code will look like this.

```html
<!-- app/views/layouts/leftsidebar.blade.php -->
<!doctype html>
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>
  Portfolio
 </title>
    <link rel='stylesheet' href='style.css' />
    <link rel='stylesheet' href='anotherstylesheet.css' />
</head>
<body>
 <div class='leftsidebar'>
  <h3>Left sidebar projects</h3>
 </div>
</body>
</html>
```

### Comments

You can insert notes in your views using blade comments syntax like that.

```html
{{-- you comment here --}}
```