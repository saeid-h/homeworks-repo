
# Task 1  ----------------------------------------------------------------------

actual_labels = ['spam', 'ham', 'spam', 'spam', 'spam',
                 'ham', 'ham', 'spam', 'ham', 'spam',
                 'spam', 'ham', 'ham', 'ham', 'spam',
                 'ham', 'ham', 'spam', 'spam', 'ham']
				 

predicted_labels = ['spam', 'spam', 'spam', 'ham', 'spam',
                      'spam', 'ham', 'ham', 'spam', 'spam',
                      'ham', 'ham', 'spam', 'ham', 'ham',
                      'ham', 'spam', 'ham', 'spam', 'spam']
					  
tp = 0
tn = 0
fp = 0
fn = 0

for i in range(len(actual_labels)):
    if predicted_labels [i] == 'ham':
        if actual_labels [i] == predicted_labels [i]:
            tp += 1
        else:
            fp += 1
    else:
        if actual_labels [i] == predicted_labels [i]:
            tn += 1
        else:
            fn += 1

percision = tp / (tp + fp)
recall = tp / (tp + fn)
accuracy = (tp + fn) / (tp + tn + fp + fn)
f1_score = 2 * percision * recall / (percision + recall)

print ("percision = {}".format(percision))    
print ("recall = {}".format(recall))    
print ("accuracy = {}".format(accuracy))    
print ("f1_score = {}".format(f1_score))    
            


# Task 2  ----------------------------------------------------------------------

import io
feature_list = []
with io.open("sad.thorn", "r", encoding='utf-8') as source:
    labels = []
    for i,line in enumerate(source.readlines()):
        if i == 1000: break
        elif i == 0:
            # Read the header
            labels = line.split(u'þ')
        else:
            data = line.split(u'þ')
            feature_list.append({u'id': int(data[0]),\
                                    u'label': '+' if (data[1]==u'1') else '-' ,\
                                    u'text': data[2]})


# Get a list of all the words in the + tweets
pos_tweets = list(filter(lambda x: x['label'] == '+', feature_list))
# Get a list of all the words in the - tweets
neg_tweets = list(filter(lambda x: x['label'] == '-', feature_list))
import nltk
from nltk import word_tokenize

# Create a list of features for positive and negative tweets
import collections
import nltk.util
from nltk.util import ngrams

GRAM_SIZE = 3

pos_features = []
for item in pos_tweets:
    for words in ngrams(word_tokenize(item[u'text']), GRAM_SIZE):
        word = ' '.join(words)
        pos_features.append({'feature':word})

neg_features = []
for item in neg_tweets:
    for words in ngrams(word_tokenize(item[u'text']), GRAM_SIZE):
        word = ' '.join(words)
        neg_features.append({'feature':word})


from nltk.corpus import stopwords
stopwords = stopwords.words('english')
pos_features = list(filter(lambda x: x["feature"] not in stopwords, pos_features))
neg_features = list(filter(lambda x: x["feature"] not in stopwords, neg_features))

# Split the data to train and test
import random
from random import shuffle
SPLIT = 0.75

shuffle(pos_features)
shuffle(neg_features)

POS_TRAIN_SIZE = int(len(pos_features) * SPLIT)
NEG_TRAIN_SIZE = int(len(neg_features) * SPLIT)

train_set =  [(feat, '+') for feat in pos_features[:POS_TRAIN_SIZE]]
train_set += [(feat, '-') for feat in neg_features[:NEG_TRAIN_SIZE]]
test_set  = [ (feat, '+') for feat in pos_features[POS_TRAIN_SIZE:]]
test_set += [ (feat, '-') for feat in neg_features[NEG_TRAIN_SIZE:]]

shuffle(train_set)
shuffle(test_set)

from sklearn.feature_extraction.text import TfidfVectorizer

vectorizer = TfidfVectorizer (min_df=1)
X = vectorizer.fit_transform (train_set)
y = vectorizer.idf_

Z = vectorizer.fit_transform(test_set)


# Task 3  ----------------------------------------------------------------------

from sklearn.naive_bayes import MultinomialNB
clf = MultinomialNB()
clf.fit(X, y) # Add the appropriate test information
clf.predict(Z) # Try to predict new tweets
