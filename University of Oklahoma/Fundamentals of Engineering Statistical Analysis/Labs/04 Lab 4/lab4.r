#This will be a different path if in the lab or at home
dird="\\Users\\HyDRO-Lab\\Desktop\\MATH4753\\DATAxls\\"

#my function to read data 
myread=function(csv){
  fl=paste(dird,csv,sep="")
  read.table(fl,header=TRUE,sep=",")
}
#EASY WAY TO READ IN FILES

spruce.df=myread("SPRUCE.csv")#MS pg478

# Or use 
spruce.df=read.table(file.choose(),header=TRUE,sep=",")

#get wd
getwd()

#Top six lines
tail(spruce.df)

#Plot the points

plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,max(Height)),xlim=c(0,max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)


#load s20x library and make lowess smoother
library(s20x)

trendscatter(Height~BHDiameter,f=0.5,data=spruce.df)
# Now make the linear model
spruce.lm=lm(Height~BHDiameter,data=spruce.df)

#residuals  created from the linear model object
height.res=residuals(spruce.lm)

#fitted values made from the linear model object
height.fit=fitted(spruce.lm)

#Make the plot using the plot function 
plot(height.fit,height.res)

# Put a lowess smoother through res vs fitted
trendscatter( height.fit,height.res)

# Quick way to make a residual plot
plot(spruce.lm, which =1)

# Two plots testing normality
normcheck(spruce.lm)


## Quadratic object using the linear model
quad.lm=lm(Height~BHDiameter + I(BHDiameter^2),data=spruce.df)

#add to the scatter plot
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,max(Height)),xlim=c(0,max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)

coef(quad.lm)

myplot=function(x){
 0.86089580 +1.46959217*x  -0.02745726*x^2
 }
 
curve(myplot, lwd=2, col="steelblue",add=TRUE)
 
 
plot(quad.lm, which=1)


normcheck(quad.lm)


summary(quad.lm)

ciReg(quad.lm)


predict(quad.lm, data.frame(BHDiameter=c(15,18,20)))


anova(spruce.lm,quad.lm)


anova(quad.lm)
anova(spruce.lm)

height.qfit=fitted(quad.lm)

RSS=with(spruce.df, sum((Height-height.qfit)^2))
RSS
MSS = with(spruce.df, sum((height.qfit-mean(Height))^2))
MSS

TSS = with(spruce.df, sum((Height-mean(Height))^2))
TSS


MSS/TSS


cooks20x(quad.lm)


#Now remove the 24th datum and reanalyze data

quad2.lm=lm(Height~BHDiameter + I(BHDiameter^2) , data=spruce.df[-24,])
summary(quad2.lm)
summary(quad.lm)


###############################################################################

#some other code you might need
#layout
layout(matrix(1:4,nr=2,nc=2,byrow=TRUE))

#Lets look at where the plots will go
layout.show(4)

#Plot the data
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)
# add the line
abline(spruce.lm)


#make a new plot
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)

abline(spruce.lm)

#make yhat the estimates of E[Height | BHDiameter]
yhat=with(spruce.df,predict(spruce.lm,data.frame(BHDiameter)))
yhat=fitted(spruce.lm)
# Draw in segments making the residuals (regression errors)
with(spruce.df,{
segments(BHDiameter,Height,BHDiameter,yhat)
})

RSS=with(spruce.df,sum((Height-yhat)^2))

RSS

#make a new plot
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)

#make nieve model
with(spruce.df, abline(h=mean(Height)))
abline(spruce.lm)

#make the explained errors (explained by the model)
with(spruce.df, segments(BHDiameter,mean(Height),BHDiameter,yhat,col="Red"))
MSS=with(spruce.df,sum((yhat-mean(Height))^2))
MSS

# Total  error
#make a new plot
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), 
main="Spruce height prediction",data=spruce.df)

with(spruce.df,abline(h=mean(Height)))
with(spruce.df, segments(BHDiameter,Height,BHDiameter,mean(Height),col="Green"))
TSS=with(spruce.df,sum((Height-mean(Height))^2))
TSS
RSS + MSS
MSS/TSS

summary(spruce.lm)

#obtain coefft values
coef(spruce.lm)

#Calculate new y values given x
predict(spruce.lm, data.frame(BHDiameter=c(15,18,20)))

anova(spruce.lm)

spruce2.lm=lm(Height~BHDiameter + I(BHDiameter^2),data=spruce.df)
summary(spruce2.lm)


### More on the problem
windows()
plot(Height~BHDiameter,bg="Blue",pch=21,cex=1.2,
     ylim=c(0,1.1*max(Height)),xlim=c(0,1.1*max(BHDiameter)), 
     main="Spruce height prediction",data=spruce.df)

yhatt=with(spruce.df,fitted(spruce2.lm))
with(spruce.df,plot(BHDiameter,yhatt,col="Red")
)

sum(residuals(spruce2.lm)^2)
plot(yhatt~BHDiameter,data=spruce.df,type="p")
summary(spruce2.lm)
anova(spruce2.lm)
anova(spruce.lm,spruce2.lm)
MSS
RSS
