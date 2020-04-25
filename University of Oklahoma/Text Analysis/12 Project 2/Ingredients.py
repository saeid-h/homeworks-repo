

import matplotlib.pyplot as plt
import community
import networkx as nx


csvFile= open('srep00196-s2.csv', 'r')
ingradientPairs = csvFile.readlines()
ingradientPairs = ingradientPairs[4:]
ingradientPairs = [x.replace('\n', '') for x in ingradientPairs]
ingradientPairs = [x.split(',') for x in ingradientPairs]

#X = list()
TRESHOLD = 10
Y = list()
for el in ingradientPairs:
    p1 = ' '.join(el[0].split('_'))
    p2 = ' '.join(el[1].split('_'))
    val = int(el[2])
    if val > TRESHOLD:
        Y += [(p1, p2, val)]
        
   

   
G=nx.Graph()
G.add_weighted_edges_from (Y)

'''
for n,nbrs in G.adjacency_iter():
    for nbr,eattr in nbrs.items():
        data=eattr['weight']
        print('(%s, %s, %d)' % (n,nbr,data))
'''    

#nx.draw(G)

#http://perso.crans.org/aynaud/communities/
#http://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008/pdf
#http://perso.crans.org/aynaud/communities/api.html

#first compute the best partition
partition = community.best_partition(G)
print ("\n", set(partition.values()))



# Classes
print ("\nAll the ingredients have been calssified in 10 categories: \n")
print ("0: Vegatables.")
print ("1: Meats.")
print ("2: Diaries.")
print ("3: Special Spices.")
print ("4: Anises.")
print ("5: Seeds.")
print ("6: Lemons.")
print ("7: Gums.")
print ("8: Angelica.")
print ("9: Peels.")


#drawing
H = G.subgraph(G.nodes()[:20])
#H = G
size = float(len(set(partition.values())))
pos = nx.spring_layout(G)
count = 0.
for com in set(partition.values()) :
    count = count + 1.
    list_nodes = [nodes for nodes in partition.keys()
                                if partition[nodes] == com and nodes in H.nodes()]
    #print (com)
    #print (list_nodes)
    #print (len(list_nodes))
    nx.draw_networkx_nodes(H, pos, list_nodes, node_size = 20,
                                node_color = str(count / size))


nx.draw_networkx_edges(H,pos, alpha=0.5)
plt.show()



#labelList = list(partition.values())
#nodeList = G.nodes()
labelList, nodeList = zip(*sorted(zip(list(partition.values()), G.nodes())))
X = list()
for i in range (len(Y)):
    X += [(Y[i][0], Y[i][1], Y[i][2], labelList[nodeList.index(Y[i][0])])]

#X = sorted(X, key=lambda x: x[3]) 

#for i in set(labelList):
#    print ("Category ", i, " is:\n", [x[1] for x in X if x[3] == i])




#import random
#random.shuffle(X)
Z = [x for x in X if x[2] > 50]

'''
x1 = list()
x2 = list()
n1 = list()
n2 = list()
c = list()
s = list()
for x in Z:
    x1 += [nodeList.index(x[0])]
    x2 += [nodeList.index(x[1])]
    #n1 += [x[0]]
    #n2 += [x[1]]  
    
    #x1 += [nodeList.index(x[1])]
    #x2 += [nodeList.index(x[0])]    
    #n1 += [x[1]]
    #n2 += [x[0]]
    s += [x[2]] 
    c += [x[3]+1] 


c, s, x1, x2 = zip(*sorted(zip(c, s, x1, x2)))

plt.figure(1)
#plt.xticks(x1, n1)
#plt.yticks(x2, n2) 
#cmax = max(c)
#c = [x/cmax for x in c] 
plt.scatter(x1, x2, s=s, c=c, cmap='plasma')
plt.show()

'''