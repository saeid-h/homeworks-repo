# Cooking Food

### Packages
The following packages have been used in two phases:

	matplotlib
	community
	networkx
	sklearn
	codecs
	json
	
For this program community packege should be downloaded from [here](http://perso.crans.org/aynaud/communities/) and API is avalable [here](http://perso.crans.org/aynaud/communities/api.html).

## Ingredient Classification
###Reading file 

cvs file was considered for this phase. Extra characters were deleted and all the fields pushed into a list:

	csvFile= open('../srep00196-s2.csv', 'r')
	ingradientPairs = csvFile.readlines()
	ingradientPairs = ingradientPairs[4:]
	ingradientPairs = [x.replace('\n', '') for x in ingradientPairs]
	ingradientPairs = [x.split(',') for x in ingradientPairs]

### Make a Graph
In the next step the pairs were considered as a undirected weighted graph. A treshhold was defined to eliminated weak related items. 

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

**Y** is a list of tuples which contains nodes and weight values. The graph was established based on this list.


### Clustering 

For clustering puposes ***Community*** libraries has been used to cluster our graph. 10 different clusters were discovered in this graph. 

	partition = community.best_partition(G)
	
This package finds the most related nodes based on the strength of bond between the nodes which is the weight of the edges. The calsses were labeled maually as:

	0: Vegatables
	1: Meats
	2: Diaries
	3: Special Spices
	4: Anises
	5: Seeds
	6: Lemons
	7: Gums
	8: Angelica
	9: Peels

### Visualization

The following code were used to visulize the clustres. Different coloros shows different clusters.

	H = G.subgraph(G.nodes()[:20])
	size = float(len(set(partition.values())))
	pos = nx.spring_layout(G)
	count = 0.
	for com in set(partition.values()) :
    	count = count + 1.
    	list_nodes = [nodes for nodes in partition.keys()
                                if partition[nodes] == com and nodes in 	
	H.nodes()]
	nx.draw_networkx_nodes(H, pos, list_nodes, node_size = 20,
                                node_color = str(count / size))	
	nx.draw_networkx_edges(G,pos, alpha=0.5)
	plt.show()
	
As the number of nodes are too much and it is difficult to show them clear, it takes a random sub-graph from the big graph to visulize. 

## Cuisine Recommandation

### Structuring Data
ad first step, data were extracted from json file as a list of dictionary:

	for recipe in recipes:
		first_item = 0;
		for ingredient in recipe['ingredients']:
			if first_item == 0:
				X_dict += [{ingredient.lower() : 1}]
				first_item += 1
			else:
				X_dict[-1].update({ingredient.lower() : 1})
		Y += [recipe['id']]
		
### Vectorizing

The extracted data vectorized by *** DictVectorizer*** function from *SKLearn* package.

	vec = DictVectorizer(sparse = False)
	X = vec.fit_transform(X_dict)


### Model

A **Logistic Regression** model has been trained for given cuisines. 

	clf = LogisticRegression()
	clf.fit(X, Y) 
	
### Prediction

A very simple user interface has been developed to take ingredients from users.

	print ("\nPlease tell waht ingredient you have, I suggest you a recipe.")
	print ("Enter your list item by item. \n ")
	myList = [{'' : 1}]
	myIngredients = 'start'
	while myIngredients != '':
		myIngredients = input('Enter your ingredient: ')
		myList[0].update ({myIngredients : 1})
	myList[0].pop('')

At the first step models try to find the best cuisin matched by the given ingredients and suggest it to user. Then asks user whether she wants to see ***N*** top best matches recipes for given ingredients.



## References

> [http://perso.crans.org/aynaud/communities/](http://perso.crans.org/aynaud/communities/)

> [http://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008/pdf](http://iopscience.iop.org/article/10.1088/1742-5468/2008/10/P10008/pdf)

> [http://perso.crans.org/aynaud/communities/api.html](http://perso.crans.org/aynaud/communities/api.html)






