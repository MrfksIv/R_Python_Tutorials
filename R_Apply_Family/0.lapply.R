nyc <- list(
    pop = 8405837,
    boroughs = c("Manhattan", "Bronx", "Brooklyn", "Queens", "Staten Island"),
    capital = FALSE
)

for(l in nyc) {
    print(class(l))
}

# lapply allows us to omit the for-loop:
lapply(nyc, class)

# It is important to know that whatever the iterable object passed to the lapply is
# (i.e. the first argument) the output of the lapply will always be a list.
# To convert it to a vector, use the unlist() function

# Consider the example below:
oil_prices <- list(3.54, 2.43, 2.5, 6.23, 3,4)

multiply <- function(x, factor) {
    x * factor
}

# Note that we can pass to lapply() our own functions. The first parameter of the 
# custom function will become the i-th element of the iterable object where i = 0, 1, ... , length(iterable)
# Any more arguments needed for the custom function as the 3rd parameter onwards of the lapply():
times3_list <- lapply(oil_prices, multiply, factor=3)
times4_vector <- unlist(lapply(oil_prices, multiply, factor = 4))

# Omitting the parameter name also works:
times3_list <- lapply(oil_prices, multiply, 3)

> times3_list
[[1]]
[1] 10.62

[[2]]
[1] 7.29

[[3]]
[1] 7.5

[[4]]
[1] 18.69

[[5]]
[1] 9

[[6]]
[1] 12

> times4_vector
[1] 14.16  9.72 10.00 24.92 12.00 16.00

# If a function is only going to be used once inside of a lapply(), then there is no point
# in defining it in the global namespace. We could pass to the lapply an anonymous # function:

times3_list <- lapply(oil_prices, function(x, factor) { x * factor }, factor=3)
