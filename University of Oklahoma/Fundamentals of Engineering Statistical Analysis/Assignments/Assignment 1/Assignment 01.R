# Assignment #1
# May, 22, 2016
# Data file is DDT.csv made from DDT.xls


# set the directory of database
# This path is the directory I saved all my works relaited to assignment #1

setwd("F:/Google Drive - Saied/Courses/02 OU/11 Fundamentals of Engineering Statistical Analysis/01 Assignments/01 Assignment1")


# Read data from csv file inte R environment
ddt<-read.csv("DDT.csv")


# Q1

# The following code may help

m = with(ddt, as.numeric(levels(factor(MILE)))) # A
colm = c()
for(i in 1:length(ddt$MILE)){
  colm[i]=which(ddt$MILE[i]==m) #B
}
colm

# Q1a
#coplot of LENGTH vs. WEIGHT
coplot(LENGTH~WEIGHT|RIVER*SPECIES,data=ddt,col=colm)

#Q1f
head(ddt)
subset(ddt,RIVER=="FCM" & SPECIES=="CCATFISH",) #or
ddt[ddt$RIVER=="FCM" & ddt$SPECIES=="CCATFISH",]

Q1f<-ddt[ddt$RIVER=="FCM" & ddt$SPECIES=="CCATFISH",]
Q1fddt<-Q1f["DDT"]
Q1fmean = mean(unlist(Q1fddt))
Q1fmean


# Q5
mtbe = read.csv("MTBE.csv", header=TRUE) # You will need to change the address
head(mtbe) # First six lines
mtbe_dim <- dim(mtbe) # rows and columns
ind = sample(1:mtbe_dim[1],5,replace=FALSE) # random indices
mtbe[ind,]

# Q5a(i) Remove all the rows in mtbe that contain one or more NA's mtbeo=na.omit(mtbe)
mtbeo = na.omit(mtbe)
# Q5a(ii) Now calculate the standard deviation (sd() in R) of the depth of wells which have "Bedrock" as the Aquifier (this is using the entire mtbeo data frame)
depth = mtbeo[mtbeo$Aquifier=="Bedrock",]$Depth
sd(depth)


# Q6
eq = read.csv("EARTHQUAKE.csv", header=TRUE) 
head(eq) # First six lines
earth_dim <- dim(eq) # rows and columns
v = sample(1:earth_dim[1],30,replace=FALSE) # random indices
eq[v,]

# Q6a (i) - magnitude plot
plot(ts(eq$MAG))
# Q6a (ii)
median(eq$MAGNITUDE)


# Q8
freq = c(15,8,63,20)
RL = c("None","Both","LegsO","WheelsO")
l = rep(RL,freq)

source('F:/Google Drive - Saied/Courses/02 OU/11 Fundamentals of Engineering Statistical Analysis/01 Assignments/01 Assignment1/pareto.txt', encoding = 'UTF-8')

pareto(l)


# Q9
sec_iss = c(32,6,12)
sec_lab = c("Windows","Explorer", "Office")
# Q9a
# Pie Chart with Percentages
pct <- round(sec_iss/sum(sec_iss)*100)
sec_lab <- paste(sec_lab, pct) # add percents to labels 
sec_lab <- paste(sec_lab,"%",sep="") # ad % to labels 
pie(sec_iss,labels = sec_lab, col=rainbow(length(sec_lab)),
    main="Pie Chart of Microsoft")

#Q9b
sec_det = c(6,8,22,3,11)
sec_dlab = c("Denial of Service", "Information Disclosure",
             "Remote Code Execution", "Spoofing", 
             "Privilage Elevation")
pareto(rep(sec_dlab,sec_det))


# Q 10

swd = read.csv("SWDEFECTS.csv", header=TRUE)
head(swd)
library(plotrix)
tab = table(swd$defect)
rtab = tab/sum(tab)
round(rtab,2)
pie3D(rtab,labels=list("OK","Defective"),main="pie plot of SWD")


# Q 11
# for old location
raw_old=c(9.98,10.12,9.84,10.26,10.05,10.15,10.05,
      9.8,10.02,10.29,10.15,9.8,10.03,10,9.73,
      8.05,9.87,10.01,10.55,9.55,9.98,10.26,9.95
      ,8.72,9.97,9.7,8.8,9.87,8.72,9.84)
# for new location
raw_new=c(9.1,10.01,8.82,9.63,8.82,8.65,10.10,9.43,
      8.51,9.7,10.03,9.14,10.09,9.85,9.75,9.6,9.27
      ,8.78,10.05,8.83,9.35,10.12,9.39,9.54,9.49,
      9.48,9.36,9.37,9.64,8.68)
classes=c(1,2,3,4,5,6,7,8,9)

# Q11a

f_old = c(1, 0, 3, 0, 0, 3, 13, 9, 1)
v_old = f_old / sum(f_old)
names(v_old) <- classes

barplot(v_old,space=0,main="Old Process", col="red",
        ylab="Relative Frequency",xlab="Classes")

# Q11b
stem(raw_old)
stem(raw_new)

# Q11c
f_new = c(0, 1, 6, 1, 7, 7, 3, 5, 0)
v_new = f_new / sum(f_new)
names(v_new) <- classes
barplot(v_new,space=0,main="New Process", col="red",
        ylab="Relative Frequency",xlab="Classes")

# Q11d
v_both <- matrix(v_new, v_old, nr=2, nc=9)
barplot(v_both, main="old process vs. new process",
        ylab="Relative Frequency",xlab="Classes",
        xlab="Classes", col=c("darkblue","red"),space=0)



#Q11
VOLT = read.table(file.choose(),header=TRUE,sep=",")
OVOLT = VOLT[VOLT$LOCATION == "OLD",]
histogram(OVOLT$VOLTAGE, main = "Relative freq Hist of OLD Voltages")
sort(OVOLT$VOLTAGE)
vold = c(0.03,0,0.1,0,0,0.1,0.43,0.3,0.03)
class = c(1,2,3,4,5,6,7,8,9)
windows()
barplot(vold,space=0,
        ylab="Relative frequency",xlab="Class", 
        main = "Relative frequency histogram of old voltages")
stem(OVOLT$VOLTAGE)

NVOLT = VOLT[VOLT$LOCATION == "NEW",]
sort(NVOLT$VOLTAGE)
vnew=c(0,0.03,0.23,0.06,0.2,0.2,0.1,0.16,0)
class=c(1,2,3,4,5,6,7,8,9)
windows()
barplot(vnew,space=0,
        ylab="Relative frequency", xlab="Class", 
        main = "Relative frequency historam of new voltages")
stem(NVOLT$VOLTAGE)

mold = mean(OVOLT$VOLTAGE)
meold = median(OVOLT$VOLTAGE)
moold = mfv(OVOLT$VOLTAGE)
sold = sd(OVOLT$VOLTAGE)
zold = (10.5 - mold)/sold
boxplot(OVOLT$VOLTAGE, horizontal = TRUE)

mnew = mean(NVOLT$VOLTAGE)
menew = median(NVOLT$VOLTAGE)
monew = mfv(NVOLT$VOLTAGE)
snew = sd(NVOLT$VOLTAGE)
znew= (10.5 - mnew)/snew
boxplot(NVOLT$VOLTAGE, horizontal = TRUE)
windows()
layout(matrix(c(1,2),nr=1,nc=))# 1 row 2 cols
layout.show(2)
boxplot(OVOLT$VOLTAGE, horizontal = TRUE, main = "old location")
boxplot(NVOLT$VOLTAGE, horizontal = TRUE, main = "new location")




# Q12
roughness = c(1.72, 2.50, 2.16, 2.13, 1.06, 2.24, 2.31, 2.03, 1.09, 1.40,
              2.57, 2.64, 1.26, 2.05, 1.19, 2.13, 1.27, 1.51, 2.41, 1.95)

hist(roughness,main="Histogram of Pipe Roughness",
     ylab="Frequency",xlab="Roughness", col="darkblue")

int_low = mean(roughness) - 2 * sd(roughness)
int_high = mean(roughness) + 2 * sd(roughness)



# Q13
ants = c(3,3,52,7,5,49,5,4,4,5,4)
plantc = c(40,52,40,43,27,30,16,30,56,22,14)

# Q13a
ant_mean = mean(ants)
ant_median = median(ants)
ant_mode = 4

# Q13c
drysteppe = plantc[1:5]
ds_mean = mean(drysteppe)
ds_median = median(drysteppe)
ds_mode = 40

# Q13d
gobideseret = plantc[6:11]
gd_mean = mean(gobideseret)
gd_median = median(gobideseret)
gd_mode = 30



# Q14
v_galaxy = c(22922, 20210, 21911, 19225, 18792, 21993, 23059,
             20785, 22781, 23303, 22192, 19462, 19057, 23017,
             20186, 23292, 19408, 24909, 19866, 22891, 23121,
             19673, 23261, 22796, 22355, 19807, 23432, 22625,
             22744, 22426, 19111, 18933, 22417, 19595, 23408,
             22809, 19619, 22738, 18499, 19130, 23220, 22647,
             22718, 22779, 19026, 22513, 19740, 22682, 19179,
             19404, 22193)

hist(v_galaxy,main="Histogram of Galaxy A1775 Velocity",
     ylab="Frequency",xlab="Velocity", col="red")

v_galaxy_A = v_galaxy[which(v_galaxy<21000)]  
v_galaxy_B = v_galaxy[which(v_galaxy>=21000)] 

mean_v_A = mean(v_galaxy_A)
sd_v_A = sd(v_galaxy_A)
mean_v_B = mean(v_galaxy_B)
sd_v_B = sd(v_galaxy_B)




