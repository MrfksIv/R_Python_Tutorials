# S4 
# 
# S4 classes are defined using the S4 function
setClass("student", slots=list(name="character", age="numeric", GPA="numeric"))

# S4 classes are instantiated using the new() function
s <- new("student", name="John", age=21, GPA=3.2)

#se setClass function returns a generator function which makes object instantiation easier ald less verbose:
student <- setClass("student", slots=list(name="character", age="numeric", GPA="numeric"))

student
# class generator function for class “student” from package ‘.GlobalEnv’
# function (...) 
# new("student", ...)

s <- student(name="costis", age=29, GPA=5.0) 

# Member variables of an S4 object are accessed with the '@' operator 
s@GPA
# 5

# Using the '@' operator and the assignment operator, a member variable can be modified:
s@GPA <- 3

# Notice, that unlike S3 classes, type checking works for reassignment as well:
s@GPA <-"a"
#Error in (function (cl, name, valueClass)  : 
#  assignment of an object of class “character” is not valid for @‘GPA’ in an object of class “student”; is(value, "numeric") is not TRUE

# Methods and Generic Functions
# 
# As is the case of S3 class, methods for the S4 class also belong to generic functions rather than
# the class itself. Working with S4 generics is similar to the S3 generics.
#
# You can list all the S4 generic functions and methods available, using the function showMethods():
> showMethods()
Function: - (package base)

Function: != (package base)
...
Function: trigamma (package base)

Function: trunc (package base)

# You can check if a function is an s4 generic function using the function isS4():
> isS4(print)
[1] FALSE

> isS4(show)
[1] TRUE

#  You cal list all methods of a generic function using:
> showMethods(show)
Function: show (package methods)
object="ANY"
object="classGeneratorFunction"
...
object="standardGeneric"
(inherited from: object="genericFunction")
object="traceable"

# We can write our own method using the setMethod() help function
setMethod("show",
         "student",
         function(object) {
           cat(object@name, "\n")
           cat(object@age, "years old\n")
           cat("GPA:", object@GPA, "\n")
         }
)
