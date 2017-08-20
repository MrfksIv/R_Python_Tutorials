# Think of a Class as the blueprint for the object. It contains all the details
# about the floors, doors, windows, etc. Based on these, we can build a house.
#
# In this analogy, the house we build is the object, also called an instance 
# of the class. The process of creating the object is called instantiation. 
# 
# While most programming languages have a single class system, R has three systems,
# namely the S3, S4 and the newer Reference class system. 

# S3
# S3 is somewhat primitive in nature. It lacks a formal definition and an object
# of this class can be created by simply adding a class attribute to it. (Most of
# the R built-in classes are of this type.)
s <-list(name="John", age=21, GPA =3.5)
class(s) <- "student"

# S4
# S4 class has improvements over the S3. It has a defined structure which makes 
# objects of this class more similar in nature.
setClass("student", slots=list(name="character", age="numeric", GPA="numeric"))
s1 <- new("student", name="Con", age=29, GPA=3.5)

# Reference Class
# It is the most similar to the OOP of other languages. Reference classes are basically
# S4 classed with an environment added to it.
setRefClass("student")