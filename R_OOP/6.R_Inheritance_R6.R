# In R6 we achieve Inheritance with the inherit argument.

fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory
)

> inherits(a_fancy_microwave, "MicrowaveOven")
[1] TRUE
> inherits(a_fancy_microwave, "FancyMicrowaveOven")
[1] TRUE
> inherits(a_fancy_microwave, "R6")
[1] TRUE
> inherits(a_microwave_oven, "R6")
[1] TRUE

# The fancy microwave now has the same functionality as the 
# original microwave. This can be modifed either by extending the class,
# i.e. adding new functionality, or overriding the class, i.e. by 
# redefining existing functionality inherited from the parent class

# Here is an example of extending the class:
fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory,
  # Add a public list with a cook baked potato method
  public = list(
    cook_baked_potato = function() {
      self$cook(3)
    }
  )
)

# Instantiate a fancy microwave
a_fancy_microwave <- fancy_microwave_oven_factory$new()

# Call the cook_baked_potato() method
a_fancy_microwave$cook_baked_potato()

# And an example of overriding the class:
# Update the class definition
fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory,
  # Add a public list with a cook method
  public = list(
    cook = function(time_seconds) {
      super$cook(time_seconds)
      message("Enjoy your dinner!")
    }
  )
)

# Instantiate a fancy microwave
a_fancy_microwave <- fancy_microwave_oven_factory$new()

# Call the cook() method
a_fancy_microwave$cook(1)

# Note that the inheritance relationship can continue to multiple levels i.e. from
# parent -> child -> grandchild. However, by default, R6 classes only have access
# to their parents functionality through the super$ variable. 
# To access the grandparent a 'hack' is used wher we define the following active binding
# in the intermediate classes:
active = list(
  super_ = function() super
)

# So our fancy microwave class becomes:
fancy_microwave_oven_factory <- R6Class(
  "FancyMicrowaveOven",
  inherit = microwave_oven_factory,
  public = list(
    cook_baked_potato = function() {
      self$cook(3)
    },
    cook = function(time_seconds) {
      super$cook(time_seconds)
      message("Enjoy your dinner!")
    }
  ),
  # Add an active element with a super_ binding
  active = list(
    super_ = function() super
  )
)

# Once intermediate classes have exposed their parent functionality with super_ active bindings, 
# you can access methods across several generations of R6 class. The syntax is

parent_method <- super$method()
grand_parent_method <- super$super_$method()
great_grand_parent_method <- super$super_$super_$method()

# Here is a concrete example:

# Explore other microwaves
microwave_oven_factory
fancy_microwave_oven_factory

# Define a high-end microwave oven class
high_end_microwave_oven_factory <- R6Class(
  "HighEndMicrowaveOven",
  inherit= fancy_microwave_oven_factory,
  public = list(
    cook = function(time_seconds) {
      super$super_$cook(time_seconds)
      message(ascii_pizza_slice)
    }
  )
)

# Instantiate a high-end microwave oven
a_high_end_microwave <- high_end_microwave_oven_factory$new()

# Use it to cook for one second
a_high_end_microwave$cook(1)
