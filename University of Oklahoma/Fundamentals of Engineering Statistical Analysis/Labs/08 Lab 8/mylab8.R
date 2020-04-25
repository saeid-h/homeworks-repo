# This file is creaed for Lab 8 on May 25th 2016

# Function Area

mycltsum=function(n,iter){
  y=runif(n*iter,0,5)
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  sm=apply(data,2,sum)
  hist(sm, main="Histogram of Summation", xlab = "Total")
  Expmean =  mean(sm)
  Expvar= var(sm)
  Calmean = n * 0.5 *(5+0)
  Calvar = n * 1/12 * (5-0)^2
  return(list(Expmean = Expmean, Calmean = Calmean, Expvar= Expvar, Calvar =Calvar))
}

mycltmean=function(n,iter){
  y=runif(n*iter,0,5)
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  sm=apply(data,2,mean)
  hist(sm, main="Histogram of Mean", xlab = "Mean")
  Expmean = mean(sm)
  Expvar= var(sm)
  Calmean = 0.5 *(5+0)
  Calvar = 1/12 * (5-0)^2 / n
  return(list(Expmean = Expmean, Calmean = Calmean, Expvar= Expvar, Calvar =Calvar))
  }

mycltvar=function(n,iter){
  y=runif(n*iter,0,5)
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  sm=apply(data,2,var)
  hist(sm, main="Histogram of Variance", xlab = "Variance")
  Expmean = mean(sm)
  Expvar= var(sm)
  Calmean = n * 0.5 *(5+0)
  Calvar = n * 1/12 * (5-0)^2
  return(list(Expmean = Expmean, Calmean = Calmean, Expvar= Expvar, Calvar =Calvar))
  }


mycltsd=function(n,iter){
  y=runif(n*iter,0,5)
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  sm=apply(data,2,sd)
  hist(sm, main="Histogram of Standard Deviation", xlab = "Standard Deviation")
  Expmean = mean(sm)
  Expvar= var(sm)
  Calmean = n * 0.5 *(5+0)
  Calvar = n * 1/12 * (5-0)^2
  return(list(Expmean = Expmean, Calmean = Calmean, Expvar= Expvar, Calvar =Calvar))
  }


################### uniform ##########################
### CLT uniform 
## my Central Limit Function
## Notice that I have assigned default values which can be changed when the function is called
mycltu=function(n,iter,a=0,b=10){
  ## r-random sample from the uniform
  y=runif(n*iter,a,b)
  ## Place these numbers into a matrix
  ## The columns will correspond to the iteration and the rows will equal the sample size n
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  ## apply the function mean to the columns (2) of the matrix
  ## these are placed in a vector w
  w=apply(data,2,mean)
  ## We will make a histogram of the values in w
  ## How high should we make y axis?
  ## All the values used to make a histogram are placed in param (nothing is plotted yet)
  param=hist(w,plot=FALSE)
  ## Since the histogram will be a density plot we will find the max density
  
  ymax=max(param$density)
  ## To be on the safe side we will add 10% more to this
  ymax=1.1*ymax
  ## Now we can make the histogram
  hist(w,freq=FALSE,  ylim=c(0,ymax), main=paste("Histogram of sample mean",
                                                 "\n", "sample size= ",n,sep=""),xlab="Sample mean")
  ## add a density curve made from the sample distribution
  lines(density(w),col="Blue",lwd=3) # add a density plot
  ## Add a theoretical normal curve 
  curve(dnorm(x,mean=(a+b)/2,sd=(b-a)/(sqrt(12*n))),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  ## Add the density from which the samples were taken
  curve(dunif(x,a,b),add=TRUE,lwd=4)
  
}

##############################  Binomial #########


## CLT Binomial
## CLT will work with discrete or continuous distributions 
## my Central Limit Function
## Notice that I have assigned default values which can be changed when the function is called

mycltb=function(n,iter,p=0.5,...){
  
  ## r-random sample from the Binomial
  y=rbinom(n*iter,size=n,prob=p)
  ## Place these numbers into a matrix
  ## The columns will correspond to the iteration and the rows will equal the sample size n
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  ## apply the function mean to the columns (2) of the matrix
  ## these are placed in a vector w
  w=apply(data,2,mean)
  ## We will make a histogram of the values in w
  ## How high should we make y axis?
  ## All the values used to make a histogram are placed in param (nothing is plotted yet)
  param=hist(w,plot=FALSE)
  ## Since the histogram will be a density plot we will find the max density
  
  ymax=max(param$density)
  ## To be on the safe side we will add 10% more to this
  ymax=1.1*ymax
  
  ## Now we can make the histogram
  ## freq=FALSE means take a density
  hist(w,freq=FALSE,  ylim=c(0,ymax),
       main=paste("Histogram of sample mean","\n", "sample size= ",n,sep=""),
       xlab="Sample mean",...)
  ## add a density curve made from the sample distribution
  #lines(density(w),col="Blue",lwd=3) # add a density plot
  ## Add a theoretical normal curve 
  curve(dnorm(x,mean=n*p,sd=sqrt(p*(1-p))),add=TRUE,col="Red",lty=2,lwd=3) 
  
}


####### Poisson ######################

## CLT Poisson
## CLT will work with discrete or continuous distributions 
## my Central Limit Function
## Notice that I have assigned default values which can be changed when the function is called

mycltp=function(n,iter,lambda=10,...){
  
  ## r-random sample from the Poisson
  y=rpois(n*iter,lambda=lambda)
  ## Place these numbers into a matrix
  ## The columns will correspond to the iteration and the rows will equal the sample size n
  data=matrix(y,nr=n,nc=iter,byrow=TRUE)
  ## apply the function mean to the columns (2) of the matrix
  ## these are placed in a vector w
  w=apply(data,2,mean)
  ## We will make a histogram of the values in w
  ## How high should we make y axis?
  ## All the values used to make a histogram are placed in param (nothing is plotted yet)
  param=hist(w,plot=FALSE)
  ## Since the histogram will be a density plot we will find the max density
  
  ymax=max(param$density)
  ## To be on the safe side we will add 10% more to this
  ymax=1.1*ymax
  
  ## Make a suitable layout for graphing
  layout(matrix(c(1,1,2,3),nr=2,nc=2, byrow=TRUE))
  
  ## Now we can make the histogram
  hist(w,freq=FALSE,  ylim=c(0,ymax), col=rainbow(max(w)),
       main=paste("Histogram of sample mean","\n", "sample size= ",n," iter=",iter," lambda=",lambda,sep=""),
       xlab="Sample mean",...)
  ## add a density curve made from the sample distribution
  #lines(density(w),col="Blue",lwd=3) # add a density plot
  ## Add a theoretical normal curve 
  curve(dnorm(x,mean=lambda,sd=sqrt(lambda/n)),add=TRUE,col="Red",lty=2,lwd=3) # add a theoretical curve
  
  # Now make a new plot
  # Since y is discrete we should use a barplot
  barplot(table(y)/(n*iter),col=rainbow(max(y)), main="Barplot of sampled y", ylab ="Rel. Freq",xlab="y" )
  x=0:max(y)
  plot(x,dpois(x,lambda=lambda),type="h",lwd=5,col=rainbow(max(y)),
       main="Probability function for Poisson", ylab="Probability",xlab="y")
}






# Task 1

getwd()


# Task 2

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
mycltsum(n=10,iter=10000)
mycltmean(n=10,iter=10000)
mycltvar(n=10,iter=10000)
mycltsd(n=10,iter=10000)



# Task 3
 
mycltu(n = 1, iter = 10000, a = 0, b = 10)
mycltu(n = 2, iter = 10000, a = 0, b = 10)
mycltu(n = 3, iter = 10000, a = 0, b = 10)
mycltu(n = 5, iter = 10000, a = 0, b = 10)
mycltu(n = 10, iter = 10000, a = 0, b = 10)
mycltu(n = 30, iter = 10000, a = 0, b = 10)



# Task 4

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
mycltb(n = 4, iter = 10000, p = 0.3)
mycltb(n = 5, iter = 10000, p = 0.3)
mycltb(n = 10, iter = 10000, p = 0.3)
mycltb(n = 20, iter = 10000, p = 0.3)

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
prob = 0.7
mycltb(n = 4, iter = 10000, p = prob)
mycltb(n = 5, iter = 10000, p = prob)
mycltb(n = 10, iter = 10000, p = prob)
mycltb(n = 20, iter = 10000, p = prob)

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
prob = 0.5
mycltb(n = 4, iter = 10000, p = prob)
mycltb(n = 5, iter = 10000, p = prob)
mycltb(n = 10, iter = 10000, p = prob)
mycltb(n = 20, iter = 10000, p = prob)



# Task 5

windows()
mycltp(n = 2,iter = 10000, lambda = 4)
mycltp(n = 3,iter = 10000, lambda = 4)
mycltp(n = 5,iter = 10000, lambda = 4)
mycltp(n = 10,iter = 10000, lambda = 4)
mycltp(n = 20,iter = 10000, lambda = 4)


windows()
mycltp(n = 2,iter = 10000, lambda = 10)
mycltp(n = 3,iter = 10000, lambda = 10)
mycltp(n = 5,iter = 10000, lambda = 10)
mycltp(n = 10,iter = 10000, lambda = 10)
mycltp(n = 20,iter = 10000, lambda = 10)



# Task 6

mycltpsum = function(n, iter, lambda = 10, ...){
  
  y = rpois(n*iter, lambda = lambda)
  data = matrix(y, nr= n, nc = iter, byrow = TRUE)
  w = apply(data, 2, sum)
  param = hist(w, plot = FALSE)
  
  ymax = 1.1 * max(param$density)
  
  layout(matrix(c(1,1,2,3), nr = 2, nc = 2, byrow = TRUE))
  
  hist(w, freq = FALSE,  ylim = c(0,ymax), col = rainbow (min(15, length(param$mids))),
       main=paste("Histogram of sample sum","\n", "sample size= ",n," iter=",iter," lambda=",lambda,sep=""),
       xlab="Sample mean")
  curve(dnorm(x, mean = n * lambda, sd = sqrt(lambda * n)),
        add = TRUE, col = "Red", lty = 2, lwd = 3) # add a theoretical curve
  
 barplot(table(y)/(n*iter), col = rainbow(max(y)), main="Barplot of sampled y", ylab ="Rel. Freq",xlab="y" )
  x=0:max(y)
  plot(x,dpois(x,lambda=lambda),type="h",lwd=5,col=rainbow(max(y)),
       main="Probability function for Poisson", ylab="Probability",xlab="y")
}

windows()
mycltpsum(n = 50,iter = 10000, lambda = 10)

