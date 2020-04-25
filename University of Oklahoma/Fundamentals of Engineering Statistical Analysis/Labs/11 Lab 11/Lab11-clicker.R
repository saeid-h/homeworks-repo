# Lab 11
# assume you do not know the pop mean and std dev
set.seed(101); x=rnorm(30,mean=20,sd=5)

# For ci sigma^2 use Lab 11 formulae
qchisq(0.025,29)
qchisq(1-0.025,29)