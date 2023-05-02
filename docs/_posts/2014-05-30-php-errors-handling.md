---
title: PHP Errors Handling
date: 2014-05-30 00:00:00
featured_image: https://images.unsplash.com/photo-1530172888244-f3520bbeaa55
excerpt: PHP5 introduced exceptions, a completely different way to handle errors. Simply, exceptions like sensors detect any error occur within your code and output a bunch of data to handle these errors. Let's see how these exceptions work.
---

![](https://images.unsplash.com/photo-1530172888244-f3520bbeaa55)

PHP5 introduced exceptions, a completely different way to handle errors. Simply, exceptions like sensors detect any error occur within your code and output a bunch of data to handle these errors. Let's see how these exceptions work.

Take a look at the following wrapper class for file management.

```php
class FileManager
{
    /**
     * Returns content of given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
     public function readFile($path)
     {
         if ($content = file_get_contents($path))
         {
             return $content;
         }

         return false;
     }
    /**
     * Write content in given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
     public function writeFile($path, $content)
     {
         if ($handle = fopen($path, "w+"))
         {
             fwrite($handle, $content);
             fclose($handle);
             return true;
         }
         return false;
     }
}
``

Assume you call class methods on nonexistent file like that.

```php
$non_exist_file = new FileManager;
$non_exist_file->readFile('test.txt');
```

The code will return the following error.

```php
Warning: file_get_contents(test.txt): failed to open stream:....
```

Generally, To handle this error, We might check if provided path is to a file before reading or writing this file like that.

```php
$non_exist_file = new FileManager;
if(is_file('test.txt')){
 $non_exist_file->readFile('test.txt');
}
```

Also we can perform the previous check inside the class methods itself like that.

```php
class FileManager
{
    /**
     * Returns content of given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
    public function readFile($path)
    {
        if (!is_file($path))
        {
            return false;
        }
        if ($content = file_get_contents($path))
        {
            return $content;
        }

        return false;
    }
    /**
     * Write content in given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
    public function writeFile($path, $content)
    {
       if (!is_file($path))
        {
            return false;
        }
        if ($handle = fopen($path, "w+"))
        {
            fwrite($handle, $content);
            fclose($handle);
            return true;
        }
        return false;
    }
}
```

As you can see, we checked if provided path is to a file in both methods using `is_file()` function. But this solution is simple and not drastic. Imagine you work on a project contains many classes and one of these classes like the previous one. When you read a non-existent file, the class will break the project silently and no error appear for debugging. Also Imagine if there is a class that can catch any error raise in your classes and return it back. So each time your code breaks, you can simply return to the error class to get more details about the error.

### Exceptions

An exception is an instance of PHP built-in `Exception` class. It accepts two parameters, the first parameter is a custom error message while the second parameter is the error code. It provides some useful public methods.

- `getMessage()`: Get the error message passed to `Exception` class instance.
- `getCode()`: Get the error code passed to `Exception` class instance.
- `getFile()`: Get the file in which exception generated.
- `getLine()`: Get the line number in which exception generated.
- `getPrevious()`: Get nested exception object.
- `getTrace()`: Get array tracing call led to exception (class, method, file and method arguments).
- `getTraceAsString()`: Get string version of data returned from `getTrace()`.
- `__String()`: Called automatically when exception object used in string context.

Let's see how to handle errors within our class using exceptions.

```php
class FileManager
{
    /**
     * Returns content of given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
    public function readFile($path)
    {
   	if (!is_file($path))
        {
             return new Exception("File {$path} does not exist");
        }
        if ($content = file_get_contents($path))
        {
            return $content;
        }

        return false;
    }
    /**
     * Write content in given file
     *
     * @access  public
     * @param   string
     * @return  string
     */
    public function writeFile($path, $content)
    {
       if (!is_file($path))
       {
            return new Exception("File {$path} does not exist");
       }
       if ($handle = fopen($path, "w+"))
       {
            fwrite($handle, $content);
            fclose($handle);
            return true;
        }
        return false;
    }
}
```

As you can see, I returned an instance of `Exception` class with all data about the error. Now your errors will be prevented from appearing to end user and still you have a simple way to access it at any time. Consider the following example.

```php
$non_exist_file = new FileManager;
$result = $non_exist_file->readFile('test.txt');
if($result instanceof Exception){
 echo "Error: {$result->getMessage()} <br/>";
 echo "File: {$result->getFile()} <br/>";
 echo "Line: {$result->getLine()} <br/>";
}
```

Well, let's check the result.

```php
Error: File test.txt does not exist
File: C:\wamp\www\app\index.php
Line: 15
```

As you can see, We can get further details about the error using exceptions but still we scratch the etch so let's explore another way to handle errors.

We can create a stand alone class that extends `Exception` class to catch all errors raise within your classes for both debugging and logging.

```php
class App_Error extends Exception
{
    private $error_log;

    private $log_file = "log/error_log.php";

    public function __construct($message)
    {
       parent::__construct($message);
       $file = basename($this->file);
       $message = $this->message;
       $line = $this->line;
       $time = time();
       $this->error_log = "Time: {$time} - Message: {$message} - File: {$file} - Line: {$line}";
       $this->log_error();
    }

    private function log_error()
    {
       if (!is_file($this->log_file))
        {
            return false;
        }

       $content = file_get_contents($this->log_file);

       if ($handle = fopen($this->log_file, "w+"))
         {
            fwrite($handle, $content ."\n".$this->error_log);
            fclose($handle);
            return true;
         }
    }
}
```

So each time any error could raise from your classes code, You should return a new instance of `App_Error` class like that.

```php
class FileManager
{
      /**
       * Returns content of given file
       *
       * @access  public
       * @param   string
       * @return  string
       */
      public function readFile($path)
      {
      	  if (!is_file($path))
          {
               return new App_Error("File {$path} does not exist");
          }
          if ($content = file_get_contents($path))
          {
              return $content;
          }

          return false;
      }
      /**
       * Write content in given file
       *
       * @access  public
       * @param   string
       * @return  string
       */
      public function writeFile($path, $content)
      {
      	  if (!is_file($path))
          {
              return new App_Error("File {$path} does not exist");
          }
          if ($handle = fopen($path, "w+"))
          {
              fwrite($handle, $content);
              fclose($handle);
              return true;
          }
          return false;
      }
}
```

Let's run the previous code several times and check how `App_Error` class will handle the errors.

```php
$non_exist_file = new FileManager;
$result = $non_exist_file->readFile('test.txt');
```

Well, the code breaks so open `log/error_log.php` and check the error.

```php
Time: 1401460443 - Message: File test.txt does not exist - File: index.php - Line: 49
Time: 1401460446 - Message: File test.txt does not exist - File: index.php - Line: 49
Time: 1401460990 - Message: File test.txt does not exist - File: index.php - Line: 49
Time: 1401460991 - Message: File test.txt does not exist - File: index.php - Line: 49
Time: 1401460993 - Message: File test.txt does not exist - File: index.php - Line: 49
```

As you can see, you can check all errors raised from your application and that's why exceptions is a great feature. Finally I'd like to say thanks to PHP artisans.