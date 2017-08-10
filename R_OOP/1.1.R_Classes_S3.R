# S3 uses a strict naming convention: all S3 methods have a name of the form generic.class.
# However, the opposite is not always the case: Functions can contain dots without being an S3
# method (these are older functions that have been around since the early days of the S language)
#
# You can check if a function is an S3 generic using the is_s3_generic() of the pryr package

install.packages("pryr")
library(pryr)
is_s3_generic("t")              # TRUE
is_s3_method("t.data.frame")    # TRUE
is_s3_method("t.test")          # FALSE

# To create a generic, use the UseMethod() function inside the function definition. It is a 
# good idea to pass the ellipsis as a second argument to x:

get_n_elements <- function(x, ...) {
  UseMethod("get_n_elements")
}

# By itself, the generic function doesn't do anything. For that, you need to create methods, 
# which are just regular functions with two conditions:
# 1.    The name of the method must be of the form generic.class.
# 2.    The method signature - that is, the arguments that are passed in to the method - 
#       must contain the signature of the generic.

get_n_elements.data.frame <- function(x, ...) {
  nrow(x) * ncol(x)
}

# Call the method on the sleep dataset
n_elements_sleep <- get_n_elements(sleep) 

# View the result
n_elements_sleep


# It is always a good idea to write a generic.default method:
get_n_elements.default <- function(x, ...) {
  length(unlist(x))
}

# methods(x) returns all the class functions of generic x (both S3 and S4)
# use .S3methods() or .S4methods() to get only the S3 or s4 respectively.

# Some core functionality of R is defined using primitive functions, which use a special 
# tecnhique for accessing C-code (e.g. if, for, +, $, exp, sin, etc.).
# Primitive functions include S3 generics; the complete list of S3 primitive generics can
# be found using the .S3PrimitiveGenerics

# S3 also provides us with some form of inheritance. This is done by applying mupltiple 
# classes to a single object

#consider the generic method what_am_i:

what_am_i <- function(x, ...) {
    UseMethod("what_am_i")
}

what_am_i.triangular_numbers <- function(x, ...) {
    message("I belong to the triangular numbers class")
    NextMethod("what_am_i")
}

what_am_i.real_numbers <- function(x, ...) {
    message("I belong to the real numbers class")
    NextMethod("what_am_i")
}

what_am_i.numeric <- function(x, ...) {
    message("I belong to the numeric class")
}

# Now we create a vector that has all three classes:
v <- c(1.2, 4.5, 3.3, 5.5)
class(v) <- c("triangular_numbers", "real_numbers", "numeric")

# Now we can use inherits() to see if the multiple classes assignment has worked:
> inherits(v, "triangular_numbers")
[1] TRUE
> inherits(v, "real_numbers")
[1] TRUE
> inherits(v, "numeric")
[1] TRUE
# Note that inherits(v, numeric) provides the same result as is.numeric(), 
# although inherits is faster:
> is.numeric(v)
[1] TRUE

# Now notice what happens when we call what_am_i():
> what_am_i(v)
I belong to the triangular numbers class
I belong to the real numbers class
I belong to the numeric class

# ALWAYS classes should be ordered from more specific to more general as we move
# from left to right since we want to begin with the behaviour most targetted
# to your object.

