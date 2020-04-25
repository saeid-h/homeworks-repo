
#Task 1
dird="F:/Google Drive - Saied/Courses/02 OU/11 Fundamentals of Engineering Statistical Analysis/02 Labs/05 Lab 5/"
setwd=dird
getwd()


#Task 2
mybin=function(iter=100,n=10, p=0.7){ 
  # make a matrix to hold the samples
  #initially filled with NA's
  sam.mat=matrix(NA,nr=n,nc=iter, byrow=TRUE)
  #Make a vector to hold the number of successes in each trial
  succ=c()
  for( i in 1:iter){
    #Fill each column with a new sample
    sam.mat[,i]=sample(c(1,0),n,replace=TRUE, prob=c(p,1-p))
    #Calculate a statistic from the sample (this case it is the sum)
    succ[i]=sum(sam.mat[,i])
  }
  #Make a table of successes
  succ.tab=table(factor(succ,levels=0:n))
  #Make a barplot of the proportions
  barplot(succ.tab/(iter), col=rainbow(n+1), main="Binomial simulation", xlab="Number of successes")
  succ.tab/iter
}
mybin(iter=10,n=10, p=0.7)

mybin(iter=100,n=10, p=0.7)

mybin(iter=200,n=10, p=0.7)

mybin(iter=500,n=10, p=0.7)

mybin(iter=1000,n=10, p=0.7)

mybin(iter=10000,n=10, p=0.7)

success=c()
for( i in 1:10){
  success[i]=dbinom(i,10,0.7)}
#Make a barplot of the proportions
barplot(success, col=rainbow(11), 
        main="Binomial simulation iteration=10000",
        xlab="Number of successes")

#Task 3
#sample() function for a bag of 20 marbles, 12 white ("1") and 8 black "0". size n=5 without replacement
marbles=rep(c("w","B"),c(12,8))
sample(marbles,size=5,prob=rep(c(1/20),c(20)),replace = FALSE)
sample(marbles,size=5,prob=rep(c(1/20),c(20)),replace = TRUE)



myhyper=function(iter=100,N=20,r=12,n=5){
  # make a matrix to hold the samples
  #initially filled with NA's
  sam.mat=matrix(NA,nr=n,nc=iter, byrow=TRUE)
  #Make a vector to hold the number of successes over the trials
  succ=c()
  for( i in 1:iter){
    #Fill each column with a new sample
    sam.mat[,i]=sample(rep(c(1,0),c(r,N-r)),n,replace=FALSE)
    #Calculate a statistic from the sample (this case it is the sum)
    succ[i]=sum(sam.mat[,i])
  }
  #Make a table of successes
  succ.tab=table(factor(succ,levels=0:n))
  #Make a barplot of the proportions
  barplot(succ.tab/(iter), col=rainbow(n+1), main="HYPERGEOMETRIC simulation", xlab="Number of successes")
  succ.tab/iter
}

windows()
myhyper(iter=100,n=5, N=20,r=12)
myhyper(iter=200,n=5, N=20,r=12)
myhyper(iter=500,n=5, N=20,r=12)
myhyper(iter=1000,n=5, N=20,r=12)
myhyper(iter=10000,n=5, N=20,r=12)


success=c()
for( i in 1:5){
  success[i]=dhyper(i,12,8,5)}
#Make a barplot of the proportions
barplot(success, col=rainbow(11), 
        main="Binomial simulation iteration=10000",
        xlab="Number of successes")


#Task 4
mysample=function(n, iter=10,time=0.5){
  for( i in 1:iter){
    #make a sample
    s=sample(1:10,n,replace=TRUE)
    # turn the sample into a factor
    sf=factor(s,levels=1:10)
    #make a barplot
    barplot(table(sf)/n,beside=TRUE,col=rainbow(10), 
            main=paste("Example sample()", " iteration ", i, " n= ", n,sep="") ,
            ylim=c(0,0.2)
    )
    
    #release the table
    Sys.sleep(time)
  }
}

mysample(n=1000, iter=30,time=1)


#Task 5
choose(8,4)

#Pois
dpois(4,2)
1-dpois(4,2)


#NegBinom
dnbinom(7,3,0.4)
#Binom
mybin=function(y,n,p){
       choose(n,y)*p^y*(1-p)^(n-y)
   }
mybin(1,15,0.4)+mybin(2,15,0.4)+mybin(3,15,0.4)+
  mybin(4,15,0.4)+mybin(5,15,0.4)+mybin(6,15,0.4)+
  mybin(7,15,0.4)+mybin(8,15,0.4)



