
# GENERAL NOTES
# To deal with different platforms and path separators '/' vs '\' etc use file.path():

path <- file.path(".", "datasets", "METRO_201706.txt")

read.csv("METRO_201706.txt", stringsAsFactors=FALSE)

# read.txt() can be used for tab-delimited files
# For more exotic flat files use read.table()

read.table("METRO_201706.txt",
            header= TRUE,
            sep=";",
            stringsAsFactors=FALSE
)

# stringsAsFactors applies the same type to all string columns. Instead, we may want 
# some columns to be read as a factor (e.g. sex which has only 'M' or 'F') and names which should be
# treated as string.
# For this we can use the colClasses option and pass a vector. Passing "NULL" causes the column not 
# to be read, and thus will be omitted from the data.frame
#
# con.names is used with header=FALSE. It should be vector specifying the ordered column names.

hotdogs2 <- read.delim("hotdogs.txt", 
                    header = FALSE, 
                    col.names = c("type", "calories", "sodium"),
                    colClasses = c("factor", "NULL", "numeric"))






