# DSA/ISE-5103 - Assignment Submission Example
# Example of R code submission
# Submit your .R code if you haven't worked with R Markdown

# All the libraries statement that your are using have to go in the top of the file
library(ggplot2) # for data visualization
library(dplyr) # for data manipulation

# Problem 1

m <- mean(mtcars$hp) # calculation of mean
s <- sd(mtcars$hp) # calculation of standard deviation
plot(mtcars$hp) 

quantile_hp <- quantile(mtcars$hp) # taking quantile for hp
quantile_hp 

# creating a function to normalize our data
scale_0to1 <- function(x){(x-min(x))/(max(x)-min(x))} # creating a function to scale from 0 to 1

glimpse(mtcars) # similar to str 

# Problem 2: Shrinking plots

# Plotting weight vs miles per galon
arc <- ggplot(mtcars, aes(x=wt, y= mpg, col = factor(cyl))) + 
  geom_point(size = 4.5, alpha=0.6) +
  geom_smooth(method = "lm", se = F) +
  xlab("Weigth (lb/1000)") + ylab("Miles/US gallon") + 
  labs(col= "Cylinders") +
  stat_smooth(method = "lm", se = F) + 
  stat_smooth(method="lm", se=F, col = "black", aes(group=1)) +
  theme_classic()
arc # showing the plot

# Final remarks

# * Your write-up does not have to contain unnecesary code. Save space for your analysis and results that help your analysis.
# * Each piece of results or plot that you are presenting in the write-up should come along with some analysis.
# * If you have several interesting results, use a table or something creative to show them.
# * You do not have to use R Markdown. It's only one more option for you.
# * Do not forget to submit your R code along with your write-up. If you used R Markdown, you are good to upload your .Rmd file instead of the .R file
