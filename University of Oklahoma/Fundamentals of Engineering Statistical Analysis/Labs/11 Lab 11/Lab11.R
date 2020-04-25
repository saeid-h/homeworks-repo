#Lab 11
#Confidence Intervals
#set.seed(20);d=rnorm(25, mean=5, sd=0.05)
#dput(round(d,4))

d=c(5.0581, 4.9707, 5.0893, 4.9334, 4.9777, 5.0285, 4.8555, 4.9565, 
4.9769, 4.9722, 4.999, 4.9925, 4.9686, 5.0662, 4.9239, 4.9781, 
5.0485, 5.0014, 4.9957, 5.0195, 5.0118, 4.9928, 5.0361, 5.0185, 
4.9879)
t=qt(0.975,24)
ci=c()
ci[1]=mean(d)-t*sd(d)/sqrt(25)
ci[2]=mean(d)+t*sd(d)/sqrt(25)
ci

ci=t.test(d,conf.level=0.95)$conf.int
ci



set.seed(35);sam=rnorm(30,mean=20,sd=5)
t=qt(0.975,29)
ci=c()
ci[1]=mean(sam)-t*sd(sam)/sqrt(30)
ci[2]=mean(sam)+t*sd(sam)/sqrt(30)
ci




### Fish
#set.seed(50);blue=rnorm(20,mean=20,sd=3)
#blue=round(blue,2)
#dput(blue)

blue=c(21.65, 17.48, 20.1, 21.57, 14.82, 19.17, 21.08, 18.23, 22.93, 
15.66, 20.89, 21.66, 18.5, 20.59, 18.63, 18.91, 19.53, 17.7, 
16.5, 19.03)

#set.seed(50);snapper=rnorm(15,mean=30,sd=3)
#snapper=round(snapper,2)
#dput(snapper)

snapper=c(31.65, 27.48, 30.1, 31.57, 24.82, 29.17, 31.08, 28.23, 32.93, 
25.66, 30.89, 31.66, 28.5, 30.59, 28.63)

t.test(snapper,blue)
t.test(snapper,blue,conf.level=0.20)




## BOOTSTRAP ###

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
#axis(1,pte,labels=TRUE)
segments(ci[1],0,ci[2],0,lwd=4)      #Make the segment for the ci
text(ci[1],0,paste("(",round(ci[1],2),sep=""),col="Red",cex=3)
text(ci[2],0,paste(round(ci[2],2),")",sep=""),col="Red",cex=3)

# plot the point estimate 1/2 way up the density
text(pte,max(para$density)/2,round(pte,2),cex=3)

return(list(ci=ci,fun=fun,x=x))# Some output to use if necessary
}

myboot(iter=10000,x=sam,fun="mean",alpha=0.05)
ci


#####################################
set.seed(45);sam=rnorm(30,mean=20,sd=5)
xsq1=qchisq(0.975,29)
xsq2=qchisq(0.025,29)

ci=c()
ci[1]=29*var(sam)/xsq1
ci[2]=29*var(sam)/xsq2
ci
 myboot(iter=10000,x=sam,fun="var",alpha=0.05)



#### Find samples that give confidence intervals for the pop mean such that
#   mu is not contained within the ci

# Say we want 10 samples that meet the above criterion

outside=function(nsam=10, n=30,mn=20,std=5,...){
i=1  #initialize counters
j=0
T=c() # create a NULL vector
repeat{  # This will repeat until break()
j=j+1   # j=1,2,3 ...
sam=rnorm(n,mean=mn,sd=std)  # each loop gives a new sample
ci=t.test(sam,...)$conf.int   # create a ci from t.test
if((mn<ci[1] |mn>ci[2] )& i<=nsam) {T=cbind(T,sam);i=i+1}
#store those sams that produce cis not containing mn
if(i>nsam) {
T.test=apply(T,2,function(x) t.test(x)$conf.int)
return(list(T=T,j=j,i=i,pout=i/j*100, T.test=T.test))
# return BEFORE break
break()
}
}
}
outside(nsam=9,mn=30,n=20,std=8,T.test=T.test)

M=c()
for(k in 1:1000){

tt=outside(nsam=9,mn=30,n=50,std=8)

M=c(M,tt$pout)

}
plot(M)
hist(M)
summary(M)
