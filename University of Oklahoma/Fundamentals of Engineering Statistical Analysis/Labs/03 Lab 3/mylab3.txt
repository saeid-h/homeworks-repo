# TASK 1 
getwd()
# TASK 2 
SPRUCE = read.table(file.choose(),sep=",",header=TRUE)
head(SPRUCE)
# TASK 3 
windows() 
plot(Height~BHDiameter,bg="Blue",main="Spruce Data",pch=21,cex=1.2,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)),data=SPRUCE)
#Load library
library(s20x)
#Make a New Plot
trendscatter(Height~BHDiameter,f=0.7, data=SPRUCE)
#layout
windows()
layout(matrix(1:3,nr=3,nc=1,byrow=TRUE))
layout.show(3) # see Layout and plot for all 3 values of f= 0.5,0.6,0.7
trendscatter(Height~BHDiameter,f=0.5, data=SPRUCE)
trendscatter(Height~BHDiameter,f=0.6, data=SPRUCE)
trendscatter(Height~BHDiameter,f=0.7, data=SPRUCE)
# make a linear model
spruce.lm=with(SPRUCE, lm(Height~BHDiameter))

#make a new plot
windows()
with(SPRUCE, 
     plot(Height~BHDiameter,bg="Blue",main = "scatter plot with LSR line",pch=21,
          ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter))))
#plot a least squares regression line
abline(spruce.lm)

#Task 4
windows()
layout(matrix(1:4,nr=2,nc=2,byrow=TRUE))
layout.show(4)
#plot 1
plot(Height~BHDiameter,bg="Blue",pch=21,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), data=SPRUCE)
abline(spruce.lm)
#plot 2
plot(Height~BHDiameter,bg="Blue",pch=21,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), data=SPRUCE)
yhat=with(SPRUCE,predict(spruce.lm,data.frame(BHDiameter)))
with(SPRUCE,segments(BHDiameter,Height,BHDiameter,yhat))
abline(spruce.lm)

#plot 3
plot(Height~BHDiameter,bg="Blue",pch=21,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), data=SPRUCE)
abline(spruce.lm)
with(SPRUCE, segments(BHDiameter,mean(Height),BHDiameter,yhat,col="Red"))
with(SPRUCE, abline(h=mean(Height)))

#plot 4
plot(Height~BHDiameter,bg="Blue",pch=21,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), data=SPRUCE)
with(SPRUCE,abline(h=mean(Height)))
with(SPRUCE, segments(BHDiameter,Height,BHDiameter,mean(Height),col="Green"))




#residual sum of squares
RSS=with(SPRUCE,sum((Height-yhat)^2))
RSS


#make the explained deviations (explained by the model)
with(SPRUCE, segments(BHDiameter,mean(Height),BHDiameter,yhat,col="Red"))
MSS=with(SPRUCE,sum((yhat-mean(Height))^2))
MSS

# Total  error
#make a new plot
windows()
with(SPRUCE, 
     plot(Height~BHDiameter,bg="Blue",pch=21,ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)))
)
with(SPRUCE,abline(h=mean(Height)))
with(SPRUCE, segments(BHDiameter,Height,BHDiameter,mean(Height),col="Green"))
TSS=with(SPRUCE,sum((Height-mean(Height))^2))
TSS
RSS + MSS
MSS/TSS

#TASK 5 
summary(spruce.lm)

#Get coeffts
coef(spruce.lm)

#Predict new HEAT values for RATIO values
predict(spruce.lm, data.frame(BHDiameter=c(15,18,20)))


anova(spruce.lm)

