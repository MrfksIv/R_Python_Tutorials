# A (faster) alternative is to use the  read_csv() function from the readr package (instead of the
# read.csv() from the utils package)

# First install the package
install.packages("readr")

# And load it in memmory
library(readr)

# readr provides as with read_csv(), read_tsv() & read_delim() which are the equivalent of read.csv(),
# read.table() & read.delim() respectively.



# All of the readr read_...() functions have an col_names argument which takes a string vector of 
# the ordered column names (similar to the col.names of read.delim()) OR a boolean value
# 
# If col_names is passed a boolean TRUE, it uses the first row of the txt-file as the column names.
# If col_names is passed a boolean FALSE, it automatically creates columns names (X1, X2, ... , Xn)
#
# NOTE: THE DEFAULT VALUE OF col_names IS TRUE THEREFORE IF WE DON'T SPECIFY IT, THE FIRST ROW WILL BE
# READ AS THE COLUMN NAMES

properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

potatoes <- read_tsv("potatoes.txt", col_names=properties)

# read_delim() has an delim option parameter equivalent to the sep parameter of the read.delim()
potatoes <- read_delim("potatoes.txt", delim="\t", col_names=properties)

# the skip and n_max parameters can be used to skip the a given number of lines and limit the lines read
# to a given number
# This will skip the first 6 lines and read the 7,8,9,10,11 lines only. When skipping, it is important
# to pass the col_names argument as FALSE or as vector otherwise the first non-skipped line will be read 
# as the col names.
potatoes_fragment <- read_tsv("potatoes.txt", skip = 6, n_max = 5, col_names = properties)

# read_delim() and all its wrappers, takes col_types argument which is a string that takes the following
# values:
# 'c' - for character
# 'd' - for double
# 'i' - for integer
# 'l' - for boolean (logical)
# '_' - skips the column (similar to 'NULL' in colClasses of read,delim())

# the following will load the file with the first 5 columns as integers and the following 3 as doubles
potatoes_ <- read_tsv("potatoes.txt", col_types = "iiiiiddd", col_names = properties)