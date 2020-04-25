# This file is created for Lab 9 on May 26th 2016


# Function area


########### bootstrap function ##################

myboot <- function(iter = 10000, x, fun = "mean", alpha = 0.05, dlab = "Normal", ...){  #Notice where the ... is repeated in the code
  n = length(x)   #sample size
  
  y = sample(x, n * iter, replace = TRUE)
  rs.mat = matrix(y, nr = n, nc = iter, byrow = TRUE)
  xstat = apply(rs.mat, 2, fun) # xstat is a vector and will have iter values in it 
  ci = quantile(xstat, c(alpha/2,1-alpha/2))# Nice way to form a confidence interval
  # A histogram follows
  # The object para will contain the parameters used to make the histogram
  para = hist(xstat, freq = FALSE, las = 1,
            main = paste("Histogram of Bootstrap sample statistics","\n",
                         "alpha = ", alpha, ", iter = ", iter, "\n", 
                         "(", dlab, " Distribution)", sep = ""),
            ...)
  
  #mat will be a matrix that contains the data, this is done so that I can use apply()
  mat = matrix(x, nr = length(x), nc = 1, byrow = TRUE)
  
  #pte is the point estimate
  #This uses whatever fun is
  pte=apply(mat, 2, fun)
  abline(v = pte,lwd = 3,col = "Black") # Vertical line
  segments(ci[1], 0, ci[2], 0, lwd=4)      #Make the segment for the ci
  text(ci[1], 0, paste("(",round(ci[1],2),sep=""), col = "Red", cex = 1.5)
  text(ci[2], 0, paste(round(ci[2],2),")",sep=""), col = "Red", cex=1.5)
  
  # plot the point estimate 1/2 way up the density
  text(pte, max(para$density)/2, round(pte,2), cex=2)
  
  Mu = mean(xstat)
  SD = sd(xstat)
  curve(dnorm(x,mean=Mu,sd=SD),add=TRUE,col="Red",lty=2,lwd=3)
  
  return(list(ci=ci,fun=fun,x=x))# Some output to use if necessary
}









# Task 1

getwd()



# Task 2

set.seed(35); 
sam=round(rnorm(20,mean=10,sd=4),2)
unique(sample(sam,20,replace = T))
unique(sample(sam,20,replace = F))
sample(sam,21,replace = F)



# Task 3

windows()
set.seed(39); sam = rnorm (25, mean = 25, sd = 10);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.05, xlab = "mean (x)", col = "Light Blue")
mean(sam)

windows()
set.seed(30); sam = rchisq (20, df = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.05, xlab = "mean (x)", col = "Light Blue")
mean(sam)

windows()
set.seed(40); sam = rgamma (30, shape = 2, scale = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.05, xlab = "mean (x)", col = "Light Blue")
mean(sam)

windows()
set.seed(10); sam = rbeta (30, shape1 = 3, shape2 = 4);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.05, xlab = "mean (x)", col = "Light Blue")
mean(sam)


# ------------------------------

windows()
set.seed(39); sam = rnorm (25, mean = 25, sd = 10);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.2, xlab = "variance (x)", col = "Light Blue")
var(sam)

windows()
set.seed(30); sam = rchisq (20, df = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.2, xlab = "variance (x)", col = "Light Blue")
var(sam)

windows()
set.seed(40); sam = rgamma (30, shape = 2, scale = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.2, xlab = "variance (x)", col = "Light Blue")
var(sam)

windows()
set.seed(10); sam = rbeta (30, shape1 = 3, shape2 = 4);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.2, xlab = "variance (x)", col = "Light Blue")
var(sam)



# Task 4

windows()
sam = c(1,1,1,2,2,2,2,3,3,3,4,4)
myboot(10000, x = sam, fun = function(x) median(x),
       alpha = 0.5, xlab = "median (x)", col = "Light Blue")
median (sam)



# Task 5

windows()
set.seed(39); sam = rnorm (25, mean = 25, sd = 10);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.05, xlab = "mean (x) / median (x)", col = "Light Blue")
mean(sam)/median(sam)

windows()
set.seed(30); sam = rchisq (20, df = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.05, xlab = "mean (x) / median (x)", col = "Light Blue")
mean(sam)/median(sam)

windows()
set.seed(40); sam = rgamma (30, shape = 2, scale = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.05, xlab = "mean (x) / median (x)", col = "Light Blue")
mean(sam)/median(sam)

windows()
set.seed(10); sam = rbeta (30, shape1 = 3, shape2 = 4);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.05, xlab = "mean (x) / median (x)", col = "Light Blue")
mean(sam)/median(sam)


# ---------------------------------------

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
set.seed(39); sam = rnorm (25, mean = 25, sd = 10);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.30, xlab = "mean (x) / median (x)", col = "Light Blue")

set.seed(30); sam = rchisq (20, df = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.30, xlab = "mean (x) / median (x)", col = "Light Blue")

set.seed(40); sam = rgamma (30, shape = 2, scale = 3);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.30, xlab = "mean (x) / median (x)", col = "Light Blue")

set.seed(10); sam = rbeta (30, shape1 = 3, shape2 = 4);
round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x)/median(x),
       alpha = 0.05, xlab = "mean (x) / median (x)", col = "Light Blue")




# Task 6

windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
set.seed(39); sam = rf (20, df1 = 25, df2 = 10);round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.20, xlab = "mean (x)", col = "Light Blue", dlab = "F")

set.seed(39); sam = rcauchy (20);round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.20, xlab = "mean (x)", col = "Light Blue", dlab = "Cauchy")

set.seed(39); sam = rlnorm (20);round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.20, xlab = "mean (x)", col = "Light Blue", dlab = "Log Normal")

set.seed(39); sam = rpois (20, 10);round(sam, 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = 0.20, xlab = "mean (x)", col = "Light Blue", dlab = "Poisson")



windows()
layout(matrix(1:4,nr=2,nc=2,byrow = TRUE))
set.seed(39); sam = rf (20, df1 = 25, df2 = 10);round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.20, xlab = "variance (x)", col = "Light Blue", dlab = "F")

set.seed(39); sam = rcauchy (20);round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.20, xlab = "variance (x)", col = "Light Blue", dlab = "Cauchy")

set.seed(39); sam = rlnorm (20);round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.20, xlab = "variance (x)", col = "Light Blue", dlab = "Log Normal")

set.seed(39); sam = rpois (20, 10);round(sam, 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = 0.20, xlab = "variance (x)", col = "Light Blue", dlab = "Poisson")



# Task 7

windows()
alpha = 0.05; n = 20
set.seed(68); sam = rnorm(n, mean = 10, sd = 4)
myboot(10000, x = sam, fun = function(x) sd(x),
       alpha = alpha, xlab = "Standards Deviation (x)", col = rainbow(15), dlab = "Normal")

windows()
alpha = 0.05; n = 20
set.seed(68); sam = rnorm(n, mean = 10, sd = 4)
myboot(10000, x = sam, fun = function(x) IQR(x),
       alpha = alpha, xlab = "IQR (x)", col = rainbow(15), dlab = "Normal")


windows()
alpha = 0.05; n = 20
set.seed(68); sam = rnorm(n, mean = 10, sd = 4)
myboot(10000, x = sam, fun = function(x) mean(x),
       alpha = alpha, xlab = "mean (x)", col = rainbow(15), dlab = "Normal")
za = qnorm(1-alpha/2, mean = 0, sd = 1)
L = round(mean(sam) - za * sqrt(var(sam)/n), 2)
U = round(mean(sam) + za * sqrt(var(sam)/n), 2)
L; mean(sam); U


# Task 8

windows()
alpha = 0.05; n = 100
set.seed(68); sam = rf(n, mean = 10, sd = 4)
myboot(10000, x = sam, fun = function(x) var(x),
       alpha = alpha, xlab = "Variance (x)", col = rainbow(15), dlab = "F")


