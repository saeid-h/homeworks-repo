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


#monitor the number of solutions evaluated
solutionsChecked = 0



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


# Local Search Function --------------------------------------------------------

def localSearch (value, weight, 
                 myPRNG = Random(5113), 
                 method='Best improvement',
                 restart=1,
                 show=False):
    
    n=len(value)
    #varaible to record the number of solutions evaluated
    solutionsChecked = 0
    f_tracked = [0.0, 0.0]
    
    for iteration in range(restart):
        x_curr = initial_solution(n, myPRNG)  #x_curr will hold the current solution 
        x_best = x_curr[:]           #x_best will hold the best solution 
        #f_curr will hold the evaluation of the current soluton
        f_curr = evaluate(x_curr, value, weights)    
        f_best = f_curr[:]

        #begin local search overall logic 
        done = False
        while not done:
            #create a list of all neighbors in the neighborhood of x_curr        
            Neighborhood = neighborhood(x_curr)   
            #evaluate every member in the neighborhood of x_curr
            for s in Neighborhood:                
                solutionsChecked = solutionsChecked + 1
                sv = evaluate(s, value, weights)
                if sv[0] > f_best[0]:   
                    #find the best member and keep track of that solution
                    x_best = s[:]                 
                    f_best = sv[:]   #and store its evaluation  
                    if method == 'First Improvement':
                        break    
            
            #if there were no improving solutions in the neighborhood
            if f_best == f_curr:               
                done = True
            else:   
                x_curr = x_best[:]     #else: move to the neighbor solution and continue
                f_curr = f_best[:]     #evalute the current solution
                
                if show:
                    print ("\nTotal number of solutions checked: ", solutionsChecked)
                    print ("Best value found so far: ", f_best)        

            # New seed for random selection
            myPRNG.seed(myPRNG.randint(1,65000))

        # Keep track of best solution
        if f_best[0] > f_tracked[0]:
            f_tracked = f_best
            x_tracked = x_best
        
    return solutionsChecked, f_best, x_best, f_tracked, x_tracked



# Print Result Section ---------------------------------------------------------
  
solutionsChecked, f_best, x_best, f_tracked, x_tracked = localSearch (value, weights, myPRNG=myPRNG, method='First Improvement')

print ("\nFinal number of solutions checked: ", solutionsChecked)
print ("Best value found: ", f_best[0])
print ("Weight is: ", f_best[1])
print ("Total number of items selected: ", np.sum(x_best))
print ("Best solution: ", x_best)

print("\nFinal number of the best solutions checked: ", solutionsChecked)
print("Best value found: ", f_tracked[0])
print("Best weight is: ", f_tracked[1])
print("Total number of items selected: ", np.sum(x_tracked))
print("Best solution: ", x_tracked)