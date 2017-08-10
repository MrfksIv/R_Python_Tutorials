# lists and environments are the two data structures in r that can hold
# other variables, functions, etc.

# To create a new environment:
env <- new.env()

# Variables are added to it using the list syntax:
env$x <- 3
env[["y"]] <-4

# Although environments and lists are in some respects similar, they have a very important
# difference: Lists are copied by value while environments are copies by reference

# Here is an example:
ls1 = list(x = 1:5)
ls1$x
[1] 1 2 3 4 5

ls2 <- ls1

> ls2 <- ls1
> identical(ls2, ls1)
[1] TRUE

> ls2$x <- ls2$x + 2
> ls2$x
[1] 3 4 5 6 7
> identical(ls2, ls1)
[1] FALSE # Because the values are copied by value, as soon as the second list changes, they are not identical

# R6 classes can use environments' copy by reference behavior to share fields between objects. 
# To set this up, define a private field named shared. This field takes several lines to define. It should:
#   - Create a new environment.
#   - Assign any shared fields to that environment.
#   - Return the environment.
#
# The shared fields should be accessed via active bindings. These work in the same way as other active bindings
# that you have seen, but retrieve the fields using a private$shared$ prefix.

R6Class(
  "Thing",
  private = list(
    shared = {
      e <- new.env()
      e$a_shared_field <- 123
      e
    }
  ),
  active = list(
    a_shared_field = function(value) {
      if(missing(value)) {
        private$shared$a_shared_field
      } else {
        private$shared$a_shared_field <- value
      }
    }
  )
)

# Here is a working example:
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    shared = {
      # Create a new environment named e
      e <- new.env()
      # Assign safety_warning into e
      e$safety_warning <- "Warning. Do not try to cook metal objects."
      # Return e
      e
    }
  ),
  active = list(
    # Add the safety_warning binding
    safety_warning = function(value) {
      if(missing(value)) {
        private$shared$safety_warning
      } else {
        private$shared$safety_warning <- value 
      }
    }
    
  )
)

# Create two microwave ovens
a_microwave_oven <- microwave_oven_factory$new()
another_microwave_oven <- microwave_oven_factory$new()
  
# Change the safety warning for a_microwave_oven
a_microwave_oven$safety_warning <- "Warning. If the food is too hot you may scald yourself."
  
# Verify that the warning has change for another_microwave
another_microwave_oven$safety_warning


# By default, R6 objects are cloned by reference. To achieve the copy by value,
# use the clone() method available for all R6 objects by default

# Create a microwave oven
a_microwave_oven <- microwave_oven_factory$new()

# Copy a_microwave_oven using <- 
assigned_microwave_oven <- a_microwave_oven
  
# Copy a_microwave_oven using clone()
cloned_microwave_oven <- a_microwave_oven$clone()
  
# Change a_microwave_oven's power level  
  a_microwave_oven$power_level_watts <- 400
  
# Check a_microwave_oven & assigned_microwave_oven same 
identical(a_microwave_oven$power_level_watts, assigned_microwave_oven$power_level_watts)
[1] TRUE
# Check a_microwave_oven & cloned_microwave_oven different 
!identical(a_microwave_oven$power_level_watts, cloned_microwave_oven$power_level_watts) 
[1] TRUE

# When R6 objects contain other R6 objects, when cloning, we should pass the argument deep=true.
# Otherwise, although the 'outer' R6 object will be properly cloned each will refer to a different
# object, the nested object will act as a shared environment.
#
# Here is an example:
a_microwave_oven <- microwave_oven_factory$new()

# Look at its power plug
a_microwave_oven$power_plug

# Copy a_microwave_oven using clone(), no args
cloned_microwave_oven <- a_microwave_oven$clone()
  
# Copy a_microwave_oven using clone(), deep = TRUE
deep_cloned_microwave_oven <- a_microwave_oven$clone(deep= TRUE)
  
# Change a_microwave_oven's power plug type  
a_microwave_oven$power_plug$type <- "British"

# Check a_microwave_oven & cloned_microwave_oven same 
identical(a_microwave_oven$power_plug$type, cloned_microwave_oven$power_plug$type)

# Check a_microwave_oven & deep_cloned_microwave_oven different 
!identical(a_microwave_oven$power_plug$type, deep_cloned_microwave_oven$power_plug$type)