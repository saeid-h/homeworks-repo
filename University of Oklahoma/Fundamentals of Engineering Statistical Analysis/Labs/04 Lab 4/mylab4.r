#  This file has been created for Lab 4 on June 7th, 2016

# library(s20x)
spruce.df=read.table(file.choose(),header=TRUE,sep=",")


# Task 3

y = spruce.df$Height
x = spruce.df$BHDiameter

with(spruce.df,trendscatter(Height~BHDiameter, f = 0.5))

spruce.lm=with(spruce.df,lm(Height~BHDiameter))

summary(spruce.lm)

height.res = residuals(spruce.lm)

height.fit = fitted(spruce.lm)

plot(height.res~height.fit)

trendscatter(height.res~height.fit, f = 0.5)

plot(spruce.lm$residuals)

windows()
normcheck(spruce.lm, shapiro.wilk = TRUE)



# Task 4

quad.lm = with(spruce.df,lm(Height~BHDiameter+I(BHDiameter^2)))

summary(quad.lm)

with(spruce.df,trendscatter(Height~BHDiameter, f = 0.5))

myplot=function(x){
  0.86089580 +1.46959217*x  -0.02745726*x^2
}

curve(myplot, lwd=2, col="steelblue",add=TRUE)

quad.res = residuals(quad.lm)

quad.fit = fitted(quad.lm)

trendscatter(quad.res~quad.fit, f = 0.5)

windows()
normcheck(quad.lm, shapiro.wilk = TRUE)

predict(quad.lm, data.frame(BHDiameter=c(15,18,20)))

predict(spruce.lm, data.frame(BHDiameter=c(15,18,20)))

anova(spruce.lm,quad.lm)




