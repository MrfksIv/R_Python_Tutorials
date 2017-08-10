# All R function arguments are passed by value. This means that an R function cannot
# change the variable that you input to that function.
triple <- function(x) {
  x <- 3*x
  x
}

a <- 5
> triple(a)
[1] 15
> a
[1] 5

# When we call the function triple with argument a, R makes a copy of the variable and
# executes the function with the new copy. This is why if we do not reassign the result 
# to a, it remains unchanged.
# (Other languages like C, C++ can call functions using pointers which allows the user 
# to pass arguments by reference, i.e. the memory location) 