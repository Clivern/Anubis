---
title: How To Test PHP Classes and Objects
date: 2014-05-06 00:00:00
featured_image: https://images.unsplash.com/photo-1642086878890-63300bbec916
excerpt: PHP provides a set of functions to test classes and objects. These functions allow you to know more information about classes and objects that you are using at runtime. All these functions provided by PHP reflection API but their simplicity make them the first choice.
---

![](https://images.unsplash.com/photo-1642086878890-63300bbec916)

PHP provides a set of functions to test classes and objects. These functions allow you to know more information about classes and objects that you are using at runtime. All these functions provided by PHP reflection API but their simplicity make them the first choice.

First we need to create a simple class to work with

```php
// store_products.class.php
class StoreProducts {

 private $product_id;
 private $product_name;
 private $product_price;

 public function setProduct($prod_id, $prod_name, $prod_price) {
  $this->product_id = $prod_id;
  $this->product_name = $prod_name;
  $this->product_price = $prod_price;
 }

  /* ....... */
}
```

Let's explore these functions:

`class_exists()`: It is used to check if class exist. It accepts a string representing class name. It returns a boolean value (`true` or `false`). You should use this function if you include class from another file to be sure that class already included.

```php
//index.php
include_once 'store_products.class.php';

if (class_exists('StoreProducts')):
 $product = new StoreProducts;
 $product->setProduct(2, 'laptop', 2500);
endif;
```

`get_declared_classes()`: It returns all classes (user-defined and built-in) defined at the time of function call.

```php
//index.php
include_once 'store_products.class.php';
print_r(get_declared_classes());

//returns
/* Array([0] => stdClass [1] => Exception ..  [124] => StoreProducts ) */
```

`get_class_methods()`: It returns a list of all methods in a class. It accepts a string representing class name.

```php
//index.php
include_once 'store_products.class.php';
print_r(get_class_methods('StoreProducts'));

//returns
/* Array ( [0] => setProduct ) */
```

`method_exists()`: It checks if the given method exists in the given object's class. It accepts two parameters (an object and method name) and returns `true` if the given method exists.

```php
//index.php
 include_once 'store_products.class.php';

 if (class_exists('StoreProducts')):
  $product = new StoreProducts;
  if (method_exists($product, 'setProduct')):
   $product->setProduct(2, 'laptop', 2500);
  endif;
endif;
```

`is_callable()`: Similar to `method_exists()` except that its parameters passed in an array. It returns `true` if the method exists in the class.

```php
//index.php
 include_once 'store_products.class.php';

 if (class_exists('StoreProducts')):
  $product = new StoreProducts;
  if (is_callable(array($product, 'setProduct'))):
   $product->setProduct(2, 'laptop', 2500);
  endif;
endif;
```

`get_class_vars()`: It requires a class name and returns an array of class properties and their values.

```php
class TestClass {

 public $var1 = 5;
 public $var2 = 'data';

}

var_dump(get_class_vars('TestClass'));
//outputs
/* array (size=2)
   'var1' => int 5
   'var2' => string 'data' (length=4) */
```

`get_parent_class()`: It requires an object or class name as parameter and returns the name of the parent class

```php
class ParentClass
 {

  public $var;

  /* .... */
 }

 class ChildClass extends ParentClass {

  public $var1 = 5;
  public $var2 = 'data';

 }

 var_dump(get_parent_class('ChildClass'));
 //outputs
 /* string 'ParentClass' (length=11) */
```

`get_class()`: It returns the class name of an object. It accepts an object as parameter.

```php
//index.php
include_once 'store_products.class.php';

$product = new StoreProducts;
var_dump(get_class($product));
//outputs
/* string 'StoreProducts' (length=13) */
```