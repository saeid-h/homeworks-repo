### Task #1
getwd()

### Task #2
# one sample t-test
set.seed(55);x1=rnorm(30,mean=25,sd=5)
boxplot(x1, main="Sample x1")

t.test(x1,mu=22)
ci=t.test(x1,mu=22)$conf.int
ci

pvalue=t.test(x1,mu=22)$p.value
pvalue


t.test(x1,mu=23)
ci=t.test(x1,mu=23)$conf.int
ci

pvalue=t.test(x1,mu=23)$p.value
pvalue


t.test(x1,mu=24)
ci=t.test(x1,mu=24)$conf.int
ci

pvalue=t.test(x1,mu=24)$p.value
pvalue


t.test(x1,mu=25)
ci=t.test(x1,mu=25)$conf.int
ci

pvalue=t.test(x1,mu=25)$p.value
pvalue


t.test(x1,mu=26)
ci=t.test(x1,mu=26)$conf.int
ci

pvalue=t.test(x1,mu=26)$p.value
pvalue

abline(h=c(ci,mean(x1)),col=c("Red","Red","Green"))



#tcalc
tcalc=(mean(x1)-24)/(sd(x1)/sqrt(30))
tcalc

#### FUNCTION for Pvalues 
# Display P-value areas
mypvalue=function(t0,xmax=4,n=20, alpha=0.05){
  #calculate alpha/2
  va=round(pt(-t0,df=n-1),4)
  pv=2*va
  
  # plot the t dist
  curve(dt(x,df=n-1),xlim=c(-xmax,xmax),ylab="T Density",xlab=expression(t),
        main=substitute(paste("P-value=", pv, " alpha=", alpha)))
  
  
  # set up points on the polygon to the right
  xcurve=seq(t0,xmax,length=1000)
  ycurve=dt(xcurve,df=n-1)
  
  # set up points to the left
  xlcurve=seq(-t0,-xmax,length=1000)
  ylcurve=dt(xcurve,df=n-1)
  
  # Shade in the polygon defined by the line segments
  polygon(c(t0,xcurve,xmax),c(0,ycurve,0),col="green")
  polygon(c(-t0,xlcurve,-xmax),c(0,ylcurve,0),col="green")
  
  # make quantiles
  q=qt(1-alpha/2,n-1)
  abline( v=c(q,-q),lwd=2) # plot the cut off t value 
  axis(3,c(q,-q),c(expression(abs(t[alpha/2])),expression(-abs(t[alpha/2]))))
  
  
  # Annotation
  text(0.5*(t0+xmax),max(ycurve),substitute(paste(area, "=",va)))
  text(-0.5*(t0+xmax),max(ycurve),expression(area))
  
  return(list(q=q,pvalue=pv))
}
mypvalue(tcalc,n=30,alpha=0.05)
tcalc


### bootstrap pvalues
bootpval<-function(x,conf.level=0.95,iter=3000,mu0=0, test="two"){
  n=length(x)
  y=x-mean(x)+mu0  # transform the data so that it is centered at the NULL
  rs.mat<-c()    #rs.mat will become a resample matrix -- now it is an empty vector
  xrs.mat<-c()
  for(i in 1:iter){ # for loop - the loop will go around iter times
    rs.mat<-cbind(rs.mat,sample(y,n,replace=TRUE)) #sampling from y cbind -- column bind -- binds the vectors together by columns
    xrs.mat<-cbind(xrs.mat,sample(x,n,replace=TRUE)) #sampling from x cbind -- column bind -- binds the vectors together by columns
    
  }
  
  tstat<-function(z){ # The value of t when the NULL is assumed true (xbar-muo)/z/sqrt(n)
    sqrt(n)*(mean(z)-mu0)/sd(z)
  }
  
  tcalc=tstat(x) # t for the data collected
  ytstat=apply(rs.mat,2,tstat) # tstat of resampled y's, ytstat is a vector and will have iter values in it
  xstat=apply(xrs.mat,2,mean)  # mean of resampled x's
  alpha=1-conf.level # calculating alpha
  ci=quantile(xstat,c(alpha/2,1-alpha/2))# Nice way to form a confidence interval
  pvalue=ifelse(test=="two",length(ytstat[ytstat>abs(tcalc) | ytstat < -abs(tcalc)])/iter,
                ifelse(test=="upper",length(ytstat[ytstat>tcalc])/iter,
                       length(ytstat[ytstat<xstat])/iter))
  
  h=hist(ytstat,plot=FALSE)
  mid=h$mid
  if(test=="two"){
    ncoll=length(mid[mid<= -abs(tcalc)])
    ncolr=length(mid[mid>=  abs(tcalc)])
    col=c(rep("Green",ncoll),rep("Gray",length(mid)-ncoll-ncolr),rep("Green",ncolr))
  }
  if(test=="upper"){
    ncolr=length(mid[mid>=  abs(tcalc)])
    col=c(rep("Gray",length(mid)-ncolr),rep("Green",ncolr))
  }
  
  if(test=="lower"){
    ncoll=length(mid[mid<=  -abs(tcalc)])
    col=c(rep("Green",ncoll),rep("Gray",length(mid)-ncoll))
  }
  hist(ytstat,col=col,freq=FALSE,las=1,main="",xlab=expression(T[stat]))
  #segments(ci[1],0,ci[2],0,lwd=2)
  pround=round(pvalue,4)
  title(substitute(paste(P[value],"=",pround)))
  return(list(pvalue=pvalue,tcalc=tcalc,n=n,x=x,test=test,ci=ci))
}


bootmu22=bootpval(x=x1,mu0=22,test="two")
bootmu22

bootmu23=bootpval(x=x1,mu0=23,test="two")
bootmu23

bootmu24=bootpval(x=x1,mu0=24,test="two")
bootmu24

bootmu25=bootpval(x=x1,mu0=25,test="two")
bootmu25

bootmu26=bootpval(x=x1,mu0=26,test="two")
bootmu26



### Task #3
######### End Bootstrap pvalues
## Make some fake data

set.seed(30);x=rnorm(15,mean=10,sd=7)   # fake data to understand t-tests
set.seed(40); y=rnorm(20,mean=12,sd=4)
boxplot(list(x=x,y=y)) # boxplot of a list

## Equal variances?
var.test(x,y)

## t.test for NULL=muy-mux=0
t.test(x,y, mu=0,var.equal=FALSE)

## t.test for NULL=muy-mux=2
t.test(x,y,mu=2,var.equal=FALSE)

### Task #4
set.seed(30);x=rnorm(15,mean=10,sd=7)   # fake data to understand t-tests
set.seed(40);y=rnorm(20,mean=12,sd=4)

var.test(x,y)

## t.test for NULL=muy-mux=0
t.test(x,y, mu=0,var.equal=FALSE)

## t.test for NULL=muy-mux=5
t.test(x,y,mu=5,var.equal=FALSE)



### Task #5
## Bootstrap interval for a two sample test
boot2pval<-function(x1,x2,conf.level=0.95,iter=3000,mudiff=0, test="two"){
  n1=length(x1)
  n2=length(x2)
  y1=x1-mean(x1)+mean(c(x1,x2))  # transform the data so that it is centered at the NULL
  y2=x2-mean(x2)+mean(c(x1,x2))
  y1rs.mat<-c()    #rs.mat will be come a resample matrix -- now it is an empty vector
  x1rs.mat<-c()
  y2rs.mat<-c()
  x2rs.mat<-c()
  for(i in 1:iter){ # for loop - the loop will go around iter times
    y1rs.mat<-cbind(y1rs.mat,sample(y1,n1,replace=TRUE)) #sampling from y cbind -- column bind -- binds the vectors together by columns
    y2rs.mat<-cbind(y2rs.mat,sample(y2,n2,replace=TRUE))
    
  }
  x1rs.mat<-y1rs.mat+mean(x1)-mean(c(x1,x2))
  x2rs.mat<-y2rs.mat+mean(x2)-mean(c(x1,x2))
  
  xbar1=mean(x1)
  xbar2=mean(x2)
  sx1sq=var(x1)
  sx2sq=var(x2)
  
  tcalc=(xbar1-xbar2-mudiff)/sqrt(sx1sq/n1+sx2sq/n2)
  
  sy1sq=apply(y1rs.mat,2,var)
  sy2sq=apply(y2rs.mat,2,var) 
  y1bar=apply(y1rs.mat,2,mean)
  y2bar=apply(y2rs.mat,2,mean)
  
  tstat=(y1bar-y2bar-mudiff)/sqrt(sy1sq/n1+sy2sq/n2)
  
  
  alpha=1-conf.level # calculating alpha
  #ci=quantile(xstat,c(alpha/2,1-alpha/2))# Nice way to form a confidence interval
  pvalue=ifelse(test=="two",length(tstat[tstat>abs(tcalc) | tstat < -abs(tcalc)])/iter,
                ifelse(test=="upper",length(tstat[tstat>tcalc])/iter,
                       length(ytstat[tstat<tcalc])/iter))
  
  h=hist(tstat,plot=FALSE)
  mid=h$mid
  if(test=="two"){
    ncoll=length(mid[mid<= -abs(tcalc)])
    ncolr=length(mid[mid>=  abs(tcalc)])
    col=c(rep("Green",ncoll),rep("Gray",length(mid)-ncoll-ncolr),rep("Green",ncolr))
  }
  hist(tstat,col=col,freq=FALSE)
  #segments(ci[1],0,ci[2],0,lwd=2)
  
  return(list(pvalue=pvalue))
  #return(list(pvalue=pvalue,tcalc=tcalc,n=n,x=x,test=test,ci=ci))
}

set.seed(30);x=rnorm(15,mean=10,sd=7)   
set.seed(40);y=rnorm(20,mean=12,sd=4)

### mudiff=0
boot2pval(x1=x,x2=y)

### mudiff=2
boot2pval(x1=x,x2=y,mudiff=2)


### Task #6

set.seed(30);x=rnorm(15,mean=10,sd=4)   
set.seed(40);y=rnorm(20,mean=12,sd=4)

### mudiff=0
boot2pval(x1=x,x2=y)

### mudiff=5
boot2pval(x1=x,x2=y,mudiff=5)



### Task #7