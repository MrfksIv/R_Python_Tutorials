# Install the "parallel" package:
install.packages("parallel")
library("parallel")

# You can see the number of cores of your system by:
> detectCores()
[1] 8

# But when can parallelised computer be used in statistics? The
# truth is that many statistical algorithms haven't been designed with parallelism in
# mind.

# A general rule of thumb to determine whether a loop can be parallelised is by 
# answering the question 'Could the loop run backwards?'
# For example, if we want to perform 10 monte carlo simulations and combine the results,
# the order does not really matter:

for(i in 1:8) {
    simulation[i] <- monte_carlo_simulation()
}

# However in the following loop the order matters:
for (i in 2:8) {
    x[i] <- x[i-1]
}

# NOTE THAT IN PARALLEL PROGRAMMING THE ORDER OF EXECUTION IS NOT GUARANTEED!!


# EXAMPLES

# the apply() function is similar to a for loop that apllies a function to each/row 
# or column of a matrix. Here is an example:
 
> apply(mat, 1, sum) # sum of rows
 [1] 460 470 480 490 500 510 520 530 540 550

> apply(mat, 2, sum) # sum of columns
 [1]  55 155 255 355 455 555 655 755 855 955

# We could use parApply to parallelise the above code:
# We first load the package
library("parallel")

# Specify the number of cores to use:
cores_to_use <- detectCores() - 1 

# create a cluster of cores to use:
cl <- makeCluster(cores_to_use)

# call parApply()
parApply(cl, mat, 1, sum)

# stop the cluster when you are done:
stopCluster(cl)


# It is important to keep in mind that for fast procedures, running in parallel can actually
# be slower due to the overhead of thread communication

# For a 10 x 10 matrix:
mat <- matrix(1:100, c(10,10))
microbenchmark(
    apply(mat, 1, sum),
    parApply(cl, mat, 1, sum),
    times=10
)

Unit: microseconds
                      expr      min       lq      mean   median       uq      max neval
        apply(mat, 1, sum)   66.122   67.028   89.2645   89.898   96.013  159.416    10
 parApply(cl, mat, 1, sum) 3741.284 3952.328 4964.6623 4845.870 5123.489 8924.553    10
> 

# For a 1000 x 1000 matrix:
mat1 <- matrix(1:1000000, c(1000,1000))
microbenchmark(
    apply(mat1, 1, sum),
    parApply(cl, mat1, 1, sum),
    times=10
)
Unit: milliseconds
                       expr      min       lq     mean   median       uq       max neval
        apply(mat1, 1, sum) 24.97389 25.02416 26.95422 25.80494 29.39722  29.93162    10
 parApply(cl, mat1, 1, sum) 76.54300 77.83146 86.23492 79.32417 82.39473 145.47844    10
> 

# For a 10000 x 10000 matrix:
mat2 <- matrix(1:100000000, c(10000,10000))
microbenchmark(
    apply(mat2, 1, sum),
    parApply(cl, mat2, 1, sum),
    times=10
)


# Similarly, the sapply and lapply have their respective parLapply() and parSapply()
