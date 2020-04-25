# This file is created fot lab no. 6

# Task 1

getwd()



# Task 2

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dnorm(x, mean=10,sd=4),xlim=c(-2,22))
curve(dnorm(x, mean=10,sd=2),xlim=c(4,16))
curve(dnorm(x, mean=5,sd=10),xlim=c(-25,35))
curve(dnorm(x, mean=10,sd=0.5),xlim=c(8,12))


windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

m = 0
s = 1
L = m - 3*s
H = m + 3*s
pl = 2
ph = H
curve(dnorm(x, mean = m,sd = s), xlim = c(L,H))
xcurve = seq(pl, ph, length = 1000)
ycurve = dnorm(xcurve,mean = m,sd = s)
polygon(c(pl,xcurve,ph),c(0,ycurve,0),col="Red")
prob = pnorm(ph, mean = m, sd = s)
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

m = 4
s = 2
L = m - 3*s
H = m + 3*s
pl = 1
ph = 5
curve(dnorm(x, mean = m,sd = s), xlim = c(L,H))
xcurve = seq(pl, ph, length = 1000)
ycurve = dnorm(xcurve,mean = m,sd = s)
polygon(c(pl,xcurve,ph),c(0,ycurve,0),col="Red")
prob = pnorm(ph, mean = m, sd = s) - pnorm(pl, mean = m, sd = s)
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

m = 10
s = 4
L = m - 3*s
H = m + 3*s
pl = L
ph = 10
curve(dnorm(x, mean = m,sd = s), xlim = c(L,H))
xcurve = seq(pl, ph, length = 1000)
ycurve = dnorm(xcurve,mean = m,sd = s)
polygon(c(pl,xcurve,ph),c(0,ycurve,0),col="Red")
prob = pnorm(ph, mean = m, sd = s) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


m = -2
s = 0.5
L = m - 3*s
H = m + 3*s
pl = -3
ph = -2
curve(dnorm(x, mean = m,sd = s), xlim = c(L,H))
xcurve = seq(pl, ph, length = 1000)
ycurve = dnorm(xcurve,mean = m,sd = s)
polygon(c(pl,xcurve,ph),c(0,ycurve,0),col="Red")
prob = pnorm(ph, mean = m, sd = s) - pnorm(pl, mean = m, sd = s) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))



# Task 3

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dgamma(x, shape=1,scale=1),xlim=c(0,5))
curve(dgamma(x, shape=3,scale=1),xlim=c(0,12))
curve(dgamma(x, shape=5,scale=1),xlim=c(0,10))

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)


curve(dgamma(x, shape=3,scale=2),xlim=c(0,20))
xcurve=seq(2,5,length=1000)
ycurve = dgamma(xcurve, shape=3,scale=2)
polygon(c(2,xcurve,5),c(0,ycurve,0),col="Red")
prob = pgamma(5, shape=3,scale=2) - pgamma(2, shape=3,scale=2) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


curve(dgamma(x, shape=6,scale=3),xlim=c(0,6))
xcurve=seq(1,4,length=1000)
ycurve = dgamma(xcurve, shape=6,scale=3)
polygon(c(1,xcurve,4),c(0,ycurve,0),col="Red")
prob = pgamma(4, shape=6,scale=3) - pgamma(1, shape=6,scale=3) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dgamma(x, shape=2,scale=4),xlim=c(0,30))
xcurve=seq(3,6,length=1000)
ycurve = dgamma(xcurve, shape=2,scale=4)
polygon(c(3,xcurve,6),c(0,ycurve,0),col="Red")
prob = pgamma(6, shape=2,scale=4) - pgamma(3, shape=2,scale=4) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


# Task 4

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dchisq(x, df=1),xlim=c(0,1))
curve(dchisq(x, df=2),xlim=c(0,6))
curve(dchisq(x, df=4),xlim=c(0,15))
curve(dchisq(x, df=20),xlim=c(0,40))

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dchisq(x, df=2),xlim=c(0,6))
xcurve=seq(2,4,length=1000)
ycurve = dchisq(xcurve, df=2)
polygon(c(2,xcurve,4),c(0,ycurve,0),col="Red")
prob = pchisq(4, df=2) - pchisq(2, df=2) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dchisq(x, df=3),xlim=c(0,10))
xcurve=seq(3,5,length=1000)
ycurve = dchisq(xcurve, df=3)
polygon(c(3,xcurve,5),c(0,ycurve,0),col="Red")
prob = pchisq(5, df=3) - pchisq(3, df=3) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dchisq(x, df=20),xlim=c(0,40))
xcurve=seq(10,21,length=1000)
ycurve = dchisq(xcurve, df=20)
polygon(c(10,xcurve,21),c(0,ycurve,0),col="Red")
prob = pchisq(21, df=20) - pchisq(10, df=20) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


# Task 5

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dweibull(x, shape=2,scale=4),xlim=c(0,15))
curve(dweibull(x, shape=1,scale=2),xlim=c(0,10))
curve(dweibull(x, shape=5,scale=10),xlim=c(0,20))
curve(dweibull(x, shape=4,scale=1),xlim=c(0,2))


windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dweibull(x, shape=2,scale=4),xlim=c(0,15))
xcurve=seq(2,5,length=1000)
ycurve = dweibull(xcurve, shape=2,scale=4)
polygon(c(2,xcurve,5),c(0,ycurve,0),col="Red")
prob = pweibull(5, shape=2,scale=4) - pweibull(2, shape=2,scale=4)
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


curve(dweibull(x, shape=1,scale=2),xlim=c(0,10))
xcurve=seq(2,10,length=1000)
ycurve = dweibull(xcurve, shape=1,scale=2)
polygon(c(2,xcurve,10),c(0,ycurve,0),col="Red")
prob = 1 - pweibull(2, shape=1,scale=2) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


curve(dweibull(x, shape=5,scale=10),xlim=c(0,20))
xcurve=seq(7,12,length=1000)
ycurve = dweibull(xcurve, shape=5,scale=10)
polygon(c(7,xcurve,12),c(0,ycurve,0),col="Red")
prob = pweibull(12, shape=5,scale=10)  - pweibull(7, shape=5,scale=10) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dweibull(x, shape=4,scale=1),xlim=c(0,2))
xcurve=seq(0.5,2,length=1000)
ycurve = dweibull(xcurve, shape=4,scale=1)
polygon(c(0.5,xcurve,2),c(0,ycurve,0),col="Red")
prob = 1  - pweibull(0.5, shape=4,scale=1) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))



# Task 6

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dbeta(x, shape1=1,shape2 = 5),xlim=c(0,1))
curve(dbeta(x, shape1=1,shape2 = 1),xlim=c(0,1))
curve(dbeta(x, shape1=2,shape2 = 2),xlim=c(0,1))
curve(dbeta(x, shape1=5,shape2 = 1),xlim=c(0,1))

windows()
layout(matrix(1:4, nr=2,nc=2))
layout.show(4)

curve(dbeta(x, shape1=1,shape2 = 5),xlim=c(0,1))
xcurve=seq(0.2,1,length=1000)
ycurve = dbeta(xcurve, shape1=1,shape2 = 5)
polygon(c(0.2,xcurve,1),c(0,ycurve,0),col="Red")
prob = 1  - pbeta(0.2, shape1=1,shape2 = 5) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


curve(dbeta(x, shape1=1,shape2 = 1),xlim=c(0,1))
xcurve=seq(0.2,0.6,length=1000)
ycurve = dbeta(xcurve, shape1=1,shape2 = 1)
polygon(c(0.2,xcurve,0.6),c(0,ycurve,0),col="Red")
prob = pbeta(0.6, shape1=1,shape2 = 1)  - pbeta(0.2, shape1=1,shape2 = 1) 
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dbeta(x, shape1=2,shape2 = 2),xlim=c(0,1))
xcurve=seq(0,0.7,length=1000)
ycurve = dbeta(xcurve, shape1=2,shape2 = 2)
polygon(c(0,xcurve,0.7),c(0,ycurve,0),col="Red")
prob = pbeta(0.7, shape1=2,shape2 = 2)  
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))

curve(dbeta(x, shape1=5,shape2 = 1),xlim=c(0,1))
xcurve=seq(0,0.8,length=1000)
ycurve = dbeta(xcurve, shape1=5,shape2 = 1)
polygon(c(0,xcurve,0.8),c(0,ycurve,0),col="Red")
prob = pbeta(0.8, shape1=5,shape2 = 1)   
prob = round(prob,4)
text(locator(1), paste("Area = ", prob, sep=""))


# Task 7
windows()
layout(matrix(1:2, nr=1,nc=2))
layout.show(2)
lambda = 10
curve(dexp(x,rate = lambda),xlim=c(0,5/lambda))
curve(dgamma(x,shape = 1, scale = 1/lambda),xlim=c(0,5/lambda))

