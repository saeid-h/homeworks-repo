#Assignment #0
#Name: Charles Nicholson
#ISE 5103 Intelligent Data Analytics
#Date: mm/dd/yyyy

#required packages for this assignment
library(ggplot2)  #provides advanced graphics



#Problem 1: create a vector of strings and demonstrate access

#Problem 1(a)
x<-c('R','is','a','powerful','open source','statistical','scripting language')

x[1]    #access first element
x[4:6]  #access third thru fifth elements

#Problem 1(b)
length(x)  #determine length of x


#Problem 1(c)
#create a new vector "z" from x, but insert "my favorite"
z<-c(x[1:2],"my favorite",x[4:length(x)])   
z  #view the results





#Problem 2   -------------------------------------------------------------------

#the data and the command `qplot' are from the package `ggplot2'

data(diamonds)  #data frame from ggplot2
head(diamonds)  #examine first few rows

#scatterplot of diamond carat and price; clarity differentiated by color
qplot(carat, price, data = diamonds, colour = clarity)


#more exploration

#increase breaks of histogram to look for detail
hist(diamonds$carat,breaks=50) 

