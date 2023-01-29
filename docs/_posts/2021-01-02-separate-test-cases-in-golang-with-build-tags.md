---
title: Separate Test Cases in Golang With Build Tags
date: 2021-01-02 00:00:00
featured_image: https://images.unsplash.com/photo-1498196915534-f2fd4dc29430?q=5
excerpt: A build tag or a build constraint as described in the build package documentation, is a line comment that begins `// +build` that lists the conditions under which a file should be included in the package.
---

![](https://images.unsplash.com/photo-1498196915534-f2fd4dc29430?q=5)

A build tag or a build constraint as described in the build package documentation, is a line comment that begins `// +build` that lists the conditions under which a file should be included in the package.

You can provide build constraints for one file. The tags can then be passed to the go build command, when building the package, like so

```
$ go build -tags <tags>
$ go test -tags=integration
```

Also This will allow us to separate test cases by separating them in different files and then giving each file a special build tag. here is an example:

```
// main.go file

package main

func main() {
    //
}

// Sum ...
func Sum(ar []int) int {
    result := 0

    for _, v := range ar {
        result += v
    }

    return result
}
```

```
// main_unit_test.go file

// +build unit

package main

import (
    "testing"

    "github.com/franela/goblin"
)

// TestUnitSum test cases
func TestUnitSum(t *testing.T) {
    g := goblin.Goblin(t)

    g.Describe("#SumFunc", func() {
        g.It("It should satisfy all provided test cases", func() {
            var tests = []struct {
                input  []int
                wantResult int
            }{
                {[]int{1, 2, 3, 4, 5}, 15},
                {[]int{3, 4, 5}, 12},
                {[]int{36, 98, 63, 3628, 2863, 27392, 883929}, 918009},
                {[]int{36, 21, 63, 12, 56, 90, 32}, 310},
                {[]int{123, 283, 345, 544, 332, 4455, 1233}, 7315},
            }

            for _, tt := range tests {
                g.Assert(Sum(tt.input)).Equal(tt.wantResult)
            }
        })
    })
}

// BenchmarkUnitSum benchmark
func BenchmarkUnitSum(b *testing.B) {
    var input []int

    for n := 0; n < b.N; n++ {
        input = append(input, n)
    }

    b.Logf("[Unit] Sum function input length %v \n", len(input))

    Sum(input)
}
```

```
// main_integration_test.go file

// +build integration

package main

import (
    "testing"

    "github.com/franela/goblin"
)

// TestIntegrationSum test cases
func TestIntegrationSum(t *testing.T) {
    // Skip if -short flag exist
    if testing.Short() {
        t.Skip("skipping test in short mode.")
    }

    g := goblin.Goblin(t)

    g.Describe("#SumFunc", func() {
        g.It("It should satisfy all provided test cases", func() {
            var tests = []struct {
                input  []int
                wantResult int
            }{
                {[]int{1, 2, 3, 4, 5}, 15},
                {[]int{3, 4, 5}, 12},
                {[]int{36, 98, 63, 3628, 2863, 27392, 883929}, 918009},
                {[]int{36, 21, 63, 12, 56, 90, 32}, 310},
                {[]int{123, 283, 345, 544, 332, 4455, 1233}, 7315},
            }

            for _, tt := range tests {
                g.Assert(Sum(tt.input)).Equal(tt.wantResult)
            }
        })
    })
}

// BenchmarkIntegrationSum benchmark
func BenchmarkIntegrationSum(b *testing.B) {
    // Skip if -short flag exist
    if testing.Short() {
        b.Skip("skipping test in short mode.")
    }

    var input []int

    for n := 0; n < b.N; n++ {
        input = append(input, n)
    }

    b.Logf("[Integration] Sum function input length %v \n", len(input))

    Sum(input)
}
```

```
$ go test -tags=unit -bench=. -benchmem -v -cover ./...
$ go test -tags=integration -bench=. -benchmem -v -cover ./...
```

#### The -run flag

Another way of separating our tests is the -run flag. This flag takes a regexp as a value, which then the test command uses in order for it to run only the tests whose name matches against it. so we can use it with the above example after removing the `build` flag

```
// main.go file

package main

func main() {
    //
}

// Sum ...
func Sum(ar []int) int {
    result := 0

    for _, v := range ar {
        result += v
    }

    return result
}
```

```
// main_unit_test.go file

package main

import (
    "testing"

    "github.com/franela/goblin"
)

// TestUnitSum test cases
func TestUnitSum(t *testing.T) {
    g := goblin.Goblin(t)

    g.Describe("#SumFunc", func() {
        g.It("It should satisfy all provided test cases", func() {
            var tests = []struct {
                input  []int
                wantResult int
            }{
                {[]int{1, 2, 3, 4, 5}, 15},
                {[]int{3, 4, 5}, 12},
                {[]int{36, 98, 63, 3628, 2863, 27392, 883929}, 918009},
                {[]int{36, 21, 63, 12, 56, 90, 32}, 310},
                {[]int{123, 283, 345, 544, 332, 4455, 1233}, 7315},
            }

            for _, tt := range tests {
                g.Assert(Sum(tt.input)).Equal(tt.wantResult)
            }
        })
    })
}

// BenchmarkUnitSum benchmark
func BenchmarkUnitSum(b *testing.B) {
    var input []int

    for n := 0; n < b.N; n++ {
        input = append(input, n)
    }

    b.Logf("[Unit] Sum function input length %v \n", len(input))

    Sum(input)
}
```

```
// main_integration_test.go file

package main

import (
    "testing"

    "github.com/franela/goblin"
)

// TestIntegrationSum test cases
func TestIntegrationSum(t *testing.T) {
    // Skip if -short flag exist
    if testing.Short() {
        t.Skip("skipping test in short mode.")
    }

    g := goblin.Goblin(t)

    g.Describe("#SumFunc", func() {
        g.It("It should satisfy all provided test cases", func() {
            var tests = []struct {
                input  []int
                wantResult int
            }{
                {[]int{1, 2, 3, 4, 5}, 15},
                {[]int{3, 4, 5}, 12},
                {[]int{36, 98, 63, 3628, 2863, 27392, 883929}, 918009},
                {[]int{36, 21, 63, 12, 56, 90, 32}, 310},
                {[]int{123, 283, 345, 544, 332, 4455, 1233}, 7315},
            }

            for _, tt := range tests {
                g.Assert(Sum(tt.input)).Equal(tt.wantResult)
            }
        })
    })
}

// BenchmarkIntegrationSum benchmark
func BenchmarkIntegrationSum(b *testing.B) {
    // Skip if -short flag exist
    if testing.Short() {
        b.Skip("skipping test in short mode.")
    }

    var input []int

    for n := 0; n < b.N; n++ {
        input = append(input, n)
    }

    b.Logf("[Integration] Sum function input length %v \n", len(input))

    Sum(input)
}
```

```
$ go test -run=Integration -bench=. -benchmem -v -cover ./...
$ go test -run=Unit -bench=. -benchmem -v -cover ./...
```
