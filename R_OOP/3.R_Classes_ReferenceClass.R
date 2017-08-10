# Reference Class
#
# Reference Classes in R are the closest we can get to the OOP we are used to seeing in C++, JAVA, etc.
# Unlike S3 and S4 classes, methods belong to the class rather than generic functions. Reference classes
# are internally implemented as S4 classes with an environment added to it.

# To define a reference class we use the setRefClass(). All member variables need to be passed to the
# fields parameter as a list (similar to the slots parameter for an S4 class)
# The setRefClass also returns a generator function which can be used to create objects of that class:

student1 <- setRefClass("student1",
    fields = list(name = "character", age = "numeric", GPA = "numeric"))

s <- student1(name = "Constantinos", age=29, GPA=0)
s <- student1(name = "John", age = 21, GPA = 3.5)

# Fields of the object can be accessed using the $ operator.
> s$name
[1] "John"

> s$age
[1] 21

> s$GPA
[1] 3.5

# Similarly, it is modified by reassignment.
s$name <- "Paul"

# Warning Note:
# In R programming, objects are copied when assigned to new variable or passed to a function (pass by value).
# For example:

> # create list a and assign to b
> a <- list("x" = 1, "y" = 2)
> b <- a

> # modify b
> b$y = 3

> # a remains unaffected
> a
$x
[1] 1

$y
[1] 2

> # only b is modified
> b
$x
[1] 1

$y
[1] 3

# But this is not the case with reference objects. 
# Only a single copy exist and all variables reference to the same copy. Hence the name, reference.
> # create reference object a and assign to b
> a <- student1(name = "John", age = 21, GPA = 3.5)
> b <- a

> # modify b
> b$name <- "Paul"

> # a and b both are modified
> a
Reference class object of class "student"
Field "name":
[1] "Paul"
Field "age":
[1] 21
Field "GPA":
[1] 3.5

> b
Reference class object of class "student"
Field "name":
[1] "Paul"
Field "age":
[1] 21
Field "GPA":
[1] 3.5

# If what we want is to create two separate object and modify the new one, we can use the copy() method:
> # create reference object a and assign a’s copy to b
> a <- student1(name = "John", age = 21, GPA = 3.5)
> b <- a$copy()

> # modify b
> b$name <- "Paul"

> # a remains unaffected
> a
Reference class object of class "student"
Field "name":
[1] "John"
Field "age":
[1] 21
Field "GPA":
[1] 3.5

> # only b is modified
> b
Reference class object of class "student"
Field "name":
[1] "Paul"
Field "age":
[1] 21
Field "GPA":
[1] 3.5


# Reference Methods
#
# Methods are explicitly defined for a reference class and do not belong to generic functions
# as in S3 and S4 classes
#
# All reference classes have some methods predefined becuase they are all inherited from the superclass
# envRefClass

> student1
Generator for class "student1":

Class fields:
                                    
Name:       name       age       GPA
Class: character   numeric   numeric

Class Methods: 
     "field", "trace", "getRefClass", "initFields", "copy", "callSuper", ".objectPackage", "export", "untrace", "getClass", "show", 
     "usingMethods", ".objectParent", "import"

Reference Superclasses: 
     "envRefClass"

# We can see class methods like copy(), field() and show() in the above list. 
# These methods are inherited methods. We can also create our own methods for the class.

student1 <- setRefClass("student",
  fields = list(name = "character", age = "numeric", GPA = "numeric"),
  methods = list(
    inc_age = function(x) {
      age <<- age + x
    },
    dec_age = function(x) {
      age <<- age - x
    }
  )
)
# Note that we have to use the non-local assignment operator '<<-' 
# since age isn't in the method's local environment. This is important.

> s <- student1(name = "John", age = 21, GPA = 3.5)

> s$inc_age(5)
> s$age
[1] 26

> s$dec_age(10)
> s$age
[1] 16