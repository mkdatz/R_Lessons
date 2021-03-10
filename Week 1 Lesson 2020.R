# R Lesson - Week 1 - February 11th, 2021

# This script was created on 05/03/2018 by Beatrice Langer.
# This script was last modified on 8/08/20 by Michael Datz,
# updated for Fall 2020 CLDM Lab.
# This script was last modified on 2/04/21 by Michael Datz.

# This lesson covers: installing packages, basic objects, lists,
# matrices, and logical operators.

# Anytime you modify your script, you can update it here to remind
# yourself.
# It's a good idea to document any major modifications you make. 
# If you publish a script and put the data online, it's important
# for other people to be able to understand your code.

#----Creating a Project----

# Before we get started, let's keep with programming tradition and say Hello World!

print("Hello World!")

# RStudio allows you to keeps a bunch of data associated with one project
# all together -- input data, R scripts, analytical results, and figures can
# all be preserved by creating a project. Once you start working on larger
# projects in R this will be super useful! 

# To create a project, click on File and select New Project.
# Click on New Directory.
# Click on Empty Project.
# Name your project, and choose where it will be saved on your desktop.
# That's it!

# You can create multiple scripts within your project, or have just one.
# Now, even when you clear your environment, you will always have access to
# your source code.

# Separate files can be made by selecting New File
# And creating a new R script.
# This is good if you have a small process you want to test out independently.

# ----Installing Packages----

# Packages are sets of functions that someone else has written for
# you to use. In order to use a package, you must install it and
# load it. You only need to install it on your computer once, but 
# you need to load it in every script you plan on using it. 
# Let's use tidyverse for example. This is a package that you'll
# use a lot when learning R.

# You can either click Tools > Install Packages, or just type out 
# the code by hand.

install.packages("tidyverse")

# Once you've installed it, tidyverse is now libraried. You won't
# ever have to install it again unless you run your script on a
# different computer. Click on packages and you can see which 
# packages you have libraried and which ones are loaded. 

# If you want to call a function from tidyverse in your script, you
# have to load it. You have to load it in your script before you 
# can use any of its functions, but once you've loaded it, you won't
# have to load it in that specific script again.

library(tidyverse)

# It's good to get into the habit of loading all your packages 
# before you start writing your code; we do this by calling the
# library() functions first at the top of our scripts.

# Let's do one together! Say we want to use the praise package to
# make us feel more confident. The praise package includes the
# praise() function. What if we try calling the praise() function
# without installing the package first? Let's try it. Run the 
# following code:

praise()

# We get an error because R couldn't find the praise() function.
# This will happen if you don't install or load your packages.
# Now let's install the praise package. Type the following into your
# script:

install.packages("praise")

# Now run this line of code. The console will output a few lines of red 
# text and then a few lines of black text. 
# We've installed the package! Now, let's load the package. 
# Type the following into your script:

library(praise)

# Run this line of code. We just told the script that we will be using
# functions from the praise package in our code. Let's call one of those
# functions! Type the following into your script:

praise()

# Now, if you want to use praise() in another script, all you have to do
# is load the package and R will run the function when you call it.

# ----Objects----

# Now that we have a script set up, let's create our first object.
# Type the equation and hit command + enter on a Mac or CTRL + enter
# on a PC to run the code. 

x = 2 + 2

# Because we are using a script, our object will save (see box to the 
# right). We can use this object later on in this project because it is 
# saved into the script. Let's try using this object in an equation. 

x + 2

# You can run multiple lines of code by selecting the lines you want
# and pressing command + enter on a Mac or CTRL + enter on a PC. You can
# run your entire script by pressing shift + command + enter on a Mac or 
# shift + CTRL + enter on a PC.

# ----Lists----

# You can create a list of string objects (useful for qualitative data).
# To do this, we call the c() function. Fun fact: the c stands for
# compile, which is easy to remember because you're compiling a list!

c("Liz", "Katie", "Ben", "Ciara", "Yiwen", "Dan", "Shannon", "Michael", "Kayla", "Danielle", "Anna", "Johani", "Eric", "Julia")

# After you run this code, the list is printed to the Console.
# Let's assign it to a variable.

people_in_lab <- c("Liz", "Katie", "Ben", "Ciara", "Yiwen", "Dan", "Shannon", "Michael", "Kayla", "Danielle", "Anna", "Johani", "Eric", "Julia")

# Now you should see it show up as an object in the Environment pane. 

#You can also create lists of number objects. 

exam_grades <- c(88, 90, 76, 85, 88, 80)

# You can run some basic functions on this list that come already
# included in R.

mean(exam_grades)
median(exam_grades)
range(exam_grades)
max(exam_grades)
min(exam_grades)

# ----Matrices----

# You can make a matrix out of an already existing object.
# A matrix is a collection of objects of the same type with a specified
# Number of rows and columns
# Let's use our exam grades list.

matrix <- as.matrix(exam_grades)
as.matrix(exam_grades) -> matrix2

# Now we can see our matrix if we click on it in the environment
# window.

# Now, let's create a matrix from scratch using the matrix base
# function in R.

newmatrix <- matrix(c(1,2,3, 11,12,13), 
             nrow = 2, 
             ncol = 3, 
             byrow = TRUE,
             dimnames = list(c("row1", "row2"),
                         c("C.1", "C.2", "C.3")))

# You can also set "dimnames" to NULL if you do not want to these
# labels.

# Note that in the environment, the matrices show up under "Data."
# This matrix we created is already very much like a data frame! 

# ----Help----

# If you don't understand how a function works or want to find how to call a
# particular function, you can use Google or go to the Help tab.

# Start by clicking on "Help" and type "praise" into the search bar.
# You can now see how the "praise" function is used and what arguments it takes.

# Now click on packages. Scroll down to and click on ggplot2. 
# You can see all the functions included in this package.
# Scroll down and click on "qplot", which is a simple way to create a histogram
# with ggplot2.

# You can also get to this same page by typing "qgplot" in the search bar,
# just like we did with the praise function.

# Finally, you can also learn how to use specific functions by using the help 
# function.

help(mean)
help(ggplot)

# Using "mean" as the argument for the help function results in the help pane 
# showing the mean function's usage, arguments, and several more important 
# pieces of information.

#----Logical Operators----

# Logical operators return a value of TRUE or FALSE. They are used to combine
# two or more conditions.

# & and && is logical AND. This returns TRUE when both conditions are true.
# & can compare multiple elements, and && compares only one element.

x <- 4
y <- 6

(x + 2) & (y) == 6

# | and || is logical OR. This returns TRUE when at least one of the two
# conditions is true.
# | can compare multiple elements, and || compares only one element.

x | y == 4

# ! is logical NOT. If the condition is true, logical NOT returns as false.

!(x==4)

# Here's an example of logical operators being used with if statements.
# You'll learn more about if statements later. 

age <- 70
if (!(age > 18)) {                    # If age is not greater than 18,
  print("Teenager")                   # run this line of code.
} else if(age > 18 && age <= 30) {    # If age is greater than 18 and less than or equal to 30,
  print("Young Adult")                # run this line of code.
} else if(age == 31 || age <= 60) {   # If age is equal to 31 or less than or equal to 60,
  print("Adult")                      # run this line of code.
} else {                              # If age does not meet any of these criteria,
  print("Senior")                     # run this line of code.
}

# ----Comments & Subsets----

# You can comment anywhere on your code by using a pound sign. To comment multiple
# lines of code, press command + shift + c on a Mac or CTRL + shift + c on a PC.

# You can also create subsets of code like this by using a pound sign followed
# by 4 dashes, the name of the subset (in this case, "Comments & Subsets") and
# 4 more dashes. Subsets help you organize your code and make it easier to read
# and understand.

