# R6 allows us to store both data and function in each object (the instantiation of the class)

# First import the R6 library
library(R6)

# Define the class generator (a.k.a factory) using the R6Class() 
thing_factory <- R6Class(
  "Thing",                  # the name of the class
  private = list(           # a list of the private member variables
    a_field = "a value",
    another_field = 123
  )
)

# To make an object, create a factory and call its new() method which exists
# by default
a_thing = thing_factory$new()

# One of the main benefits of Object Oriented Programming is Encapsulation: 
# The idea of separating the implementation details from the public interface.
# This allows us for example to use packages written by other people without
# knowing how they implement them. We only use the public interface of the package.
#
# In the example below, the user doesn't have to know how many watts the  microwave is.
# That is why it is part of the private list. (Private members are only accessible from
# within the class)
# On the other hand, the user should be able to cook his/her food. So, the cook() 
# function is part of the public list:

microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800,
    door_is_open = FALSE
  ),
  public = list(
    cook = function(time_seconds) {
      Sys.sleep(time_seconds)
      print("Your food is cooked!")
    },
    open_door = function() {
      private$door_is_open = TRUE
    },
    close_door = function() {
      private$door_is_open = FALSE
    }
  )
)
# Create microwave oven object
a_microwave_oven <- microwave_oven_factory$new()

# R6 privates a way to customize the classes constructor. When we call the new()
# method, internally the initialize() method is called. This we can modify:

microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    power_rating_watts = 800,
    door_is_open = FALSE
  ),
  public = list(
    cook = function(time_seconds) {
      Sys.sleep(time_seconds)
      print("Your food is cooked!")
    },
    open_door = function() {
      private$door_is_open = TRUE
    },
    close_door = function() {
      private$door_is_open = FALSE
    },
    # Add initialize() method here
    initialize = function(power_rating_watts, door_is_open) {
      if(!missing(power_rating_watts)) {
        private$power_rating_watts <- power_rating_watts
      }
      if(!missing(door_is_open)) {
        private$door_is_open <- door_is_open
      }
    }
  )
)

# Now we can create microwaves with different initial settings:
a_microwave_oven <- microwave_oven_factory$new(650, TRUE)

# Just as an R6 class can define a public initialize() method to run custom code when objects are 
# created, they can also define a public finalize() method to run custom code when objects are 
# destroyed. finalize() should take no arguments. It is typically used to close connections to 
# databases or files, or undo side-effects such as changing global options() or graphics par()ameters.

thing_factory <- R6Class(
  "Thing",
  public = list(
    initialize = function(x, y, z) {
      # do something
    },
    finalize = function() {
      # undo something
    }
  )
)

# The finalize() method is called when the object is removed from memory by R's automated 
# garbage collector. You can force a garbage collection by typing gc().

# Here is an example:

# Microwave_factory is pre-defined
microwave_oven_factory

# Complete the class definition
smart_microwave_oven_factory <- R6Class(
  "SmartMicrowaveOven",
  inherit = microwave_oven_factory, # Specify inheritance
  private = list(
    # Add a field to store connection
    conn = NULL
  ),
  public = list(
    initialize = function() {
      # Connect to the database
      private$conn = dbConnect(SQLite(), "cooking-times.sqlite")
    },
    get_cooking_time = function(food) {
      dbGetQuery(
        private$conn,
        sprintf("SELECT time_seconds FROM cooking_times WHERE food = '%s'", food)
      )
    },
    finalize = function() {
      # Print a message
      message("Disconnecting from the cooking times database.")
      # Disconnect from the database
      dbDisconnect(private$conn)
      
    }
  )
)

# Create a smart microwave object
a_smart_microwave <- smart_microwave_oven_factory$new()
  
# Call the get_cooking_time() method
a_smart_microwave$get_cooking_time("soup")

# Remove the smart microwave
rm(a_smart_microwave)

# Force garbage collection
gc()









# R6 also provides us with getters and setters through what is called 
# "Active Bindings". These allow the user controlled access to the class'
# private member variables. Active bindings are defined in another list called active

# Add a binding for power rating
microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    # The R convention is to use '..' for private member variables 
    ..power_rating_watts = 800
  ),
  active = list(
    # add the binding here
    power_rating_watts = function() {
      private$..power_rating_watts
    }

  )
)

# Make a microwave 
a_microwave_oven <- microwave_oven_factory$new()

# Get the power rating
a_microwave_oven$power_rating_watts

# Firstly note that although we defined the active binding as a function, we retrieve
# it as a variable.
# Notice also that if we try to modify the power_rating_watts an error will be thrown.
# This is because we only defined a 'getter' but not a setter.
# A setter is defined inside the same function but with an argument. If the argument 
# is missing, we assume that a getter is needed, else a setter:

microwave_oven_factory <- R6Class(
  "MicrowaveOven",
  private = list(
    ..power_rating_watts = 800,
    ..power_level_watts = 800
  ),
  # Add active list containing an active binding
  active = list(
    power_level_watts = function(value) {
      if(missing(value)) {
        private$..power_level_watts
      } else {
        #notice that since we are inside a function, we add custom logic and checks to the assignment
        assert_is_a_number(value)
        assert_all_are_in_closed_range(value, 0, private$..power_rating_watts)
        private$..power_level_watts <- value
      }
    }
  )
)

# Make a microwave 
a_microwave_oven <- microwave_oven_factory$new()

# Get the power level
a_microwave_oven$power_level_watts

# Try to set the power level to "400"
# Notice that following the same logic, although the setter is a function, we use variable assignment:
a_microwave_oven$power_level_watts <- 400
