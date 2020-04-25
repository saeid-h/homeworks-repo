
# This script was crested by Saeid Hosseinipoor for 
# homework #5 of course Intelegent Data Analysis

# ------------------------------------------- Libraries ----------------------------------------------- 
# ------------------------------------------- Libraries ----------------------------------------------- 
# ------------------------------------------- Libraries ----------------------------------------------- 

library(mlbench)
library(caret)
library(ROCR)
library(Hmisc)
library(sm)
install.packages("InformationValue")
library(InformationValue)
library(car)
library(MASS)
library(VIM)
library(rpart)
library(partykit)      # to print trees using "party"
library(rattle)
library(randomForest)   #for Random Forests
library(adabag)         #for boosting
library(e1071)
install.packages('neuralnet')
library("neuralnet")


# ------------------------------------------- Functions ----------------------------------------------- 
# ------------------------------------------- Functions ----------------------------------------------- 
# ------------------------------------------- Functions ----------------------------------------------- 




# ------------------------------------------- Problem #1 ---------------------------------------------- 
# ------------------------------------------- Problem #1 ---------------------------------------------- 
# ------------------------------------------- Problem #1 ---------------------------------------------- 

CPE <- function (Observed, Predicted, ...){
  
  # Confusion Matrix and Statistics
  require(InformationValue)
  result = list()
  result$"Confusion Table" = table(true = Observed, pred = Predicted)
  result$"Confusion Matrix" = confusionMatrix(Predicted, Observed)
  
  
  # ROC Curve and AUC
  require(ROCR)
  result$Predictions = prediction(Predicted, Observed)
  result$ROC = performance(result$Predictions,"tpr","fpr")
  plotROC(Observed, Predicted)
  plot(result$ROC, colorize=TRUE, print.cutoffs.at=c(0.25,0.5,0.75)); 
  abline(0, 1, col="red")
  result$"AUC Performance" = performance(result$Predictions,"auc")
  result$AUROC = AUROC(Observed, Predicted)
  
  
  # Concordant Pairs
  temp = Concordance(Observed, Predicted)
  result$Concordant = temp$Concordance
  result$Discordant = temp$Discordance
  result$Ties = temp$Tied
  result$Pairs = temp$Pairs
  
  
  # D Statistic
  inputData = cbind(Observed, Predicted) 
  Obs1 = inputData[inputData[,1] == 1,]
  Obs0 = inputData[inputData[,1] == 0,]
  result$D.statistic = mean(Obs1) - mean(Obs0)
  require(Hmisc)
  result$"Hoeffding's D Statistic" = hoeffd(Observed,Predicted)
  result$"Somer's D Statistic" = somersD(Observed, Predicted)

  
  # K-S Chart and Statistics
  ks_plot(Observed, Predicted)
  result$"K-S Stat" = ks_stat(Observed, Predicted)
  
  
  # Distribution of predicted probabilities values for true positives and true negatives
  require(sm)
  sm.density.compare(Predicted, Observed, xlab="cut of values")
  
  
  #Lift Chart
  Lift.chart = performance(result$Predictions,"lift","rpp")
  plot(Lift.chart, colorize=TRUE, print.cutoffs.at=c(0.25,0.5,0.75))
  
  
  return(result)
}


# ------------------------------------------- Test for Problem #1 -------------------------------------- 
# test for Classificaiton Performance Evaluation (CPE) function
honors <- read.csv("honors.csv")  
fit <- glm(data=honors, hon ~ math + read + female , family="binomial")
summary(fit)
Predicted = predict(fit)
Predicted = as.numeric(Predicted >= 0)
Observed = honors$hon

test = CPE(Observed, Predicted)
summary(test)
test$Concordant

# ------------------------------------------- Problem #3 ---------------------------------------------- 
# ------------------------------------------- Problem #3 ---------------------------------------------- 
# ------------------------------------------- Problem #3 ---------------------------------------------- 

# Load Data
Bank.Market <- read.table("bank-additional-full.csv", header=TRUE, sep=";")
head(Bank.Market)
str(Bank.Market)
summary(Bank.Market)

# Missing data investigation
Bank.missing = vector()
for (i in 1:length(Bank.Market)){
  Bank.missing[i] = length(Bank.Market[is.na(Bank.Market[,i]),i])
}
Bank.missing 

for (i in 1:length(Bank.Market)){
  Bank.missing[i] = Bank.missing[i] + length(Bank.Market[Bank.Market[,i]=="unknown",i])
}
Bank.missing 
Bank.missing / length(Bank.Market[,1]) * 100

#Assessing Missing Data
Bank.Clean = Bank.Market
Bank.Clean[Bank.Clean=="unknown"] <- NA
mean(is.na(Bank.Clean))
aggregate(Bank.Clean, by=list(Bank.Clean$y), function(x) mean(is.na(x)))

# Data investigation
numericVariables = c(1, 11:14, 16:20)
pairs(Bank.Clean[,numericVariables], main = "Bank Data Visualization", pch=21, bg = Bank.Market$y )
Bank.cor = cor(Bank.Clean[,numericVariables])
# nr.employed, euribor3m, cons.price.idx, emp.var.rate, previous, and pdays
Bank.cor[Bank.cor > .5]
cor(Bank.Clean[,c(13:14, 16:17, 19:20)])
cor(Bank.Clean[,c(20, 17, 19, 16, 14)])
summary(lm(data = Bank.Clean[,c(20, 17, 19, 16, 14, 13)], nr.employed~.))
summary(lm(data = Bank.Clean, nr.employed~.))
summary(lm(data = Bank.Clean[,c(20, 17, 19, 16, 14, 9, 8, 12, 15)], nr.employed~.))
pairs(Bank.Clean[,c(20, 17, 19, 16, 14, 9, 8, 12, 15)], 
      main = "Bank Data Visualization", pch=21, bg = Bank.Market$y )
heatmap(cor(Bank.Market[,numericVariables]))
scattmatrixMiss(Bank.Market[,numericVariables])    # Breif view for binary scatter

Bank.Clean = Bank.Clean[,-c(17, 19, 16, 14, 9, 8, 12, 15, 5)]

Bank.Clean$y = as.numeric(Bank.Clean$y=="yes")

#Imputing Missing Data using KNN method
temp = kNN(Bank.Clean, k=10)
Bank.Clean.NotImputed = Bank.Clean
Bank.Clean = temp[,1:length(Bank.Clean.NotImputed)]
mean(is.na(Bank.Clean))

# Random sampling process for training, cross validation, and test set
n = length(Bank.Clean[,1])
sampleBag = sample(1:n, n)

#Bank.Training = Bank.Clean[sampleBag[1:(0.8*n)],]
#Bank.CV = Bank.Clean[sampleBag[((0.8*n)+1):(0.9*n)],]
#Bank.Test = Bank.Clean[sampleBag[((0.9*n)+1):n],]

Bank.Training = Bank.Clean[sampleBag[1:(0.8*n)],]
Bank.Test = Bank.Clean[sampleBag[((0.8*n)+1):n],]

# ------------------------------------------- Problem #3 (b) ------------------------------------------- 

fit.LR <- glm(data=Bank.Training, y~., family="binomial")
summary(fit.LR)
plot(fit.LR)

#influence
influence.measures(fit.LR)
influencePlot(fit.LR)

#variance inflation
vif(fit.LR)
AIC(fit.LR)
fit.LR <- glm(data=Bank.Training, y~.-job, family="binomial")
vif(fit.LR)
AIC(fit.LR)

mean(vif(fit.LR))

fit.LR.pr = predict(fit.LR, Bank.Test)
fit.LR.pr[fit.LR.pr >= 0] = 1
fit.LR.pr[fit.LR.pr < 0] = 0
fit.LR.CPE = CPE (Bank.Test$y, fit.LR.pr)
hist(fit.LR.pr - Bank.Test$y)

plot(fit.LR)
plot(fit.LR, which = 6)

boxplot(fit.LR)
alias(fit.LR)
stepAIC(fit.LR)

pearsonRes <-residuals(fit.LR,type="pearson")
devianceRes <-residuals(fit.LR,type="deviance")
rawRes <-residuals(fit.LR,type="response")
studentDevRes<-rstudent(fit.LR)
fv<-fitted(fit.LR)
plot(studentDevRes) 
barplot(studentDevRes)

plot(hatvalues(fit.LR), rstudent(fit.LR))

# ------------------------------------------- Problem #3 (c) ------------------------------------------- 

#Elastic Net regularization (for logistic regression)
fitControl = trainControl(method="cv", number=10)# 10-fold CV
fit.EN = train(y~., data=Bank.Training, method="glmnet", trControl=fitControl)
summary(fit.EN)
plot(fit.EN)

#Decision Tree
fit.DT <- rpart(y~., data=Bank.Training, parms=list(split="information"), 
                control=rpart.control(cp=0.001), xval=20)
summary(fit.DT)
fitTreeParty<-as.party(fit.DT)
plot(fitTreeParty)
fancyRpartPlot(fit.DT)
printcp(fit.DT) #the cost-parameter
plotcp(fit.DT)
cp <- fit.DT$cptable[which.min(fit.DT$cptable[,"xerror"]),"CP"]
fit.DT <- prune(fit.DT, cp=cp)#Pruning the tree
fancyRpartPlot(fit.DT)
plot(fit.DT)
fitTreeParty<-as.party(fit.DT)
plot(fitTreeParty)

fit1 <- rpart(data=train, type ~.)
fitTreeParty<-as.party(fit1)
plot(fitTreeParty)

#Random Forest
fit.RF <- randomForest(y ~ ., data=Bank.Training, importance=T, ntrees=1500, mtry=3)
plot(fit.RF)

par(mfrow = c(2, 1))
barplot(fit.RF$importance[, 1], main = "Importance (Dec.Accuracy)")
barplot(fit.RF$importance[, 2], main = "Importance (Gini Index)")
par(mfrow = c(1, 1))
varImpPlot(fit.RF)

#Boosted Tree
a = Bank.Training
a$y = as.factor(a$y)
fit.BT <- boosting(y ~ ., data=a, boos=F, mfinal=20)
plot(fit.BT$importance)
plot(fit.BT$class)

# ------------------------------------------- Problem #3 (d) ------------------------------------------- 

#Elastic Net regularization
fit.EN.pr = predict(fit.EN, Bank.Test)
fit.EN.pr[fit.EN.pr >= 0] = 1
fit.EN.pr[fit.EN.pr < 0] = 0
hist(fit.EN.pr - Bank.Test$y)
fit.EN.CPE = CPE (Bank.Test$y, fit.EN.pr)

#Decision Tree
fit.DT.pr = predict(fit.DT, Bank.Test)
fit.DT.pr[fit.DT.pr >= 0.5] = 1
fit.DT.pr[fit.DT.pr < 0.5] = 0
hist(fit.DT.pr - Bank.Test$y)
fit.DT.CPE = CPE (Bank.Test$y, fit.DT.pr)

#Random Forest
fit.RF.pr = predict(fit.RF, Bank.Test)
fit.RF.pr[fit.RF.pr >= 0.5] = 1
fit.RF.pr[fit.RF.pr < 0.5] = 0
hist(fit.RF.pr - Bank.Test$y)
fit.RF.CPE = CPE (Bank.Test$y, fit.RF.pr)

#Boosted Tree
fit.BT.pr = predict(fit.BT, Bank.Test)
b = as.numeric(fit.BT.pr$class)
hist(b - Bank.Test$y)
fit.BT.CPE = CPE (Bank.Test$y, b)

# ------------------------------------------- Problem #4 ---------------------------------------------- 
# ------------------------------------------- Problem #4 ---------------------------------------------- 
# ------------------------------------------- Problem #4 ---------------------------------------------- 

## svm
fit.SVM <- svm(y ~ ., data = Bank.Training, cost = 100, gamma = 1)
plot(fit.SVM)
fit.SVM.pr  <- predict(fit.SVM, Bank.Test)
fit.SVM.pr[fit.SVM.pr >= 0] = 1
fit.SVM.pr[fit.SVM.pr < 0] = 0
hist(fit.SVM.pr - Bank.Test$y)
fit.RF.CPE = CPE (Bank.Test$y, fit.RF.pr)
table(pred = fit.SVM.pr, true = Bank.Test$y)


# Neural Network
Bank.NN = Bank.Training[,-(2:8)]
Bank.NN.Test = Bank.Test[,-(2:8)]
Bank.names <- names(Bank.NN)
f <- as.formula(paste("y ~", paste(Bank.names[!Bank.names %in% "y"], collapse = " + ")))
fit.NN <- neuralnet(f, data=Bank.Training, hidden=10, threshold=0.5)
print(fit.NN)
plot(fit.NN)
fit.NN.pr <- compute(fit.NN,Bank.NN.Test[,1:5])$net.result
fit.NN.pr[fit.NN.pr >= 0] = 1
fit.NN.pr[fit.NN.pr < 0] = 0
hist(fit.NN.pr - Bank.NN.Test[,6])
table(pred = fit.NN.pr, true = Bank.NN.Test[,6])




