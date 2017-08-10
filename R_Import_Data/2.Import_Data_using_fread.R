# The fastest way is to use the fread() function of the data.table package
install.packages("data.table")
library(data.table)

# fread() has the drop & select arguments which can be used in different ways to select/drop specific columns
fread("path/to/file.txt", drop = 2:4)
fread("path/to/file.txt", select = c(1, 5))
fread("path/to/file.txt", drop = c("b", "c", "d")
fread("path/to/file.txt", select = c("a", "e"))