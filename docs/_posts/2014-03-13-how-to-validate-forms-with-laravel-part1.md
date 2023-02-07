---
title: How To Validate Forms With Laravel Part1
date: 2014-03-13 00:00:00
featured_image: https://images.unsplash.com/photo-1604182234951-06adec74329e?q=75&fm=jpg&w=1000&fit=max
excerpt: We discussed before form creation with laravel and I think the important thing you need to learn right now is form validation. You should always validate forms to ensure that you receive good data. You shouldn't trust your clients or they will exploit your application.
---

![](https://images.unsplash.com/photo-1604182234951-06adec74329e?q=75&fm=jpg&w=1000&fit=max)

We discussed before form creation with laravel and I think the important thing you need to learn right now is form validation. You should always validate forms to ensure that you receive good data. You shouldn't trust your clients or they will exploit your application.

I'm glad to see that you are care about form validation. First let's create two routes, One for form view and another for form validation.

```php
Route::get('form', function(){
     //render app/views/form.blade.php
     return View::make('form');
});

Route::post('form-submit', array('before'=>'csrf',function(){
     //get all request data
     $inputs = Input::all();
     //build validation rules
     $rules=array();
     //create validator instance
     $validator = Validator::make($inputs,$rules);

     //check if inputs valid
     if($validator->passes()){
          //save data and send to form page
     }

     //return to form form page with errors
     return Redirect::to('form')->withErrors($validator);
}));
```

As you can see, We created the following in `form-submit` route.

- Fetch all request data and assign to `$inputs` variable.
- Create array of validation rules.
- Pass both request data and validation rules to validator instance.
- Save data if inputs are valid.
- Redirect user to form with errors if inputs invalid.

Let's explore how to build validation rules array.

### Validation Rules

Laravel will allow us to attach one or multiple validation rules to field value. Validation rules can be passed as array or separate them with `|` character. Let's explore syntax.

```php
$rules = array(
     'field_name'=>array('role 1','role 2','role 3')
);
//or
$rules = array(
     'field_name'=>'role 1|role 2|role 3'
);
```


Well. here's a list of built in validation rules.

`accepted`: Used to ensure that a field has value of yes, on or 1. It's perfect for checkbox fields.

`active_url`: Used to ensure that a field value is a valid url and active as it checks DNS records.

`after:date`: Used to ensure that a field contains valid date that occurs after provided date. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Too bad) message
Route::get('form', function(){
     $inputs = array('date' => '3/10/2014');
     $rules = array('date' => 'after:3/13/2014');

     $validator = Validator::make($inputs, $rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`alpha`: Used to ensure that a field value contain alphabetic characters.

`alpha_dash`: Used to ensure that field value is alphanumeric with dashes and underscores. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('username' => '-');
     $rules = array('username' => 'alpha_dash');

     $validator = Validator::make($inputs, $rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`alpha_num`: Used to ensure that field value is alphanumeric. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('username'=>'clivern245');
     $rules = array('username'=>'alpha_num');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
     echo 'Too bad';
     }
});
```

`before:date`: Used to ensure that field contains valid date that occurs before provided date.

`between:min,max`: Used to ensure that field value between min and max. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('username'=>'clivern','age'=>'22');
     $rules = array('username'=>'between:3,10','age'=>'numeric|between:20,30');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`confirmed`: Used to ensure that another field exists that matches the current field and has name of current_field_confirmation. The following example will show you how to ensure that password confirmation field has the same value of password field.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Too bad) message
Route::get('form', function(){
     $inputs = array('password'=>'25689srt','password_confirmation'=>'25689sr');
     $rules = array('password'=>'confirmed');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```


`date`: Used to ensure that field value is valid date.

`date_format:format`: Used to ensure that date value in provided format. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('birthdate'=>'10/29/1991');
     $rules = array('birthdate'=>'date|date_format:m/d/Y|before:01/01/2000');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`different:field`: Used to ensure that field value is different from provided field. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Too bad) message
Route::get('form', function(){
     $inputs = array('field'=>'buz','another_field'=>'buz');
     $rules = array('field'=>'different:another_field');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`digits:lenght`: Used to ensure that field value is numeric with provided lenght. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('year'=>'2014');
     $rules = array('year'=>'digits:4');

     $validator = Validator::make($inputs, $rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`digits_between:min,max`: Used to ensure that field value has lenght between min and max value.

`email`: Used to ensure that field value is email address.

`exists:table,column`: Used to ensure that field value is unique and not used before. It is perfect to check if user submit unique email in registration form.

`image`: Used to ensure that file is image (jpeg, bmp, gif or png).

`in:foo,bar,...`: Used to ensure that field value is one of provided values. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Well) message
Route::get('form', function(){
     $inputs = array('gender'=>'male');
     $rules = array('gender'=>'in:male,female');
     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`integer`: Used to ensure that field value is integer.

`ip`:Used to ensure that field value is ip.

`max:value`: Used to ensure that field value less than provided value.

`mimes:png,bmp,`: Used to ensure that MIME type within listed MIMES.

`min:value`: Used to ensure that field value more than provided value.

`not_in:foo,bar,...`: Used to ensure that field value not in provided values.

`numeric`: Used to ensure that field value is integer.

`regex:pattern`: Used to ensure that field value match the given regular expression.

`required`: Used to ensure that field present and its value not empty.

`required_if:field,value`: Used to ensure that field present if another field equal to value. Here's an example.

```php
//visit http://localhost/<laravel dir>/public/form
//you will get (Too bad) message
Route::get('form', function(){
     $inputs = array(
          'has_website'=>'on','website_url'=>''
     );

     $rules = array(
          'has_website'=>'in:on,off',
          'website_url'=>'required_if:has_website,on|url'
     );

     $validator = Validator::make($inputs,$rules);

     if($validator->passes()){
          echo 'Well';
     }else{
          echo 'Too bad';
     }
});
```

`required_with:foo,bar,...`: Used to ensure that field present if any of other provided fields present.

`required_with_all:foo,bar,...`: Used to ensure that field present if all provided fields present.

`required_without:foo,bar,...`: Used to ensure that field present if any of other provided fields not present.

`required_without_all:foo,bar,...`: Used to ensure that field present if all provided fields not present.

`same:field`: Used to ensure that field value match value of provided field.

`size:value`: Used to ensure that field value size match provided size.

`unique:table,column,except,idColumn`: Used to ensure that field value unique on a given database table.

`url`: Used to ensure that field value is url. It doesn't check DNS records.