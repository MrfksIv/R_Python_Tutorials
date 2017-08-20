# Intermediate Python Course

# The pandas DataFrame is a tabular data structure with labelled rows and columns
# Rows in dataframe are labelled by a special data structure called an index. An index is
# a tabled list of labels that allow fast lookup and relational operations

import pandas as pd 
# Dataframes can be created using a number of ways:

# From a csv:
users = pd.read_csv("/path/users.csv", index_col=0)

# Also, they can be created from dictionaries ( which are associative arrays):

# First create a dictionary:
data = {
    'weekday': ["Sun", "Sun", "Mon", "Tue"],
    'city': ["Nic", "Lim", "Nic", "Lar"],  
    'visitors': [141, 12422, 98543, 1231],
    "signups": [345, 2, 4, 12]  
}

# Use the pd.DataFrame method to create the df:
users = pd.DataFrame(data)


# assuming the variable df is a dataframe:

# use df.head() / df.tail() to view the first/last few rows of the dataframe respectively:
df.head()

df.tail(10) # If no argument is passed, first/last  5 rows are displayed

In [1]: df.info()
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 13374 entries, 0 to 13373
Data columns (total 5 columns):
CountryName                      13374 non-null object
CountryCode                      13374 non-null object
Year                             13374 non-null int64
Total Population                 9914 non-null float64
Urban population (% of total)    13374 non-null float64
dtypes: float64(2), int64(1), object(2)
memory usage: 522.5+ KB

# pandas depends upon numpy and uses it to provide us with some useful tools. For example
# pandas dataframes can be passed to numpy methods or we can convert dataframes to numpy 
# arrays:

import numpy as np 

# We can assign the numerical values of a dataframe to a numpy array using the .values method:
np_values = df.values

# We can then pass that np array to any np method:
np_values_log10 = np.log10(np_values) # This is a numpy array

# We can even pass dataframes to np methods:
df_log10 = np.log10(df)

# 


