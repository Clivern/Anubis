---
title: Working With PHP Interceptors
date: 2014-02-19 00:00:00
featured_image: https://images.unsplash.com/photo-1538294514414-41a9041a46be
excerpt: PHP provides some handful methods which can be used within your classes to intercept messages sent to undefined methods and properties .Some developers call this overloading .These methods like `__construct()` method which invoked when you instantiate object. Let's explores these methods.
---

![](https://images.unsplash.com/photo-1538294514414-41a9041a46be)

PHP provides some handful methods which can be used within your classes to intercept messages sent to undefined methods and properties .Some developers call this overloading .These methods like `__construct()` method which invoked when you instantiate object. Let's explores these methods.

### `__get()` Method

This method invoked when client attempt to read undefined method like that

```php
 class storeProducts {

  public function __get($property) {
   $method_name = "get{$property}";
   if (method_exists($this, $method_name))
    return $this->$method_name();
  }

  private function getPrice() {
   return "25$";
  }

  private function getName() {
   return "camera";
  }

 }
```

As you can see ,I pass final string to `method_exists()` function which accepts an object and method name to check if it exist or not .Then if client requests `$Price` property ,the `getPrice()` method invoked like that

```php
$product = new storeProducts;
print $product->Price;
print $product->Name;
```

### `__set()` Method

This method invoked when client attempt to set value to undefined property .This solution used mostly if you declare class property as private and need to pass it's value to custom filters before set.

```php
 class storeProducts {

  private $Name;
  private $Price;

  public function __set($property, $value) {
   $method_name = "set{$property}";
   if (method_exists($this, $method_name))
    return $this->$method_name($value);
  }

  private function setPrice($price) {
   $this->Price = $price;
  }

  private function setName($name) {
   if (!is_null($name))
    $this->Name = $name;
  }

 }
```

Now to set class properties ,you can use the follwing.

```php
$product = new storeProducts;
$product->Price = "25$";
$product->Name = "Camera";
var_dump($product);
```

### `__unset()` Method

This method like `__unset()` method but it set property value to null .It is invoked when `unset()` is called on an undefined property

```php
 class storeProducts {

  private $Name;
  private $Price;

  public function __unset($property) {
   $method_name = "unset{$property}";
   if (method_exists($this, $method_name))
    return $this->$method_name();
  }

  private function unsetPrice() {
   $this->Price = null;
  }

  private function unsetName() {
    $this->Name = null;
  }
 }
```

Now to set property to null you can do that.

```php
 $product = new storeProducts;
 var_dump($product);
 unset($product->Name);
 var_dump($product);
```

### `__isset()` Method

This method invoked when client call `isset()` function on an undefined property.

```php
 class storeProducts {

  private $Name;
  private $Price;
  private $Stock;

  public function __isset($property) {
   $method_name = "get{$property}";
   return ((method_exists($this, $method_name)));
  }

  private function getPrice() {
   return $this->Price;
  }

  private function getName() {
   return $this->Name;
  }
 }
```

Now you can test a property existance (actually for its getter) before using it.

```php
 $product = new storeProducts;
 var_dump(isset($product->Name)); //return true
 var_dump(isset($product->Price)); //return true
 var_dump(isset($product->Stock)); //return false
```

### `__call()` Method

This method used to pass method of an object from another .cumbersome i know , it is like inheritance but it is more flexible .Let's clarify things.

```php
 class store {

  private $total_items = 0;

  public function newProducts($items_data) {
   $this->total_items = $items_data[0]['items'] + $this->total_items;
   return $this->total_items;
  }

 }

 class digitalProducts {

  private $store;

  public function __construct(store $store_object) {
   $this->store = $store_object;
  }

  public function __call($method_name, $args) {
   if (method_exists($this->store, $method_name))
    return $this->store->$method_name($args);
  }

 }

 class otherProducts {

  private $store;

  public function __construct(store $store_object) {
   $this->store = $store_object;
  }

  public function __call($method_name, $args) {
   if (method_exists($this->store, $method_name))
    return $this->store->$method_name($args);
  }
 }

 $store = new store();
 $digital_products = new digitalProducts($store);
 $otherProducts = new otherProducts($store);
 //add some digital products
 $digital_products->newProducts(array('items' => 200));
 //add other products and check total
 print_r($otherProducts->newProducts(array('items' => 50)));  //output 250
 print "<br/>";
 print_r($otherProducts->newProducts(array('items' => 50)));  //output 300
 print "<br/>";
 print_r($otherProducts->newProducts(array('items' => 200)));  //output 500
```

### `__destruct()` Method

This method invoked just before an object is garbage collected .some developers may need to save class data to database or session ,this method will be perfect.

```php
 class storeProducts {

  private $id;
  private $name;
  private $price;

  //some cool stuff here
  public function __destruct() {
   if (!empty($this->id))
   //save product data to session or database
    return;
  }

 }

 $product=new storeProducts();
 //invoke __destruct() method
 unset($product);
```

### `__clone()` Method

This method invoked when client attempt to copy objects .you should know that `__clone()` method is run on the copied objects not the original object.

```php
 class storeProducts {

  private $id;
  private $name;
  private $price;

  public function __construct($id, $name, $price) {
   $this->id = $id;
   $this->name = $name;
   $this->price = $price;
  }

  public function __clone() {
   //silence is golden
  }
 }

 $product1 = new storeProducts(1, 'camera', '20$');
 //create a copy of first product (it will have the same properties values)
 $product2 = clone $product1;
```

The `__clone()` method create a copy of objects and the this method invoked ,so any changes in properties within the context of `__clone()` method overrides the default values.

```php
 class storeProducts {

  private $id;
  private $name;
  private $price;

  public function __construct($id, $name, $price) {
   $this->id = $id;
   $this->name = $name;
   $this->price = $price;
  }

  public function __clone() {
   //change id of copied objects
   $this->id = 20;
  }
 }

 $product1 = new storeProducts(1, 'camera', '20$');
 //create a copy of first product (only id will change to 20)
 $product2 = clone $product1;
 ```