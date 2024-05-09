---
title: Memory Safety in Rust
date: 2025-03-17 00:00:00
featured_image: https://images.unsplash.com/photo-1501191830500-0513b5d594cd?q=90&fm=jpg&w=1000&fit=max
excerpt: Learn how Rust achieves memory safety without runtime overhead, preventing crashes, data corruption, and security vulnerabilities through compile-time analysis.
keywords: rust, lifetimes, rust-ownership, rust-borrowing, rust-lifetimes
---

![](https://images.unsplash.com/photo-1501191830500-0513b5d594cd?q=90&fm=jpg&w=1000&fit=max)

Traditional systems programming languages like `C` and `C++` allow direct memory access without bounds checking, leading to buffer overflows that can cause crashes, data corruption, or security vulnerabilities. For example the following `C` program may access memory beyond the array causing unpredictable results

```c
#include <stdio.h>
#include <stdint.h>

int main(void) {
    printf("Hello, world!\n");
    printf("Let's overflow the buffer!\r\n");

    uint32_t array[5] = {0, 0, 0, 0, 0};

    for (int index = 0; index < 10; index++) {
        printf("Index %d: %d\r\n", index, array[index]);
    }

    return 0;
}
```

```
Hello, world!
Let's overflow the buffer!
Index 0: 0
Index 1: 0
Index 2: 0
Index 3: 0
Index 4: 0
Index 5: 0
Index 6: 1294494416
Index 7: 7
Index 8: 1
Index 9: 0
```

`Rust` addresses this fundamental problem by implementing `compile-time` and `runtime safety` checks that prevent accessing memory outside of allocated bounds.  Unlike `C`, where buffer overflows result in undefined behavior and potential exploitation, Rust's memory safety guarantees ensure that out-of-bounds access either fails to compile or panics safely at runtime, making it impossible for such vulnerabilities to go unnoticed.

```rust
fn main() {
    println!("Hello, world!");
    println!("Let's try to overflow the buffer!");

    let array = [0, 0, 0, 0, 0];

    // This would cause a compile error or panic
    for index in 0..10 {
        println!("Index {}: {}", index, array[index]); // Panic on out of bounds
    }
}
```

```
Hello, world!
Let's try to overflow the buffer!
Index 0: 0
Index 1: 0
Index 2: 0
Index 3: 0
Index 4: 0

thread 'main' panicked at s.rs:9:41:
index out of bounds: the len is 5 but the index is 5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Let go through Rust's Memory Safety Features:

#### Ownership System

In Rust, Every value has exactly one owner and it gets deallocated when the owner goes out of the scope.

```rust
fn main() {
    // Ownership example 1: Simple ownership transfer
    let s1 = String::from("hello");
    let s2 = s1; // s1 is moved to s2, s1 is no longer valid

    // println!("{}", s1); // This would cause a compile error!
    println!("s2: {}", s2); // This works fine

    // Ownership example 2: Automatic cleanup
    {
        let s3 = String::from("world");
        println!("s3: {}", s3);
    } // s3 goes out of scope here and memory is automatically freed

    // Ownership example 3: Preventing double-free
    let s4 = String::from("rust");
    let s5 = s4.clone(); // Clone creates a deep copy, both s4 and s5 are valid
    println!("s4: {}, s5: {}", s4, s5);

    // Both s4 and s5 will be automatically dropped when they go out of scope
}
```

But why the following work for integers but not strings.

```rust
fn main() {
    // Ownership example 1: Simple ownership transfer
    let s1 = String::from("hello");
    let s2 = s1; // s1 is moved to s2, s1 is no longer valid

    //println!("{}", s1); // This would cause a compile error!
    println!("s2: {}", s2); // This works fine

    let k1 = 20;
    let k2 = k1;

    println!("k1 {}", k1); // This works fine
    println!("k2: {}", k2); // This works fine
}
```

The reason is the `Copy` trait:

- `String`: Does not implement `Copy` trait (ownership transferred)
- `i32` (integers): Implements `Copy` trait (value duplicated)

```rust
// Copy vs Move demonstration
fn main() {
    // String - Move semantics (no Copy trait)
    let s1 = String::from("hello");
    let s2 = s1; // Move: s1 is moved to s2
    // s1 is now invalid, s2 owns the data

    // Integer - Copy semantics (has Copy trait)
    let n1 = 42;
    let n2 = n1; // Copy: n1 is copied to n2
    // Both n1 and n2 are valid and independent

    println!("n1: {}, n2: {}", n1, n2); // Both work fine

    // Other Copy types include: i32, f64, bool, char, tuples of Copy types
    let b1 = true;
    let b2 = b1; // Copy
    println!("b1: {}, b2: {}", b1, b2); // Both work fine
}
```

Types that implement `Copy` trait:

- All integer types (`i32`, `u64`, etc.)
- All floating-point types (`f32`, `f64`)
- Boolean (`bool`)
- Character (`char`)
- Tuples containing only `Copy` types
- Arrays containing only `Copy` types

Types that do NOT implement `Copy` trait:

- `String`
- `Vec<T>`
- `Box<T>`
- Most custom structs (unless explicitly implemented)

Same applies for functions - `Copy` types are duplicated when passed to functions, while `non-Copy` types are moved and ownership is transferred.

```rust
// Ownership in functions
fn take_ownership(s: String) {
    println!("I own this string: {}", s);
} // s goes out of scope and is dropped

fn make_copy(i: i32) {
    println!("I copied this integer: {}", i);
} // i goes out of scope, but i32 is Copy so no cleanup needed

fn main() {
    let s = String::from("hello");
    take_ownership(s); // s is moved into the function
    // println!("{}", s); // Error! s is no longer valid

    let x = 5;
    make_copy(x); // x is copied into the function
    make_copy(x); // x is copied into the function
    println!("x is still valid: {}", x); // x is still valid
}
```

#### Borrowing Rules

Rust's borrowing system enforces strict rules to prevent data races at compile time. Immutable references (`&T`) allow multiple readers to access data simultaneously, while mutable references (`&mut T`) provide exclusive write access to a single writer, ensuring that data cannot be modified while being read.

```rust
fn main() {
    let mut data = vec![1, 2, 3, 4, 5];

    // Multiple immutable references allowed
    let r1 = &data;
    let r2 = &data;
    let r3 = &data;
    println!("r1: {:?}", r1);
    println!("r2: {:?}", r2);
    println!("r3: {:?}", r3);

    // Drop immutable references before creating mutable one
    let _ = r1;
    let _ = r2;
    let _ = r3;

    // Only one mutable reference allowed
    let r4 = &mut data;
    r4.push(6);
    println!("r4: {:?}", r4);

    // This would cause a compile error:
    // let r5 = &data; // Error: cannot borrow as immutable
    // let r6 = &mut data; // Error: cannot borrow as mutable
    // println!("{:?} {:?}", r5, r6);

    demonstrate_borrowing();
}

// Example: Function that reads data
fn read_data(data: &Vec<i32>) {
    println!("Reading data: {:?}", data);
}

// Example: Function that modifies data
fn modify_data(data: &mut Vec<i32>) {
    data.push(42);
}

fn demonstrate_borrowing() {
    let mut numbers = vec![1, 2, 3];

    read_data(&numbers); // Immutable borrow
    modify_data(&mut numbers); // Mutable borrow
    read_data(&numbers); // Immutable borrow again

    println!("Final: {:?}", numbers);
}
```

#### Lifetime Management

Rust's `lifetime` system tracks reference validity through `lifetime` annotations, preventing dangling pointers and use-after-free errors by ensuring that references never outlive the data they point to, providing compile-time guarantees for memory safety.

```rust
// Example 1: Lifetime annotations in structs
struct Person<'a> {
    name: &'a str,
    age: u32,
}

fn main() {
    let name = String::from("Alice");

    let person = Person {
        name: &name, // Reference must live as long as Person
        age: 30,
    };

    println!("Name: {}, Age: {}", person.name, person.age);
} // name and person go out of scope safely

// Example 2: Function with lifetime parameters
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

fn demonstrate_longest() {
    let string1 = String::from("short");
    let string2 = String::from("longer string");

    let result = longest(&string1, &string2);
    println!("The longest string is: {}", result);

    // Both string1 and string2 must live at least as long as result
}

// Example 3: Lifetime elision (compiler infers lifetimes)
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}

// Example 4: Preventing dangling references
fn create_reference() -> &'static str {
    "This is a static string" // 'static lifetime - lives for entire program
}

// This would NOT compile (dangling reference):
/*
fn bad_function() -> &str {
    let s = String::from("hello");
    &s // Error: s goes out of scope, but reference would remain
}
*/
```

#### Bounds Checking

Rust's bounds checking system validates array and slice access at runtime, panicking on out-of-bounds access instead of allowing undefined behavior, while providing safe indexing through the `get()` method that returns `Option<T>` for graceful error handling.

```rust
fn main() {
    let arr = [1, 2, 3, 4, 5];

    // Example 1: Safe indexing with get()
    match arr.get(2) {
        Some(value) => println!("Index 2: {}", value),
        None => println!("Index 2: Out of bounds!"),
    }

    match arr.get(10) {
        Some(value) => println!("Index 10: {}", value),
        None => println!("Index 10: Out of bounds!"),
    }

    // Example 2: Direct indexing (panics on out of bounds)
    println!("Index 1: {}", arr[1]); // Safe: within bounds

    // This would panic at runtime:
    // println!("Index 10: {}", arr[10]); // Panic: index out of bounds

    // Example 3: Safe iteration
    for (i, &value) in arr.iter().enumerate() {
        println!("Index {}: {}", i, value);
    }

    // Example 4: Working with slices
    let slice = &arr[1..4]; // Safe slice creation
    println!("Slice: {:?}", slice);

    // Example 5: Safe array access in loops
    let indices = [0, 2, 4, 6]; // Some indices are out of bounds
    for &index in &indices {
        match arr.get(index) {
            Some(val) => println!("arr[{}] = {}", index, val),
            None => println!("arr[{}] is out of bounds", index),
        }
    }
}

// Example 6: Function that safely processes array data
fn safe_process_array(arr: &[i32]) {
    for i in 0..10 { // Try to access indices 0-9
        match arr.get(i) {
            Some(value) => println!("Processing value {} at index {}", value, i),
            None => {
                println!("Stopping at index {} (out of bounds)", i);
                break;
            }
        }
    }
}
```

#### Type Safety

Rust's type safety eliminates common memory vulnerabilities by preventing null pointer dereferencing through the use of `Option<T>` instead of null pointers, preventing data races through strict borrowing rules, and eliminating buffer overflows through comprehensive bounds checking.

```rust
// Example 1: No null pointer dereferencing with Option<T>
fn find_user(id: u32) -> Option<String> {
    if id == 1 {
        Some("Alice".to_string())
    } else {
        None // No null pointer, just None
    }
}

fn main() {
    let user = find_user(1);

    match user {
        Some(name) => println!("Found user: {}", name),
        None => println!("User not found"),
    }

    // Safe unwrapping with defaults
    let user_name = user.unwrap_or("Unknown".to_string());
    println!("User name: {}", user_name);
}

// Example 2: Type safety with Result<T, E> for error handling
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

fn demonstrate_result() {
    let result = divide(10, 2);
    match result {
        Ok(value) => println!("Result: {}", value),
        Err(error) => println!("Error: {}", error),
    }

    let bad_result = divide(10, 0);
    match bad_result {
        Ok(value) => println!("Result: {}", value),
        Err(error) => println!("Error: {}", error),
    }
}

// Example 4: Type safety with enums
enum Message {
    Text(String),
    Number(i32),
    Empty,
}

fn process_message(msg: Message) {
    match msg {
        Message::Text(text) => println!("Text message: {}", text),
        Message::Number(num) => println!("Number message: {}", num),
        Message::Empty => println!("Empty message"),
    }
}
```

#### Move Semantics

Rust's move semantics ensure that values are moved rather than copied by default, preventing accidental deep copies and their associated performance bugs, while enabling zero-cost abstractions that compile to efficient machine code without runtime overhead.

```rust
fn main() {
    // Example 1: Move semantics prevent accidental deep copies
    let data1 = vec![1, 2, 3, 4, 5]; // Vec allocates memory on heap
    let data2 = data1; // Move: data1 is moved to data2 (no deep copy!)

    // println!("{:?}", data1); // Error! data1 is no longer valid
    println!("data2: {:?}", data2); // data2 now owns the data

    // In C++, this would be: Vec<int> data2 = data1; // Expensive deep copy!
    // In Rust, this is just a pointer move - O(1) operation

    // Example 2: Move semantics with large data structures
    let large_string1 = "A".repeat(1000000); // 1MB string
    let large_string2 = large_string1; // Move: just pointer transfer, no copying!

    println!("String length: {}", large_string2.len());
    // No performance cost - just moved the ownership

    // Example 3: Move semantics in function calls
    let expensive_data = vec![1; 1000000]; // Large vector

    process_data(expensive_data); // Moved into function, no copy
    // expensive_data is no longer valid here

    // If we wanted to keep it, we'd need to clone:
    let another_data = vec![2; 1000000];
    process_data(another_data.clone()); // Expensive deep copy
    println!("Still have: {:?}", another_data); // Still valid
}

fn process_data(data: Vec<i32>) {
    println!("Processing {} elements", data.len());
    // data is dropped here when function ends
}
```

```rust
// Example 4: Move semantics enable zero-cost abstractions
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];

    // This iterator chain doesn't copy the data multiple times
    let result: Vec<i32> = numbers
        .into_iter()        // Move numbers into iterator
        .map(|x| x * 2)     // Transform each element
        .filter(|&x| x > 5) // Filter elements
        .collect();         // Collect into new Vec

    println!("Result: {:?}", result);

    // numbers is moved and no longer available
    // Each transformation is applied lazily without copying
}

// Example 5: Preventing accidental deep copies
fn demonstrate_copy_vs_move() {
    let original = vec![1, 2, 3];

    // Move semantics - no copy
    let moved = original; // original is no longer valid
    println!("Moved: {:?}", moved);

    // If we need a copy, we must be explicit
    let copied = moved.clone(); // Explicit deep copy
    println!("Original moved: {:?}", moved); // Still valid
    println!("Copy: {:?}", copied); // Independent copy

    // This prevents expensive accidental copies
}
```

#### RAII (Resource Acquisition Is Initialization)

Rust implements RAII (Resource Acquisition Is Initialization) to automatically clean up resources when objects go out of scope, eliminating the need for manual memory management and preventing resource leaks through deterministic resource lifetime management.

```rust
use std::fs::File;
use std::io::Write;

// Example 1: Automatic file cleanup
fn write_to_file() {
    let mut file = File::create("example.txt").unwrap();
    file.write_all(b"Hello, World!").unwrap();
    // File is automatically closed when file goes out of scope
} // RAII: file handle is automatically cleaned up here

// Example 2: Custom RAII wrapper
struct Resource {
    name: String,
}

impl Resource {
    fn new(name: &str) -> Resource {
        println!("Acquiring resource: {}", name);
        Resource {
            name: name.to_string(),
        }
    }
}

impl Drop for Resource {
    fn drop(&mut self) {
        println!("Releasing resource: {}", self.name);
    }
}

fn demonstrate_raii() {
    let resource1 = Resource::new("Database Connection");
    let resource2 = Resource::new("File Handle");

    println!("Using resources...");

    // Resources are automatically dropped in reverse order
} // resource2 dropped here, then resource1

// Example 3: RAII with memory management
fn memory_management_example() {
    {
        let data = vec![1, 2, 3, 4, 5]; // Memory allocated
        println!("Using data: {:?}", data);
        // Memory automatically freed when data goes out of scope
    } // RAII: vec memory is automatically freed here

    println!("Memory has been automatically cleaned up");
}

// Example 4: RAII prevents resource leaks
fn prevent_leaks() {
    let resources = vec![
        Resource::new("Resource 1"),
        Resource::new("Resource 2"),
        Resource::new("Resource 3"),
    ];

    // Even if an error occurs, all resources are cleaned up
    println!("All resources will be cleaned up automatically");
} // All resources in vec are dropped here
```

#### Zero-Cost Abstractions

Rust's zero-cost abstractions ensure that safety features compile to efficient machine code with no runtime overhead for memory safety, delivering performance comparable to C/C++ while providing high-level language features and compile-time safety guarantees.

```rust
// Example 1: Iterator chains compile to efficient loops
fn zero_cost_iterators() {
    let numbers = vec![1, 2, 3, 4, 5];

    // This looks like multiple operations but compiles to a single loop
    let result: Vec<i32> = numbers
        .into_iter()           // Move ownership
        .map(|x| x * 2)        // Transform each element
        .filter(|&x| x > 5)    // Filter elements
        .collect();            // Collect results

    println!("Result: {:?}", result);

    // Equivalent C-style loop would be:
    // let mut result = Vec::new();
    // for x in numbers {
    //     let doubled = x * 2;
    //     if doubled > 5 {
    //         result.push(doubled);
    //     }
    // }
}

// Example 2: Option<T> has zero runtime cost
fn zero_cost_option() {
    let maybe_number: Option<i32> = Some(42);

    match maybe_number {
        Some(n) => println!("Number: {}", n),
        None => println!("No number"),
    }

    // This compiles to the same assembly as a null check in C
    // No runtime overhead for the Option wrapper
}

// Example 3: Zero-cost abstractions with closures
fn zero_cost_closures() {
    let numbers = vec![1, 2, 3, 4, 5];

    // Closure is inlined by the compiler
    let doubled: Vec<i32> = numbers
        .iter()
        .map(|&x| x * 2)  // This closure is inlined
        .collect();

    println!("Doubled: {:?}", doubled);

    // Compiles to efficient machine code with no function call overhead
}

// Example 4: Zero-cost error handling
fn zero_cost_result() -> Result<i32, &'static str> {
    let value = 42;

    if value > 0 {
        Ok(value * 2)
    } else {
        Err("Invalid value")
    }
}

fn demonstrate_zero_cost_result() {
    match zero_cost_result() {
        Ok(value) => println!("Success: {}", value),
        Err(error) => println!("Error: {}", error),
    }

    // Result<T, E> has no runtime overhead compared to manual error handling
}

// Example 5: Zero-cost abstractions with generics
fn zero_cost_generics<T>(value: T) -> T
where
    T: Copy,
{
    value // Generic function compiles to specific code for each type
}

fn demonstrate_generics() {
    let int_result = zero_cost_generics(42);     // Compiles to i32-specific code
    let float_result = zero_cost_generics(3.14); // Compiles to f64-specific code

    println!("Int: {}, Float: {}", int_result, float_result);

    // No runtime overhead for generics - monomorphization happens at compile time
}
```

#### Compile-Time Guarantees

Rust's compile-time guarantees verify memory safety during the compilation process, eliminating runtime surprises for memory issues and catching errors before deployment, ensuring that programs are memory-safe by the time they reach production.

```rust
// Example 1: Compile-time memory safety checks
fn compile_time_safety() {
    let s1 = String::from("hello");
    let s2 = s1; // s1 is moved to s2

    // This would cause a compile error:
    // println!("{}", s1); // Error: borrow of moved value: `s1`

    println!("{}", s2); // This works fine
}

// Example 2: Compile-time borrowing rules enforcement
fn borrowing_rules() {
    let mut data = vec![1, 2, 3];

    let r1 = &data;      // Immutable borrow
    let r2 = &data;      // Another immutable borrow

    // This would cause a compile error:
    // let r3 = &mut data; // Error: cannot borrow as mutable

    println!("r1: {:?}, r2: {:?}", r1, r2);

    // After dropping references, mutable borrow is allowed
    drop(r1);
    drop(r2);

    let r4 = &mut data;  // Now this works
    r4.push(4);
}

// Example 3: Compile-time lifetime checking
fn lifetime_safety() {
    let string1 = String::from("short");
    let result;

    {
        let string2 = String::from("longer string");
        // This would cause a compile error:
        // result = longest(&string1, &string2);
        // Error: `string2` does not live long enough
    }

    // result would be dangling here
}

fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// Example 4: Compile-time type safety
fn type_safety() {
    let maybe_number: Option<i32> = Some(42);

    // This would cause a compile error:
    // let result = maybe_number + 10; // Error: cannot add `i32` to `Option<i32>`

    // Must handle the Option properly
    match maybe_number {
        Some(n) => println!("Number + 10 = {}", n + 10),
        None => println!("No number to add to"),
    }
}

// Example 5: Compile-time bounds checking (in some cases)
fn compile_time_bounds() {
    let arr = [1, 2, 3, 4, 5];

    // This would cause a compile error:
    // let value = arr[10]; // Error: index out of bounds

    // Safe access
    if let Some(value) = arr.get(2) {
        println!("Value: {}", value);
    }
}

// Example 6: Compile-time data race prevention
fn data_race_prevention() {
    let mut data = vec![1, 2, 3];

    let reader = &data;    // Immutable borrow
    let reader2 = &data;   // Another immutable borrow

    // This would cause a compile error:
    // let writer = &mut data; // Error: cannot borrow as mutable

    println!("Readers: {:?}, {:?}", reader, reader2);

    // Must drop immutable borrows before mutable borrow
    drop(reader);
    drop(reader2);

    let writer = &mut data; // Now this works
    writer.push(4);
}
```

#### Concurrency Safety

Rust's concurrency safety leverages ownership to prevent data races at compile time, while providing thread-safe primitives like `Arc<Mutex<T>>` and message-passing channels that enable safe parallel programming without the complexity and pitfalls of traditional lock-based synchronization.

```rust
use std::thread;
use std::sync::{Arc, Mutex};
use std::sync::mpsc;

// Example 1: Shared ownership with Arc<Mutex<T>>
fn shared_data_example() {
    let data = Arc::new(Mutex::new(vec![1, 2, 3]));
    let mut handles = vec![];

    for i in 0..3 {
        let data_clone = Arc::clone(&data);
        let handle = thread::spawn(move || {
            let mut vec = data_clone.lock().unwrap();
            vec.push(i + 10);
            println!("Thread {} added value", i);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let final_data = data.lock().unwrap();
    println!("Final data: {:?}", *final_data);
}

// Example 2: Message passing with channels
fn message_passing_example() {
    let (tx, rx) = mpsc::channel();

    // Spawn sender thread
    let tx_clone = tx.clone();
    thread::spawn(move || {
        let values = vec![1, 2, 3, 4, 5];
        for val in values {
            tx_clone.send(val).unwrap();
            thread::sleep(std::time::Duration::from_millis(100));
        }
    });

    // Spawn another sender
    thread::spawn(move || {
        let values = vec![6, 7, 8, 9, 10];
        for val in values {
            tx.send(val).unwrap();
            thread::sleep(std::time::Duration::from_millis(100));
        }
    });

    // Receive messages
    for received in rx {
        println!("Received: {}", received);
    }
}

// Example 3: Thread-safe counter with Arc<Mutex<T>>
fn thread_safe_counter() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final count: {}", *counter.lock().unwrap());
}

// Example 4: Safe parallel processing
fn parallel_processing() {
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let chunk_size = numbers.len() / 2;

    let numbers = Arc::new(numbers);
    let mut handles = vec![];

    for chunk_start in (0..numbers.len()).step_by(chunk_size) {
        let chunk_end = (chunk_start + chunk_size).min(numbers.len());
        let numbers = Arc::clone(&numbers);

        let handle = thread::spawn(move || {
            let chunk = &numbers[chunk_start..chunk_end];
            let sum: i32 = chunk.iter().sum();
            println!("Chunk sum: {}", sum);
            sum
        });
        handles.push(handle);
    }

    let mut total_sum = 0;
    for handle in handles {
        total_sum += handle.join().unwrap();
    }

    println!("Total sum: {}", total_sum);
}

// Example 5: Ownership prevents data races
fn ownership_data_race_prevention() {
    // This would NOT compile - demonstrates data race prevention
    /*
    let mut data = vec![1, 2, 3];

    thread::spawn(move || {
        data.push(4); // This would move data into the thread
    });

    thread::spawn(move || {
        data.push(5); // Error: data already moved!
    });
    */

    // Instead, use shared ownership
    let data = Arc::new(Mutex::new(vec![1, 2, 3]));

    let data1 = Arc::clone(&data);
    thread::spawn(move || {
        let mut vec = data1.lock().unwrap();
        vec.push(4);
    });

    let data2 = Arc::clone(&data);
    thread::spawn(move || {
        let mut vec = data2.lock().unwrap();
        vec.push(5);
    });

    // Safe concurrent access with proper synchronization
}
```
