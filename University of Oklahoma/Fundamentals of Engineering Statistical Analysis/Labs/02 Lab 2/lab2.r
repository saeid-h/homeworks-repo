# This is the directory structure to my data
#This will be different on the lab computer and on your home computer
dird = "F:/Google Drive - Saied/Courses/02 OU/11 Fundamentals of Engineering Statistical Analysis/02 Labs/02 Lab 2/"

#my function to read data 
myread=function(csv){
  fl=paste(dird,csv,sep="")
  read.table(fl,header=TRUE,sep=",")
}

getwd()
mpg.df=myread("EPAGAS.csv")
head(mpg.df)
z=scale(with(mpg.df,MPG))
with(mpg.df,MPG)->mpg
class(z)
apply(z,2,mean)
apply(z,2,sd)

#possible outliers
mpg[abs(z)>=2 & abs(z)<=3]
mpg[abs(z)>3]

#lattice dotplot
library(lattice)
mycol = ifelse(abs(z)>3, "Red",
        ifelse(abs(z)>=2 &abs(z)<=3,"Blue", "Black"))  
        
dotplot(mpg,col=mycol)

#Boxplot
boxplot(mpg,col="Black",notch=TRUE,main="MPG boxplot", horizontal=TRUE)

#Chebyshev
length(z[abs(z)<2])/length(z)










