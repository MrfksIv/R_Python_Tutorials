
# The idea of benchmarking is to compare different versions of code that achieve the same
# thing, and compare the time that each one takes
# 
# Below are three separate ways of creating a sequence:

fn_vec_seq <- function(x) {
    1:x
}

fn_seq <- function(x) {
    seq(1, x)
}

fn_seq_by <- function(x) {
    seq(1, x, by=1)
}

# By wrapping a function call inside system.time() we get the following:

> system.time(res <- fn_seq_by(1e8))
   user  system elapsed 
   1.81    0.93    2.75 

> system.time(res <- fn_vec_seq(1e8))
   user  system elapsed 
   0.11    0.04    0.15 

> system.time(res <- fn_seq(1e8))
   user  system elapsed 
   0.04    0.11    0.15 
> 

# User time is the CPU time needed for the execution of the user isntructions
# System time is the CPU time charged for execution by the system on behalf of the calling process
# Elapsed time is approximately the sum of the two

# The package microbenchmark allows us to easily compare functions:
install.packages("microbenchmark")
library("microbenchmark")

# Now we can call the previous 3 functions as

n = 1e8
microbenchmark(
    fn_seq_by(n),
    fn_seq(n),
    fn_vec_seq(n),
    times=20 # Run each function 20 times

)

# Consider the following:

# Compare the two functions
compare <- microbenchmark(read.csv("movies.csv"), 
                          readRDS("movies.rds"), 
                          times = 10)

> compare
Unit: milliseconds
                   expr       min        lq      mean    median        uq
 read.csv("movies.csv") 441.81681 445.63913 507.47875 467.87750 571.73247
  readRDS("movies.rds")  49.75245  50.28457  58.24333  54.38409  69.02567
       max neval
 626.49943    10
  72.47114    10

# From the above results we can see that it is generally much faster to read an .rds file (R binary file)
# than importing the .csv file each time (read.csv is on average 9 times slower!)

# But when is a program too slow? And how much would a faster machine improve your runtime?
# This is answered by the "benchmarkme" package:

install.packages("benchmarkme")
library("benchmarkme")

res <- benchmark_std(runs=3)
plot(res)

# The first plot shows your ranking in absolute time and the second one in relative time. The second
# which is useful to estimate how many times faster your code will run using a faster system.

# You can upload your results to help other users:
upload(res)

# You can get your system's ram and cpu details (These functions belong to the benchmarkme package):
ram <- get_ram()
cpu <- get_cpu()

# The package has other benchmark tests such as benchmark_io which tests reading and writing speeds
res = benchmark_io(runs = 1, size = 50)