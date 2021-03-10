# R Lesson - Week 5 - February 8
# This script was created on 02/02/2019 by Beatrice Langer.
# This script was modified on 09/18/2020 by Michael Datz.
# This lesson covers ANOVA and regression.

library(tidyverse) # Contains ggplot, dplyr, etc.
library(ggpubr)    # Way to graph data to look at descriptives (install at beginning of lesson)
library(rstatix)   # Allows us to quickly complete statistical tasks like checking for outliers.

# As always, let's start by loading our data and cleaning our dataframe:

setwd("~/Desktop/R Lessons")

# Setting up our PlantGrowth dataset.
data("PlantGrowth")
set.seed(1234)
PlantGrowth %>%
  sample_n_by(group, size = 1)

# Let's check what our levels are in this dataset:
levels(PlantGrowth$group)

# Getting the mean_sd per group
PlantGrowth %>%
  group_by(group) %>%
  get_summary_stats(weight, type = "mean_sd")

# A preliminary boxplot to look at the data:
ggboxplot(PlantGrowth, x = "group", y = "weight")

# Identifying any outliers that we may have.
PlantGrowth %>% 
  group_by(group) %>%
  identify_outliers(weight)

#---- One-Way ANOVA ----

# A One-Way analysis of variance (ANOVA) is an extension of an independent two-samples t-test. In a
# one-way ANOVA, we compare the means of three or more different groups. If there were only two groups,
# we can run a t-test. These groups differ based on the levels of our independent variable. For example,
# an ANOVA assessing the effect of undergraduate year on GPA would have GPA as the DV and 
# undergraduate year as the factor variable, with 4 levels (freshmen vs. sophomore vs. junior vs. senior).
# Therefore, you would be comparing the means from four different groups.

# Within a sample, we will expect variance in observations (i.e., plant weights).
# The total variance in a sample is comprised of two components:

#  - Within Group Variance: due to differences within each group. If within group variance is small, 
#    there is little within-group variance and the mean observations within the group will be similar.

#  - Between Group Variance: due to differences between the groups. If between group variance is small, 
#    there is little between-group variance and the means for each group will be similar.

# An ANOVA test allows us to compute a ratio of the within-group and between-group variance,
# called the F-statistic. F = Between-Group variance/Within-Group variance. If the variance
# between groups is proportionately larger than the variance within the groups, this will result in a large
# F-statistic. When this ratio is statistically significant, it suggests that the amount of 
# variance between the groups is more than you would expect by chance and that there is something  
# different between the groups (i.e., due to the properties of our manipulation or grouping variable)

# One Way ANOVA's have 2 possible hypotheses:
#  - Null hypothesis: the means of the different groups are the same.
#  - Alternative hypothesis: the means of the different groups are not the same.

# In an ANOVA, the DV is continuous and the the IV is categorical. 

#---- Example of a One-Way ANOVA using Study 1 data ----

# In Study 1, participants completed 5 tasks, where each task had a different coverstory.
# This variable was coded as "coverstory" in the dataframe.
# There were five different coverstories, called: quiz, stomach, productivity, stress, mood.
# Each task was randomly assigned to one of the coverstories, so the coverstory variable 
# was a within-subjects manipulation.

# We randomly assigned coverstories to each of the tasks because we wanted to control for effects
# that one coverstory could possibly have on participants' judgments. For example, what if participants
# have strong feelings about whether or not Facebook impacts mood, but they don't feel as strongly
# about whether or not riding a bike to work impacts productivity? If they feel strongly about 
# the Facebook coverstory, perhaps their strong prior beliefs about Facebook will more heavily influence
# their final causal judgments than their mild prior beliefs about biking to work. We randomly
# assigned the coverstories to each task so that each coverstory was used for all of the datasets,
# therefore we could control for the influence of coverstory when analyzing final judgments.

# Even though we believe we have controlled for coverstories, we still want to do analyses to
# determine whether or not the coverstory variable had an effect on causal strength judgments.
#  - Our dependent variable is final_strength_direction
#  - Our independent variable is coverstory, a factor that has 5 levels (quiz, stomach, productivity, stress, mood)
#  - Null Hypothesis: There is no difference between mean final causal judgments for the five coverstories  
#  - Alt. Hypothesis: There is a difference between mean final causal judgments between avereage judgments for
#                     at least one of the five coverstories and the other groups.

#----Running an ANOVA on PlantGrowth----

# Before running our planned analyses, let's create a line plot using ggpubr. This package
# has a useful set of functions that allow you to visualize your data with ggplot quickly and easily.
# You can also do this using bar plots, but here this package is a quick way to represent the information.
ggline(PlantGrowth, x = "group", y = "weight", add = c("mean_se"))

# It looks like the means are fairly similar between all five groups. Trt1 group is a little low, so we may see
# some effect.
# There's also some overlap in our SE bars, so we should expect an interaction.

# The function for ANOVA in R is aov(). We start by specifying the formula. In this case, our formula
# is weight ~ group. You may remember this notation from research methods.
# The variable on the left-hand side of the ~ (weight) is our dependent variable,
# and the variable on the right-hand side of the ~ (group) is our independent variable.
res.aov <- anova(lm(weight ~ group, data = PlantGrowth))

# To see the output from our ANOVA, we call the summary() function on our saved object
summary(res.aov)

# "Df" stands for degrees of freedom. 
#   - For the factor variable, this is equal to k-1, where k is the number of levels in the group
#   - For the residuals variable, this is equal to N-1, where N is the total number in the sample

# "Sum Sq" stands for sum of squares.
# To calculate SS, it is the sum of the squared differences between each observation and the group mean.
# You are calculating the total amount of variance between the observations and the average observation:
#   - SS for the factor variable is the total amount of variance in the sample between-groups.
#   - SS residuals is the total amount of variance not due to differences between groups, 
#       but due to error or individual differences within the groups

# "Mean Sq" stands for mean square. 
#   - MS is calculated by dividing the sum of squares by the degrees of freedom for that statistic.
#   - This gives us the average amount of variance between groups and the average amount of variance within groups.
#   - If MS for the factor variable and MS for the residuals is very close, then it is unlikely
#     that the population means are very different and that there are differences between the groups.

# The F-value is a ratio of mean squares.
#  - If the F-value is close to 1, there is no difference in the variance in observations 
#    due to error and the variance in observations due to differences between the groups. When the F-value is non-significant,
#  - As the F-value increases, this suggests that the proportion of variance due to difference between 
#    the groups is increasing.

# Pr(>F) is the p-value.
#  - If p > .05, then the F statistic is not statistically significant. We FAIL TO REJECT THE NULL HYPOTHESIS. 
#    Note, this is not the same as support for the null hypothesis - we are only able to claim that there is 
#    no evidence of a difference between the group means. If you wanted to find support for the null 
#    (which can be useful), you will want to look at other analyses like Bayesian ANOVA's.
#  - If p < .05, then the F statistic is statistically significant. We REJECT THE NULL HYPOTHESIS. 
#    There is a statistically significant difference between the group means.

#----Two-Way ANOVA----

# A Two-Way ANOVA, we compare the means from different groups with two or more
# factor variables/independent variables (e.g., gender and year in school). 
# In a two-way ANOVA, you can assess the independent effects that each factor have on the DV 
# and the effect that the interaction of those effects have on the DV.

# Two-way ANOVA test hypotheses:
# Null hypothesis 1: there is no difference in the means of factor A.
# Null hypothesis 2: there is no difference in the means of factor B.
# Null hypothesis 3: there is no interaction. 
# The alternative hypothesis for null hypothesis 1 and 2 is: the means are not equal.
# The alternative hypothesis for null hypothesis 3 is: there is an interaction between A and B.

# We'll run a Two-Way ANOVA on the ToothGrowth dataset.

#---- Example of a Two-Way ANOVA----

# Set up of the ToothGrowth dataset: 

my_data <- ToothGrowth
set.seed(1234)
dplyr::sample_n(my_data, 10)

# Breaking down the doses into different levels.

my_data$dose <- factor(my_data$dose, 
                       levels = c(0.5, 1, 2),
                       labels = c("D0.5", "D1", "D2"))


# In the ANOVA, we will test whether dose and supp have independent main 
# effects on lengthss. We will also see if they interact.

# Let's start again by visualizing our data. You can also do this using bar plots, but here
# is a quick way to represent the information.

ggboxplot(my_data, x = "dose", y = "len", color = "supp",
          palette = c("#00AFBB", "#E7B800"))

ggline(my_data, x = "dose", y = "len", color = "supp",
       add = c("mean_se", "dotplot"),
       palette = c("#00AFBB", "#E7B800"))

# We see here that the means are relatively different, leading us to believe there might be some interaction.

# If you remember from research methods, an interaction is when an independent variable modifies
# or changes the relationship between another independent variable and the dependent variable.
# In our case, when testing for an interaction we're looking to see if cover story valence 
# modifies the relationship between cover story and final strength judgements.


# To run a two-way ANOVA in R, we call the aov() function again and add the 
# additional coverstory_valence variable. To test if there is an interaction, we
# use the "*" operator between the two variables. Otherwise, we could use "+".

res.aov2 <- aov(len ~ supp * dose, data = my_data)
summary(res.aov2)

# or

res.aov2 <- aov(len ~ supp + dose, data = my_data)
summary(res.aov2)

# In our output, there are three rows: sup, dose, and residuals.

# It can be seen that the two main effects (supp and dose) are statistically significant, as well as their interaction.

# To see the interaction between the two independent variables, we look at the third row. 
# A significant p-value for the interaction would tell us that the effect of one of the independent variables
# on the dependent variable depends on the other independent variable.

# Thus, for our two-way ANOVA hypotheses, we reject the null.

#----Linear Regression----

# A linear regression is a statistical model that analyzes the relationship between a dependent variable (y)
# and one or more predictor variables (our IV's) and their interactions. In a regression, we enter predictor 
# variables to model a regression equation that allows us to predict a value of Y given values of our
# dependent variables.

# The equation for a linear regression takes the form of y = mx + b, where y is the dependent variable,
# x is the predictor variable, m is the slope, and b is the intercept. 

# m, our slope, is going to describe the relationship between our two variables.
# For each one unit increase in deltaP, final_strength_direction will increase by m units.
# If the two variables were perfectly correlated, the slope would be equal to 1.  
# b, our intercept, is the value from which we start measuring. 

# Just like with ANOVA, it will be helpful to visualize our data before we run any statistical tests.

# After we visualize, we can create a linear model using the lm() call.
# Here's an example using the cars dataset we had looked at previously.
view(cars)

linearMod <- lm(dist ~ speed, data=cars)  # build linear regression model on full data
print(linearMod)

summary(linearMod)

# Our R squared value is .6511, which means our model accounts for 65% of the variability in the data.
# The closer the R squared value is to 1, the better the model fits the data.

# Things look good so far, but we'll want to look at a plot of our residuals to make sure there
# aren't any hidden patterns the model isn't considering (for example, a logarithmic relationship).

plot(linearMod$residuals, pch = 1, col= "red")

# Our residuals look pretty random. If you did see a pattern, you'd want to transform your variable 
# by using logarithmic or square root functions (but with our data, this probably won't be an issue.)

# Like with ANOVA, we can use regression to test for interactions between variables. Going back to PlantGrowth,
# The plant group does not have separate groups, but say we split the data into something like roses v. tulips. 

# If we look at the relationship between final strength direction and deltaP and compare
# the short and the long-term tasks, we still see the same pattern.

# Let's say there's a hypothetical grouping according to flower type. We could split these using the face_wrap function
# we had learned last lesson.

# Do not run:

# ggplot(data = df,
#       aes(x = deltaP, y = final_strength_direction)) +
#  facet_wrap(~ flower_type, ncol = 2) +
#  geom_point() +
#  geom_smooth(method = "lm")
 

# And going back to PlantGrowth...
# If we enter weight and group as a potential interaction, we can test the following:

# - Is there a main effect of weight on groups when we control for flower type?
# - Is there a main effect of flower type on groups when we control for weight?
# - Is there an interaction between weight and flower type on groups?

# Do not run:
# model  <- lm(weight ~ group * flower_type, data = PlantGrowth)
# summary(model)

#----ANOVA or Regression?----

# ANOVA and regression are very similar tests. 
# Which one you use depends on what type of variables you're working with.

# When you are using a continuous dependent and continuous independent variable(s), you want to
# use regression. You may also want to use a regression when you are using within-subjects
# observations, like in our study. This is called a mixed-effects regression, which allows you 
# to control for within-subject variance in repeated measurements. Essentially, it's important
# to note that you can use a regression with categorical IV's, but you can also just do an ANOVA.

# When you are using a continuous dependent and categorical independent variable(s), you can
# use ANOVA. You cannot use an ANOVA with continuous IV's.

#----Manual ANOVA----

# For your benefit: optional section.
# The table we created contains the degrees of freedom, the sum of squares, the mean square, F-statistic and the p-value. 

# The sum of squares for treatments is defined as SST, for error as SSE and the total TotalSS. 
# The mean squares are calculated by dividing the sum of squares by the degrees of freedom.

# We then calculate the MST and MSE from the given degrees of freedom (k) 

plants <- split(PlantGrowth, PlantGrowth$group) # Split the data by group into a list

# The lapply function is then used to calculate the SST and SSE equation above for each group. 
# The Reduce function applies a binary function to the elements in each list and is then summed.

sst <- sum(Reduce('+', lapply(plants, function(x) {
  length(x[,1]) * (mean(x[,1]) - mean(PlantGrowth$weight))^2
})))
sst

sse <- sum(Reduce('+', lapply(plants, function(x) {
  (length(x[,1]) - 1) * sd(x[,1])^2
})))
sse

group_dof <- length(unique(PlantGrowth$group)) - 1
group_dof

residual_dof <- length(PlantGrowth$weight) - length(unique(PlantGrowth$group))
residual_dof

# Mean Squares
mst <- sst / group_dof
mst

mse <- sse / residual_dof
mse

# F-statistic
f.value <- mst / mse
f.value

# p-value
p.value <- 1-pf(q = f.value, df1 = group_dof, df2 = residual_dof)
p.value

plant.aov

#----Miscellaneous----

# R can also conduct TurkeyHSD tests:

# TukeyHSD(mydata)

# And also pairwise t tests:
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group, p.adjust.method = "BH")
