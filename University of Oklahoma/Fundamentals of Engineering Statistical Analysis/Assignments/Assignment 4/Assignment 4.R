

### This file has been created for assignment 4 on June 7th, 2016.


# Q1)

NZBirds.df = read.table("NZBIRDS.csv",header=TRUE,sep=",")
head(NZBirds.df)

# Select random 35 numbers from 1 to the number of the rows in NZBirds.df 
numbers = sample(1:nrow(NZBirds.df), size = 35, replace = FALSE) 

# select 35 species 
sample = NZBirds.df[numbers,]

Mu = mean(sample$Body.Mass)
Mu
SD = sd(sample$Body.Mass)
SD

ci = t.test(sample$B, mu = Mu, conf.level = 0.95)$conf.int
ci

mean(NZBirds.df$Body.Mass)


# Select random 35 numbers from 1 to the number of the rows in NZBirds.df 
numbersEgg = sample(1:nrow(NZBirds.df), size = 35, replace = FALSE) 

# select 35 species 
sampleEgg = NZBirds.df[numbersEgg,]

MuEgg = mean(sampleEgg$Egg)
MuEgg
SDEgg = sd(sampleEgg$Egg)
SDEgg
 
ciEgg = t.test(sampleEgg$Egg, mu = MuEgg, conf.level = 0.95)$conf.int
ciEgg

mean(c(NZBirds.df$Egg.Length[1:45],NZBirds.df$Egg.Length[48:132]))


#Q2 - 7.120

set.seed(120);x=rnorm(100,mean=1312,sd=422)   # fake data to understand t-tests
set.seed(100); y=rnorm(47,mean=1352,sd=271)
boxplot(list(x=x,y=y)) # boxplot of a list

t.test(x,y,mu =1352 - 1312,var.equal=FALSE,conf.level = 0.90)
t.test(x,y,mu =1352 - 1312,var.equal=TRUE,conf.level = 0.90)

var.test(x, y)


#Q5 8.28

WL = read.table(file.choose(),sep=",",header=TRUE)
ci=t.test(WL$DOC,mu=15,conf.level = 0.9)$conf.int
ci
pvalue=t.test(WL$DOC,mu=15,conf.level = 0.9)$p.value
pvalue

#Q6. 8.44
OR = read.table(file.choose(),sep=",",header=TRUE)
fog = subset(OR , CONDITION == "FOG" & RATIO > 0)
cl = subset(OR, CONDITION != "FOG")

t.test(fog$RATIO,cl$RATIO,mu = 0, var.equal=FALSE,conf.level = 0.95)
pvalue=t.test(fog$RATIO,cl$RATIO,mu = 0, var.equal=FALSE,conf.level = 0.95)$p.value
pvalue

#Q7 8.84

GT = read.table(file.choose(),sep=",",header=TRUE)
traditional = subset(GT, ENGINE == "Traditional")
aeroderivative = subset(GT, ENGINE == "Aeroderiv")
t.test(traditional$HEATRATE,aeroderivative$HEATRATE,mu = 0,var.equal = TRUE,conf.level = 0.95)
pvalue = t.test(traditional$HEATRATE,aeroderivative$HEATRATE,mu = 0,var.equal = TRUE,conf.level = 0.95)$p.value
pvalue

advanced = subset(GT, ENGINE == "Advanced")
t.test(advanced$HEATRATE,aeroderivative$HEATRATE,mu = 0,var.equal = TRUE,conf.level = 0.95)
pvalue = t.test(advanced$HEATRATE,aeroderivative$HEATRATE,mu = 0,var.equal = TRUE,conf.level = 0.95)$p.value
pvalue

#Q8 8.99
GA = read.table(file.choose(),sep=",",header=TRUE)
DS = subset(GA, Region == "Dry Steppe")
GD = subset(GA, Region == "Gobi Desert")
t.test(DS$AntSpecies, GD$AntSpecies,mu=0,var.equal = TRUE, conf.level = 0.05)
pvalue = t.test(DS$AntSpecies, GD$AntSpecies,mu=0,var.equal = TRUE, conf.level = 0.05)$p.value
pvalue

#Q9 8.104

TP = read.table(file.choose(),sep=",",header=TRUE)
t.test(TP$HUMAN,TP$AUTO,mu=0,var.equal = FALSE)
pvalue = t.test(TP$HUMAN,TP$AUTO,mu=0,var.equal = FALSE)$p.value
pvalue
pvalue2 = t.test(TP$HUMAN,TP$AUTO,mu=0,var.equal = TRUE)$p.value
pvalue


#Q10
myboot<-function(iter=10000,x,fun="mean",alpha=0.05,...){  #Notice where the ... is repeated in the code
  n=length(x)   #sample size
  
  y=sample(x,n*iter,replace=TRUE)
  rs.mat=matrix(y,nr=n,nc=iter,byrow=TRUE)
  xstat=apply(rs.mat,2,fun) # xstat is a vector and will have iter values in it
  ci=quantile(xstat,c(alpha/2,1-alpha/2))# Nice way to form a confidence interval
  # A histogram follows
  # The object para will contain the parameters used to make the histogram
  para=hist(xstat,freq=FALSE,las=1,
            main=paste("Histogram of Bootstrap sample statistics","\n","alpha=",alpha," iter=",iter,sep=""),
            ...)
  
  #mat will be a matrix that contains the data, this is done so that I can use apply()
  mat=matrix(x,nr=length(x),nc=1,byrow=TRUE)
  
  #pte is the point estimate
  #This uses whatever fun is
  pte=apply(mat,2,fun)
  abline(v=pte,lwd=3,col="Black")# Vertical line
  segments(ci[1],0,ci[2],0,lwd=4)      #Make the segment for the ci
  
  alpha1=0.05
  t=qt(1-alpha1/2,length(x)-1) # df=n-1=25-1
  
  cit=c()
  cit[1]=mean(x)-t*sd(x)/sqrt(length(x))
  cit[2]=mean(x)+t*sd(x)/sqrt(length(x))
  cit
  
  
  text(ci[1],0.05,paste("(",round(ci[1],2),sep=""),col="Red",cex=2)
  text(ci[2],0.05,paste(round(ci[2],2),")",sep=""),col="Red",cex=2)
  
  text(cit[1],0.2,paste("(",round(cit[1],2),sep=""),col="Blue",cex=2)
  text(cit[2],0.2,paste(round(cit[2],2),")",sep=""),col="Blue",cex=2)
  
  # plot the point estimate 1/2 way up the density
  text(pte,max(para$density)/2,round(pte,2),cex=3)
  
  return(list(fun=fun,x=x,t=t,ci=ci,cit=cit))# Some output to use if necessary
}


set.seed(35)
sam<-round(rnorm(30,mean=20,sd=3),3)
windows()
obj = myboot(10000,x=sam,fun=function(x) mean(x),alpha=0.05,xlab="xstat",col=rainbow(9))
obj












