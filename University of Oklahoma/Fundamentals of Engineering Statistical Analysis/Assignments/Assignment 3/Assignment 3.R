# Assignment 3



# Q1

data = read.csv("PHISHING.csv")
head(data)
beta = mean(data$INTTIME)
1 - pexp(120, rate = 1/beta)
1 - pexp(120, rate = 1/95)




# Q2

Mu = 3 * 0.07
Var = 3 * 0.07^2

Mu - 3*Var
Mu + 3*Var



