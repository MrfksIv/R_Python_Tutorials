# S3
#
# S3 has no predefined definition. A list with its class attributes set to a a class name,
# is an S3 object. The components of the list become the the member variables of the object.

# create a list with required components
s <- list(name = "John", age = 21, GPA = 3.5)

# name the class appropriately
class(s) <- "student"

# That's it! we now have an object of class "student"
s

# $name
# [1] "John"

# $age
# [1] 21

# $GPA
# [1] 3.5

# attr(,"class")
# [1] "student"

# Although S3 classes can be created in the above ad-hoc fashion, it is better practice to use
# constructors (functions with the same name as the class)

student <- function(name, age, gpa) {
    # add integrity checks
    if (gpa > 4 || gpa < 0) stop("GPA must be between 0 and 4")
    value <- list(name= name, age=age, GPA = gpa)
    
    attr(value, "class") <- "student"
    value
}

# Note that these integrity check only work while creating the object using the constructor
s <- student("Paul", 26, 5)
# Error in student("Paul", 26, 5) : GPA must be between 0 and 4
s <- student("Paul", 26, 2.5)

# it's up to us to maintain it. (The following works without error)
s$GPA <- 5

# Methods and Generic Functions
#
# Although we have managed to create something similar to the instance variables of a 'traditional' 
# OO class we are still missing an important ingredient: Functions (or methods in OOP terminology)
#
# Have you ever wondered why the print() function works differently for a list compared to a data.frame?
# This is because print() in reality is a generic function which has a collection of methods.
methods(print) # prints all these methods

# So when we call print() on a data.frame it is dispatched to print.data.frame()
# Printing our object of class student looks for a method of the form print.student() but this doesn't 
# exist so it 'redirects' to print.default()
#
# We could instead, write our own print.student method:
print.student <- function(obj) {
    cat(obj$name, "\n")
    cat(obj$age, " years old\n")
    cat("GPA:", obj$GPA, "\n")
}

s1
# con 
# 29  years old
# GPA: 3.5 

# Note that in the S3 system, methods do not belong to object or class but rather to generic functions.
# This will work as long as the class of the object is set.

# Writing Your own Generic Function
grade <- function(obj) {
 UseMethod("grade") # this is what a makes a function generic.
}
grade.default <- function(obj) {
    cat("This is a generic function\n")
}

grade.student <- function(obj) {
    cat("Your grade is:", obj$GPA, "\n")
}

s2 <- list(name="Con", age=29, GPA=3.2)
grade(s2) 
# This is a generic function

s3 <- student("Paul", 26, 2.5)
grade(s3)
# Your grade is: 2.5