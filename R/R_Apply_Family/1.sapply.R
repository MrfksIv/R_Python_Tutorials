# sapply() takes the same arguments as lapply but tries to simplify the result
# into a vector or matrix. 
# If this is not possible, it returns the same result as lapply()

# This is the structure of temp:
> str(temp)
List of 7
 $ : num [1:5] 3 7 9 6 -1
 $ : num [1:5] 6 9 12 13 5
 $ : num [1:5] 4 8 3 -1 -3
 $ : num [1:5] 1 4 7 2 -2
 $ : num [1:5] 5 7 9 4 2
 $ : num [1:5] -3 5 8 9 4
 $ : num [1:5] 3 6 9 4 1

# Define a function
extremes_avg <- function(x) {
  ( min(x) + max(x) ) / 2
}

# Apply extremes_avg() over temp using sapply()
> sapply(temp, extremes_avg)
[1] 4.0 9.0 2.5 2.5 5.5 3.0 5.0

# Notice that this is the same as:
> unlist(lapply(temp, extremes_avg))
[1] 4.0 9.0 2.5 2.5 5.5 3.0 5.0

# In the previous example, we have seen that sapply simplifies the result into a vector.
# If the function passed to sapply() returns a vector of length > 1, then a matrix is returned:

extremes <- function(x) {
  c(min = min(x), max = max(x))
}

> sapply(temp, extremes)
    [,1] [,2] [,3] [,4] [,5] [,6] [,7]
min   -1    5   -3   -2    2   -3    1
max    9   13    8    7    9    9    9

# If sapply cannot simplify the result into a meaningful vector or matrix, then it returs the
# same output as lapply:

below_zero <- function(x) {
  return(x[x < 0])
}
freezing_s <- sapply(temp, below_zero)

# Apply below_zero over temp using lapply(): freezing_l
freezing_l <- lapply(temp, below_zero)

# Are freezing_s and freezing_l identical?
> identical(freezing_s, freezing_l)
[1] TRUE

# Finally, here is an example demonstrating sapply()'s power:
> sapply(list(runif (10), runif (10)), 
+        function(x) c(min = min(x), mean = mean(x), max = max(x)))
           [,1]       [,2]
min  0.01998662 0.07075416
mean 0.50691288 0.58029329
max  0.98786178 0.93855891
