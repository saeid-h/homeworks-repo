
# -------------------------------- Functions -------------------------------------------
#generalized ESD test -- adapted from code available on stackoverflow.com


# helper function
# Compute the critical value for ESD Test
esd.critical <- function(alpha, n, i) {
  p = 1 - alpha/(2*(n-i+1))
  t = qt(p,(n-i-1))
  return(t*(n-i) / sqrt((n-i-1+t**2)*(n-i+1)))
}

#main function
removeoutliers = function(y,k=5,alpha=0.05) {
  
  if (k<1 || k >= length(y))
    stop ("the number of suspected outliers, k, must be in [1,n-1]")
  
  ## Define values and vectors.
  y2 = y
  n = length(y)
  toremove = 0
  tval<-NULL
  ris<-NULL
  
  ## Compute test statistic until r values have been removed from the sample.
  for (i in 1:k){
    if(sd(y2)==0) break
    ares = abs(y2 - mean(y2))/sd(y2)
    Ri = max(ares)
    y2 = y2[ares!=Ri]
    
    tval<-c(tval,esd.critical(alpha,n,i))
    ris<-c(ris,Ri)
    ## Compute critical value.
    if(Ri>esd.critical(alpha,n,i))
      toremove = i
  }
  
  # Values to keep
  if(toremove>0){
    outlierLevel = sort(abs(y-mean(y)),decreasing=TRUE)[toremove]
    o = y[abs(y-mean(y)) >= outlierLevel]
    y = y[abs(y-mean(y)) < outlierLevel]
  }
  
  RVAL <- list(numOutliers=toremove,outliers=o,cleandata=y,critical=tval,teststat=ris)
  return (RVAL) 
}


# -------------------------------- Libraries -------------------------------------------

library(reshape2)
library(ggplot2)
library(robustbase)
library(outliers)
library(fitdistrplus)
library(Amelia)
library(mice)
library(plyr)
library(HSAUR2)
library(ggbiplot)
library(VIM)


# -------------------------------- Problem 1 -------------------------------------------

x = c(3, 4, 2, 1, 7, 6, 5)
y = c(4, 3, 7, 6, 5, 2, 1)

#x = 1:12
#y = c(2, 1, 4, 3, 6, 5, 8, 7, 10, 9, 12, 11)
#y = c(12, 2:11, 1)

# C = sum(pmin(max(x)-x, max(y)-y))

C = 0; D = 0
# Calculate the Concordance and Discordance based on the definition
for(i in 1:length(x))
  for(j in 1:length(y))
  {
    if(x[i] < x[j]){
      if(y[i] < y[j]) 
        C = C + 1 
      if(y[i] > y[j]) 
        D = D + 1
    }
  }
C; D

# -------------------------------- Problem 2 -------------------------------------------

# 2a)

# Generate random variables:

a = rnorm(500)                                  # Normal Distribution
b = rchisq(500, 5)                              # Chi Square Distribution
c = rexp(500)                                   # Exponentioal Distribution
d = rlnorm(500)                                 # Log Normal Distribution

df = data.frame(a, b, c, d)                     # Make a data frame from random variables
head(df, 2)


df2 = melt(df, variable.name = "groupVar")      # Reshape the data
head (df2, 4)

# 2b)
# Using ggplot to visulize the densities
ggplot(df2, aes(x = value, fill = groupVar)) +
  geom_density(alpha = 0.3) +          #set geometry and transparency    
  labs(x = "Random Variable",           #set x-label and title
       title = "Densities for Random Distributions")

qplot(value, data = df2, geom = "density", 
      colour = groupVar, alpha=I(0.3), fill=groupVar, 
      main="a=Normal, b=Uniform, c=Chi-Square, d=Beta Distribution Densities", 
      xlab="Values", ylab="Density")




# -------------------------------- Problem 3 -------------------------------------------

#library(data.table)
#mydat <- fread('http://www.sharkattackfile.net/spreadsheets/GSAF5.xls')
#head(mydat)

# 3a)
Shark.attack = read.csv("ISE 5103 GSAF.csv")        # Reads data from the file

plot(Shark.attack$Year[Shark.attack$Year>1000], 
     col = "Blue",
     ylab = "Year")

hist(Shark.attack$Year[Shark.attack$Year>1000],
     col = "Blue",
     main = "Shark Attck Time Histogram",
     xlab = "Year",
     ylab = "Frequency")


# 3b)
GSAFdata = Shark.attack[Shark.attack$Year >= 2000,] # Deletes the records before 2000

# 3c)
GSAFdata$Date.old = GSAFdata$Date                   # Keep the old date values
GSAFdata$Date <- as.Date(GSAFdata$Case.Number , 
                         "%Y.%m.%d")    # Converts and stores the dates as date format
#GSAFdata$Date <- as.Date(GSAFdata$Date , "%d-%b-%y")

#GSAFdata$Date.old[is.na(GSAFdata$Date)]
#GSAFdata$Case.Number[is.na(GSAFdata$Date)]

# 3d)
# Calculates ratio of missing dates respect to total records
GSAFdata.missing.ratio <- nrow(GSAFdata[is.na(GSAFdata$Date),]) / nrow(GSAFdata)
round(GSAFdata.missing.ratio*100,1)       # Percentage of missing values

# 3e)
GSAFdata <- GSAFdata[!is.na(GSAFdata$Date),]    # Deletes missing data respect to date

# 3f-i)
daysBetween <- diff(GSAFdata$Date)      # Calculates the interval between attacks
length(daysBetween)                     # Checks the number of observations
# daysBetween <- c(NA, daysBetween)
GSAFdata$DaysBetween <- c(NA, daysBetween) # Add the new vaiable to data frame

# 3f-ii)
par(mfrow=c(1,2))               # Divides the screen into two sections
boxplot(GSAFdata$DaysBetween, 
        col = rainbow(10))      # Box plot
adjbox(GSAFdata$DaysBetween, 
       col = rainbow(10))       # Adjusted box plot
par(mfrow=c(1,1))               # Resets the screen in normal

# 3f-iii)
grubbs.test(GSAFdata$DaysBetween)         # Grubb's test
#cochran.test(GSAFdata$DaysBetween)
#dixon.test(GSAFdata$DaysBetween)
#days.ouliers <- removeoutliers(daysBetween, 20, 0.05) # General ESD test
#days.ouliers$outliers                                 # Display the result
#max.days <- min(days.ouliers$outliers)                # Finds the border of ouliners
#GSAFdata.inlyers <- GSAFdata[GSAFdata$DaysBetween < max.days,] # Stores the varuable inliners
GSAFdata.inlyers <- GSAFdata[GSAFdata$DaysBetween < 27,] # Stores the varuable inliners
GSAFdata.inlyers <- GSAFdata.inlyers[-1,]             # Deletes the first row (NA data)      

# 3g)
par(mfrow=c(1,2))               # Divides the screen into two sections
hist(GSAFdata.inlyers$DaysBetween,      # Shark Attack Interval Histogram
     xlab = "Shark Attack Interval (Days)",
     ylab = "Frequency",
     main = "")
# qqnorm(GSAFdata.inlyers$DaysBetween)
qqplot(GSAFdata.inlyers$DaysBetween, # Q-Q plot for Shark Attack Interval
       12*rexp(length(GSAFdata.inlyers$DaysBetween), rate = 1),
       col = "Dark Blue",
       xlab = "Days Beetween Shark Attacks",
       ylab = "Exponentioal Distribution",
       main = "")
       #main = "Q-Q Plot for Shark Attack Period Distribution")
qqline(GSAFdata.inlyers$DaysBetween, 
       distribution = qexp,
       col = "Red")
par(mfrow=c(1,1))               # Resets the screen in normal


# 3h)
par(mfrow=c(2,2))               # Divides the screen into four sections
# Builds a model according to the exponential distribution
model.fit.exp <- fitdist(GSAFdata.inlyers$DaysBetween, "exp")
cdfcomp(model.fit.exp)        # Compares the model's cfd with theoritical cfd
denscomp(model.fit.exp)       # Compares the model's density with theoritical density
qqcomp(model.fit.exp)         # Compares the model's quantiles with theoritical quantiles
ppcomp(model.fit.exp)         # Compares the model's probabilities with theoritical probabilities
gofstat(model.fit.exp)
par(mfrow=c(1,1))               # Resets the screen in normal


# 3i)
par(mfrow=c(2,2))               # Divides the screen into four sections
# Builds a model according to the exponential distribution
model.fit.pois <- fitdist(GSAFdata.inlyers$DaysBetween, "pois")
cdfcomp(model.fit.pois)        # Compares the model's cfd with theoritical cfd
denscomp(model.fit.pois)       # Compares the model's density with theoritical density
qqcomp(model.fit.pois)         # Compares the model's quantiles with theoritical quantiles
ppcomp(model.fit.pois)         # Compares the model's probabilities with theoritical probabilities
#gofstat(model.fit.pois)
gofstat(list(model.fit.pois, model.fit.exp))
par(mfrow=c(1,1))               # Resets the screen in normal


# -------------------------------- Problem 4 -------------------------------------------

# 4a)
data("freetrade")   # Load the data

missing.rate <- function(x) round(mean(is.na(x))*100, 2) # Calculates missing percentage
apply(freetrade, 2, missing.rate) # Missing percentages for all variables

missmap(freetrade)  # Explore missingness using mismap method

aggr(freetrade)     # Explore missingness using aggr method

md.pattern(freetrade)             # Investigates the missing values
md.pattern(freetrade[,c("polity", "signed", "intresmi", "fiveop", "tariff", "country")])

freetrade[is.na(freetrade$signed),] # Missing vales for signed variable

# 4b)
freetrade.country.tariff <- freetrade[,c("country","tariff")]
tarrif.NA.count <- ddply(freetrade.country.tariff,c("country"),
                         summarise, cNA=sum(is.na(tariff)))
tarrif.NA.count.table <- table(tarrif.NA.count$cNA,tarrif.NA.count$country) 
chisq.test(tarrif.NA.count.table) 
tarrif.NA.count.NoNepal <- tarrif.NA.count[(tarrif.NA.count$country!="Nepal"),] 
tarrif.NA.count.NoNepal.table <- table(tarrif.NA.count.NoNepal$cNA,
                                       tarrif.NA.count.NoNepal$country) 
chisq.test(tarrif.NA.count.NoNepal.table) 

tarrif.NA.count.NoPhilipins <- tarrif.NA.count[(tarrif.NA.count$country!="Philippines"),] 
tarrif.NA.count.NoPhilipins.table <- table(tarrif.NA.count.NoPhilipins$cNA,
                                           tarrif.NA.count.NoPhilipins$country) 
chisq.test(tarrif.NA.count.NoPhilipins.table) 


# -------------------------------- Problem 5 -------------------------------------------

# 5a)
# 5a-i)
data("mtcars")
corMat <- cor(mtcars)

# 5a-ii)
mtcars.eigen <- eigen(corMat)

# 5a-iii)
prcomp(mtcars)        # Compute the principal component of mtcars
mtcars.PC <- prcomp(mtcars, scale. = TRUE)   # Compute the principal component of mtcars

# 5a-iv)
abs(mtcars.PC$rotation) - abs(mtcars.eigen$vectors) # Compare with difference

# 5a-v)
mtcars.PC$rotation[,1] %*% mtcars.PC$rotation[,2]   # Checks orthogonality

# 5b-i)
data("heptathlon")
par(mfrow=c(2,4))               # Divides the screen into four sections
apply(heptathlon[,1:8], 2, hist)# Draws histograms
par(mfrow=c(1,1))               # Resets the screen in normal

# 5b-ii)
apply(heptathlon[,1:8], 2, grubbs.test) 
apply(heptathlon[,1:8], 2, outlier)
heptathlon[heptathlon[,1:8] == outlier(heptathlon[,1:8]),]
heptathlon["Launa (PNG)",]
heptathlon <- heptathlon[heptathlon$score != outlier(heptathlon$score),]

# 5b-iii)
heptathlon$hurdles <- max(heptathlon$hurdles) - heptathlon$hurdles
heptathlon$run200m <- max(heptathlon$run200m) - heptathlon$run200m
heptathlon$run800m <- max(heptathlon$run800m) - heptathlon$run800m

# 5b-iv)
Hpca <- prcomp(heptathlon[,1:7], scale. = TRUE)

screeplot(Hpca) #screeplot of Hpca to see which components dominate

summary(Hpca)

# 5b-v)
#biplot(Hpca)
#ggbiplot(Hpca,circle=T,obs.scale=1,varname.size=3)
#ggbiplot(Hpca,circle=T,choices=c(1,3),obs.scale=1,varname.size=3)
ggbiplot(Hpca, circle=TRUE)

# 5-vi)
plot(Hpca$x[,1],heptathlon$score,
     xlb = "PC1 Projection",
     ylab = "Score",
     col = "Red")


# 5c)
par(mfrow=c(3,1))               # Divides the screen into three sections
hw.0 <-read.csv("train.0")
hw.0.pc <-prcomp(hw.0)
hw.0.pc.summary <- summary(hw.0.pc); hw.0.pc.summary
i = 1
while (hw.0.pc.summary$importance[3,i] < 0.90) {
  i = i + 1
}
hw.0.pc.cut = i
screeplot(hw.0.pc, 
          xlab = "Principal Components",
          main = paste ("Screen plot - digit '0'- ", 
                        hw.0.pc.cut,"PCs Cover 90% of Cumullative Variation"),
          npcs = hw.0.pc.cut)


hw.5 <-read.csv("train.5")
hw.5.pc <-prcomp(hw.5)
hw.5.pc.summary <- summary(hw.5.pc); hw.5.pc.summary
i = 1
while (hw.5.pc.summary$importance[3,i] < 0.90) {
  i = i + 1
}
hw.5.pc.cut = i
screeplot(hw.0.pc, 
          xlab = "Principal Components",
          main = paste ("Screen plot - digit '5'- ", 
                        hw.5.pc.cut,"PCs Cover 90% of Cumullative Variation"),
          npcs = hw.5.pc.cut)

hw.7 <-read.csv("train.7")
hw.7.pc <-prcomp(hw.7)
hw.7.pc.summary <- summary(hw.7.pc); hw.0.pc.summary
i = 1
while (hw.7.pc.summary$importance[3,i] < 0.90) {
  i = i + 1
}
hw.7.pc.cut = i
screeplot(hw.0.pc, 
          xlab = "Principal Components",
          main = paste ("Screen plot - digit '7'- ", 
                        hw.7.pc.cut,"PCs Cover 90% of Cumullative Variation"),
          npcs = hw.7.pc.cut)

par(mfrow=c(1,1))               # Resets the screen in normal


# -------------------------------- Problem 6 -------------------------------------------


URL = "https://www.kaggle.com/c/leaf-classification/download/train.csv.zip"
web.URL = "https://www.kaggle.com/c/leaf-classification"
#fread(URL)
#temp <- tempfile()
#download.file(URL, temp)
#sequence.learning <- read.table(unz(temp, "a1.dat"))
#unlink(temp)

leaf <- read.csv("Leaf Classification.csv")
summary(leaf)
head(leaf)
leaf.missing <- sum(is.na(leaf))
leaf[is.na(leaf)]

leaf.margin <- leaf[,c(1, 2, 3:66)]
leaf.margin.pc = prcomp(leaf.margin[,3:ncol(leaf.margin)])
summary(leaf.margin.pc) # 8

leaf.shape <- leaf[,c(1, 2, 67:130)]
leaf.shape.pc = prcomp(leaf.shape[,3:ncol(leaf.shape)])
summary(leaf.shape.pc) # 2

leaf.texture <- leaf[,c(1, 2, 131:194)]
leaf.texture.pc = prcomp(leaf.texture[,3:ncol(leaf.texture)])
summary(leaf.texture.pc) # 13

screeplot(leaf.margin.pc)
screeplot(leaf.texture.pc)
screeplot(leaf.shape.pc)

ggbiplot(leaf.shape.pc, circle = T)
ggbiplot(leaf.margin.pc, circle = T)
ggbiplot(leaf.texture.pc, circle = T)


