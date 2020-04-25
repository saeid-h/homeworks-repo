# This file is created for lab 7 on 24th May 2016

# Function area:

#This is a model R function that you can alter for other statistics
# Copy this function twice and alter the two copies to make sampling distributions from the T distribution
mychisim <- function (n1 = 10, sigma1 = 3, mean1 = 5, iter = 1000, ymax = 0.1, ...){    
  
  y1 = rnorm (n1*iter, mean = mean1, sd = sigma1) # generate iter samples of size n1
  
  data1.mat = matrix(y1, nrow = n1 , ncol = iter, byrow=TRUE) # Each column is a sample size n1
  
  ssq1 = apply(data1.mat, 2, var) # ssq1 is s squared
  
  w = (n1-1) * ssq1/sigma1^2      #chi-sq stat
  
  hist (w, freq = FALSE, ylim = c(0,ymax), # Histogram with annotation
       main = substitute(paste("Sample size = ",n[1], " = ",n1," statistic = ",chi^2)),
       xlab = expression(paste(chi^2, "Statistic",sep=" ")), las=1)
  lines(density(w),col="Blue",lwd=3) # add a density plot
  curve(dchisq(x,n1-1),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  title=expression(chi^2==frac((n[1]-1)*s^2,sigma^2)) #mathematical annotation -see ?plotmath
  legend(locator(1),c("Simulated","Theoretical"),col=c("Blue","Red"),lwd=4,lty=1:2,bty="n",title=title) # Legend #
  return(list(w=w,summary=summary(w),sd=sd(w),fun="Chi-sq")) # some output to use if needed
}


myTsim <- function (n1 = 10, sigma1 = 3, mean1 = 5, iter = 1000, ymax = 0.1, ...){    
 
  y1 = rnorm (n1*iter, mean = mean1, sd = sigma1) # generate iter samples of size n1
  
  data1.mat = matrix(y1, nrow = n1 , ncol = iter, byrow=TRUE) # Each column is a sample size n1
  
  ssq1 = apply(data1.mat, 2, var) # ssq1 is s squared
  ybar1 = apply(data1.mat, 2, mean) # ssq1 is s squared
  
  w = (ybar1 - mean1) / sqrt(ssq1/n1) # t-student stat
  
  
  hist (w, freq = FALSE, ylim = c(0,ymax), # Histogram with annotation
        main = substitute(paste("Sample size = ",n[1], " = ",n1," statistic = ",T)),
        xlab = expression(paste("T-", "Statistic",sep=" ")), las=1)
  lines(density(w),col="Blue",lwd=3) # add a density plot
  curve(dt(x,n1-1),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  title=expression(T==frac((bar(y)-mu),s/sqrt(n1))) #mathematical annotation -see ?plotmath
  legend(locator(1),c("Simulated","Theoretical"),col=c("Blue","Red"),lwd=4,lty=1:2,bty="n",title=title) # Legend #
  return(list(w=w,summary=summary(w),sd=sd(w),fun="T")) # some output to use if needed
}


#### Two pop sampling
mychisim2<-function(n1=10,n2=14,sigma1=3,sigma2=3,mean1=5,mean2=10,iter=1000,ymax=0.07,...){    # adjust ymax to make graph fit
  y1=rnorm(n1*iter,mean=mean1,sd=sigma1)# generate iter samples of size n1
  y2=rnorm(n2*iter,mean=mean2,sd=sigma2)
  data1.mat=matrix(y1,nrow=n1,ncol=iter,byrow=TRUE) # Each column is a sample size n1
  data2.mat=matrix(y2,nrow=n2,ncol=iter,byrow=TRUE)
  ssq1=apply(data1.mat,2,var) # ssq1 is s squared
  ssq2=apply(data2.mat,2,var)
  spsq=((n1-1)*ssq1 + (n2-1)*ssq2)/(n1+n2-2) # pooled s squared
  w=(n1+n2-2)*spsq/(sigma1^2)#sigma1=sigma2,  Chi square stat
  hist(w,freq=FALSE, ylim=c(0,ymax), # Histogram with annotation
       main=substitute(paste("Sample size = ",n[1]+n[2]," = ",n1+n2," statistic = ",chi^2)),
       xlab=expression(paste(chi^2, "Statistic",sep=" ")), las=1)
  lines(density(w),col="Blue",lwd=3) # add a density plot
  curve(dchisq(x,n1+n2-2),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  title=expression(chi^2==frac((n[1]+n[2]-2)*S[p]^2,sigma^2)) #mathematical annotation -see ?plotmath
  legend(locator(1),c("Simulated","Theoretical"),col=c("Blue","Red"),lwd=4,lty=1:2,bty="n",title=title) # Legend #
  return(list(w=w,summary=summary(w),sd=sd(w),fun="Chi-sq")) # some output to use if needed
}


myTsim2<-function(n1=10,n2=14,sigma1=3,sigma2=3,mean1=5,mean2=10,iter=1000,ymax=0.5,...){
  y1=rnorm(n1*iter,mean=mean1,sd=sigma1)# generate iter samples of size n1
  y2=rnorm(n2*iter,mean=mean2,sd=sigma2)
  data1.mat=matrix(y1,nrow=n1,ncol=iter,byrow=TRUE) # Each column is a sample size n1
  data2.mat=matrix(y2,nrow=n2,ncol=iter,byrow=TRUE)
  ssq1=apply(data1.mat,2,var) # ssq1 is s squared
  ybar1= apply(data1.mat,2,mean)
  ssq2=apply(data2.mat,2,var)
  ybar2=apply(data2.mat,2,mean)
  spsq=((n1-1)*ssq1 + (n2-1)*ssq2)/(n1+n2-2) # pooled s squared
  w=((ybar1-ybar2)-(mean1-mean2))/sqrt(spsq*(1/n1+1/n2))#sigma1=sigma2,  Chi square stat
  hist(w,freq=FALSE, ylim=c(0,ymax), # Histogram with annotation
       main=substitute(paste("Sample size = ",n[1]+n[2]," = ",n1+n2," statistic = ",T)),
       xlab=paste(" T Statistic",sep=""), las=1)
  lines(density(w),col="Blue",lwd=3) # add a density plot
  curve(dt(x,n1+n2-2),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  title=expression(T==frac((bar(Y)[1]-bar(Y)[2])-(mu[1]-mu[2]),S[p]*sqrt(frac(1,n[1])+frac(1,n[2])))) #mathematical annotation -see ?plotmath
  legend(locator(1),c("Simulated","Theoretical"),col=c("Blue","Red"),lwd=4,lty=1:2,bty="n",title=title)# Legend #
  return(list(w=w,summary=summary(w),sdw=sd(w),fun="T")) # some output to use if needed
}


myFsim2<-function(n1=10,n2=14,sigma1=3,sigma2=2,mean1=5,mean2=10,iter=1000,ymax=0.9,...){
  y1=rnorm(n1*iter,mean=mean1,sd=sigma1)# generate iter samples of size n1
  y2=rnorm(n2*iter,mean=mean2,sd=sigma2)
  data1.mat=matrix(y1,nrow=n1,ncol=iter,byrow=TRUE) # Each column is a sample size n1
  data2.mat=matrix(y2,nrow=n2,ncol=iter,byrow=TRUE)
  ssq1=apply(data1.mat,2,var) # ssq1 is s squared
  ssq2=apply(data2.mat,2,var)
  #spsq=((n1-1)*ssq1 + (n2-1)*ssq2)/(n1+n2-2) # pooled s squared
  w=ssq1*sigma2^2/(ssq2*sigma1^2) #
  hist(w,freq=FALSE, ylim=c(0,ymax), # Histogram with annotation
       main=substitute(paste("Sample size = ",n[1]+n[2]," = ",n1+n2," statistic = ",F)),
       xlab=paste("F Statistic",sep=""), las=1)
  lines(density(w),col="Blue",lwd=3) # add a density plot
  curve(df(x,n1-1,n2-1),xlim=c(0,6),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  title=expression(F==frac(s[1]^2,s[2]^2)*frac(sigma[2]^2,sigma[1]^2)) #mathematical annotation -see ?plotmath
  legend(locator(1),c("Simulated","Theoretical"),col=c("Blue","Red"),lwd=4,lty=1:2,bty="n",title=title)# Legend #
  return(list(w=w,summary=summary(w),sd=sd(w),fun="F")) # some output to use if needed
}

# source("Lab7.R")



# Task 1

getwd()



# Task 2

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
mychisim(n1 = 10, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.15)
mychisim(n1 = 20, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.10)
mychisim(n1 = 100, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.05)
mychisim(n1 = 200, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.03)

windows()
layout(matrix(1:2,nr=2,nc=1,byrow = TRUE))
chisq = mychisim(n1 = 10, iter = 1500, mean1 = 20, sigma1 = 10, ymax = 0.15)
hist(chisq$w)



# Task 3

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
myTsim(n1 = 10, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.5)
myTsim(n1 = 20, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.5)
myTsim(n1 = 100, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.5)
myTsim(n1 = 200, iter = 1000, mean1 = 10, sigma1 = 4, ymax = 0.5)

windows()
layout(matrix(1:2,nr=2,nc=1,byrow = TRUE))
Ttest = myTsim(n1 = 10, iter = 1500, mean1 = 20, sigma1 = 10, ymax = 0.5)
hist(Ttest$w)


# Task 4

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
mychisim2(n1=10, n2=10, mean1=5,mean2=10, sigma1=4, sigma2=4, iter=1000, ymax=0.07)
mychisim2(n1=20, n2=10, mean1=3,mean2=5, sigma1=10, sigma2=10, iter=1000, ymax=0.07)
mychisim2(n1=50, n2=50, mean1=5,mean2=10, sigma1=10, sigma2=10, iter=10000, ymax=0.03)
mychisim2(n1=80, n2=50, mean1=3,mean2=5, sigma1=10, sigma2=10, iter=10000, ymax=0.03)

windows()
layout(matrix(1:2,nr=2,nc=1,byrow = TRUE))
chisq2 = mychisim2(iter=10000)
hist(chisq2$w)



# Task 5

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
myTsim2(n1=10, n2=10, mean1=5, mean2=10, sigma1=4, sigma2=4, iter=1000,ymax=0.5)
myTsim2(n1=20, n2=10, mean1=3, mean2=5, sigma1=10, sigma2=10, iter=1000,ymax=0.6)
myTsim2(n1=50, n2=50, mean1=5, mean2=10, sigma1=4, sigma2=4, iter=10000,ymax=0.6)
myTsim2(n1=80, n2=50, mean1=3, mean2=5, sigma1=10, sigma2=10, iter=10000,ymax=0.6)

windows()
layout(matrix(1:2,nr=2,nc=1,byrow = TRUE))
Ttest2 = myTsim2(iter=10000)
hist(Ttest2$w)



# Task 6

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
myFsim2(n1=10,n2=14,mean1=5,mean2=10,sigma1=3,sigma2=2,iter=1000,ymax=0.7)
myFsim2(n1=10,n2=10,mean1=2,mean2=10,sigma1=3,sigma2=3,iter=10000,ymax=0.7)
myFsim2(n1=20,n2=10,mean1=30,mean2=8,sigma1=30,sigma2=3,iter=10000,ymax=0.8)
myFsim2(n1=20,n2=10,mean1=3,mean2=10,sigma1=10,sigma2=10,iter=10000,ymax=0.8)

windows()
layout(matrix(1:2,nr=2,nc=1,byrow = TRUE))
Ftest = myFsim2(iter=10000,ymax=0.8)
hist(Ftest$w)



# Task 7

myclevel<-function(w, cprob = 0.95, ...){
  
  pl = (1 - cprob) / 2
  ph = 1 - pl
  a = quantile(w, probs = pl)
  b = quantile(w, probs = ph)
  clevel = c(round(a,4), round(b,4))
  names(clevel)<- c("Low Tail", "High Tail")
  clevel
  
  return(list(summary=summary(w),clevel=clevel, a=a, b=b)) # some output to use if needed
}

k = myclevel(chisq$w, cprob = 0.95)
myclevel(chisq$w, cprob = 0.95)

