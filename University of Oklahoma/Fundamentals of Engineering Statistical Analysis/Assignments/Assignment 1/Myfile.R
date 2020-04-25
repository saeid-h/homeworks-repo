# Question 3
#Read in the data from DDT
ddt=read.table(file.choose(),sep=",",header=TRUE) 

#Specifying a color pattern
m=with(ddt, as.numeric(levels(factor(MILE)))) 
colm=c()
for(i in 1:length(ddt$MILE)){colm[i]=which(ddt$MILE[i]==m)}

#coplot of LENGTH v WEIGHT
coplot(LENGTH~WEIGHT|RIVER*SPECIES,data=ddt,col=colm)

# Question 6
Year=c(1999,2000,2001,2002,2003)
PhDDegrees=c(5945,5990,6085,5802,5870)
DoctoralEnrollment=c(31536,33312,35425,40949,45462)
ed = data.frame(Year, PhDDegrees, DoctoralEnrollment)
with(ed, barplot(PhDDegrees, main = "PhD Degrees Awarded", 
                 xlab = "Year", ylab = "Degrees", names = Year, col = "gray"))
with(ed, barplot(DoctoralEnrollment,
                 names = Year, main = "Doctoral Enrollment", xlab = "Year", 
                 ylab = "Candidates Enrolled", col = "steelblue"))

# Question 7
incidents=c(27,24,22,10)
MS=c("ED","PP","MO","TC")
Cause=rep(MS,incidents)
pareto<-function(x,mn="Pareto barplot",...){  # x is a vector
  x.tab=table(x)
  xx.tab=sort(x.tab, decreasing=TRUE,index.return=FALSE)
  cumsum(as.vector(xx.tab))->cs
  length(x.tab)->lenx
  bp<-barplot(xx.tab,ylim=c(0,max(cs)),las=2)
  lb<-seq(0,cs[lenx],l=11)
  axis(side=4,at=lb,labels=paste(seq(0,100,length=11),"%",sep=""),las=1,line=-1,col="Blue",col.axis="Red")
  for(i in 1:(lenx-1)){
    segments(bp[i],cs[i],bp[i+1],cs[i+1],col=i,lwd=2)
  }
  title(main=mn,...)}
pareto(Cause)

# Question 8
pwb=read.table(file.choose(),sep=",",header=TRUE)
pareto(pwb)

# Question 9
vold=c(0.03,0,0.1,0,0,0.1,0.43,0.3,0.03)
class=c(1,2,3,4,5,6,7,8,9)
names(vold)<- class
barplot(vold,space=0,
        ylab="Relative Frequency",xlab="Class")
old=c(9.98,10.12,9.84,10.26,10.05,10.15,10.05,
      9.8,10.02,10.29,10.15,9.8,10.03,10,9.73,
      8.05,9.87,10.01,10.55,9.55,9.98,10.26,9.95
      ,8.72,9.97,9.7,8.8,9.87,8.72,9.84)
stem(old)
new=c(9.1,10.01,8.82,9.63,8.82,8.65,10.10,9.43,
      8.51,9.7,10.03,9.14,10.09,9.85,9.75,9.6,9.27
      ,8.78,10.05,8.83,9.35,10.12,9.39,9.54,9.49,
      9.48,9.36,9.37,9.64,8.68)
vnew=c(0,0.03,0.23,0.06,0.2,0.2,0.1,0.16,0)
class=c(1,2,3,4,5,6,7,8,9)
names(vold)<- class
barplot(vnew,space=0,ylab="Relative Frequency",xlab="Class")
stem(new)

# Question 10
date=c(15,17,18,19,20,20,21,21,22,23,23,25,25)
condition=c("Fog","Fog","Fog","Fog","Fog","Clear"
            ,"Fog","Clear","Fog","Fog","Cloud","Fog"
            ,"clear")
Thion=c(38.2,28.6,30.2,23.7,62.3,74.1,88.2,46.4,135.9
        ,102.9,28.9,46.9,44.3)
Oxon=c(10.3,6.9,6.2,12.4,0,45.8,9.9,27.4,44.8,27.8,6.5,
       11.2,16.6)
TORatio=c(0.270,0.241,0.205,0.523,0,0.618,0.112,0.591,
          0.33,0.270,0.225,0.239,0.375)
ins= data.frame(date, condition,Thion,Oxon,TORatio)
stem(TORatio)
# Question 11
#mean
sumant=3+3+52+7+5+49+5+4+4+5+4
mean=sumant/11
mean
mean(ant)
#median
sort(ant)
5
median(ant)
#mode
max(ant)

dryplant=c(40,52,40,43,27)
sum(dryplant)/5
mean(dryplant)
median(dryplant)
max(dryplant)
gobplant=c(30,16,30,56,22,14)
mean(gobplant)
median(gobplant)
max(gobplant)

# Question 13
I=c(3,4,3,3,1,4,1,3,2,3,1,1,4,
    2,3,3,2,6,1,1,3,3,2,2,2,2,
    1,3,2,1,6,1,3,2,2,1,2,2,4,2)
#quartile
length(I)
yl=(length(I)+1)/4
nl=round(yl)
yh=3*(length(I)+1)/4
nh=round(yh)
#Zscore
z6=(6-mean(I))/sd(I)
z6

# Question 14
ship.df=read.table(file.choose(),header=TRUE,sep=",")
R=ship.df$Rating
ship.df=read.table(file.choose(),header=TRUE,sep=",")
head( ship.df)
r=ship.df$R
boxplot(r,horizontal=TRUE,col="red")
zouts=r[abs(scale(r))>3]
iqr=IQR(r)
lq=quantile(r,0.25)
lq
If=lq-1.5*iqr
If
lf=lq-3*iqr
lf
r[r<=lf]
abline(v=c(If,lf),lwd=3,col="Red")
abline(v=zouts,col="Blue")
unique(zouts)

z=scale(I)
I[abs(z)>=3]

# Question 15
summary(I.df)
H=I.df$HOURS
mean=sum(H)/length(H)
mean
median(H)
max(I.df)
range=max(H)-min(H)
range

variance=sum((H-mean)^2)/(length(H)-1)
variance

std=variance^0.5
std

z=scale(H)
ones=H[abs(z)>=0 & abs(z)<=1]
length(ones)
length(ones)/length(H)
twos=H[abs(z)>=0 & abs(z)<=2]
length(twos)
length(twos)/length(H)
threes=H[abs(z)>=0 & abs(z)<=3]
length(threes)
length(threes)/length(H)
length(H)
boxplot(H,col="green")
y70=70*(length(H)+1)/100
nh=round(yh)
nh
