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
#n-flip neighborhood of solution x         
def neighborhood(x, flip=1):
    n = len(x)    
    nbrhood = []   
    a = -1
    if flip == 1:
        for i in range(0,n):
            nbrhood.append(x[:])
            if nbrhood[i][i] == 1:
                nbrhood[i][i] = 0
            else:
                nbrhood[i][i] = 1
                
                
    elif flip == 2:
        for i in range(0, n):
            for j in range(i, n):
                if i != j:
                    a += 1
                    nbrhood.append(x[:])

                    if nbrhood[a][i] == 1:
                        nbrhood[a][i] = 0
                    else:
                        nbrhood[a][i] = 1

                    if nbrhood[a][j] == 1:
                        nbrhood[a][j] = 0
                    else:
                        nbrhood[a][j] = 1 
                        
                        
    else:
        for i in range(0, n):
            for j in range(i, n):
                for k in range(j, n):
                    if i != j and i != k and j != k:
                        a += 1
                        nbrhood.append(x[:])

                        if nbrhood[a][i] == 1:
                            nbrhood[a][i] = 0
                        else:
                            nbrhood[a][i] = 1

                        if nbrhood[a][j] == 1:
                            nbrhood[a][j] = 0
                        else:
                            nbrhood[a][j] = 1

                        if nbrhood[a][k] == 1:
                            nbrhood[a][k] = 0
                        else:
                            nbrhood[a][k] = 1        
      
    return nbrhood
          


#create the initial solution ---------------------------------------------------
def initial_solution(n, myPRNG = Random(5113)):
    #myPRNG = Random(randomSeed)
    x = []   #i recommend creating the solution as a list    
    for i in range(0, n):
        x.append(myPRNG.randint(0,1))   
    return x



# Local Search Function --------------------------------------------------------

def tabu (value, weight, 
                 myPRNG = Random(5113), 
                 maxIteration=1000,
                 tenure=10,
                 show=False):
    
    n=len(value)
    #varaible to record the number of solutions evaluated
    solutionsChecked = 0
    tabuList = {}    
    
    x_curr = initial_solution(n, myPRNG)  #x_curr will hold the current solution 
    x_best = x_curr[:]           #x_best will hold the best solution 
    #f_curr will hold the evaluation of the current soluton
    f_curr = evaluate(x_curr, value, weights)    
    f_best = f_curr[:]

    #begin local search overall logic 
    for i in range(maxIteration):
        #create a list of all neighbors in the neighborhood of x_curr 
        #print ('i = {}'.format(i))
        Neighborhood = neighborhood(x_curr)  
        
        x_neighbor = Neighborhood[0]
        f_neighbor = evaluate(x_neighbor, value, weights)
        #j = 0
        for s in Neighborhood: 
            #j += 1
            #print ('j = {}'.format(j))
            solutionsChecked = solutionsChecked + 1
            sv = evaluate(s, value, weights)
            #print('sv = {}'.format(sv[0]) )
            #print('f_neighbor = {}'.format(f_neighbor[0]) )
            if sv[0] > f_neighbor[0]:
                index = abs(np.array(s) - np.array(x_curr)).argmax()
                if index in tabuList:
                    if sv[0] > f_best[0]:
                        x_neighbor = s[:]
                        f_neighbor = sv
                else:
                    x_neighbor = s[:]
                    f_neighbor = sv
                
        x_previous = x_curr
        x_curr = x_neighbor 
        
        if f_neighbor[0] > f_best[0]:
            x_best = x_neighbor
            f_best = f_neighbor
    
        previousList = tabuList
        tabuList = {}
    
        for key, tabuValue in previousList.items():
            if tabuValue > 1:
                tabuList[key] = tabuValue - 1
    
    
        index = abs(np.array(x_curr) - np.array(x_previous)).argmax()
        tabuList[index] = tenure
        
          
        if show:
            print ("\nTotal number of solutions checked: ", solutionsChecked)
            print ("Best value found so far: ", f_best)        
     
    return solutionsChecked, f_best, x_best



# Print Result Section ---------------------------------------------------------
  
solutionsChecked, f_best, x_best = tabu (value, weights, myPRNG=myPRNG, maxIteration=10000,tenure=5)

print ("\nFinal number of solutions checked: ", solutionsChecked)
print ("Best value found: ", f_best[0])
print ("Weight is: ", f_best[1])
print ("Total number of items selected: ", np.sum(x_best))
print ("Best solution: ", x_best)

