---
title: Getting Started With Ruby
date: 2022-01-02 00:00:00
featured_image: https://images.unsplash.com/photo-1542542008521-cf5d1c1cfc4d?q=5
excerpt: Ruby is a language of careful balance. Its creator, Yukihiro “Matz” Matsumoto, blended parts of his favorite languages (`Perl`, `Smalltalk`, `Eiffel`, `Ada`, and `Lisp`) to form a new language that balanced functional programming with imperative programming.
---

![](https://images.unsplash.com/photo-1542542008521-cf5d1c1cfc4d?q=5)

Ruby is a language of careful balance. Its creator, [Yukihiro “Matz” Matsumoto](https://matz.rubyist.net/), blended parts of his favorite languages (`Perl`, `Smalltalk`, `Eiffel`, `Ada`, and `Lisp`) to form a new language that balanced functional programming with imperative programming.

**Ruby has the following characteristics:**

**Seeing Everything as an Object**

Every bit of information and code can be given their own properties and actions. Ruby’s pure object-oriented approach is most commonly demonstrated by a bit of code which applies an action to a number.

```elixir
5.times do |x|
	puts x.to_s #=> 1 \n 2 \n 3 \n 4 \n 5
end
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-01)

In many languages, numbers and other primitive types are not objects.

**Ruby’s Flexibility:**

Ruby allows its users to freely alter its parts. Essential parts of Ruby can be removed or redefined, at will. Existing parts can be added upon. Ruby tries not to restrict the coder.

For example, addition is performed with the plus (+) operator. But, if you’d rather use the readable word plus, you could add such a method to Ruby’s builtin Numeric class.

```elixir
class Numeric
	def plus(x)
  		self.+(x)
	end
end

y = 5.plus 6

puts y #=> 11
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-02)

**Ruby and the Mixin**

Ruby features single inheritance only, on purpose. But Ruby knows the concept of modules. Modules are collections of methods.

Classes can mixin a module and receive all its methods for free. For example, any class which implements the each method can mixin the Enumerable module, which adds a pile of methods that use each for looping.

```elixir
module Features
	def class_name
  		self.class.to_s
	end
end

class Student
	include Features
end

obj = Student.new
puts obj.class_name #=> Student
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-4)

**Ruby’s Visual Appearance**

Ruby needs no variable declarations. It uses simple naming conventions to denote the scope of variables:

- `var` could be a local variable.
- `@var` is an instance variable.
- `@@var` is a class variable.
- `$var` is a global variable.

These sigils enhance readability by allowing the programmer to easily identify the roles of each variable. It also becomes unnecessary to use a tiresome `self.` prepended to every instance member.

**Ruby has exception handling features, like Java or Python, to make it easy to handle errors**

```ruby
begin
	raise ArgumentError, "Input is missing"
rescue => e
	puts "#{e.class}, #{e}"
end
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-03)

**Ruby features a true mark-and-sweep garbage collector for all Ruby objects.**

**Ruby is highly portable:**

it is developed mostly on GNU/Linux, but works on many types of UNIX, macOS, Windows, DOS, BeOS, OS/2, etc.

**Ruby Basics**

**Basic Arithmetic**

Ruby uses the standard arithmetic operators:

```ruby
puts 1 + 1 #=> 2
puts 10 * 2 #=> 20
puts 35 / 5 #=> 7
puts 10 / 3 #=> 3 (integer division)
puts 10.0 / 4.0 #=> 2.5
puts 10.0 / 3 #==> 3.3333333333333335 (float division)
puts 4 % 3 #=> 1  # modulus (the remainder after division)
puts 2 ** 5 #=> 32 # exponent (the number of times a number is multiplied by itself)
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-5)

`puts` is the basic command to print something out in Ruby. there is also `print` and `p`. The `print` method allows you to print information in the same line even multiple times, the `puts` method adds a new line at the end of the object. On the other hand, `p` is useful when you are trying to understand or debug what your code does.

```ruby
puts "Hello World" #=> Hello World

x = 3
y = 5
z = 'Ze'

x += 1 #=> x = 4
x = x + y #=> x = 9
y /= 5 #=> y = 5 / 5 = 0

puts x  #=> 9
puts y  #=> 1
puts z  #=> Ze

print 'Hey' #=> Hey
p x #=> 9

x = <<DOC
Line 1
Line 2
DOC

y = %q{Line 1
Line 2}

z = %q!Line 1
Line 2!

puts x #=> Line 1\nLine 2
puts y #=> Line 1\nLine 2
puts z #=> Line 1\nLine 2

i = 30
puts "i = #{i}" #=> i = 30
puts "i = " + i.to_s  #=> i = 30
puts "1 + 1 = #{1 + 1}" #=> 1 + 1 = 2
puts "repeater #{"repeat " * 3}" #=> repeater repeat repeat repeat
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-6)

`BEGIN` block code will execute first then `Main` block code will be executed after that `END` block code will be executed.

```ruby
# Ruby Program of BEGIN and END Block
BEGIN {
   # BEGIN block code
   puts "BEGIN code block"
}

END {
   # END block code
   puts "END code block"
}

puts "Hello World"

#=> BEGIN code block
#=> Hello World
#=> END code block
```

[Playground](https://replit.com/@Clivern/ruby-by-examples-7)
