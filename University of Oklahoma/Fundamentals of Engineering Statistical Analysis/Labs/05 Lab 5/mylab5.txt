# This file created to submit as lab work

# Function area: I added the functions here.

source("lab5-hypergeometric.R")
source("lab5.R")



# Task 1

getwd()



# Task 2

for ( i in c(100,200,500,1000,10000)){
  windows()
  mybin(iter=i,n=10, p=0.7)
}

a = round(dbinom(c(0:10),10,0.7),3)
names(a)<-c(0:10)
a
mybin(iter=1000,n=10, p=0.7)



# Task 3

sample(c(rep(1,12),rep(0,8)),size=5, prob = rep(1/20,20), replace=F)
sample(c(rep(1,12),rep(0,8)),size=5, prob = rep(1/20,20), replace=T)

for ( i in c(100,200,500,1000,10000)){
  windows()
  myhyper(iter=i,N=20,r=12,n=5)
}



# Task 4

mysample(n=1000, iter=30,time=1)



# Task 5

choose(8,2)

1 - dpois(4,lambda = 2)

dnbinom(x= 10-3,size = 3, prob = 0.4)

sum(dbinom(x=0:8,size = 15,prob = 0.4))


# Task 7

mydnbinom = function(y = 10, r = 3, p = 0.4){
 
  choose(y-1,r-1) * p^r * (1-p)^(y-r)
}

mydnbinom(10,3,0.4)


