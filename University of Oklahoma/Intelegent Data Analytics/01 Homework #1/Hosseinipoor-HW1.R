<<<<<<< HEAD


#install.packages("e1071")     # installs the "e1071" package if it is not istalled on the system
library(e1071)                # package for calculaiton of skewness and kurtosis
library(plyr)                 # package including data set for problem #3
library(datasets)             # package including "quakes" data set for problem #4

# Promlem #1 -------------------------------------------------------------------------------

x = c(3, 12, 6, -5, 0, 8, 15, 1, -10, 7)    # define a vector with specific numbers and assign to x

y = seq(min(x), max(x), length.out = 10)    # Creat vector y consist of 10 element from min(x) to max(x)

sum(x); sum(y)              # summation elements for "x" and "y"
mean(x); mean(y)            # mean values for "x" and "y"
sd (x); sd (y)              # standard deviation values for "x" and "y"
var(x); var(y)              # Variances for "x" and "y"
mad(x); mad(y)              # Mean absolute deviation values for "x" and "y"
quantile(x); quantile(y)    # Quartiles for "x" and "y"
quantile(x, probs = seq(0, 1, 0.2)); quantile(y, probs = seq(0, 1, 0.2))    # Quintiles for "x" and "y"


z = sample(x, 7, replace = T)


skewness(x)                 # Skewness of vector "x" from package e1071
kurtosis(x)                 # Kurtosis of vector "x" from package e1071


t.test(x, y)                # t-test to compare the mean of "x" and "y"
t.test(sort(x), y, paired = T)          # t-test to compare the mena of sorted "x" and "y"


neg_x = x < 0               # Logical vector for x < 0


x = x[!neg_x]               # Recreat "x" vector with non-negative elemets of old "x"




# Promlem #2 -------------------------------------------------------------------------------


college = read.csv("college.csv")     # Reads data from file "college.csv" and assign to data fram "college"


rownames(college) <- college[,1]      # Use the first column of data as row's name
View (college )                       # Display the content of the dataframe
college <- college[,-1]               # Remove the first column's data


summary(college)                      # Shows the numerical summaries for "college"


help("pairs")                         # Shows the description for "pairs" function
pairs(college[,1:10])                 # Used pairs fucntion to produce a scatterplot matrix for the first ten columns


plot(college$Outstate~college$Private)  # Side-by-side boxplot for Outstate vs. Private


Elite <- rep("No", nrow(college))         # Creates a vector in size of rows of the college filling with "No"
Elite [college$Top10perc > 50] <- "Yes"   # Find the Top10prec greater than 50 and replace the corresponding element of "Elite" with "Yes"
Elite <- as.factor(Elite)                 # Converts the "Elite" vector into a factor vector with 2 levels
college <- data.frame(college, Elite)     # Adds "Elite" as a new column to the "College" data frame


summary(college$Elite)                    # Shows the number of teh elite and non-elite colleges


plot(college$Outstate~college$Elite,
     xlab = "Elite University",
     ylab = "Out of state tuition",
     main = "Out of state tuitions for elite and non-elite universities"
     )  # Side-by-side boxplot for Outstate vs. Elite


par(mfrow = c(2,2))       # Divides the screen into 4 winows
# Draw histograms for out of state tuitions, book costs, personal expenses, and accommodation costs.
hist(college$Outstate, xlab = "Out of state tuition", main = "Out of State Tuition Histogram", breaks = 20)
hist(college$Books, xlab = "Estimted book costs", main = "Book Cost Histogram")
hist(college$Personal, xlab = "Personal expenses", main = "Personal Expenses Histogram", breaks = 15)
hist(college$Room.Board, xlab = "Room and boars expenses", main = "Accommodation Cost Histogram", breaks = 25)



# Promlem #3 -------------------------------------------------------------------------------

?baseball                 # Shows the help and description about basegall dataset fron plyr package 


baseball$sf[baseball$year<1954]<-0                # Set 0 "sacrifies flies" for players beore 1954
# baseball$hbp[is.na(baseball$hbp)] <- 0
baseball$hbp[!complete.cases(baseball$hbp)] <- 0  # Set 0 missing values for "Hit by pitch"
baseball <- subset(baseball, baseball$ab>=50)     # Excludes all player records with fewer than 50 at bats


obp = with(baseball, (h + bb + hbp) / (ab + bb + hbp + sf)) # Compute on base percentage
baseball = data.frame(baseball, obp)    # Adds "obp" as data in a new column


baseball <- baseball[order(-baseball$obp),]       # Sorts the sata set based on "obp"h
head(baseball[,c("id", "year", "obp")], n =5)   # Displays the top 5 on base percentage
# tail(baseball[,c("id", "year", "obp")], n =5)



# Promlem #3 -------------------------------------------------------------------------------

par(mfrow=c(1,1))                     # Reset display windows
plot(quakes$mag~quakes$depth)         # Plots earthquake magnetude agianst the depth

quakeAvgDepth = aggregate(quakes$depth, list("Magnetude level"= quakes$mag), mean)

names(quakeAvgDepth) <- c("Magnetude Level", "Average Depth")

plot(quakeAvgDepth$`Magnetude Level` ~ quakeAvgDepth$`Average Depth`,
     xlab = "Average Depth",
     ylab = "Magnetude Level",
     main = "Magnetude Level of Earthquakes vs. Average Depth")




=======


#install.packages("e1071")     # installs the "e1071" package if it is not istalled on the system
library(e1071)                # package for calculaiton of skewness and kurtosis
library(plyr)                 # package including data set for problem #3
library(datasets)             # package including "quakes" data set for problem #4

# Promlem #1 -------------------------------------------------------------------------------

x = c(3, 12, 6, -5, 0, 8, 15, 1, -10, 7)    # define a vector with specific numbers and assign to x

y = seq(min(x), max(x), length.out = 10)    # Creat vector y consist of 10 element from min(x) to max(x)

sum(x); sum(y)              # summation elements for "x" and "y"
mean(x); mean(y)            # mean values for "x" and "y"
sd (x); sd (y)              # standard deviation values for "x" and "y"
var(x); var(y)              # Variances for "x" and "y"
mad(x); mad(y)              # Mean absolute deviation values for "x" and "y"
quantile(x); quantile(y)    # Quartiles for "x" and "y"
quantile(x, probs = seq(0, 1, 0.2)); quantile(y, probs = seq(0, 1, 0.2))    # Quintiles for "x" and "y"


z = sample(x, 7, replace = T)


skewness(x)                 # Skewness of vector "x" from package e1071
kurtosis(x)                 # Kurtosis of vector "x" from package e1071


t.test(x, y)                # t-test to compare the mean of "x" and "y"
t.test(sort(x), y, paired = T)          # t-test to compare the mena of sorted "x" and "y"


neg_x = x < 0               # Logical vector for x < 0


x = x[!neg_x]               # Recreat "x" vector with non-negative elemets of old "x"


# Promlem #2 -------------------------------------------------------------------------------


college = read.csv("college.csv")     # Reads data from file "college.csv" and assign to data fram "college"


rownames(college) <- college[,1]      # Use the first column of data as row's name
View (college )                       # Display the content of the dataframe
college <- college[,-1]               # Remove the first column's data


summary(college)                      # Shows the numerical summaries for "college"


help("pairs")                         # Shows the description for "pairs" function
pairs(college[,1:10])                 # Used pairs fucntion to produce a scatterplot matrix for the first ten columns


plot(college$Outstate~college$Private)  # Side-by-side boxplot for Outstate vs. Private


Elite <- rep("No", nrow(college))         # Creates a vector in size of rows of the college filling with "No"
Elite [college$Top10perc > 50] <- "Yes"   # Find the Top10prec greater than 50 and replace the corresponding element of "Elite" with "Yes"
Elite <- as.factor(Elite)                 # Converts the "Elite" vector into a factor vector with 2 levels
college <- data.frame(college, Elite)     # Adds "Elite" as a new column to the "College" data frame


summary(college$Elite)                    # Shows the number of teh elite and non-elite colleges


plot(college$Outstate~college$Elite,
     xlab = "Elite University",
     ylab = "Out of state tuition",
     main = "Out of state tuitions for elite and non-elite universities"
     )  # Side-by-side boxplot for Outstate vs. Elite


par(mfrow = c(2,2))       # Divides the screen into 4 winows
# Draw histograms for out of state tuitions, book costs, personal expenses, and accommodation costs.
hist(college$Outstate, xlab = "Out of state tuition", main = "Out of State Tuition Histogram", breaks = 20)
hist(college$Books, xlab = "Estimted book costs", main = "Book Cost Histogram")
hist(college$Personal, xlab = "Personal expenses", main = "Personal Expenses Histogram", breaks = 15)
hist(college$Room.Board, xlab = "Room and boars expenses", main = "Accommodation Cost Histogram", breaks = 25)



# Promlem #3 -------------------------------------------------------------------------------

?baseball                 # Shows the help and description about basegall dataset fron plyr package 


baseball$sf[baseball$year<1954]<-0                # Set 0 "sacrifies flies" for players beore 1954
# baseball$hbp[is.na(baseball$hbp)] <- 0
baseball$hbp[!complete.cases(baseball$hbp)] <- 0  # Set 0 missing values for "Hit by pitch"
baseball <- subset(baseball, baseball$ab>=50)     # Excludes all player records with fewer than 50 at bats


obp = with(baseball, (h + bb + hbp) / (ab + bb + hbp + sf)) # Compute on base percentage
baseball = data.frame(baseball, obp)    # Adds "obp" as data in a new column


baseball <- baseball[order(-baseball$obp),]       # Sorts the sata set based on "obp"h
head(baseball[,c("id", "year", "obp")], n =5)   # Displays the top 5 on base percentage
# tail(baseball[,c("id", "year", "obp")], n =5)



# Promlem #3 -------------------------------------------------------------------------------

par(mfrow=c(1,1))                     # Reset display windows
plot(quakes$mag~quakes$depth)         # Plots earthquake magnetude agianst the depth

quakeAvgDepth = aggregate(quakes$depth, list("Magnetude level"= quakes$mag), mean)

names(quakeAvgDepth) <- c("Magnetude Level", "Average Depth")

plot(quakeAvgDepth$`Magnetude Level` ~ quakeAvgDepth$`Average Depth`,
     xlab = "Average Depth",
     ylab = "Magnetude Level",
     main = "Magnetude Level of Earthquakes vs. Average Depth")




>>>>>>> origin/master
