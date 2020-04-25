# This file is created for Assignment 2 on May 28, 2016




# Q7

p = c(.09, .30, .37, .2, .04)
sum(p)



# Q8

p = c(17, 10, 11, 11, 10, 10, 7, 5, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0.5, 0.5) / 100
y = c(0:20)
names(p) <- as.character(y) 

Mu = sum(y * p)
variance = sum( (y - Mu)^2 * p)

Mu
variance

SD = sqrt(variance)
Mu - 2 * SD
Mu + 2 * SD



# Q9

p = 0.7
q = 1 - p
y = 10
n = 25
choose(n,y) * p^y * q^(n-y)
dbinom(10, size = 25, prob = 0.7)
sum(dbinom(1:5, size = 25, prob = 0.7))

y = c(1:25)
py = dbinom(y, size = 25, prob = 0.7)
Mu = sum( y * py)
variance = sum( (y - Mu)^2 * py)
SD = sqrt(variance)



# Q10

dmultinom(rep(5,10), 50, rep(0.1,10))
dbinom(0,50,0.1) + dbinom(1,50,0.1)




# Q12

choose(8,4)*choose(201,6)/choose(209,10)




# Q13

1 - sum(dpois(1:3, lambda = 0.03))



# Q16

1 - pnorm(45, mean = 50, sd = 3.2)
pnorm(55, mean = 50, sd = 3.2)
pnorm(52, mean = 50, sd = 3.2) - pnorm(51, mean = 50, sd = 3.2)


# Q17

pnorm(700, mean = 605, sd = 185) - pnorm(500, mean = 605, sd = 185)
pnorm(500, mean = 605, sd = 185) - pnorm(400, mean = 605, sd = 185)
pnorm(850, mean = 605, sd = 185)
qnorm(0.9, mean = 605, sd = 185)

