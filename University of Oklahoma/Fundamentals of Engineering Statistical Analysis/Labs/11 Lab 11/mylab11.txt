# This file is created for Lab 11 on June 01, 2016










# Task 1

getwd()



# Task 2

d=c(5.0581, 4.9707, 5.0893, 4.9334, 4.9777, 5.0285, 4.8555, 4.9565, 
    4.9769, 4.9722, 4.999, 4.9925, 4.9686, 5.0662, 4.9239, 4.9781, 
    5.0485, 5.0014, 4.9957, 5.0195, 5.0118, 4.9928, 5.0361, 5.0185, 
    4.9879)


alpha = 1 - 0.95
t = qt(1-alpha/2,24)
ci=c()
ci[1] = mean(d)-t*sd(d)/sqrt(25)
ci[2] = mean(d)+t*sd(d)/sqrt(25)
ci
ci = t.test(d, conf.level= 1 - alpha)$conf.int
ci

dalpha = 1 - 0.90
t = qt(1-alpha/2,24)
ci=c()
ci[1] = mean(d)-t*sd(d)/sqrt(25)
ci[2] = mean(d)+t*sd(d)/sqrt(25)
ci
ci = t.test(d, conf.level = 1 - alpha)$conf.int
ci

alpha = 1 - 0.80
t = qt(1-alpha/2,24)
ci=c()
ci[1] = mean(d)-t*sd(d)/sqrt(25)
ci[2] = mean(d)+t*sd(d)/sqrt(25)
ci
ci = t.test(d, conf.level = 1 - alpha)$conf.int
ci

alpha = 1 - 0.50
t = qt(1-alpha/2,24)
ci=c()
ci[1] = mean(d)-t*sd(d)/sqrt(25)
ci[2] = mean(d)+t*sd(d)/sqrt(25)
ci
ci = t.test(d, conf.level = 1 - alpha)$conf.int
ci


t.test(d, conf.level = 0.95)$conf.int
t.test(d, conf.level = 0.90)$conf.int
t.test(d, conf.level = 0.80)$conf.int
t.test(d, conf.level = 0.50)$conf.int

w = t.test(d, conf.level = 0.80)
w$conf.int


alpha = 1 - 0.95
n = length(d) 
ci = c()
chisql = qchisq(1 - alpha/2, n-1)
chisqr = qchisq(alpha/2, n-1)
ci[1] = (n-1) * var(d) / chisql
ci[2] = (n-1) * var(d) / chisqr
ci


alpha = 1 - 0.90
n = length(d) 
ci = c()
chisql = qchisq(1 - alpha/2, n-1)
chisqr = qchisq(alpha/2, n-1)
ci[1] = (n-1) * var(d) / chisql
ci[2] = (n-1) * var(d) / chisqr
ci

alpha = 1 - 0.80
n = length(d) 
ci = c()
chisql = qchisq(1 - alpha/2, n-1)
chisqr = qchisq(alpha/2, n-1)
ci[1] = (n-1) * var(d) / chisql
ci[2] = (n-1) * var(d) / chisqr
ci

alpha = 1 - 0.50
n = length(d) 
ci = c()
chisql = qchisq(1 - alpha/2, n-1)
chisqr = qchisq(alpha/2, n-1)
ci[1] = (n-1) * var(d) / chisql
ci[2] = (n-1) * var(d) / chisqr
ci





# Task 3

blue = c(21.65, 17.48, 20.1, 21.57, 14.82, 19.17, 21.08, 18.23, 22.93, 
       15.66, 20.89, 21.66, 18.5, 20.59, 18.63, 18.91, 19.53, 17.7, 16.5, 19.03)
snapper = c(31.65, 27.48, 30.1, 31.57, 24.82, 29.17, 31.08, 28.23, 32.93, 
            25.66, 30.89, 31.66, 28.5, 30.59, 28.63)

ci = c()
x1 = snapper
x2 = blue
n1 = length(x1)
n2 = length(x2)

if (n1 < n2) n = n1 else n = n2

alpha = 1 - 0.95

if (n > 30){
  za = qnorm(1 - alpha/2)
  ci[1] = mean(x1) - mean(x2) - za * sqrt(var(x1)/n1 + var(x2)/n2) 
  ci[2] = mean(x1) - mean(x2) + za * sqrt(var(x1)/n1 + var(x2)/n2)
} else {
  ta = qt(1 - alpha/2, n-1)
  varp = ((n1 - 1) * var(x1) + (n2 - 1) * var(x2)) / (n1 + n2 - 2)
  ci[1] = mean(x1) - mean(x2) - ta * sqrt(varp * (1/n1 + 1/n2)) 
  ci[2] = mean(x1) - mean(x2) + ta * sqrt(varp * (1/n1 + 1/n2))
}
ci

alpha = 1 - 0.95
ci = t.test(x1, x2, mu = 0, conf.level = 1 - alpha, var.equal = TRUE)$conf.int
ci

alpha = 1 - 0.85
ci = t.test(x1, x2, mu = 0, conf.level = 1 - alpha, var.equal = TRUE)$conf.int
ci

alpha = 1 - 0.75
ci = t.test(x1, x2, mu = 0, conf.level = 1 - alpha, var.equal = TRUE)$conf.int
ci

alpha = 1 - 0.25
ci = t.test(x1, x2, mu = 0, conf.level = 1 - alpha, var.equal = TRUE)$conf.int
ci





# Task 4

Exam1 = c(40.98, 59.36, 46.69, 41.8, 61.63, 65.31, 62.96, 60.21, 56.89, 
        78.41, 53.44, 75.2, 60.54, 52.43, 41.41, 70.79, 73.55, 55.65, 
        61.43, 63.84, 58.07, 53.79, 54.45, 67.18, 44.46)

Exam2 = c(50.22, 66.19, 58.75, 51.88, 66.61, 70.86, 74.25, 70.23, 69.55, 
        87.18, 63.62, 81.7, 70.5, 66.02, 51.35, 80.92, 85.65, 65.44, 
        74.37, 75.28, 67.86, 59.92, 64.42, 73.57, 57.15)

d = Exam1 - Exam2
n = length(d)

alpha = 1 - 0.95
ci = c()

if (n > 30){
  za = qnorm(1 - alpha/2)
  ci[1] = mean(d) - za * sqrt(var(d)/n) 
  ci[2] = mean(d) + za * sqrt(var(d)/n)
} else {
  ta = qt(1 - alpha/2, n-1)
  ci[1] = mean(d) - ta * sqrt(var(d)/n) 
  ci[2] = mean(d) + ta * sqrt(var(d)/n)
}
ci



alpha = 1 - 0.90
ci = t.test(d, mu = 0, conf.level = 1 - alpha, var.equal = T)$conf.int
ci

alpha = 1 - 0.80
ci = t.test(d, mu = 0, conf.level = 1 - alpha, var.equal = T)$conf.int
ci

alpha = 1 - 0.70
ci = t.test(d, mu = 0, conf.level = 1 - alpha, var.equal = T)$conf.int
ci

alpha = 1 - 0.60
ci = t.test(d, mu = 0, conf.level = 1 - alpha, var.equal = T)$conf.int
ci

alpha = 1 - 0.10
ci = t.test(d, mu = 0, conf.level = 1 - alpha, var.equal = T)$conf.int
ci






# Task 5

data = read.csv("NZBIRDS.csv")
head(data)
with(data,table(Extinct,Flight))

n1 = 21 + 38
p1 = 21 / n1
q1 = 1 - p1
n2 = 7 + 78
p2 = 7 / n2
q2 = 1 -p2

n = min(n1, n2)


alpha = 1 - 0.95
ci = c()

if (n > 30){
  za = qnorm(1 - alpha/2)
  ci[1] = p1 - p2 - za * sqrt(p1 * q1 / n1 + p2 * q2 / n2) 
  ci[2] = p1 - p2 + za * sqrt(p1 * q1 / n1 + p2 * q2 / n2)
} else {
  ta = qt(1 - alpha/2, n-1)
  ci[1] = p1 - p2 - ta * sqrt(p1 * q1 / n1 + p2 * q2 / n2) 
  ci[2] = p1 - p2 + ta * sqrt(p1 * q1 / n1 + p2 * q2 / n2)
}
ci






# Task 6


set.seed(35); sam1 = rnorm(25, mean = 10, sd = 5); 
set.seed(45); sam2 = rnorm(34, mean = 40, sd = 8)

alpha = 1 - 0.95
ratio = (var(sam1) / var(sam2))
fa1 = qf(1 - alpha/2, 24, 33)
fa2 = qf(1 - alpha/2, 33, 24)

ci = c()
ci[1] = ratio / fa1
ci[2] = ratio * fa2
ci

alpha = 1 - 0.80; var.test(sam1, sam2, conf.level = 1 - alpha)$conf.int
alpha = 1 - 0.70; var.test(sam1, sam2, conf.level = 1 - alpha)$conf.int
alpha = 1 - 0.60; var.test(sam1, sam2, conf.level = 1 - alpha)$conf.int
alpha = 1 - 0.50; var.test(sam1, sam2, conf.level = 1 - alpha)$conf.int




