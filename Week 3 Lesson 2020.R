# R Lesson - Week 3 - January 25th
# This script was created on 05/30/2018 by Beatrice Langer. 
# This script was modified on 09/19/2018 by Aleks Brown. Updated for Fall 2018 CLDM Lab.
# This script was modified on 01/21/2019 by Beatrice Langer. Updated for Spring 2019 CLDM Lab.
# This script was modified on 8/23/2020 by Michael Datz. Updated for Fall 2020 CLDM Lab.
# This lesson covers descriptive statistics, subsetting, piping, if/else statements, and NA values.

# First things first, we need to import our data.

setwd("~/Desktop/R Lessons")

df_1 <- read.csv("~/Desktop/R Lessons/nc_charlotte_2020_04_01.csv")
df_2 <- read.csv("~/Desktop/R Lessons/nc_raleigh_2020_04_01 2.csv")

rbind(df_1, df_2) -> df

# We're going to be learning subsetting and piping today. These functions are part of the dplyr package, 
# which is included in tidyverse. Let's load that.

library(tidyverse)

#----Dplyr and Tidyverse----

# Today we're going to be working with dplyr, a package that provides a consistent set of verbs
# you can use to manipulate data in R. The main functions in dplyr are:

# mutate(): adds new variables that are functions of existing variables.
# select(): picks variables based on their names.
# filter(): picks cases based on their values.
# summarise(): reduces multiple values down to a single summary.
# arrange(): changes the ordering of rows.

# These functions are used with group_by(), which allows you to preform operations using one or more
# grouping variables -- for us, this will most commonly be condition and task length.

# dplyr is included in a larger package collection called tidyverse, which also includes the data
# visualization package ggplot2. We'll be learning about ggplot2 later, when we start making graphs.

#----Subsetting----

# Before we can work with our data, imagine we need to remove officers from the dataset:
# Maybe the hash ID of the officer was incorrectly listed, and we need to remove this value.

# Let's start by making lists of all the users we want to drop we can tell R to ignore this data.
# For example, we can create a list of officer hash numbers to ignore, effectively removing these officers from the dataset

officer_hashes <- c("22e35044ed", "ba2321ddff", "5556a5f7b9")


# Now that we have all these users compiled, let's write a code to drop them from our dataframe.
# To do this, we're going to be working with the subset() function.
# Remember from last week that ! is a logical operator that means "not."

subset(df, !(officer_id_hash %in% officer_hashes)) -> trimmed


#----If/Else Statements----

# Now, let's deal with the missing values. There are three variables we're going to be looking at
# for this: final_direction, final_strength, and final_strength_direction.

# final_strength is a number between 0 and 10, and indicates how strong participants thought the
# causal relationship was at the end of the study. Missing values are defined as -9.

# final_direction is either 0 (if they thought there was no relationship between the variables),
# 1 (if they thought the causal relationship was generative), and -1 (if they thought the causal
# relationship was preventive). Missing values are defined as -9.

# final_strength_direction is essentially final_strength * final_direction * coverstory_valence
# and therefore is between -10 and +10. Because -9 is a theoretically plausible value for this
# variable, missing values are defined as -11.

# Although we assigned certain numbers to be missing values, R doesn't know that. 
# In order for R to treat a number or character as a missing value, it must be re-coded as NA.

# We can do this with if/else statements.
# If/else statements are conditional statements used to perform different actions based on
# different conditions. When you're writing an if/else statement, you're telling R
# "if x is true, do y."

# The code below is telling R that for the variable final_direction, if a value equals -9,
# replace it with NA, otherwise keep the original value in that cell.

df$final_direction <- ifelse(df$final_direction == -9, NA, df$final_direction)

# We can do the same thing for the final_strength variable. This code is saying
# that if final strength is equal to -9, replace it with NA.

df$final_strength <- ifelse(df$final_strength == -9, NA, df$final_strength)

# Note: there is usually more than one way to accomplish the same task in R.
# For example, the code below will result in the same output as above, but using 
# a different method. Here, it's saying to search the df$final_strength column
# for any values equal to -9 and setting them to NA. This code is shorter for now,
# but we will be using piping shortly in which case it makes sense to do the 
# slightly longer ifelse code.

df$final_strength[df$final_strength == -9] = NA

#----Interactive Activity 1: Replacing Missing Values----

# Remember, missing values for final strength direction are equal to -11.
# Try declaring the missing final_strength_direction values as NA.

df$final_strength_direction <- ifelse(df$final_strength_direction == -11, NA, df$final_strength_direction)

#----Solution to Interactive Activity 1----

df$final_strength_direction <- ifelse(df$final_strength_direction == -11, NA, df$final_strength_direction)
df$final_strength_direction[df$final_strength_direction == -11] = NA

#----Piping----

# While running each line of code separately is effective, it can be time-consuming when you're working
# with a large number of variables or have to make a lot of different changes to your dataframe.

# When we're working within the same dataframe, R allows us to combine our code. Let's start by compiling
# all the code we just wrote for dropping users and replacing missing values.

subset(df, !(usernum %in% admins) & !(usernum %in% drops))

df$final_direction <- ifelse(df$final_direction == -9, NA, df$final_direction)

df$final_strength <- ifelse(df$final_strength == -9, NA, df$final_strength)

df$final_strength_direction <- ifelse(df$final_strength_direction == -11, NA, df$final_strength_direction)

# Now, let's try using piping to combine all this code. 
# This is the pipe symbol: %>%. When we use the pipe symbol, it tells R that all the code following the
# pipe should be applied to the code that's before the pipe.

df %>%
  subset(
    !(usernum %in% admins) & !(usernum %in% drops) 
  )

# This code tells R that the subset function should be applied to what came before the pipe: in this case,
# our data frame, df. Note how we didn't have to put df in our subset function.
# When you are using piping, make sure to have the correct number of parantheses for each function.

# Using another pipe, we are now able to combine our subset code with our if/else statements.
# I added additional if/else statements for some other variables with missing values.

df %>%
  subset(!(usernum %in% admins) & !(usernum %in% drops) ) %>%
  mutate(
    final_strength_direction = ifelse(final_strength_direction == -11, NA, final_strength_direction),
    final_direction = ifelse(final_direction == -9, NA, final_direction),
    final_strength = ifelse(final_strength == -9, NA, final_strength),
    rt_final_strength = ifelse(rt_final_strength == -9, NA, rt_final_strength),
    final_cell_a = ifelse(final_cell_a == -9, NA, final_cell_a),
    final_cell_b = ifelse(final_cell_b == -9, NA, final_cell_b),
    final_cell_c = ifelse(final_cell_c == -9, NA, final_cell_c),
    final_cell_d = ifelse(final_cell_d == -9, NA, final_cell_d),
    rt_final_frequency = ifelse(rt_final_frequency == -9, NA, rt_final_frequency)
  ) -> trimmed

#----NA Values----

# Now that R is able to identify the missing values in our data, we'll have to be sure we specify NOT to
# include these NA values when we do data analysis. We indicate that by using the expression na.rm.

mean(trimmed$final_strength_direction)

# We got NA as our result because there are NA values in our data. Let's add na.rm=TRUE to tell R not to
# include the NA values when caculating the mean.

mean(trimmed$final_strength_direction, na.rm=TRUE)


#----Descriptive Statistics----

# Descriptive statistics provide simple summaries that describe the basic features of data
# in a study. They can represent an entire populatino or a sample of it.

# R has a base function called summary() that gives us 5-number summaries, means, and frequencies
# for every variable in the dataset.

summary(trimmed)

# However, this isn't very helpful, because we haven't subset our data by condition yet. Let's do that.

subset(trimmed, condition == "generative") -> dfgen

# Now, let's look at some descriptive statistics using the function summarise(). We're going to use piping
# so R knows to take the descriptives from our new "dfgen" dataframe.

dfgen %>%
  summarise(
  mean = mean(final_strength_direction, na.rm=TRUE),
  sd = sd(final_strength_direction, na.rm=TRUE)
  ) -> dfgen_averages

# Now we can see the mean final strength direction value for the generative condition. We could do this
# for every condition individually, but that would take a long time. Luckily, R has a function called
# group_by() that will allow us to do this much faster, with just one line of code! 

# We're going back to our original "trimmed" dataframe now.

trimmed %>%
  group_by(condition) %>%
  summarise(
    mean = mean(final_strength_direction, na.rm=TRUE),
    sd = sd(final_strength_direction, na.rm=TRUE)
  ) -> averages

# This table allows us to quickly and easily compare the means between the four conditions. Are the
# means for each condition what you would expect? Why or why not?

#----Interactive Activity 2: Grouping by Two Variables-----

# We still have a problem, though. There's another important independent variable that we aren't 
# accounting for: task length. 

# Create a table of descriptives that groups by task length AND condition. Include mean, median,
# standard deviation, standard error, and N in your table.

#----Solution to Interactive Activity 2----

# Thankfully, group_by() makes it easy to group by multiple variables as well as single ones.

trimmed %>%
  group_by(condition, task_length) %>%
  summarise(
    N       = sum(!is.na(final_strength_direction)),
    mean    = mean(final_strength_direction, na.rm = TRUE),
    median  = median(final_strength_direction, na.rm = TRUE),
    sd      = sd(final_strength_direction, na.rm = TRUE),
    se      = sd/sqrt(N)
  ) -> averages2

# It looks like there were stronger illusory correlations for the long term conditions, especially the
# A Cell Bias condition. We still need to assess these results for significance, though -- this could
# make for an interesting data project!

#----Homework 3 Solutions----

# Creating change_in_strength variable

trimmed$change_in_strength <- trimmed$final_strength_direction - trimmed$prior_strength_direction

# Histogram for change_in_strength variable

hist(trimmed$change_in_strength)

# What does it tell you about the realationship between prior strength judgements and final strength
# judgements? Does this make sense in the context of our study?

# change_in_strength having a mean of zero makes it seem like participants were not able to learn
# causal relationships during the study. However, we know that on average, prior_strength_direction
# was not significantly different from zero (which we want, because this means participants were 
# unbiased). We also know that many participants in the Outcome Density and A-Cell Bias conditions
# correctly identified the variables as having no causal relationship by giving a final strength
# judgement of zero. So, for participants in these conditions, a change_in_strength value of zero
# actually indicates successful causal learning. This is a very good example of why it’s important
# to look at the data for each condition separately. Otherwise, we would be drawing false conclusions.

# Do you expect mean change in strength values to be positive, negative, or zero for each condition?
# Which two of the four conditions might you expect to see more zero judgements?

# Outcome Density: 0 / slightly +
# A Cell Bias: 0 / slightly +
# Generative: +
# Preventive: -

# Histogram for final_strength_direction variable in A Cell Bias condition

acell <- subset(trimmed, condition == "aCellBias")
hist(acell$final_strength_direction)

# Using aggregate and piping for descriptives 

trimmed %>%
  subset(select = c(prior_strength_direction, final_strength_direction, change_in_strength)) %>% 
  aggregate(by=list(trimmed$condition), FUN = mean, na.rm=TRUE) -> means

# Using summarise, group_by(), and piping for descriptives

trimmed %>%
  group_by(condition) %>%
  summarise(
    N       = sum(!is.na(change_in_strength)),
    mean    = mean(change_in_strength, na.rm = TRUE),
    median  = median(change_in_strength, na.rm = TRUE),
    sd      = sd(change_in_strength, na.rm = TRUE),
    se      = sd/sqrt(N)
  ) -> descriptives
