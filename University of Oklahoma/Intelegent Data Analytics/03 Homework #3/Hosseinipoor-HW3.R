
# Assignment #3


# --------------------------------------- Libraries -------------------------------------

library(mlbench)
library(VIM)
library(ggplot2)
library(GGally)
library(robustbase)

library(reshape2)
library(Amelia)
library(lattice)    
library("car")        #<-- used to get Prestige dataset; and 'symbox' function
library("EnvStats")   #<-- used to get "boxcox" function

library(ggbiplot)
library(MASS)

library(mice)

# --------------------------------------- Problem #1 -------------------------------------
# --------------------------------------- Problem #1 -------------------------------------
# --------------------------------------- Problem #1 -------------------------------------

data(Glass)       # Load data from the package "mlbench"

# 1a)  ----------------------------------------------------------------------------------

str(Glass)        # Take a look at data structure
summary(Glass)
plot(Glass)       # Full data plot
plot(Glass[,1:9], col = Glass$Type)
pairs(Glass[1:9], main = "Glass Data Visualization", pch=21, bg = Glass$Type )

# Histogram - together
par(mfrow=c(3,3))               # Divides the screen into three sections
apply(Glass[,1:9], 2, hist)
par(mfrow=c(1,1))               # Reset display

# Histogram - separated
par(mfrow=c(3,3))               # Divides the screen into three sections
hist(Glass$RI, main="Refractive Index", xlab="Refractive Index")
hist(Glass$Na, main="Sodium", xlab="Sodium Percentage")
hist(Glass$Mg, main="Magnesium", xlab="Magnesium Percentage")
hist(Glass$Al, main="Aluminum", xlab="Aluminum Percentage")
hist(Glass$Si, main="Silicon", xlab="Silicon Percentage")
hist(Glass$K,  main="Potassium", xlab="Potassium Percentage")
hist(Glass$Ca, main="Calcium", xlab="Calcium Percentage")
hist(Glass$Ba, main="Barium", xlab="Barium Percentage")
hist(Glass$Fe, main="Iron", xlab="Iron Percentage")
par(mfrow=c(1,1))               # Reset display

# Test skeness
apply(Glass[,1:9], 2, skewness)

# Check the correlations
cor(Glass[,1:9],method = "kendall")
cor(Glass[,1:9],method = "pearson")
cor(Glass[,1:9],method = "spearman")


# Boxplots
par(mfrow=c(3,3))               # Divides the screen into three sections
boxplot(data=Glass, RI ~ Type, xlab = "Type", ylab = "RI")
boxplot(data=Glass, Na ~ Type, xlab = "Type", ylab = "Na")
boxplot(data=Glass, Mg ~ Type, xlab = "Type", ylab = "Mg")
boxplot(data=Glass, Al ~ Type, xlab = "Type", ylab = "Al")
boxplot(data=Glass, Si ~ Type, xlab = "Type", ylab = "Si")
boxplot(data=Glass, K ~ Type, xlab = "Type", ylab = "K")
boxplot(data=Glass, Ca ~ Type, xlab = "Type", ylab = "Ca")
boxplot(data=Glass, Ba ~ Type, xlab = "Type", ylab = "Ba")
boxplot(data=Glass, Fe ~ Type, xlab = "Type", ylab = "Fe")
par(mfrow=c(1,1))               # Reset display


Ion = c("RI", "Na", "Mg", "Al", "Si", "K", "Ca", "Ba", "Fe")    # Ion vector
par(mfrow=c(3,6))
for (i in Ion){
  adjbox(data=Glass, RI ~ Type, xlab="Type", ylab=i, main="Adjusted")
  boxplot(data=Glass, RI ~ Type, xlab="Type", ylab=i, main="Normal")
}
par(mfrow=c(1,1))               # Reset display

par(mfrow=c(3,3))
for (i in Ion){
  adjbox(data=Glass, RI ~ Type, xlab="Type", ylab=i, main="Adjusted")
  #boxplot(data=Glass, RI ~ Type, xlab="Type", ylab=i, main="Normal")
}
par(mfrow=c(1,1))               # Reset display


scattmatrixMiss(Glass[,1:9])    # Breif view for binary scatter
heatmap(cor(Glass[,1:9]))       # Check the correlations between variables

ggplot(data=Glass, aes(x=Ca,y=RI))+ geom_point(aes(fill=Type), alpha=I(.75), colour="black", pch=21, size=5)+
  theme_bw()+ labs(y="y", x="x") + theme(legend.key=element_blank(), axis.title = element_text(size = 14))


ggplot(data=Glass, aes(x=RI,y=Si))+ geom_point(aes(fill=Type), alpha=I(.75), colour="black", pch=21, size=5)+
  theme_bw()+ labs(y="y", x="x") + theme(legend.key=element_blank(), axis.title = element_text(size = 14))

ggplot(data=Glass, aes(x=Na,y=Ca))+ geom_point(aes(fill=Type), alpha=I(.75), colour="black", pch=21, size=5)+
  theme_bw()+ labs(y="y", x="x") + theme(legend.key=element_blank(), axis.title = element_text(size = 14))


Glass2 <- melt(Glass)

# Checking the density function for different ions
#identify data and set the aesthetics 
#Ion = c("RI", "Na", "Mg", "Al", "Si", "K", "Ca", "Ba", "Fe")    # Ion vector
for (i in Ion) {
  print(ggplot(Glass2[Glass2$variable == i,], aes(x=value, fill=Type)) +
    geom_density(alpha=0.45) +        #set geometry and transparency    
    labs(x = "Ion Concentration",          #set x-label and title
         title = paste ("Densities for", i, "of Glass Types")))
}

# ggpairs(Glass[, 1:9], lower=list(continuous="smooth", params=c(colour="blue")),
#         diag=list(params=c(colour="blue")), 
#         upper=list(params=list(corSize=6)), axisLabels='show')


# Caution: this part of code is slow
ggpairs(Glass, lower=list(continuous="smooth"),axisLabels='show')
ggpairs(Glass[, 1:9], lower=list(continuous="smooth"),axisLabels='show')
ggpairs(Glass2, lower=list(continuous="smooth"),axisLabels='show')


#we can also use gplot to produce more advanced boxplots
ggplot(Glass2,aes(x=variable, y=value, fill=Type)) + geom_boxplot()


#parallelplot help documentation -- the input is unfortunately a little different with the ~ symbol
parallelplot(~Glass[1:9] | Type, data = Glass,             
             groups = Type,   
             horizontal.axis = FALSE, 
             scales = list(x = list(rot = 90)))            



par(mfrow=c(3,3))               # Divides the screen into three sections
for (i in 1:9) {
  boxplot(Glass[,1:9]|Glass$Type==i)
}
par(mfrow=c(1,1))               # Reset display


# 1b)  ----------------------------------------------------------------------------------

par(mfrow=c(3,3))               # Divides the screen into three sections
for (i in 1:9) {
  #and look at symbox output
  symbox(Glass[,i]+1e-12, 
         powers=c(3,2,1,0,-0.5,-1,-2),
         ylab = Ion[i])
}
par(mfrow=c(1,1))               # Reset display


logGlass = log(Glass[,1:9]+1e-12)
logGlass$Type = Glass$Type
par(mfrow=c(3,3))               # Divides the screen into three sections
apply(logGlass[,1:9], 2, hist)
par(mfrow=c(1,1))               # Reset display

ggplot(data=Glass, aes(x=RI,y=Si))+ geom_point(aes(fill=Type), alpha=I(.75), colour="black", pch=21, size=5)+
  theme_bw()+ labs(y="y", x="x") + theme(legend.key=element_blank(), axis.title = element_text(size = 14))

ggplot(data=Glass, aes(x=Na,y=Ca))+ geom_point(aes(fill=Type), alpha=I(.75), colour="black", pch=21, size=5)+
  theme_bw()+ labs(y="y", x="x") + theme(legend.key=element_blank(), axis.title = element_text(size = 14))


# melt the variable
logGlass2 = melt(logGlass)
#Ion2 = c("RI", "Na", "Mg", "Al", "Si", "K", "Ca", "Ba", "Fe")
for (i in Ion) {
  print(ggplot(logGlass2[logGlass2$variable == i,], aes(x=value, fill=Type)) +
          geom_density(alpha=0.45) +        #set geometry and transparency    
          labs(x = "Ion Concentration",          #set x-label and title
               title = paste ("Densities for", i, "Ions of Glass Types")))
}


# can use boxcox to search for the optimal lambda value
lambda.opt <- rep(1, 9)
names(lambda.opt) <- names(Glass[,1:9])
for (i in 2:9) {
  a <- EnvStats::boxcox(Glass[,i]+1e-27, optimize = TRUE, lambda=c(-10,10))    # if optimize = TRUE, then you must tell the function the 
  # the search range, e.g. search on the interval (-10,10)
  lambda.opt[i] <- a$lambda
}
lambda.opt
Ion

par(mfrow=c(3,3))               # Divides the screen into three sections
apply(Glass3,2,hist)
par(mfrow=c(1,1))               # Reset display


# 1c)  ----------------------------------------------------------------------------------

Glass.PCA<-prcomp(Glass[,1:9],scale=TRUE)
Glass.PCA

plot(Glass.PCA)
summary(Glass.PCA)
ggbiplot(Glass.PCA,obs.scale = 1, var.scale = 1, circle = TRUE, choices = c(1,2))
ggbiplot(Glass.PCA,obs.scale = 1, var.scale = 1, circle = TRUE, choices = c(1,3))
ggbiplot(Glass.PCA,obs.scale = 1, var.scale = 1, circle = TRUE, choices = c(1,4))
ggbiplot(Glass.PCA,obs.scale = 1, var.scale = 1, circle = TRUE, choices = c(1,5))
ggbiplot(Glass.PCA,obs.scale = 1, var.scale = 1, circle = TRUE, choices = c(2,3))

# 1d)  ----------------------------------------------------------------------------------

fit.LDA <- lda(formula = Type ~ ., data = Glass)   # The function lda on the Glass types
fit.LDA
fit.predict <- predict(fit.LDA, newdata=Glass[,1:9])$class
table(fit.predict, Glass[,10])

# --------------------------------------- Problem #2 -------------------------------------
# --------------------------------------- Problem #2 -------------------------------------
# --------------------------------------- Problem #2 -------------------------------------

data(freetrade)   # Load data from the package "Amelia"

summary(freetrade)
str(freetrade)
head(freetrade)

#convert data to proper formats
freetrade$year <- as.numeric(freetrade$year)        # Converting to number
freetrade$country <- as.factor(freetrade$country)   # Converting to factor
freetrade$polity <- as.numeric(freetrade$polity)    # Converting to number
freetrade$signed <- as.numeric(freetrade$signed)    # Converting to number
str(freetrade)   # structure of converted freetrade data

# 2a)  ----------------------------------------------------------------------------------

freetrade.LD <- na.omit(freetrade)  #listwise deletion
freetrade.LD.fit <- lm(data = freetrade.LD,
                   tariff~year+country+polity+pop+gdp.pc+intresmi+signed+fiveop+usheg) #Linear regression

summary(freetrade.LD.fit)
sf.a <- summary(freetrade.LD.fit)
coef.a <- sf.a[[4]]
se.a <- sf.a[[6]]

# 2b)  ----------------------------------------------------------------------------------

freetrade.mimp <- freetrade
freetrade.mimp[is.na(freetrade.mimp$tariff), "tariff"] <- mean(freetrade.mimp$tariff,na.rm=T)
freetrade.mimp[is.na(freetrade.mimp$polity), "polity"] <- mean(freetrade.mimp$polity,na.rm=T)
freetrade.mimp[is.na(freetrade.mimp$intresmi), "intresmi"] <- mean(freetrade.mimp$intresmi,na.rm=T)
freetrade.mimp[is.na(freetrade.mimp$signed), "signed"] <- mean(freetrade.mimp$signed,na.rm=T)
freetrade.mimp[is.na(freetrade.mimp$fiveop), "fiveop"] <- mean(freetrade.mimp$fiveop,na.rm=T)

freetrade.mimp.fit <- lm(data=freetrade.mimp, 
                         tariff ~ year + country + polity + pop + gdp.pc + intresmi + signed + fiveop + usheg)
summary(freetrade.mimp.fit)
sf.b <- summary(freetrade.mimp.fit)
coef.b <- sf.b[[4]]
se.b <- sf.b[[6]]



# 2c)  ----------------------------------------------------------------------------------

freetrade.MI <- mice(freetrade, m=5, maxit=10, method="mean")
freetrade.MI <- mice(freetrade, m=5, maxit=10, method="rf")
freetrade.MI <- mice(freetrade, m=5, maxit=10, method="sample")
freetrade.MI <- mice(freetrade, m=5, maxit=10, method="cart")
freetrade.MI.copmlete <-complete(freetrade.MI, "long")   #Complete Imputed data

str(freetrade.MI)
str(freetrade.MI.copmlete)

freetrade.MI$chainMean
freetrade.MI$chainVar

plot(freetrade.MI)
freetrade.MI.fit <- with(freetrade.MI, 
                         lm(tariff ~ year + country + polity + 
                              pop + gdp.pc + intresmi + signed + fiveop + usheg))

summary(pool(freetrade.MI.fit))
sf.c <- summary(freetrade.MI.fit)
coef.c <- sf.c[[4]]
se.c <- sf.c[[6]]


# 2d)  ----------------------------------------------------------------------------------

predictorMatrix<-freetrade.MI$predictorMatrix #Extract matrix from earlier
predictorMatrix[,5] <- 0

# single imputation on different variables with different methods
freetrade$polity <- as.factor(freetrade$polity)    # Converting to factor
freetrade$signed <- as.factor(freetrade$signed)    # Converting to factor
freetrade.SI <- mice(freetrade, method=c("","","norm","polr","","","norm","logreg","norm",""),
                     predictorMatrix = predictorMatrix) 
freetrade.SI.fit <- with(freetrade.SI,
                         lm(tariff~year+country+polity+pop+gdp.pc+intresmi+signed+fiveop+usheg)) # fit single imputation

summary(freetrade.SI.fit)
sf.d <- summary(freetrade.SI.fit)
coef.d <- sf.d[[4]]
se.d <- sf.d[[6]]

coeficient <- data.frame(coef.a[,1], coef.b[,1])
coeficient


# 2e)  ----------------------------------------------------------------------------------

summary(freetrade.LD.fit)
summary(freetrade.mimp.fit)
summary(pool(freetrade.MI.fit))
summary(pool(freetrade.SI.fit))



# --------------------------------------- Problem #3 -------------------------------------
# --------------------------------------- Problem #3 -------------------------------------
# --------------------------------------- Problem #3 -------------------------------------

Sensor.Data <- read.csv(file="bridgeSensor.csv", head=TRUE, sep=",")  # Load data from csv file

#helper function to plot the frequency spectrum based 
plot.frequency.spectrum <- function(X.k, xlimits=c(0,length(X.k)/2)) {
  plot.data  <- cbind(0:(length(X.k)-1), Mod(X.k))
  
  plot(plot.data, t="h", lwd=2, main="", 
       xlab="Frequency (Hz)", ylab="Strength", 
       xlim=xlimits, ylim=c(0,max(Mod(plot.data[,2]))))
}

# 3a)  ----------------------------------------------------------------------------------

Sensor11 <- Sensor.Data[1:801,c(1,2)]
Sensor12 <- Sensor.Data[802:length(Sensor.Data$Time),c(1,2)]
Sensor21 <- Sensor.Data[1:801,c(1,3)]
Sensor22 <- Sensor.Data[802:length(Sensor.Data$Time),c(1,3)]

S11 <- fft(Sensor11$Sensor1)
S12 <- fft(Sensor12$Sensor1)
S21 <- fft(Sensor21$Sensor2)
S22 <- fft(Sensor22$Sensor2)

par(mfrow=c(2,2))
PS11  <- cbind(0:(length(S11)-1), Mod(S11))
plot(PS11, t="h", lwd=2, main="Sensor=1 / Truck=1", xlab="Frequency (Hz)", ylab="Strength",
     xlim=c(0,length(S11)/2), ylim=c(0,max(Mod(PS11[,2]))))

PS12  <- cbind(0:(length(S12)-1), Mod(S12))
plot(PS12, t="h", lwd=2, main="Sensor=1 / Truck=2", xlab="Frequency (Hz)", ylab="Strength",
     xlim=c(0,length(S12)/2), ylim=c(0,max(Mod(PS12[,2]))))

PS21  <- cbind(0:(length(S21)-1), Mod(S21))
plot(PS21, t="h", lwd=2, main="Sensor=2 / Truck=1", xlab="Frequency (Hz)", ylab="Strength",
     xlim=c(0,length(S21)/2), ylim=c(0,max(Mod(PS21[,2]))))

PS22  <- cbind(0:(length(S22)-1), Mod(S22))
plot(PS22, t="h", lwd=2, main="Sensor=2 / Truck=2", xlab="Frequency (Hz)", ylab="Strength",
     xlim=c(0,length(S22)/2), ylim=c(0,max(Mod(PS22[,2]))))
par(mfrow=c(1,1))


sens1fft<-fft(Sensor.Data$Sensor1)
sens2fft<-fft(Sensor.Data$Sensor2)

#plot signal 1 and signal 2
plot(Sensor.Data$Time, Sensor.Data$Sensor1, type = "l",main="Sensor 1 Wave", col=2); abline(h=0)
plot(Sensor.Data$Time, Sensor.Data$Sensor2, type = "l",main="Sensor 2 Wave", col=3); abline(h=0)

#plot fourier transform for frquency spectrum
plot.frequency.spectrum(sens1fft)
plot.frequency.spectrum(sens2fft)



# 3b)  ----------------------------------------------------------------------------------

#1.
#Sensor 1 / Truck 1
max(abs(Sensor11$Sensor1))
#Sensor 1 / Truck 2
max(abs(Sensor12$Sensor1))
#Sensor 2 / Truck 1
max(abs(Sensor21$Sensor2))
#Sensor 2 / Truck 2
max(abs(Sensor22$Sensor2))

#from the maximum absolute value above it can be understand that the Truck 1 has less weight than Truck 2

#2.
#Sensor 1 / Truck 1
max(PS11[,2])
#Sensor 1 / Truck 2
max(PS12[,2])
#Sensor 2 / Truck 1
max(PS21[,2])
#Sensor 2 / Truck 2
max(PS22[,2])

#Using the maximum value of the furior the same result can be drawn which Truck 1 is heavier than Trcuk 2.

#3.
#Sensor 1 / Truck 1
which.max(PS11[1:(length(PS11[,2])/2),2])
#Sensor 1 / Truck 2
which.max(PS12[1:(length(PS12[,2])/2),2])
#Sensor 2 / Truck 1
which.max(PS21[1:(length(PS21[,2])/2),2])
#Sensor 2 / Truck 2
which.max(PS22[1:(length(PS22[,2])/2),2])

#4.
Sensor.Data$strength1 <- Mod(sens1fft) #strength1 for sensor 1
Sensor.Data$strength2 <- Mod(sens2fft) #strength2 for sensor 2
Sensor.Data$ang1 <- Arg(sens1fft) #fft angle for sensor 1
Sensor.Data$ang2 <- Arg(sens2fft) #fft angle for sensor 2
#interaction between strength and frequency
Sensor.Data$str.fre1 <- (Sensor.Data$Time-Sensor.Data$Time[1])*Sensor.Data$strength1*100
Sensor.Data$str.fre2 <- (Sensor.Data$Time-Sensor.Data$Time[1])*Sensor.Data$strength2*100
head(Sensor.Data,7)

