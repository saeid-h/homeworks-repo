import json
import codecs
from pprint import pprint
from sklearn.feature_extraction import DictVectorizer
from sklearn.linear_model import LogisticRegression



with codecs.open('yummly.json.txt', 'r', encoding='utf8') as json_file:    
	recipes = json.load(json_file)


X_dict = list()
Y = list()
for recipe in recipes:
	first_item = 0;
	for ingredient in recipe['ingredients']:
		if first_item == 0:
			X_dict += [{ingredient.lower() : 1}]
			first_item += 1
		else:
			X_dict[-1].update({ingredient.lower() : 1})
	Y += [recipe['id']]



vec = DictVectorizer(sparse = False)
X = vec.fit_transform(X_dict)



clf = LogisticRegression()
clf.fit(X[:1000], Y[:1000])  

print ("\nPlease tell waht ingredient you have, I suggest you a recipe.")
print ("Enter your list item by item. \n ")
myList = [{'' : 1}]
myIngredients = 'start'
while myIngredients != '':
	myIngredients = input('Enter your ingredient: ')
	myList[0].update ({myIngredients.lower() : 1})

myList[0].pop('')


# romaine lettuce
# black olives
# grape tomatoes
# garlic
# pepper
# purple onion
# seasoning
# garbanzo beans
# feta cheese crumbles

x = vec.transform(myList)
a = clf.predict (x)
b = clf.predict_proba (x)


c = [r for r in recipes if r['id'] == int(a)]
if len (c) == 0:
	print ("I can't suggest you any cuisine with these gradients")
else:
	print ("\nI suggest you a " + c[0]['cuisine'] + " food !!!")
	print ("\nHere is the recipe: ")
	pprint (c)
	
	

N = int(input('\nLet me know how many recipes you want: '))

d = zip(*sorted(zip (b[0], clf.classes_)))
e = list(d)

d = zip (b[0], clf.classes_)
e = sorted (d, reverse=True)
f1, f2 = zip(*e)
food = f2[:N]

suggestions = [r for r in recipes for f in food if r['id'] == int(f)]

print ("\nI found the following recipe(s) for you: ")
for r in suggestions:
	print ("\n")
	pprint (r)




