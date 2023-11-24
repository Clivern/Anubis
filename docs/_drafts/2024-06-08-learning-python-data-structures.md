---
title: Learning Python Data Structures
date: 2024-06-08 00:00:00
featured_image: https://images.unsplash.com/photo-1517782924173-aac5b5fcee7b
excerpt: Python ships with an extensive set of data structures in its standard library. I will cover most of them in this guide.
---

![](https://images.unsplash.com/photo-1517782924173-aac5b5fcee7b)

Python ships with an extensive set of data structures in its standard library. I will cover most of them in this guide.


### `Lists`

Python lists are versatile and mutable data structures that store ordered collections of items.

```python
# Creating a list
x = [1, 2, 3, 4, 5]

# Accessing elements
print(x[0])       # Output: 1
print(x[2:4])     # Output: [3, 4]

# Adding elements at the end
x.append(6)
print(x)          # Output: [1, 2, 3, 4, 5, 6]

# Insert 10 at index 2
x.insert(2, 10)
print(x)          # Output: [1, 2, 10, 3, 4, 5, 6]

# Extend the list with another list
x.extend([7, 8])
print(x)           # Output: [1, 2, 10, 3, 4, 5, 6, 7, 8]

# Removing element by value
x.remove(10)
print(x)           # Output: [1, 2, 3, 4, 5, 6, 7, 8]

# Remove element at certain index
pe = x.pop(2)
print(x)           # Output: [1, 2, 4, 5, 6, 7, 8]
print(pe)          # Output: 3

del x[2:4]
print(x)           # Output: [1, 2, 6, 7, 8]

# Searching and Counting
print(2 in x)      # Output: True
print(x.count(6))  # Output: 1
print(x.index(7))  # Output: 3

# Sorting and Reversing
x.sort()
print(x)          # Output: [1, 2, 6, 7, 8]

x.reverse()
print(x)          # Output: [8, 7, 6, 2, 1]

# Other Operations
print(len(x))    # Output: 5

y = x.copy()
print(y)         # Output: [8, 7, 6, 2, 1]

x.clear()
print(x)         # Output: []
```


### `Queue`

A Queue in Python is a linear data structure that follows the `First-In-First-Out` (`FIFO`) principle.

```python
class Queue():

    def __init__(self):
        self.queue = []

    def enqueueCharacter(self, char):
        self.queue.insert(0, char)

    def dequeueCharacter(self):
        return self.queue.pop()

    def __repr__(self):
        return str(self.queue)
```

The `queue` module in Python provides the Queue class, which implements a thread-safe `FIFO` `queue`

```python
from queue import Queue

q = Queue(maxsize=3)  # Create a bounded queue with max size 3
q.put('a')  # Enqueue elements
q.put('b')
q.put('c')

print(q.full())  # True

print(q.get())  # 'a' (Dequeue)
print(q.get())  # 'b'
```


### `Stack`

A Stack in Python is a linear data structure that follows the `Last-In-First-Out` (`LIFO`) principle.

```python
class Stack():

    def __init__(self):
        self.stack = []

    def pushCharacter(self, char):
        self.stack.append(char)

    def popCharacter(self):
        return self.stack.pop()

    def __repr__(self):
        return str(self.stack)
```

The `deque` class from the `collections` module provides an efficient way to implement a stack with `O(1)` time complexity for append and pop operations at both ends.

```python
from collections import deque

stack = deque()

# Push elements
stack.append('a')
stack.append('b')
stack.append('c')

print(stack)  # Output: deque(['a', 'b', 'c'])

# Pop elements
print(stack.pop())  # Output: 'c'
print(stack.pop())  # Output: 'b'
print(stack.pop())  # Output: 'a'
```
