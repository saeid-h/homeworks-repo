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


n = 2                   #number of dimensions of problem
swarmSize = 200         #number of particles in swarm
PhiG = 2                #Cognitive acceleration
PhiS = 3                #Social acceleration
VelMax = 1              #Maximun Velocity
iter_max = 1000         #Maximun number of iterations
stagnation = 100        #Maximun number of consecutive non improvements 
weight = 1              #Inertia weight
maximun = 500
minimum = -500
NcolVonNeumman = 10
      
#Schwefel function to evaluate a real-valued solution x    
# note: the feasible space is an n-dimensional hypercube centered at the origin with side length = 2 * 500
               
def evaluate(x):          
      val = 0
      d = len(x)
      for i in range(d):
            val = val + x[i]*math.sin(math.sqrt(abs(x[i])))
                                        
      val = 418.9829*d - val         
                    
      return val          



def module (x):          #Calculate the module of a vector
      _mod = 0
      for i, j in enumerate(x):
            _mod = _mod + j**2
      _mod = _mod ** 0.5
      return _mod 


def localBest(pBestVal2,i):          #Calculate the local best
      if i%NcolVonNeumman == 0: 
            prev = i + NcolVonNeumman -1 
      else:
            prev = i-1

      curr = i

      if (i+1)%NcolVonNeumman == 0:
            nxt = i - NcolVonNeumman +1
      else:
            nxt = i + 1
      
      if (i+NcolVonNeumman) >= swarmSize:
            dwn = i - (swarmSize - NcolVonNeumman)
      else:
            dwn = i + NcolVonNeumman
            
      if i < NcolVonNeumman:
            up = i + (swarmSize - NcolVonNeumman)
      else:
            up = i - NcolVonNeumman

      if pBestVal2[prev] == min(pBestVal2[prev],pBestVal2[curr],pBestVal2[nxt],pBestVal2[up],pBestVal2[dwn]):
            lBesti = prev
      if pBestVal2[curr] == min(pBestVal2[prev],pBestVal2[curr],pBestVal2[nxt],pBestVal2[up],pBestVal2[dwn]):
            lBesti = curr      
      if pBestVal2[nxt] == min(pBestVal2[prev],pBestVal2[curr],pBestVal2[nxt],pBestVal2[up],pBestVal2[dwn]):
            lBesti = nxt            
      if pBestVal2[up] == min(pBestVal2[prev],pBestVal2[curr],pBestVal2[nxt],pBestVal2[up],pBestVal2[dwn]):
            lBesti = up                  
      if pBestVal2[dwn] == min(pBestVal2[prev],pBestVal2[curr],pBestVal2[nxt],pBestVal2[up],pBestVal2[dwn]):
            lBesti = dwn                  
      
      return lBesti

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

#gBest = pBest[pBestVal.index(min(pBestVal))]
#gBestVal = min(pBestVal)

#gBestValList = list()


# Initialization of variables
iteration = 0
gBest = pos[0]
gBestVal = curValue[0]
gBestValList = []
gBestList = []
PositionsList = []
VelocityList = []
gBestIndex = ['NA'] * iter_max
noImprove = 0

for i,v in enumerate(curValue):     #Calculate the gBest and gBestVal for the starting positions
      if v < gBestVal:
            gBestVal = v
            gBest = pos[i]
            gBestIndex[0]=i



#done = False
#Iteration = 0

while iteration < iter_max:
      #Iteration += 1
      noImprove = noImprove + 1
      
      PositionsList.append(pos[:])
      for i,p in enumerate(pos):    
            val = evaluate(p)
            if val < pBestVal[i]:
                  pBestVal[i] = val
                  pBest[i] = p[:]
                  
            if val < gBestVal:       
                  gBest = p[:]
                  gBestVal = val
                  noImprove = 0
                  gBestIndex[iteration] = i
                  
      gBestValList.append(gBestVal)
      gBestList.append(gBest)    
      
      VelocityList.append(vel[:])
      for i,v in enumerate(vel):    
            lBest_i = localBest(pBestVal, i)
           
            aux = weight * np.array(v) + \
                  PhiG * myPRNG.random() * (np.array(pBest[i])- \
                  np.array(pos[i])) + \
                  PhiS * myPRNG.random() * (np.array(pBest[lBest_i])-\
                                            np.array(pos[i]))
            
            mod_aux = module(aux)
            if mod_aux <= VelMax:
                  vel[i] = aux[:].tolist()
            else:
                  ratio = VelMax/mod_aux
                  for w,z in enumerate(aux):
                        aux[w]=ratio * aux[w]
                  vel[i] = aux[:].tolist()
                  
      for i,p in enumerate(pos):    
            aux2 = np.array(p) + np.array(vel[i])
            if aux2[0] > maximun:
                  aux2[0] = maximun
            if aux2[0] < minimum:
                  aux2[0] = minimum
            if aux2[1] > maximun:
                  aux2[1] = maximun
            if aux2[1] < minimum:
                  aux2[1] = minimum            
            pos[i] = aux2[:].tolist()
      iteration2 = iteration
      if noImprove >= stagnation:         
            iteration = iter_max
      else:
            iteration = iteration + 1
      
      print (gBestVal)
 
                                                        
print ("gBest Position:", gBest)
print ("gBest Value:", gBestVal)
print ("Iterations:", iteration2+1)