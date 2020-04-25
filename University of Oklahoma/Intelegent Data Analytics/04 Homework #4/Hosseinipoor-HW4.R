
# -----------------------------------------------------------------------------------------------------
# This R script is created for homework in Intelligent Data Analysis course by
# Saeid Hosseinipoor on Oct. 26, 2016.
# -----------------------------------------------------------------------------------------------------

# Libraries
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

library(jpeg)
library(ggplot2) #to make pretty plots
library(caret)
library(car)
library(MASS)
library(hydroGOF)
library(pls)
library(lars)
library(polycor)
library(glmnet)
library(Matrix)
library(foreach)

# Functions
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------



#a function to use ggplot2 to create scree plots
ggscreeplot <- function(pcobj, k=10, type = c('pev', 'cev')) 
{
  type <- match.arg(type)
  d <- pcobj$sdev^2
  yvar <- switch(type, 
                 pev = d / sum(d), 
                 cev = cumsum(d) / sum(d))
  
  yvar.lab <- switch(type,
                     pev = 'proportion of explained variance',
                     cev = 'cumulative proportion of explained variance')
  
  df <- data.frame(PC = 1:length(d), yvar = yvar)
  
  ggplot(data = df[1:k,], aes(x = PC, y = yvar)) + 
    xlab('principal component number') + ylab(yvar.lab) +
    geom_bar(stat="identity",alpha=0.4,fill="blue",color="grey") + geom_line()
}


# Problem 1
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

# Fetch data from csv files
classDigits = read.csv("classDigits.csv", header = T)
class7Test = read.csv("class7Test.csv", header = T)

# Shows the image
a = data.matrix(classDigits[3,2:785])
a = matrix(a, nrow = 28, ncol=28, byrow = T)
image(a, col = grey(seq(0, 1, length = 256)))
classDigits[3,1]

b = data.matrix(classDigits[2,2:785])
b = matrix(b, nrow = 28, ncol=28, byrow = T)
image(b, col = grey(seq(0, 1, length = 256)))
classDigits[2,1]


# Problem 1a)
# -----------------------------------------------------------------------------------------------------

digits.data = as.matrix(classDigits[,2:785])           # Copies the pixel data in a matrix
digits.PCA = prcomp(digits.data)                       # Runs PC Analusis and stores the results
digits.Eigen.Vector = as.matrix(digits.PCA$rotation)   # Stores the eigen vectors in a separated variable
digits.Eigen.Vector[1:5, 1:5]                          # Shows a small part of the eigen vectors

# Problem 1b)
# -----------------------------------------------------------------------------------------------------

digits.mean = as.matrix(digits.PCA$center)             # Store mean value of digit space
#digits.mean.matrix = data.matrix(digits.mean)
digits.mean.matrix = 
  matrix(digits.mean, nrow = 28, ncol=28, byrow = T)   # Makes a 28x28 matrix to show the picture
image(digits.mean.matrix, 
      col = grey(seq(0, 1, length = 256)))             # Shows the gray scale image of the mean digit
writeJPEG(digits.mean.matrix, 
          target = "meanDigit.jpg")                    # Saves the mean digits as a jpeg file


# I prefer this method to save a pretty and high quality mean digit
jpeg("meanDigit2.jpg", 
     width = 2800, height = 2800, res = 600)           # Open a new jpeg file as an putput
image(digits.mean.matrix, 
      col = grey(seq(0, 1, length = 256)))             # Writes the mean digit in new output
dev.off()                                              # Closes the jpeg file as an output


# Problem 1c)
# -----------------------------------------------------------------------------------------------------

# This loop reconstruct the images #15 and #100 with lower dimensions and saves them in the separated
# jpeg files. 
X.mean = t(digits.mean)
for (img in c(15, 100)){                                      # Outer loop for images
  for (k in c(5, 20, 100)){                                   # Inner loop for dimensions
    X = digits.data[img,]                                     # Pick the image data
    E = digits.Eigen.Vector[,1:k]                             # Pick the eigen vectors
    weight = digits.PCA$x[img, 1:k]                           # Calulate the weight values
    new.image = X.mean + weight %*% t(E)                      # Reconstruct the image
    new.image = matrix(new.image, 
                       nrow = 28, ncol=28, byrow = T)         # Converts data into a matrix to show
    image.name = 
      do.call("paste0", list("image", img, "-", k, ".jpg"))   # Make proper file name
    jpeg(image.name, width = 2800, height = 2800, res = 600)  # Open a jpeg output
    image(new.image, col = grey(seq(0, 1, length = 256)))     # Write the image into a jpeg output
    dev.off()                                                 # Save the jpeg file
  }
}


# Problem 1d)
# -----------------------------------------------------------------------------------------------------

# Investigation of the minumum number of the dimensions
print(ggscreeplot(digits.PCA, k = 200))
print(ggscreeplot(digits.PCA, k = 100))
s = summary(digits.PCA)$importance[3,]
names(s[s>.8][1])
names(s[s>.85][1])
names(s[s>.9][1])


k = 87                                                             # Choose a k from above (I chose from 90%)
X = as.matrix(class7Test[,3:786])                                  # Rest Data set
E = digits.Eigen.Vector[,1:k]                                      # Eigen vectors
X.mean = matrix(rep(digits.mean, 7), 
                nrow = 7, ncol = 784, byrow = T)                   # Mean digit from digit space
X.diff = X - X.mean                                                # Deviation form mean digit
test.projection = X.diff %*% E                                     # Map test data into new space
training.projection = digits.PCA$x[ ,1:k]                          # Map training data into the new sapce
projection.corr = cov(training.projection)                         # Calculates the covariance

mahala.mean = rep(0,7)                                             # Empty matrix
for(i in 1:7){
  mahala.mean[i] = mean(mahalanobis(                               # Calculates the mean values for distances
    training.projection, test.projection[i,], projection.corr))    # Calculates the mah. distances
}
mahala.mean                                                        # Displays the results


# Problem 1e)
# -----------------------------------------------------------------------------------------------------


for (img in 4:6){
  k = 1
  repeat {
    X = as.matrix(class7Test[,3:786])
    E = digits.Eigen.Vector[,1:k]
    X.mean = matrix(rep(t(as.matrix(digits.mean)), 7), 
                    nrow = 7, ncol = 784, byrow = T)
    X.diff = X - X.mean
    test.projection = X.diff %*% E
    training.projection = as.matrix(digits.PCA$x[ ,1:k] )
    projection.corr = cov(training.projection)
    
    a = which.min(mahalanobis(
      training.projection, test.projection[img,], projection.corr))
    predict.lable = classDigits[a, 1]
    test.lable = class7Test[img, 2]
    
    if (predict.lable == test.lable || k > 784) break
    k = k + 1
  }
  print (k)
}




# Problem 2
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------

housingData = read.csv("housingData.csv", header = T)
housingTest = read.csv("housingTest.csv", header = T)

str(housingData)

housingData.clean = housingData
#relevel(housingData.clean$Alley, "0")
#housingData.clean$Alley [is.na(housingData.clean$Alley)] = 0
housingData.missing = rep(0, length(housingData))
for (i in 1:length(housingData)){
  housingData.missing[i] = sum(is.na(housingData[,i]))
}
housingData.missing
which(housingData.missing > 0)
which(housingData.missing > 100)
names(housingData[which(housingData.missing > 100)])

housingData[,names(housingData[which(housingData.missing > 100)])]

housingData.clean = housingData[,-c(1, 2, 5, 7, 55, 68, 69, 70)]
housingData.clean$LogSalePrice = log(housingData.clean$SalePrice)
housingData.clean$SalePrice = NULL

# This part is optional
#housingData.clean$Alley = as.factor(housingData.clean$Alley)
#housingData.clean$MSSubClass = as.factor(housingData.clean$MSSubClass)
#housingData.clean$OverallQual = as.factor(housingData.clean$OverallQual)
#housingData.clean$OverallCond = as.factor(housingData.clean$OverallCond)
#housingData.clean$BsmtFullBath = as.factor(housingData.clean$BsmtFullBath)
#housingData.clean$BsmtHalfBath = as.factor(housingData.clean$BsmtHalfBath)
#housingData.clean$FullBath = as.factor(housingData.clean$FullBath)
#housingData.clean$HalfBath = as.factor(housingData.clean$HalfBath)
#housingData.clean$BedroomAbvGr = as.factor(housingData.clean$BedroomAbvGr)
#housingData.clean$KitchenAbvGr = as.factor(housingData.clean$KitchenAbvGr)
#housingData.clean$TotRmsAbvGrd = as.factor(housingData.clean$TotRmsAbvGrd)
#housingData.clean$Fireplaces = as.factor(housingData.clean$Fireplaces)
#housingData.clean$GarageCars = as.factor(housingData.clean$GarageCars)
#housingData.clean$MoSold = as.factor(housingData.clean$MoSold)
#housingData.clean$YrSold = as.factor(housingData.clean$YrSold)
#housingData.clean$MasVnrArea = as.factor(housingData.clean$MasVnrArea)


str(housingData.clean)
plot(LogSalePrice~., data = housingData.clean)


housingData.model = housingData.clean

housingData.model$LotShape = NULL
housingData.model$LandContour = NULL
housingData.model$LotConfig = NULL
housingData.model$BldgType = NULL
housingData.model$HouseStyle = NULL
housingData.model$RoofStyle = NULL
housingData.model$Exterior1st = NULL
housingData.model$Exterior2nd = NULL
housingData.model$MasVnrType = NULL
housingData.model$BsmtCond = NULL
housingData.model$BsmtExposure = NULL
housingData.model$BsmtType = NULL
housingData.model$BsmtFinType2 = NULL
housingData.model$Heating = NULL
housingData.model$HeatingQC = NULL
housingData.model$LowQualFinSF = NULL
housingData.model$BsmtHalfBath = NULL
housingData.model$HalfBath = NULL
housingData.model$BedroomAbvGr = NULL
housingData.model$Functional = NULL
housingData.model$GarageType = NULL
housingData.model$GarageCond = NULL
housingData.model$PoolArea = NULL
housingData.model$MiscVal = NULL
housingData.model$MoSold = NULL
housingData.model$YrSold = NULL
housingData.model$MasVnrArea = NULL

#separates numeric variables and factor variables

attach(housingData.model)
numerics = sapply(housingData.model, is.numeric)
housingData.model.numerics = housingData.model[,numerics]                             #numeric values and logSalePrice
str(housingData.model.numerics)

factors = sapply(housingData.model, is.factor)
housingData.model.factors = housingData.model[,factors]
housingData.model.factors = cbind(housingData.model.factors, housingData.model$LogSalePrice)                       #factor values and logSalePrice
str(housingData.model.factors)

#Visualizes and examines the important numeric variables to logSalePrice
numericsCor = cor(housingData.model.numerics)                                   #calculates the correlation
corrplot(numericsCor, method = "circle")                          #finds out the most relavant variables to SalePrice
head(numericsCor)
#heatmap(numericsCor)

a = hetcor(housingData.clean)
aheatmap(a)

pairs(housingData.model)

fitHousing = lm(LogSalePrice ~ . -TotalBsmtSF, data = housingData.model)
summary(fitHousing)
AIC(fitHousing)
vif(fitHousing)
mean(vif(fitHousing))

str(housingData.model)
plot(LogSalePrice~., data = housingData.model)

housingData.model$GarageQual = NULL
housingData.model$PavedDrive = NULL
housingData.model$TotRmsAbvGrd = NULL
housingData.model$ExterQual = NULL
housingData.model$ExterCond = NULL
housingData.model$GarageFinish = NULL
housingData.model$GarageYrBlt = NULL
housingData.model$BsmtFinType1 = NULL
housingData.model$BsmtQual = NULL
housingData.model$Foundation = NULL
housingData.model$TotalBsmtSF = NULL
housingData.model$MSZoning = NULL

fitHousing = lm(LogSalePrice ~ . , data = housingData.model)
summary(fitHousing)
AIC(fitHousing)
BIC(fitHousing)
vif(fitHousing)
mean(vif(fitHousing))
anova(fitHousing)
plot(fitHousing)
ncvTest(fitHousing)
defaultSummary(data.frame(obs=housingData.clean$LogSalePrice,pred=predict(fitHousing, housingData.clean)))

fitHousing2 = lm(LogSalePrice ~ . -Neighborhood , data = housingData.model)
summary(fitHousing2)
AIC(fitHousing2)
BIC(fitHousing2)
vif(fitHousing2)
mean(vif(fitHousing2))
anova(fitHousing2)
ncvTest(fitHousing2)
plot(fitHousing2)

str(housingData.model)

plot(LogSalePrice~., data = housingData.model)
plot(fitHousing)
housingData.model[c("124","909","402"),]


predict(fitHousing2, housingData.clean) 
rmse(predict(fitHousing, housingData.clean), housingData.clean$LogSalePrice)
rmse(predict(fitHousing2, housingData.clean), housingData.clean$LogSalePrice)

sqrt(sum(fitHousing$residuals^2) / fitHousing$df.residual)

fitHousing.step = stepAIC(fitHousing, direction = "both", trace = FALSE)
summary(fitHousing.step)
AIC(fitHousing.step)
BIC(fitHousing.step)
vif(fitHousing.step)
mean(vif(fitHousing.step))
anova(fitHousing.step)
ncvTest(fitHousing.step)
plot(fitHousing.step)


# Problem 2b)
# -----------------------------------------------------------------------------------------------------

housingData.model.b = housingData.model[101:1000,]
fitHousing.b = lm(LogSalePrice ~ ., data = housingData.model.b)
summary(fitHousing.b)
AIC(fitHousing.b)
BIC(fitHousing.b)
vif(fitHousing.b)
mean(vif(fitHousing.b))
anova(fitHousing.b)
plot(fitHousing.b)
ncvTest(fitHousing.b)
fitHousing.b$xlevels [["OverallCond"]] = union(levels(housingData.model$OverallCond), 
                                               fitHousing.b$xlevels [["OverallCond"]])
predict.b = predict(fitHousing.b, housingData.model[1:100,])
defaultSummary(data.frame(obs=housingData.clean$LogSalePrice[1:100], pred = predict.b))



# Problem 2c)
# -----------------------------------------------------------------------------------------------------

housingData.model.c = housingData.clean
pls.fit <- plsr(LogSalePrice~., data=housingData.model.c, validation="CV")

pls.pred <- predict(pls.fit, housingData.model.c[1:5,],ncomp=1:2)
pls.pred

summary(pls.fit)
pls.CVRMSE <- RMSEP(pls.fit, validation = "CV")
str(pls.CVRMSE)
plot(pls.CVRMSE)
(min<-which.min(pls.CVRMSE$val[1,1,]))
points(min-1,pls.CVRMSE$val[1,1,min],col="red",cex=1.5, lwd=2)

pls.pred <- predict(pls.fit, housingData.model.c,ncomp=1:24)
residual.c = pls.pred - housingData.model.c$LogSalePrice


# Problem 2d)
# -----------------------------------------------------------------------------------------------------

housingData.model.d = housingData.clean
lasso.ctrl = trainControl(method="cv", number=5)                     
lasso.model = train(LogSalePrice ~., 
                    data = housingData.model.d, na.action = na.exclude,      
                    trControl=lasso.ctrl, method="glmnet")               
plot(lasso.model)

lasso.model$bestTune
lasso.model$resample$RMSE
lasso.model$resample$Rsquared
lasso.model$results
str(lasso.model)

lasso.coef = coef(lasso.model$finalModel, lasso.model$bestTune$lambda)



# Problem 2d)
# -----------------------------------------------------------------------------------------------------


housingData.test = read.csv("housingTest.csv", header = TRUE)     
housingData.test = housingData.test[,c(-1,-2)]                              

pred.e = predict(fitHousing, housingData.test)
SalesPrice = exp(pred.e)
SalesPrice

