#######                     #######                                        
## 1 ## NEVER GROW A VECTOR ## 1 ##  
#######                     #######

# The following code will cause R to explode since at every iteration it requests more
# memory allocation which is a relatively time-consuming process.
x <- NULL
n <- 30000
for(i in 1:n) {
    x <- c(x, rnorm(1))
}

n <- 30000
# Slow code: This is because x starts as NULL which means it has no assigned memory
growing <- function(n) {
    x <- NULL
    for(i in 1:n)
        x <- c(x, rnorm(1))
    x
}

system.time(res_grow <-growing(n))
> system.time(res_grow <-growing(n))
   user  system elapsed 
   1.77    0.01    1.86 


n <- 30000
# Fast code: x is preallocated enough memory for n numbers
pre_allocate <- function(n) {
    x <- numeric(n) # Pre-allocate
    for(i in 1:n) 
        x[i] <- rnorm(1)
    x
}

> system.time(res_allocate <- pre_allocate(n))
   user  system elapsed 
   0.07    0.00    0.07 


#######                                   #######                                        
## 2 ## VECTORIZE YOUR CODE WHEN POSSIBLE ## 2 ##  
#######                                   #######

# Calling an R function eventually leads to C or FORTRAN code.
# This code is VERY heavily optimised. Our goal should always be to reach that optimised
# code ASAP.

n <- 100000
total <- 0
x <- runif(n)
unvect_logsum <- function() {
    
    for(i in 1:n) 
        total <- total + log(x[i])
}

total <- 0

vect_logsum <- function() {
    total <- sum(log(x))
}

microbenchmark(
    unvect_logsum(),
    vect_logsum(),
    times=10
)

Unit: microseconds
            expr       min        lq       mean    median        uq       max neval
 unvect_logsum() 45286.690 45469.657 46957.7912 47488.391 47868.589 48790.662    10
   vect_logsum()     5.435     5.889    14.2669    18.796    20.381    20.834    10


#######                            #######                                        
## 3 ## USE A MATRIX WHEN POSSIBLE ## 3 ##  
#######                            #######

# Because a dataframe is allowed to have different value types in each row (but not within one
# column) subsetting rows is much slower. 
# On the other hand, all of a matrix values should be of the same type. This makes subsetting
# both columns and rows fast.

# Below, the same csv file of size 100 * 1000 has been loaded both as a dataframe (df) and a 
# matrix (mat)


# See the difference between subsetting a row Vs subsettig a column. Notice that even in the
# column case, the matrix is still faster. But where it really shines, (or dataframe slows down)
# is in the case of a row

> microbenchmark(mat[, 1], df[, 1])
Unit: microseconds
     expr   min     lq    mean median    uq    max neval
 mat[, 1] 1.434 2.0975 2.44244  2.321 2.526 15.912   100
  df[, 1] 7.050 8.1015 9.41056  8.510 9.115 60.903   100

> microbenchmark(mat[1, ], df[1, ])
Unit: microseconds
     expr      min         lq       mean     median         uq       max neval
 mat[1, ]    4.740     9.9635    41.9383    12.2395    41.7135  1751.129   100
  df[1, ] 5565.646 11836.0235 14850.3006 13029.3520 15927.7020 48514.976   100