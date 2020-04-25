# This file was created for Lab 10 on May 31, 2016


# Function Area

# various log likelihoods defined
logbin=function(x,param) log(dbinom(x,prob=param,size=10))
logpoiss=function(x,param) log(dpois(x,lambda=param)) 
logexp=function(x,param) log(dexp(x,rate=param))


#max likelihood function  
## For repeated sampling from same distribution                     
mymaxlik=function(lfun,x,param,...){
  # how many param values are there?
  np=length(param)
  # outer -- notice the order, x then param
  # this produces a matrix -- try outer(1:4,5:10,function(x,y) paste(x,y,sep=" "))   to understand
  z=outer(x,param,lfun)
  # z is a matrix where each x,param is replaced with the function evaluated at those values
  y=apply(z,2,sum)
  
  # y is a vector made up of the column sums
  # Each y is the log lik for a new parameter value
  plot(param,y,col="Blue",type="l",lwd=2,...)
  # which gives the index for the value of y == max.
  # there could be a max between two values of the parameter, therefore 2 indices
  # the first max will take the larger indice
  i=max(which(y==max(y)))
  abline(v=param[i],lwd=2,col="Red")
  
  # plots a nice point where the max lik is
  points(param[i],y[i],pch=19,cex=1.5,col="Black")
  axis(3,param[i],round(param[i],2))
  #check slopes. If it is a max the slope shoud change sign from + to 
  # We should get three + and two -vs
  ifelse(i-3>=1 & i+2<=np, slope<-(y[(i-2):(i+2)]-y[(i-3):(i+1)])/(param[(i-2):(i+2)]-param[(i-3):(i+1)]),slope<-"NA")
  return(list(i=i,parami=param[i],yi=y[i],slope=slope))
}



myNRML=function(x0,delta=0.001,llik,xrange,parameter="param"){
  f=function(x) (llik(x+delta)-llik(x))/delta
  fdash=function(x) (f(x+delta)-f(x))/delta
  d=1000
  i=0
  x=c()
  y=c()
  x[1]=x0
  y[1]=f(x[1])
  while(d > delta & i<100){
    i=i+1
    x[i+1]=x[i]-f(x[i])/fdash(x[i])
    y[i+1]=f(x[i+1])
    d=abs(y[i+1])
  }
  windows()
  layout(matrix(1:2,nr=1,nc=2,byrow=TRUE),width=c(1,2))
  curve(llik(x), xlim=xrange,xlab=parameter,ylab="log Lik",main="Log Lik")
  curve(f(x),xlim=xrange,xaxt="n", xlab=parameter,ylab="derivative",main=  "Newton-Raphson Algorithm \n on the derivative")
  points(x,y,col="Red",pch=19,cex=1.5)
  axis(1,x,round(x,2),las=2)
  abline(h=0,col="Red")
  
  segments(x[1:(i-1)],y[1:(i-1)],x[2:i],rep(0,i-1),col="Blue",lwd=2)
  segments(x[2:i],rep(0,i-1),x[2:i],y[2:i],lwd=0.5,col="Green")
  
  list(x=x,y=y)
}
  
  


### 2 parameters with a general log  likelihood 


maxlikg2=function(theta1,theta2,lfun="logbinpois",...){
  n1=length(theta1)
  n2=length(theta2)
  z=outer(theta1,theta2,lfun)
  contour(theta1,theta2,exp(z),...) # exp(z) gives the lik
  maxl=max(exp(z))    # max lik
  coord=which(exp(z)==maxl,arr.ind=TRUE)  # find the co-ords of the max
  th1est=theta1[coord[1]] # mxlik estimate of theta1
  th2est=theta2[coord[2]]
  abline(v=th1est,h=th2est)
  axis(3,th1est,round(th1est,2))
  axis(4,th2est,round(th2est,2),las=1)
  list(th1est=th1est,th2est=th2est)
}





# Make a max lik function for two parameters


mymlnorm=function(x,mu,sig,...){  #x sample vector
  nmu=length(mu) # number of values in mu
  nsig=length(sig)
  n=length(x) # sample size
  zz=c()    ## initialize a new vector
  lfun=function(x,m,p) log(dnorm(x,mean=m,sd=p))   # log lik for normal
  for(j in 1:nsig){
    z=outer(x,mu,lfun,p=sig[j]) # z a matrix 
    # col 1 of z contains lfun evaluated at each x with first value of mu, 
    # col2 each x with 2nd value of m 
    # all with sig=sig[j]
    y=apply(z,2,sum)
    # y is a vector filled with log lik values, 
    # each with a difft mu and all with the same sig[j]
    zz=cbind(zz,y)
    ## zz is the matrix with each column containing log L values, rows difft mu, cols difft sigmas 
  }
  maxl=max(exp(zz))
  coord=which(exp(zz)==maxl,arr.ind=TRUE)
  maxlsig=apply(zz,1,max)
  contour(mu,sig,exp(zz),las=3,xlab=expression(mu),ylab=expression(sigma),axes=TRUE,
          main=expression(paste("L(",mu,",",sigma,")",sep="")),...)
  mlx=round(mean(x),2)  # theoretical
  mly=round(sqrt((n-1)/n)*sd(x),2)
  #axis(1,at=c(0:20,mlx),labels=sort(c(0:20,mlx)))
  #axis(2,at=c(0:20,mly),labels=TRUE)
  abline(v=mean(x),lwd=2,col="Green")
  abline(h=sqrt((n-1)/n)*sd(x),lwd=2,col="Red")
  
  # Now find the estimates from the co-ords
  muest=mu[coord[1]]
  sigest=sig[coord[2]]
  
  abline(v=muest, h=sigest)
  return(list(x=x,coord=coord,maxl=maxl))
}





##### Beta distribution

mymlbeta=function(x,alpha,beta,...){  #x sample vector
  na=length(alpha) # number of values in alpha
  nb=length(beta)
  n=length(x) # sample size
  zz=c()    ## initialize a new vector
  lfun=function(x,a,b) log(dbeta(x,shape1=a,shape2=b))   # log lik for beta
  for(j in 1:nb){
    z=outer(x,alpha,lfun,b=beta[j]) # z a matrix 
    # col 1 of z contains lfun evaluated at each x with first value of alpha, 
    # col2 each x with 2nd value of a 
    # all with b=beta[j]
    y=apply(z,2,sum)
    # y is a vector filled with log lik values, 
    # each with a difft alpha and all with the same sig[j]
    zz=cbind(zz,y)
    ## zz is the matrix with each column containing log L values, rows difft alpha, cols difft betas 
  }
  maxl=max(exp(zz))    # max lik
  coord=which(exp(zz)==maxl,arr.ind=TRUE)  # find the co-ords of the max
  aest=alpha[coord[1]] # mxlik estimate of alpha
  best=beta[coord[2]]
  contour(alpha,beta,exp(zz),las=3,xlab=expression(alpha),ylab=expression(beta),axes=TRUE,
          main=expression(paste("L(",alpha,",",beta,")",sep="")),...)
  
  abline(v=aest, h=best)
  points(aest,best,pch=19)
  axis(4,best,round(best,2),col="Red")
  axis(3,aest,round(aest,2),col="Red")
  return(list(x=x,coord=coord,maxl=maxl,maxalpha=aest,maxbeta=best))
}












# Task 1

getwd()



# Task 2

y = c(3, 3, 4, 3, 4, 5, 5, 4)
n = 20;
p = seq(0,1,length=1000);

inx = 0
for (i in 1:length(p)) {

  likelihood[i] = 1
  for (j in 1:length(y)){
    likelihood[i] = likelihood[i] * dbinom(y[j], size = n, prob = p[i])
  }
}

p[which(max(likelihood)==likelihood)]

y = c(3, 3, 4, 3, 4, 5, 5, 4); param = seq(0,1,length=1000); 
logbin=function(x,param) log(dbinom(x, prob = param, size =20))
mymaxlik(y, param ,lfun = logbin  ,xlab = expression(pi), main="Binomial", cex.main = 2)


    


  
# Task 3

x = c(4, 6, 7, 6, 5); param = seq(00,10,length=1000); 
logpoiss=function(x,param) log(dpois(x,lambda=param)) 
mymaxlik(x, param ,lfun = logpoiss  ,xlab = expression(lambda), main="Poisson", cex.main = 2)


myNRML(x0 = 2, delta = 0.000001,
       llik = function(x) log(dpois(4,x)*dpois(6,x)*dpois(7,x)*dpois(6,x)*dpois(5,x)),
       xrange=c(0,20), parameter = "lambda" )




# Task 4

x = c(2, 4); n = c(6, 10); param = seq(0, 1, length = 1000); 
logbin=function(x,param) log(dbinom(x[1], prob = param, size = n[1])*dbinom(x[2], prob = param, size = n[2])) 
mymaxlik(x, param ,lfun = logbin  ,xlab = expression(pi), main = "Binomial", cex.main = 1)



# Task 5

logbinpois = function(theta1, theta2) log(dbinom(4,size=20,prob=theta1)) + log(dpois(4,lambda=theta2))
maxlikg2 (theta1 = seq (0,1,length=1000), theta2 = seq(0,10,length=1000), nlevels = 20)  



# Task 6

mymlnorm(x=c(10,12,13,15,12,11,10),mu=seq(10,14,length=1000),sig=seq(0.5,4,length=1000),lwd=2,labcex=1)



# Task 7

windows()
layout(matrix(1:12, nr = 3, nc = 4, byrow = TRUE))
sam = rbeta(30, shape1 = 3, shape2 = 4)

z = c()

for(i in 1:12){
  x = sample(sam, 20, replace = TRUE)
  w = mymlbeta(x, alpha = seq(1,12,length=100), beta=seq(1,20,length=100),lwd=2,labcex=1,col="steelblue")
  points(3, 4, col = "Red")
  abline(v = 3, h = 4, col = "Red")
  z <- rbind(z, c(w$maxalpha,w$maxbeta))
}


Distance = apply(z-c(3,4),1,function(x) sqrt(sum(x^2)) )
plot(Distance)





# Task 9

##### Gamma distribution

mymlgamma = function(x, shape , scale,...){  #x sample vector
  na = length(shape) # number of values in alpha
  nb = length(scale)
  n = length(x) # sample size
  zz = c()    ## initialize a new vector
  lfun = function(x, a, b) log(dgamma(x, shape = a, scale = b))   # log lik for gamma
  for(j in 1:nb){
    z = outer(x, shape, lfun, b = scale[j]) # z a matrix 
    # col 1 of z contains lfun evaluated at each x with first value of alpha, 
    # col2 each x with 2nd value of a 
    # all with b=scale[j]
    y = apply(z, 2, sum)
    # y is a vector filled with log lik values, 
    # each with a difft alpha and all with the same sig[j]
    zz = cbind(zz, y)
    ## zz is the matrix with each column containing log L values, rows difft alpha, cols difft betas 
  }
  maxl = max(exp(zz))    # max lik
  coord = which(exp(zz)==maxl,arr.ind=TRUE)  # find the co-ords of the max
  aest = shape[coord[1]] # mxlik estimate of shape
  best = scale[coord[2]]
  contour(shape,scale,exp(zz),las=3,xlab=expression(shape),ylab=expression(scale),axes=TRUE,
          main=expression(paste("L(",shape,",",scale,")",sep="")),...)
  
  abline(v = aest, h = best)
  points(aest, best, pch=19)
  axis(4, best, round(best,2), col="Red")
  axis(3, aest, round(aest,2), col="Red")
  return(list(x = x, coord = coord, maxl = maxl,maxshape = aest, maxscale = best))
}


windows()
w = mymlgamma(x, shape = seq(3,12,length=100), scale=seq(0.01,0.15,length=100),lwd=2,
             labcex=1,col="steelblue")


