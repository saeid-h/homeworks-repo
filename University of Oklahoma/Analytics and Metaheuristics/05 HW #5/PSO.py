#particle swarm optimization for Schwefel minimization problem


# Packages ---------------------------------------------------------------------

#need some python libraries
import copy
from math import sqrt, sin 
from random import Random
import numpy as np


# Functions --------------------------------------------------------------------
    
#Schwefel function to evaluate a real-valued solution x    
# note: the feasible space is an n-dimensional hypercube centered at the origin with side length = 2 * 500
               
def evaluate(x):          
      val = 0
      d = len(x)
      for i in range(d):
            val = val + x[i]*sin(sqrt(abs(x[i])))
                                        
      val = 418.9829*d - val         
                    
      return val          
          
          

#the swarm will be represented as a list of positions, velocities, values, pbest, and pbest values


def PSO (n=2, swarmSize=200, \
         PhiC=2, PhiS=2, 
         constriction=1, inertia=1, stagnation=100,  
         maxPos=500, minPos=-500,  Vmax = 100, 
         minIteration = 100, tol = 0.000001,
         myPRNG=Random(12345), show=0,        
         ):
      
      pos = [[] for _ in range(swarmSize)]      #position of particles -- will be a list of lists
      vel = [[] for _ in range(swarmSize)]      #velocity of particles -- will be a list of lists
      
      curValue = [] #value of current position  -- will be a list of real values
      pBest = []    #particles' best historical position -- will be a list of lists
      pBestVal = [] #value of pbest position  -- will be a list of real values
      
      gBest = 0
      gBestVal = 0
      
      #initialize the swarm randomly
      for i in range(swarmSize):
            for j in range(n):
                  pos[i].append(myPRNG.uniform(-500,500))    #assign random value between -500 and 500
                  vel[i].append(myPRNG.uniform(-1,1))        #assign random value between -1 and 1
                  
            curValue.append(evaluate(pos[i]))   #evaluate the current position
                                                       
      pBest = copy.deepcopy(pos)  # initialize pbest to the starting position
      pBestVal = curValue[:]  # initialize pbest to the starting position
      
      gBestVal = min(pBestVal)
      gBest = pBest[pBestVal.index(gBestVal)]
       
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
                      
                  if sqrt(sumSquare) > Vmax:
                        for j in range(n):
                              vel[i][j]= (Vmax/sqrt(sumSquare))*vel[i][j]
                         
                  for j in range(len(vel[i])):
                        vel[i][j]= constriction*(vel[i][j])
                
            #updating positions
            for i in range(swarmSize):
                  for j in range(n):
                        pos[i][j] = pos[i][j] + vel[i][j]
                    
                        if pos[i][j] > maxPos:
                              pos[i][j] = maxPos
                        elif pos[i][j] < minPos:
                              pos[i][j] = minPos
                          
      
            if show > 0:
                  if Iteration % show == 0:
                        print (Iteration, ': ', gBestVal)      
  
            gBestValList.append(gBestVal)
        
            #stopping criteria
            if Iteration > minIteration:
                  err = abs((gBestValList[Iteration-1] - \
                             gBestValList[Iteration-stagnation-1])\
                            /gBestValList[Iteration-1])
                  
                  if err < tol:
                        done = True         
             
 
      return {'gBest':gBest, 'gBestVal': gBestVal, \
              'gBestValList': gBestValList}




# Solutions --------------------------------------------------------------------

seed = 12345
myPRNG = Random(seed)



# Q2d:
Q2d2 = PSO(n=2, swarmSize=100, myPRNG=myPRNG)

print ("\n\nResults for question 2 part d - 2D: ")
print ("Best Global Position: ", Q2d2['gBest'])
print ("Best Global Value: ", Q2d2['gBestVal'])
print ("Number of Best Values: ", len(Q2d2['gBestValList']))


