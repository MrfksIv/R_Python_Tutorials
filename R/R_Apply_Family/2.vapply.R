# vapply() works exactly as sapply() but takes a third argument which specifies what kind 
# of output we are expecting. If this is not matched, R throws an error. This allows us 
# to bypass the dangers of sapply() returning something unexpected.

basics <- function(x) {
  c(min = min(x), mean = mean(x), max = max(x))
}

> vapply(temp, basics, numeric(3))
     [,1] [,2] [,3] [,4] [,5] [,6] [,7]
min  -1.0    5 -3.0 -2.0  2.0 -3.0  1.0
mean  4.8    9  2.2  2.4  5.4  4.6  4.6
max   9.0   13  8.0  7.0  9.0  9.0  9.0

# Notice that this is the same as:
> sapply(temp, basics)
     [,1] [,2] [,3] [,4] [,5] [,6] [,7]
min  -1.0    5 -3.0 -2.0  2.0 -3.0  1.0
mean  4.8    9  2.2  2.4  5.4  4.6  4.6
max   9.0   13  8.0  7.0  9.0  9.0  9.0

# Note that an error is thrown is the template output you pass does not match the output:
basics <- function(x) {
  c(min = min(x), mean = mean(x), median = median(x), max = max(x))
}

> vapply(temp, basics, numeric(3))
Error: values must be length 3,
 but FUN(X[[1]]) result is length 4

# This works:
> vapply(temp, basics, numeric(4))
       [,1] [,2] [,3] [,4] [,5] [,6] [,7]
min    -1.0    5 -3.0 -2.0  2.0 -3.0  1.0
mean    4.8    9  2.2  2.4  5.4  4.6  4.6
median  6.0    9  3.0  2.0  5.0  5.0  4.0
max     9.0   13  8.0  7.0  9.0  9.0  9.0

# Note that the template-output parameter goes before any function parameters:
vapply(temp, function(x, y) { mean(x) > y }, logical(1), y = 5)