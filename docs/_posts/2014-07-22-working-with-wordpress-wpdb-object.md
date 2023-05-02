---
title: Working With WordPress wpdb Object
date: 2014-07-22 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: WordPress offers an object that can be used to access data form default tables and custom tables. The $wpdb object contains several methods to read, insert, delete and update records from tables. Let's  explore these methods in details.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

WordPress offers an object that can be used to access data form default tables and custom tables. The `$wpdb` object contains several methods to read, insert, delete and update records from tables. Let's  explore these methods in details.

Please don't forgot to globalize `$wpdb` object within your functions before using it.

```php
function my_plug_func(){
global $wpdb;
//your code goes here
}
```

### Retrieving Data

To retrieve an entire row or parts of a row, you can use `get_row()` method. The syntax of this method is as follows:

```php
//get an entire row or part of it
$wpdb->get_row($sql, $output_type, $row_offset);
```

As you can see, The method accepts the following parameters:

- `$sql`: The SQL query.
- `$output_type`: The result type. It accepts three predefined constants `OBJECT` (returns result as an object), `ARRAY_A` (returns result as an associative array) or `ARRAY_N` (returns result as numerically indexed array). The default value is `OBJECT`.
- `$row_offset`: Whether to return row after specific offset. The default value is `0`.

Explore the following example.

```php
//get pages titles published
$published_pages = $wpdb->get_row("SELECT post_title FROM {$wpdb->posts}
  WHERE post_status='publish' AND post_type='page'", OBJECT);
var_dump($published_pages);
//outputs
// object(stdClass)[234]
//    public 'post_title' => string 'Sample Page' (length=11)
```

The `get_var()` method returns a single value from SQL statement. For instance to fetch the total number of pages you published on your blog, you can do the following.

```php
//get number of published pages
$num_pages = $wpdb->get_var("SELECT COUNT(id) FROM {$wpdb->posts} WHERE
  post_status='publish' AND post_type='page'");
var_dump($num_pages);
//outputs
// string '1' (length=1)
```

To get an entire column or part of it, you can use `get_col()` method. It accepts the SQL query as first parameter and column offset as second parameter. Consider the following example.

```php
//get all pages titles
$pages = $wpdb->get_col("SELECT post_title FROM {$wpdb->posts}
   WHERE post_type='page'");
var_dump($pages);
//outputs
//array (size=2)
//  0 => string 'About' (length=5)
//  1 => string 'Sample Page' (length=11)
```

### Inserting Data

To insert records in database, you can use `insert()` method, it has the following syntax.

```php
//insert new record
$wpdb->insert($wpdb->custom_table, $values, $format_values);
```

As you can see, it accepts three parameters:

- `$wpdb->custom_table`: A table name.
- `$values`: An array of columns and data pairs and should be unescaped.
- `$format_values`: An optional array of format to validate these values otherwise, it will be treated as strings.

Consider the following example

```php
$new_values = array(
  'first_col' => 'value',
  'second_col' => 20,
);

$format = array('%s','%d');
$wpdb->insert($wpdb->custom_table, $new_values, $format);
```

The method returns `false` on error and number of rows on success.

### Updating Data

The `update` method used to update records and it has the following syntax.

```php
//update record
$wpdb->update($wpdb->custom_table, $values, $where, $format_values, $format_where);
```

As you can see, the method accepts the following parameters:

- `$wpdb->custom_table`: A table name.
- `$values`: An array of columns and data updated pairs and should be unescaped.
- `$where`: An array of where clauses and also unescaped. if there are many clauses, they will be joined by `AND`.
- `$format_values`: An optional array of format to validate updated data otherwise, it will be treated as strings.
- `$format_where`: An optional array of format to validate where data otherwise, it will be treated as strings.

Also this method returns `false` on error and number of rows affected on success. Consider the following example.

```php
$values = array(
   'first_col' => 'value',
   'second_col' => 20,
);
$format_values = array('%s','%d');
$where = array(
  'another_col' => 25,
);
$format_where = array('%d');

$wpdb->update($wpdb->custom_table, $values, $where, $format_values, $format_where);
```

### Custom Queries

Whether you need to delete data or perform any of previous tasks, you can use `query` method. It returns `false` on error and number of rows affected of selected on success

Consider the following example.

```php
// Delete any comment marked as spam
$wpdb->query("DELETE FROM {$wpdb->comments} WHERE comment_type = 'spam'");
```

To get more about `wpdb` object, you can visit [wordpress developers site](http://developer.wordpress.org/reference/classes/wpdb/)