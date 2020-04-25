#particle swarm optimization for Schwefel minimization problem


#need some python libraries
import copy
import math
from random import Random
import numpy as np


#to setup a random number generator, we will specify a "seed" value
seed = 12345
myPRNG = Random(seed)

#to get a random number between 0 and 1, write call this:             myPRNG.random()
#to get a random number between lwrBnd and upprBnd, write call this:  myPRNG.uniform(lwrBnd,upprBnd)
#to get a random integer between lwrBnd and upprBnd, write call this: myPRNG.randint(lwrBnd,upprBnd)


#number of dimensions of problem
n = 2

#number of particles in swarm
swarmSize = 200



#Cognitive acceleration
PhiC = 2

#Social acceleration
PhiS = 2

#acceleration of the normalized velocity
constriction = 1

#factor for initail velocity
inertia = 1

#stagnation
stagnation = 100

#boundary
maximum = 500
minimum = -500

#maximum velocity
Vmax = 100

      
#Schwefel function to evaluate a real-valued solution x    
# note: the feasible space is an n-dimensional hypercube centered at the origin with side length = 2 * 500
               
def evaluate(x):          
      val = 0
      d = len(x)
      for i in range(d):
            val = val + x[i]*math.sin(math.sqrt(abs(x[i])))
                                        
      val = 418.9829*d - val         
                    
      return val          
          
          

#the swarm will be represented as a list of positions, velocities, values, pbest, and pbest values

pos = [[] for _ in range(swarmSize)]      #position of particles -- will be a list of lists
vel = [[] for _ in range(swarmSize)]      #velocity of particles -- will be a list of lists

curValue = [] #value of current position  -- will be a list of real values
pbest = []    #particles' best historical position -- will be a list of lists
pbestVal = [] #value of pbest position  -- will be a list of real values



#initialize the swarm randomly
for i in range(swarmSize):
      for j in range(n):
            pos[i].append(myPRNG.uniform(-500,500))    #assign random value between -500 and 500
            vel[i].append(myPRNG.uniform(-1,1))        #assign random value between -1 and 1
            
      curValue.append(evaluate(pos[i]))   #evaluate the current position
                                                 
pBest = copy.deepcopy(pos)  # initialize pbest to the starting position
pBestVal = curValue[:]  # initialize pbest to the starting position

gBest = pBest[pBestVal.index(min(pBestVal))]
gBestVal = min(pBestVal)

gBestValList = list()

done = False
Iteration = 0

while not done:
      Iteration += 1

      curValue = []
      for i in range(swarmSize):
            curValue.append(evaluate(pos[i]))
      
            if curValue[i] < pBestVal[i]:
                  pBest[i] = list(pos[i])
                  pBestVal[i] = curValue[i]
        
      if min(pBestVal) < gBestVal:
            gBest = pBest[pBestVal.index(min(pBestVal))]
            gBestVal = min(pBestVal)



      #updating velocity
      for i in range(swarmSize):
            vel[i]= inertia*np.array(vel[i]) + \
                  PhiC*myPRNG.uniform(0,1)*(np.array(pBest[i])-np.array(pos[i]))\
                  + PhiS*myPRNG.uniform(0,1)*(np.array(gBest)-np.array(pos[i]))
            vel[i]= vel[i].tolist()
  
      #normalizing
            sumSquare = 0
            for j in range(len(vel[i])):
                  sumSquare = sumSquare + (vel[i][j])**2
                
            if math.sqrt(sumSquare) > Vmax:
                  for j in range(n):
                        vel[i][j]= (Vmax/math.sqrt(sumSquare))*vel[i][j]
                   
            for j in range(len(vel[i])):
                  vel[i][j]= constriction*(vel[i][j])
          
      #updating positions
      for i in range(swarmSize):
            for j in range(n):
                  pos[i][j] = pos[i][j] + vel[i][j]
              
                  if pos[i][j] > maximum:
                        pos[i][j] = maximum
                  elif pos[i][j] < minimum:
                        pos[i][j] = minimum
                    

      print (gBestVal)      
  
      gBestValList.append(gBestVal)
  
      #stopping criteria
      if Iteration > stagnation:
            if gBestValList[Iteration-1] == gBestValList[Iteration-stagnation-1]:
                  done = True         
 
                                                        
print (gBest)
print (len(gBestValList))
