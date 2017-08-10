# How do we find code bottlenecks?
# The way is through code profiling. The general idea is to run the code and every few
# milliseconds we record what is currently being executed
# Rprof() comes with R and does exactly that but is not very user friendly.
#
# An alternative is to use the profvis package:

install.packages("profvis")
library("profvis")

# Profvis works by recording the callstack at regular intervals

install.packages("ggplot2movies")
data("movies", package="ggplot2movies")

profvis({
  # Load and select data
  movies <- movies[movies$Comedy == 1, ]

  # Plot data of interest
  plot(movies$year, movies$rating)

  # Loess regression line
  model <- loess(rating ~ year, data = movies)
  j <- order(movies$year)
  
  # Add a fitted line to the plot
  lines(movies$year[j], model$fitted[j], col = "red")
})

# This opens up a .html file in your browser, showing line by line the code
# and the time it took to run.
# It is clear that our bottleneck in the above code is the loess model.



