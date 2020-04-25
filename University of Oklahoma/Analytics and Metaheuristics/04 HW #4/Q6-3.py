'''
basic hill climbing search provided as base code for the DSA/ISE 5113 course
author: Charles Nicholson
date: 4/5/2017

modified for assignments by Saeid Hosseinipoor
modificaiton date: April 22, 2017.

NOTE: YOU MAY CHANGE ALMOST ANYTHING YOU LIKE IN THIS CODE.  
However, I would like all students to have the same problem instance, 
therefore please do not change anything relating to:
  random number generation
  number of items (should be 100)
  random problem instance
  weight limit of the knapsack
  
'''
#------------------------------------------------------------------------------

#Student name: Saeid Hosseinipoor
#Date:         April 22, 2017



# Code Initialization Section --------------------------------------------------

#need some python libraries
import copy
#need this for the random number generation -- do not change
from random import Random   
import numpy as np
import math


#to setup a random number generator, we will specify a "seed" value
#need this for the random number generation -- do not change
seed = 5113
myPRNG = Random(seed)

#to get a random number between 0 and 1, use this:             myPRNG.random()
#to get a random number between lwrBnd and upprBnd, use this:  myPRNG.uniform(lwrBnd,upprBnd)
#to get a random integer between lwrBnd and upprBnd, use this: myPRNG.randint(lwrBnd,upprBnd)

#number of elements in a solution
n = 100

#create an "instance" for the knapsack problem
value = []
for i in range(0,n):
    value.append(myPRNG.uniform(10,100))
    
weights = []
for i in range(0,n):
    weights.append(myPRNG.uniform(5,20))
    
#define max weight for the knapsack
maxWeight = 5*n


# Function Section -------------------------------------------------------------

#function to evaluate a solution x ---------------------------------------------
def evaluate(x, v, w):
          
    a=np.array(x)
    b=np.array(v)
    c=np.array(w)
    
    #compute the value of the knapsack selection
    #compute the weight value of the knapsack selection
    totalValue = np.dot(a,b)   
    totalWeight = np.dot(a,c)
    
    if totalWeight > maxWeight:
        totalValue = maxWeight - totalWeight

    #returns a list of both total value and total weight
    return [totalValue, totalWeight]   
          
       
#here is a simple function to create a neighborhood ----------------------------
#1-flip neighborhood of solution x         
def neighborhood(x):
    n = len(x)    
    nbrhood = []     
    
    for i in range(0,n):
        nbrhood.append(x[:])
        if nbrhood[i][i] == 1:
            nbrhood[i][i] = 0
        else:
            nbrhood[i][i] = 1
      
    return nbrhood
          


#create the initial solution ---------------------------------------------------
def initial_solution(n, myPRNG = Random(5113)):
    #myPRNG = Random(randomSeed)
    x = []   #i recommend creating the solution as a list    
    for i in range(0, n):
        x.append(myPRNG.randint(0,1))   
    return x


#state probability calulation  -------------------------------------------------

def state_probability (E1, E2, T):
    return math.exp ((E1 - E2)/T)


#state probability calulation  -------------------------------------------------

def moveToNext(T, 
               coolingMethod='Proportioanal',
               alpha=0.95,
               T0=5000,
               k=0,
               c=1,
               Q=1):
    
    if coolingMethod == 'Proportioanal':
        T = alpha * T
    elif coolingMethod == 'Cauchy':
        T = T0 / (1 + k)
    elif coolingMethod == 'Boltzmann':
        T = T0 / math.log(1 + k)
    elif coolingMethod == 'Very Fast':
        T = T0 * math.exp(-c * k ** Q)        
        
    return T

# Local Search Function --------------------------------------------------------

def simulatedAnnealing (value, weight, 
                 myPRNG = Random(5113), 
                 maxIteration=100,
                 T_min=1,
                 T_max=10000,
                 coolingMethod='Proportioanal',
                 alpha=0.95,
                 show=False):
    
    T = T_max
    k = 1;
    n=len(value)
    #varaible to record the number of solutions evaluated
    solutionsChecked = 0
    f_tracked = [0.0, 0.0]
    
    x_curr = initial_solution(n, myPRNG)  #x_curr will hold the current solution 
    x_best = x_curr[:]           #x_best will hold the best solution 
    #f_curr will hold the evaluation of the current soluton
    f_curr = evaluate(x_curr, value, weights)    
    f_best = f_curr[:]

    #begin local search overall logic 
    done = False
    while not done:
        for i in range(maxIteration):
            #create a list of all neighbors in the neighborhood of x_curr        
            Neighborhood = neighborhood(x_curr)   
            #evaluate every member in the neighborhood of x_curr
            s = Neighborhood[myPRNG.randint(0, len(Neighborhood)-1)]
            solutionsChecked = solutionsChecked + 1
            sv = evaluate(s, value, weights)
            if sv[0] > f_best[0]:   
                    #find the best member and keep track of that solution
                    x_best = s[:]                 
                    f_best = sv[:]   #and store its evaluation  
            else: 
                if state_probability(sv[0], f_best[0], T) > myPRNG.random():
                    x_best = s[:]                 
                    f_best = sv[:]   #and store its evaluation 
                    
        T = moveToNext(T, T0=T_max, k=k)
        k += 1;
        
        if T < T_min:
            done = True
        else:
            x_curr = x_best[:]
            f_curr = f_best
                  
            if show:
                print ("\nTotal number of solutions checked: ", solutionsChecked)
                print ("Best value found so far: ", f_best)        
                print("Current Temperature: ", T)
     
    return solutionsChecked, f_best, x_best



# Print Result Section ---------------------------------------------------------
  
solutionsChecked, f_best, x_best = simulatedAnnealing (value, weights, myPRNG=myPRNG, T_max=5000, coolingMethod='Cauchy')

print ("\nFinal number of solutions checked: ", solutionsChecked)
print ("Best value found: ", f_best[0])
print ("Weight is: ", f_best[1])
print ("Total number of items selected: ", np.sum(x_best))
print ("Best solution: ", x_best)

