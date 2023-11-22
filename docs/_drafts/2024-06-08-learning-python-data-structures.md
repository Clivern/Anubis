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
print(x[0])  # Output: 1
print(x[2:4])  # Output: [3, 4]

# Adding elements at the end
x.append(6)
print(x)  # Output: [1, 2, 3, 4, 5, 6]

# Insert 10 at index 2
x.insert(2, 10)
print(x)  # Output: [1, 2, 10, 3, 4, 5, 6]

# Extend the list with another list
x.extend([7, 8])
print(x)  # Output: [1, 2, 10, 3, 4, 5, 6, 7, 8]

# Removing element by value
x.remove(10)
print(x)  # Output: [1, 2, 3, 4, 5, 6, 7, 8]

# Remove element at certain index
pe = x.pop(2)
print(x)  # Output: [1, 2, 4, 5, 6, 7, 8]
print(pe)  # Output: 3

del x[2:4]
print(x)  # Output: [1, 2, 6, 7, 8]

# Searching and Counting
print(2 in x)  # Output: True
print(x.count(6))  # Output: 1
print(x.index(7))  # Output: 3

# Sorting and Reversing
x.sort()
print(x)  # Output: [1, 2, 6, 7, 8]

x.reverse()
print(x)  # Output: [8, 7, 6, 2, 1]

# Other Operations
print(len(x))  # Output: 5

y = x.copy()
print(y)  # Output: [8, 7, 6, 2, 1]

x.clear()
print(x)  # Output: []
```

### `Queue`


### `Stack`


### `Heap`


### `Tuple`

