# Regular expressions allows to easily achieve the following in strings:
# - Check for Pattern existence
# - Replace a Pattern
# - Extract a Pattern

# To check for Pattern existence we use the grepl()

animals <- c("cat", "moose", "impala", "ant", "kiwi")
grepl( pattern="a", x=animals)

[1]  TRUE FALSE  TRUE  TRUE FALSE # returns TRUE if an element CONTAINS "a"

grepl( pattern="^a", x=animals) # returns TRUE if an element STARTS with "a"

grepl( pattern="$a", x=animals) # returns TRUE if an element ENDS with "a"

# grep() returns a vector of indices of the matched patterns
> grep( pattern="a", x=animals)
[1] 1 3 4


# sub() allows us to replace occurences of a pattern in a string:
> sub(pattern="a", replacement="A", x=animals)
[1] "cAt"    "moose"  "impAla" "Ant"    "kiwi"

# Notice that in impAla only the first occurence was replaced. For replacing all occurences
# use gsub (for global)  
> gsub(pattern="a", replacement="A", x=animals)
[1] "cAt"    "moose"  "impAlA" "Ant"    "kiwi"  

> gsub(pattern="a|o", replacement="_", x=animals)
[1] "c_t"    "m__se"  "imp_l_" "_nt"    "kiwi"  

# Suppose we want to match correctly-looking email addresses that end in "edu" from the list below:
emails <- c("john.doe@ivyleague.edu", "education@world.gov", "dalai.lama@peace.org",
            "invalid.edu", "quant@bigdatacollege.edu", "cookie.monster@sesame.tv")

grepl("@.*(\\.edu)$", emails) 
[1]  TRUE FALSE FALSE FALSE  TRUE FALSE

grep("@.*(\\.edu)$", emails) 
[1] 1 5

> emails[grepl("@.*(\\.edu)$", emails) ]
[1] "john.doe@ivyleague.edu"   "quant@bigdatacollege.edu"
> emails[grep("@.*(\\.edu)$", emails) ]
[1] "john.doe@ivyleague.edu"   "quant@bigdatacollege.edu"

# Notes:
# - ".*"  Matches any character (.) zero or more times (*)
# - "\\.edu$" Matches the ".edu" to be at the end of the string ($). The "\\" escapes the special
#   meaning of the (.)

# We can use sub() to replace the domain .edu to datacamp.edu:
sub("@.*\\.edu$", ".datacamp.edu", emails)

[1] "john.doe.datacamp.edu"    "education@world.gov"     
[3] "dalai.lama@peace.org"     "invalid.edu"             
[5] "quant.datacamp.edu"       "cookie.monster@sesame.tv"

# Notice that the above replaces the '@' as well. We could add it in the replacement argument:
sub("@.*\\.edu$", "@datacamp.edu", emails)

# There exist lots of metacharacters in regular expressions:
# - \\s     : "s" normally matches the letter "s". By escaping it, we match a space.
# - [0-9]+  : matches any digit at least once.
# - ([0-9]+): The parentheses are used to make parts of the matching string available to define
# the replacement

