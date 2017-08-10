# What's the date today?
today <- Sys.Date()
> today
[1] "2017-08-08"

# Notice that the today variable is neither  a string nor a number.
# R has a special Date class:
> class(today)
[1] "Date"

now <- Sys.time()
> now
[1] "2017-08-08 16:43:57 +03"
> class(now)
[1] "POSIXct" "POSIXt" 

# We can create our own date objects:
my_date <- as.Date("1988-10-14")
> my_date
[1] "1988-10-14"
> class(my_date)
[1] "Date"

# Notice that this fails:
> my_date <- as.Date("1988-14-10")
Error in charToDate(x) : 
  character string is not in a standard unambiguous format

# The above fails because R tries to convert to the default format of %Y-%m-%d
# To make it work, we can pass the format that the string is in as the second parameter:

> my_date <- as.Date("1988-14-10", format="%Y-%d-%m")
> my_date
[1] "1988-10-14"
> class(my_date)
[1] "Date"

# Notice that although now it has worked, internally R has stored the date as its
# default format %Y-%m-%d

# Note that this is also valid:
my_date <- as.Date("1988_14_10", format="%Y_%d_%m")

# We can perform date arithmetic easily with the R Date objects as well as the POSIXct objects
# Date objects increment by 1 day while POSIX objects increment by 1 second

# Checkout lubridate, zoo & xts packages for more advanced Date functions

# Here are some common date formats in R:
# %Y : 4-digit year (1982)
# %y : 2-digit year (82)
# %m : 2-digit month (01)
# %d : 2-digit day of the month (13)
# %A : weekday (Wednesday)
# %a : abbreviated weekday (Wed)
# %B : month (January)
# %b : abbreviated month (Jan)


str1 <- "May 23, '96"
str2 <- "2012-03-15"
str3 <- "30/January/2006"

# Convert the strings to dates: date1, date2, date3
date1 <- as.Date(str1, format = "%b %d, '%y")
date2 <- as.Date(str2, format = "%Y-%m-%d")
date3 <- as.Date(str3, format = "%d/%B/%Y")

# Convert dates to formatted strings using the format() function:
format(date1, "%A")
format(date2, "%d")
format(date3, "%b %Y")

[1] "Thursday"
[1] "15"
[1] "Jan 2006" 

# Similar to dates POSIXct also has some predefined formats:
# %H : hours as a decimal number (00-23)
# %I : hours as a decimal number (01-12)
# %M : minutes as a decimal number
# %S : seconds as a decimal number
# %T : shorthand notation for the typical format %H:%M:%S
# %p : AM/PM indicator

str1 <- "May 23, '96 hours:23 minutes:01 seconds:45"
str2 <- "2012-3-12 14:23:08"

# Convert the strings to POSIXct objects: time1, time2
time1 <- as.POSIXct(str1, format = "%B %d, '%y hours:%H minutes:%M seconds:%S")
time2 <- as.POSIXct(str2, format= "%Y-%m-%d %H:%M:%S")

# Convert times to formatted strings
format(time1, "%M")
format(time2, "%I:%M %p")

str1 <- "May 23, '96 hours:23 minutes:01 seconds:45"
str2 <- "2012-3-12 14:23:08"

# Convert the strings to POSIXct objects: time1, time2
time1 <- as.POSIXct(str1, format = "%B %d, '%y hours:%H minutes:%M seconds:%S")
time2 <- as.POSIXct(str2, format= "%Y-%m-%d %H:%M:%S")

# Convert times to formatted strings
format(time1, "%M")
format(time2, "%I:%M %p")