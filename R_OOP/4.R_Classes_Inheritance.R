# INHERITANCE
#
# Inheritance is one of the most useful features of an OOP language.
# It allows us to derive new classes from existing ones and add new features. Attributes
# defined in the base class, are present in the derived (extended) class

# Inheritance in S3
# S3 classes do not have any fixed definition. Hence attributes of S3 objects can be arbitrary.

# The Derived classes, however, inherit the methods defined for base class. 
# Let us suppose we have a function that creates new objects of class student as follows.

student <- function(n,a,g) {
  value <- list(name=n, age=a, GPA=g)
  attr(value, "class") <- "student"
  value
}

print.student <- function(obj) {
  cat(obj$name, "\n")
  cat(obj$age, "years old\n")
  cat("GPA:", obj$GPA, "\n")
}

# Now we want to create an object of class InternationalStudent which inherits from student.
# This is be done by assigning a character vector of class names like class(obj) <- c(child, parent).

> s <- list(name="John", age=21, GPA=3.5, country="France")

> # make it of the class InternationalStudent which is derived from the class student
> class(s) <- c("InternationalStudent","student")

> # print it out
> s
John 
21 years old
GPA: 3.5

# Now let us define print.InternationalStudent().
print.InternationalStudent <- function(obj) {
    print.student(obj)
    cat(obj$name, "is from", obj$country, "\n")
}

> s
John 
21 years old
GPA: 3.5 
John is from France 

# We can check for inheritance with functions like inherits() or is().
> inherits(s,"student")
[1] TRUE

> is(s,"student")
[1] TRUE

# Inheritance in S4

# Since S4 classes have proper definition, derived classes will inherit both attributes 
# and methods of the parent class.
# Let us define a class student with a method for the generic function show().

student <- setClass("student",
  slots=list(name="character", age="numeric", GPA="numeric")
)

# define class method for the show() generic function
setMethod("show",
  "student",
  function(object) {
    cat(object@name, "\n")
    cat(object@age, "years old\n")
    cat("GPA:", object@GPA, "\n")
  }
)

# Inheritance is done during the derived class definition with the argument contains as shown below.
setClass("InternationalStudent",
  slots=list(country="character"),
  contains="student"
)

s <- new("InternationalStudent",name="John", age=21, GPA=3.5, country="France")

> show(s)
John 
21 years old
GPA: 3.5

setMethod("show",
    "InternationalStudent",
    function(object) {
        show(as(object, "student")) # this is similar to calling the super.show() method 
        cat("Country of origin:", object@country)
    }
)

# Inheritance in Reference Classes
# Here is an example of student reference class with two methods inc_age() and dec_age():

student <- setRefClass("student",
  fields=list(name="character", age="numeric", GPA="numeric"),
  methods=list(
    inc_age = function(x) {
      age <<- age + x
    },
    dec_age = function(x) {
      age <<- age - x
    }
  )
)

# Now we will inherit from this class. 
# We also overwrite dec_age() method to add an integrity check to make sure age is never negative.

InternationalStudent <- setRefClass("InternationalStudent",
  fields=list(country="character"),
  contains="student",
  methods=list(
    dec_age = function(x) {
      if((age - x)<0)  stop("Age cannot be negative")
      age <<- age - x
    }
  )
)

# Instead of redefining the dec_age() function, we can use the export() function to coerce the 
# InternationalStudent Object into a "student" object and then call the student's dec_age() method.
# Although in this contrived example both are single-line functions, it real scenarions, functions 
# will be longer (and even not available).

InternationalStudent <- setRefClass("InternationalStudent",
  fields=list(country="character"),
  contains="student",
  methods=list(
    dec_age = function(x) {
      if((age - x)<0)  stop("Age cannot be negative")
      export("student")$dec_age(x)
    }
  )
)
