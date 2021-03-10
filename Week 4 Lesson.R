# R Lesson - Week 4 - February 1
# This script was revised on 06/06/2018 by Beatrice Langer. 
# This script was modified on 09/25/2018 by Aleks Brown. Updated for Fall 2018 CLDM Lab.
# This script was modified on 1/28/2019 by Beatrice Langer. Updated for Spring 2019 CLDM Lab.
# This script was modified on 9/5/2020 by Michael Datz. Updated for Fall 2020 CLDM Lab.
# This lesson covers histograms and plotting using the ggplot package.

# First, let's load our data and packages:

setwd("~/Desktop/R Lessons")

library(tidyverse)

# This week, for the sake of qualitative analysis, we'll be looking at some of the base data in ggplot.
# Namely, we'll look at mtcars and mpg, dummy data based on car statistics.

view(mtcars)
view(mpg)

# Normally, we would clean out dataset, making sure to get rid of any mis-coded values,
# but the mtcars dataset is already able to be examined.

#----Intro to ggplot2----

# Why is ggplot so important?
# Well, it goes back to tidyverse being incredibly amazing as an extension of R
# Also, everyone loves to look at aesthetically pleasing data.

# The "gg" in "ggplot" stands for "grammar of graphics." 
# There are four main elements in the grammar of graphics.

# Data: the data-set being plotted.
# Aesthetics: the scales onto which we plot our data.
# Geometry: the visual elements used for our data.
# Facet: groups by which we divide the data.

# Here is a template for creating graphics in ggplot2:

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# <DATA> is where you'd put the name of your dataframe. Like with piping, when we put the
# name of our dataframe here, we won't have to type df$ every time we want to call a variable.

# <GEOM_FUNCTION> is the geometry, or visual elements, that we'll be using to create our plot.
# Some examples of geoms include geom_bar (bar graphs), geom_point (scatterplots), and
# geom_boxplot (boxplots).
# When creating a graph with ggplot2, you can have one geom, or many layered on top of each other.

# <MAPPINGS> are the aesthetics we use to plot our data. We use aesthetic mappings to set the
# x and y variables for our plots. Aesthetics also include the shapes, colors, etc. that we 
# might map our variables to. Here is a guide to aesthetics in ggplot2: 
# https://cran.r-project.org/web/packages/ggplot2/vignettes/ggplot2-specs.html

# We can also use global mappings if there are certain mappings (i.e., x and y variable) that
# we want to apply to ALL the geoms in our code. That would look like this:
# ggplot(data = <DATA>, aes(<GLOBAL MAPPINGS)) +
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# Think of a call to ggplot like snapping together lego pieces. You can keep adding more and more components,
# growing and making something more complex as a result.

#----Histograms----

# Just creating some dummy data to view in R.
data=data.frame(value=rnorm(10000))

ggplot(data, aes(x=value)) + 
  geom_histogram()
# R usually does a pretty good job of guessing how your plot should look.

# And here it is in the context of mtcars.
# Here, we can create a simple histogram and give different bin widths to change the scale of the x axis.
ggplot(mtcars,aes(x=mpg)) + 
  geom_histogram(binwidth=5)

# But we can get even more crazy here.


# Notice we change the bin width and we have even smaller bars, showing us a more detailed shape of the data.
ggplot(data, aes(x=value)) + 
  geom_histogram(binwidth = 0.05)

# And here, using the aes() field, we can color it based on count.
ggplot(data, aes(x=value)) + 
  geom_histogram(binwidth = 0.2, aes(fill = ..count..))

#----Scatterplots (geom_point)----

# We can create scatterplots in ggplot2 using geom_point.

ggplot(data = mtcars, aes(x = mpg, y = hp)) +
  geom_point()

# The code above plots mpg on the x axis and hp on the y axis.
# You can add a third variable to your plot by mapping a variable to an aesthetic. 
# Aesthetics in ggplot include color, size, alpha (transparency), and shape.
# Let's see what happens when we map the cyl variable to the color aesthetic.

ggplot(data = mtcars, aes(x = mpg, y = hp, col = factor(cyl))) +
  geom_point()

# mpg (miles per gallon) is assigned to the x axis.
# hp (horsepower) is assigned to the y axis.
# cyl (number of cylinders) determines the color. We set this to "factor" so ggplot2 treats it
# as a categorical variable.

my_scatplot <- ggplot(mtcars,aes(x=wt,y=mpg,col=cyl)) + 
  geom_point()

my_scatplot + labs(x='Weight (x1000lbs)',y='Miles per Gallon',colour='Number of\n Cylinders')

# Example from R for Data Science... isn't it beautiful?
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

# Let's say we want to focus on one level of the variable at a time. We can do this with facets. 

#----Facets (facet_wrap)----

# In R, a facet refers to a particular aspect or feature of a dataset.
# You can use facet_wrap() to facet the data by one variable:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(. ~ class, nrow = 2)

# displ (engine displacement) is assigned to the x axis.
# hwy (highway miles per gallon) is assigned to the y axis.
# We write ". ~ class" to indicate that we are faceting the data by car class.
# nrow = 2 tells R to display our graph using 2 rows.

my_scatplot <- ggplot(mtcars,aes(x=wt,y=mpg,col=cyl)) + geom_point()
my_scatplot + facet_wrap(~cyl)


# Here we use the mpg dataset, and color the data according to class of car.

# Can you see what we've done with geom_smooth here? How have we changed the data?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    se = FALSE
  )


#----Smoothed Conditional Means (geom_smooth)----

# geom_smooth will allow you to look at smoothed conditional means. For our data, this might be an
# estimate of the mean final_strength_judgement conditional on deltaP.

view(mpg)

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# You can overlay multiple geoms in one graph by putting a plus sign inbetween your two geom codes.

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = cty))

# If we use the method = "lm" in geom_smooth, it fits a linear model to the data. 

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy), method="lm") +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# This is where global mappings starts to become really useful for cleaning up our codes.


# Here's a fully fledged scatterplot, albeit with a bit different formatting.

my_scatplot <- ggplot(mtcars,aes(x=wt,y=mpg)) + geom_point()
my_scatplot + xlab('Weight (x 1000lbs)') + ylab('Miles per Gallon') + geom_smooth()

#----Bar Graphs (geom_bar)----

# Bar graphs are another basic for of data visualization.

# Let's start by looking at a bar graph of number of cylinders vs. gears from the mtcars dataset. 

ggplot(data = mtcars, aes(x = cyl, fill = factor(gear))) +
  geom_bar()

# Setting position to "fill" gives us a plot in terms of proportion. 

ggplot(data = mtcars, aes(x=cyl,fill=factor(gear))) +
  geom_bar(position = "fill")

# Let's continue here with an examination of the mtcars dataset and a count of cars by cyl.

ggplot(mtcars, aes(x=as.factor(cyl))) + 
  geom_bar() + xlab("Number of Cylinders") + ylab("Count")

# And we can customize this according to RGB values, whatever looks good.
ggplot(mtcars, aes(x=as.factor(cyl) )) +
  geom_bar(color="blue", fill=rgb(0.1,0.4,0.5,0.7))

ggplot(mtcars, aes(x=as.factor(cyl), fill=as.factor(cyl) )) + geom_bar( ) +
  scale_fill_hue(c = 40)

# For geom_bar, the default argument is stat = "bin." This creates a bar graph where the
# height of the bar represents the count of cases in each category. We want to set stat = "identity"
# so that we can change the variable on the y-axis.


# In addition, we set position = "dodge" which arranges the elements side by side as opposed
# to stacking them on top of one another to show proportions.

# This looks nice, but often times we'll want to customize it to fit APA format guidelines (or close to them).
# You're going to want to add a title, change the axis labels, add error bars, remove the grid,
# and change the legend title and labels to make your graph more readable.

# You can use Google to find code for this! Here are two great places to start:
# http://ggplot2.tidyverse.org/reference/labs.html
# http://ggplot2.tidyverse.org/reference/theme.html 
# Note: not everything you will want to do is included with the lab and theme function, you will
# need to use others.

#----Regressions, etc.----

# Here we look a little deeper into linear models in ggplot.
# As you can see here, we have inserted a formula y~x to model the linear model
# When ggplot shows the graph, it will have this linear model with the best fit.
ggplot(mtcars, aes(wt, mpg, color = cyl)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y~x) +
  labs(title = "Regression of MPG on Weight", x = "Weight", y = "Miles per Gallon")


# There is more to ggplot for sure, and we haven't hardly touched concepts such as variable interactions in the dataset.
# For now, I will leave you with that, and I'll try to send you more ggplot info in a few days.

#----Additional Notes on ggplot----
# An examination on ggplot using examples I found online:
# Includes examples about boxplots, themes, and function call syntax.

# Using the midwest dataset.
# Notice this is a valid call, but the graph is blank. You need to specify your visualization- R will
# not do that for you.
# Notice that for the aesthetic fields we manually map the x and y values. Think of transitioning a table of x and y
# to a graph form.
ggplot(midwest, aes(x=area, y=poptotal))

# Reading in a CSV direct from github.
# Github is an website where programmers/software engineers create repositories of code, either for public
# Or internal use.
tips <- read.csv("https://sebastiansauer.github.io/data/tips.csv")

# Facet with respect to sex
qplot(x = total_bill, y = tip, facets = ~sex, data = tips) +
  geom_smooth(method = "lm")

# We can also do boxplots in ggplot!
ggplot(tips) +
  aes(x = sex, y = tip) +
  geom_boxplot() +
  facet_wrap(~smoker)

# With a simple coord_flip() call, you can change the display in the plotting environment.
ggplot(tips) +
  aes(x = sex, y = tip) +
  geom_boxplot() +
  facet_wrap(~smoker) +
  coord_flip()

# We can also create line graphs that better help us to visualize interactions in our data.
tips %>% 
  ggplot() +
  aes(x = sex, color = smoker, group = smoker, y = tip) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun = mean, geom = "line")

# Here's a more straightforward example for bar graphs, using the diamonds dataset.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# Notice we can also make the graph have its' axis with respect to proportion, rather than count, as was given
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

# We can also map stat summaries to a graph using a call like this.
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

# Also found this, pretty cool.
# Shows the diamonds dataset in a sort of polar representation.
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
bar + coord_polar()

# Setting themes- adding flair to your graphs
# Base plot, with styling
gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")

# Manually changing the scale
# Also manually saving to a variable gg
gg <- gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01))

# method 1: Using theme_set(), done for you
theme_set(theme_classic())
gg

# method 2: Adding theme Layer itself.
# Run each line separately and make note of their differences.
gg + theme_bw() + labs(subtitle="BW Theme")
gg + theme_classic() + labs(subtitle="Classic Theme")

view(diamonds)
# Explanation of syntax:
# As I had said in the lesson, you have to specify your aesthetics for ggplot.
# Though, we have options.
# If we want the same aesthetics across the entire call, we can put the aes specification right in the ggplot call.
# Specifying the aesthetics inside the ggplot call.
ggplot(diamonds, aes(x=carat, y=price, color=cut)) +
  geom_point() + 
  geom_smooth() 

# Specifying the aesthetics inside the geoms.
ggplot(diamonds) +
  geom_point(aes(x=carat, y=price, color=cut)) + 
  geom_smooth(aes(x=carat, y=price, color=cut)) 

# These get you the same graph. Use whatever you are comfortable with.

# There's still even more to ggplot, I suggest you take the time on your own to research some tutorials if you're interested.
# You can even get super advanced and create plots overlayed on a map of the United States, for example.

# Check out the tidyverse docs for more on ggplot2.
# https://ggplot2.tidyverse.org/index.html
