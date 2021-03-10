# R Lesson - Week 2
# This script was revised on 05/22/2018 by Beatrice Langer. 
# This script was modified on 09/19/2018 by Aleks Brown. Updated for Fall 2018 CLDM Lab.
# This script was modified on 01/06/2018 by Ciara Willett for Spring 2019.
# This script was modified on 8/09/2020 by Michael Datz for Fall 2020.
# This script was modified on 2/10/2021

#---- Lesson Summary ----
# In this lesson, you will learn how to create a dataframe, read/import dataframes into R,
# and create new variables in an already existing dataframe. You will also begin to
# look at descriptive statistics using the aggregate() function and hist() function.

# We'll also talk about the dataset we'll be using in these lessons.

#---- Creating a Dataframe ----
# Always good to load in what you may need first.
library(tidyverse)
library(dplyr)

# Before we learn how to import our own data into R, we will start by creating
# our own pretend dataframe with fake data. In contrast to a matrix, dataframes
# can consist of columns that have different modes (like numeric, factor types, etc.)

# Dataframes are relatively lightweight and make it easy to store large amounts of data.

# First, create three lists that represent each of the columns you want in your df
d <- c(133,134,135,136)
e <- c("red", "blue", "orange", "green")
f <- c(FALSE, FALSE, TRUE, FALSE)

# Next, merge the three columns into a data frame
mydata <- data.frame(d,e,f)

# You can also rename each of the three columns 
names(mydata) <- c("ID","Favorite Color","Experienced Glitches")

# Note: this is not the only way to create a dataframe, you can use Google 
# to search for other methods.

#---- Set your working directory to read in a dataframe ----
# One way to read a file into R using R Studio is to use the drop-down menus,
# like you would do in SPSS. You could go to File > Import Dataset > Import Excel File
# However, you should ALWAYS use code when possible, because it will help you remember
# exactly where you saved things and which datasets you used.

# If you are not working in a project, you will need to set your working directory
# to let R know where all of your files are located. If you are working in a project,
# then R already has set the working directory.

# Step 1: find out the path for where the file is located on your computer
# For example, I downloaded my files in /Desktop/R Lessons/Week 2
# Week 2 being the file name.

# On Mac, use Option + Click to open the context menu and show file name
# On Windows, us Shift + Right click and get the full file name from the dropdown context menu.

# Step 2: Set your working directory to define where your files are saved

setwd("~/Desktop/R Lessons/")
# For example, I have a separate folder on my desktop that holds all these files.

#---- Reading a .csv file into R ----
# First, go to the folder in which you downloaded the multiple datasets so that we can
# try uploading just the first .csv file.

df_1 <- read.csv("~/Desktop/R Lessons/nc_charlotte_2020_04_01.csv")


# Now, you should try looking at the dataframe to make sure that it loaded properly.

View(df_1) # This command will open the dataframe in a new tab - you would need this if just using R

# Or you can use these commands to get information on the dataframe, right in the console.
colnames(df_1) # This gives the column names
nrow(df_1) # This gives the number of rows
ncol(df_1) # And the number of columns

# Because you are using R Studio, you can also open the dataframe by clicking on df_1 
# in the Data section of your Environment in the top right corner.

#---- Read other types of files into R (excel, spss) ----
# Sometimes, you might have data that isn't a .csv file.
# Save these files into your working directory and access them using these packages:

## Reading in Excel files
# In order to read excel files into R, you need to library a package:
library(readxl) # Library the excel package
df_excel <- read.excel("~/Example Path Name/file.xlsx")

## Reading in SPSS files
# You follow a similar method for .sav files, using the haven package
library(haven)
df_spss <- read_sav("~/Example Path Name/file.sav")

#---- Merge multiple dataframes into R ----
# There are multiple ways to merge dataframes in R. This is not an exhaustive list

# Option 1: 
# Read each file in individually and then use merge to combine the dataframes

# You already have df_1 loaded, so now load the second df:
df_2 <- read.csv("~/Desktop/R Lessons/nc_durham_2020_04_01.csv")

# And we can go ahead and view it as well.
View(df_2)

# Then, merge the two files:
df_merged <- rbind(df_1, df_2)

# Voila! If you look at our global environment on the right
# You can see our datafram listed in all its' massive glory.
# Double click to view, if you like.

# Option 2: 
# If you have all of the files saved in the same place, you can use a function 
# to merge files that are located in the same folder. This might be helpful
# when you have multiple dataframes, especially if you have to update the number
# of dataframes that you are merging each time. For example, you might start out
# with 5 datasets at the beginning of the semester, but the final dataset might
# contain 11 datasets. If they're all saved in the same folder, you just have to run
# the one function again

# Define the function (Originally found this on the internet):
multMerge = function(mypath){
  filenames = list.files(path = mypath, full.names = TRUE)
  datalist = lapply(filenames, 
                    function(x){read.csv(file = x,
                                         header = TRUE,
                                         stringsAsFactors = FALSE)})
  Reduce(function(x,y) {merge(x, y, all = TRUE)}, datalist)
}

# Use the function to merge all of the files in the folder together. Make sure
# that the folder ONLY includes .csv files, or this will not work.
df <- multMerge("~/Desktop/pathname where data is saved")
df <- multMerge("~/Desktop/R Lessons")

#---- Exploring our Dataset ----
# This dataframe uses data from the Open Policing Project.
# This gathers data from traffic stops and compiles it all into one readable dataset.
# This is public record and you can access it yourself.

# When you download separate datasets for given cities, and want to merge them, make sure they contain the same data.
# Some cities lack columns that others may have, so on.

#---- Cleaning our Dataset ----
# In previous studies in our lab, we would code any missing values due to data errors as values such as -11 or -9
# In the open policing dataset, we see that any missing values are coded to NA.
# Though, trust me on this, some values were left as 0 in the subject_age column.
# So what should we do with these erroneous values?

# Before we start manipulating the dataset, we need to replace our coding of 0 values
# with something that is able to fit into our analysis.

# The quickest solution to this problem is to use something called an if/else statement.
# This function is formatted like this: ifelse(test, yes, no).

# "Test" is the value you're searching the data for -- in this case, we'll call the 
# variable we're looking for to search it for instances of 0 by using 
# df_1$subject_age == 0.

# It's important to use == and not =, because = assigns values to variables, while == compares 
# values and determines TRUE or FALSE. 

# "Yes" is the value you want to use to replace the instances of 0 your test (in this case,
# we are using NA to replace 0).

# "No" is the value that you want to use for the instances of everything OTHER than your test
# value. In this case, we want to retain the meaningful prior  data, so we would
# use df_1$subject_age for this.

# Let's load in a separate dataset, for Philadelpia
df_phila <- read.csv("~/Desktop/R Lessons/pa_philadelphia_2020_04_01.csv")

ifelse(df_phila$subject_age == 0, NA, df_phila$subject_age)

# This command by itself wasn't helpful because it ran in the console, not in the dataframe.
# We have to assign the ifelse statement to run in our data frame -- let's call it!

df_phila <- ifelse(df_phila$subject_age == 0, NA, df_phila$subject_age)

# Wait, that didn't work, either! We just created a new object. No worries, just clear your
# environment using the broom icon in the top right of your screen.

df_phila$subject_age <- ifelse(df_phila$subject_age == 0, NA, df_phila$subject_age)

df_phila$subject_age[1]
# This would give us the element in the first row of this column.

# Check out your data; all the 0s are now NAs (at least for subject_age)!

#---- Creating Variables in Dataframe ----
# You can create a variable in a new column based on the values in another dataframe
# Let's calculate the age difference between the officer and the subject in this dataset.
# It probably won't tell us anything of note, but it's good practice!

# This section is outdated due to new structure of the data, but the idea is the same

# df_phila$age_difference <- NA
# df_phila$age_difference <- df_phila$officer_age - df_phila$subject_age

#---- The aggregate() function ----

# Splits our data into subsets, running summary statistics on them, and prints out easy to read results.

# aggregate(DATA, by=list(what you are subsetting by), FUN=function you want to compute, na.rm=TRUE/FALSE)
# This allows us to take out portions of the data of interest and run calculations.


# Can someone describe how we would find the mean age of the subjects in the dataframe, subsetting by race?
# What column would we include in by=list and what would our FUN be?
# Any guesses as to what na.rm does?



agg_mean = aggregate(df_phila$subject_age,by=list(df_phila$subject_race),FUN=mean, na.rm=TRUE)
# Let's break this down.
# We're acting on the subject_age portion of our df.
# We're subsetting according to subject_race.
# We're using the mean fuction to get the average.
# And na.rm is TRUE as we want to avoid any NAs.

# Good! But if someone looks at this, there's not much description.
# Let's rename the columns of this dataframe.
names(agg_mean) <- c("Race","Average Age")

# Looking good. Now we have some descriptive stats about the data.
  
#---- Looking at our data in a Histogram ----
# Histograms show us the distribution of frequencies of a variable.
# It's important to visualize the data so that we can see if our data is normally 
# distributed, or if there are any extreme values. We ALWAYS want to look over 
# our data before jumping straight to statistical tests. 

# As a simple exercise, we are going to take the ages of the subjects in the traffic stop
# We will put them into a simple visualization using R.

# The base package of R has a histogram function.

# Let's create a basic histogram.
hist(df_phila$subject_age)

# This is decent, but we can definitely make it a bit fancier.
# Luckily, histograms in R have a bunch of parameters you can change.

hist(df_phila$subject_age, 
     main="Histogram for Subject Age", 
     xlab="Age")

# Looking good.

# There's many more modifications you can make, including scale.
# R usually does a decent job of scaling, but you can use both
# xlim and ylim to change these to better fit your data.

# You can also insert a column and border color.

hist(df_phila$subject_age, 
     main="Histogram for Subject Age in Pittsburgh", 
     col="blue",
     border="black",
     xlab="Age",
     ylab="Stops")

# Nice! Now we have a presentable histogram.
# As we get further into analysis, you can even insert functions into the histrogram that mirror the 
# distribution of the data.
# Something to think about for the future, especially if your data is abnormally distributed.

#---- Descriptive Statistics ----
# Now that we've looked at the data, let's see how we can use it in our coding.
# You can call columns of variables by using dataframe_name$column_name.
# You can use these variables just like the list variables that we've worked with before.


# Let's run some basic descriptive statistics- mean and standard deviation work well.
# These will print out to the console.
mean(df_phila$subject_age)
sd(df_phila$subject_age)

# Hmm, didn't work, what did it return instead? Can anyone explain why?



# We have NA values- R by design does not ignore these for descriptive statistics. Thus, we have a separate argument for
# arithmetic mean and other descriptive statistics that allows R to ignore NA values.

mean(df_phila$subject_age, na.rm = TRUE)
sd(df_phila$subject_age, na.rm = TRUE)

# And thus we have the mean and standard deviation for subject age in our Philadelphia dataset!

# That's all for our intro to data analysis in R!
# This was still pretty preliminary, in later weeks we'll get into more complex data manipulation.
