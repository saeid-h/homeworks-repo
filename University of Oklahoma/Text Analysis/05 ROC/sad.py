
import logging
from imp import reload
reload(logging) # To stop repeated outputs in iPython
import sys

log = logging.getLogger("P/R/ROC")
log.setLevel(logging.INFO)

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

formatter = logging.Formatter("%(asctime)s %(levelname)s:%(name)s %(message)s")
ch.setFormatter(formatter)

log.addHandler(ch)

log.info("Now logging")

# Read the sentiment analysis data set
MAX_TWEETS = 1000

import io
feature_list = []
with io.open("sad.thorn", "r", encoding='utf-8') as source:
    labels = []
    for i,line in enumerate(source.readlines()):
        if i == MAX_TWEETS: break
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
log.info("pos_tweets: {}".format(len(pos_tweets))) 
# Get a list of all the words in the - tweets
neg_tweets = list(filter(lambda x: x['label'] == '-', feature_list))
log.info("neg_tweets: {}".format(len(neg_tweets))) 

# Create a big [({feature}, label)] list
import nltk
from nltk import word_tokenize

# Create a list of features for positive and negative tweets
import collections
import nltk.util
from nltk.util import ngrams

GRAM_SIZE = 4

log.info("Creating positive feature list.")
pos_features = []
for item in pos_tweets:
    for words in ngrams(word_tokenize(item[u'text']), GRAM_SIZE):
        word = ' '.join(words)
        pos_features.append({'feature':word})

log.info("Creating negative feature list.")
neg_features = []
for item in neg_tweets:
    for words in ngrams(word_tokenize(item[u'text']), GRAM_SIZE):
        word = ' '.join(words)
        neg_features.append({'feature':word})


from nltk.corpus import stopwords
log.info("Filtering stopwords")
stopwords = stopwords.words('english')
pos_features = list(filter(lambda x: x["feature"] not in stopwords, pos_features))
neg_features = list(filter(lambda x: x["feature"] not in stopwords, neg_features))

# Split the data to train and test
import random
from random import shuffle
SPLIT = 0.75

log.info("Shuffling pos_features")
shuffle(pos_features)
log.info("Shuffling neg_features")
shuffle(neg_features)

POS_TRAIN_SIZE = int(len(pos_features) * SPLIT)
NEG_TRAIN_SIZE = int(len(neg_features) * SPLIT)
log.info("POS_TRAIN_SIZE {}".format(POS_TRAIN_SIZE))
log.info("NEG_TRAIN_SIZE {}".format(NEG_TRAIN_SIZE))

train_set =  [(feat, '+') for feat in pos_features[:POS_TRAIN_SIZE]]
train_set += [(feat, '-') for feat in neg_features[:NEG_TRAIN_SIZE]]
test_set  = [ (feat, '+') for feat in pos_features[POS_TRAIN_SIZE:]]
test_set += [ (feat, '-') for feat in neg_features[NEG_TRAIN_SIZE:]]

log.info("Shuffling the train set")
shuffle(train_set)
log.info("Shuffling the test set")
shuffle(test_set)

from nltk.classify import NaiveBayesClassifier

log.info("Training NaiveBayesClassifier")
nb_classifier = NaiveBayesClassifier.train(train_set)
log.info("NaiveBayesClassifier classes: {}".format(nb_classifier.labels()))

from nltk.classify import DecisionTreeClassifier

log.info("Training DecisionTreeClassifier")
d_classifier = DecisionTreeClassifier.train(train_set)
log.info("DecisionTreeClassifier classes: {}".format(d_classifier.labels()))

from nltk.classify import MaxentClassifier

log.info("Training MaxentClassifier")
m_classifier = MaxentClassifier.train(train_set)
log.info("MaxentClassifier classes: {}".format(m_classifier.labels()), )

# Get precision recall f1 measure of each 
import sklearn
import sklearn.metrics
from sklearn.metrics import precision_recall_fscore_support

import operator
from operator import itemgetter

def prfs(classify, test_set):
    return precision_recall_fscore_support(list(map(itemgetter(1), test_set)),\
                                            list(map(lambda x: classify(x[0]), test_set)),\
                                            pos_label='+')


# plotting the ROC curve http://blog.yhat.com/posts/roc-curves.html
log.info("plotting the curve...")
from sklearn.metrics import roc_curve
from sklearn.metrics import auc
import pandas as pd
import ggplot
from ggplot import aes
from ggplot import geom_abline
from ggplot import geom_line
from ggplot import ggplot
from ggplot import ggtitle

def plus2one(x): return 1 if x == '+' else 0

# matplotlib inline
import matplotlib.pyplot as plt

def plot(classify, test_set):
    truth = list(map(plus2one, map(itemgetter(1), test_set)))
    data = list(map(plus2one, map(lambda x: classify(x[0]), test_set)))
    fpr, tpr, thresholds = roc_curve(truth, data, drop_intermediate=False)
    roc_auc = auc(fpr, tpr)
    
    df = pd.DataFrame(dict(fpr=fpr, tpr=tpr))
    g = ggplot(df, aes(x='fpr', y='tpr' )) + geom_line() + geom_abline(linetype='dashed')
    g += ggtitle("ROC Curve: AUC({})".format(roc_auc))
    return g

def matplot(classify, test_set):
    truth = list(map(plus2one, map(itemgetter(1), test_set)))
    data = list(map(plus2one, map(lambda x: classify(x[0]), test_set)))
    fpr, tpr, thresholds = roc_curve(truth, data, drop_intermediate=False)
    
    roc_auc = auc(fpr, tpr)
    plt.plot(fpr, tpr, label='ROC curve (area = %0.2f)' % roc_auc)
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.legend(loc="lower right")
    return plt

p,r,f1,_ = prfs(nb_classifier.classify, test_set)
log.info("nb precision: {}".format(p))
log.info("nb recall: {}".format(r))
log.info("nb f1: {}".format(f1))
plot(nb_classifier.classify, test_set)

p,r,f1,_ = prfs(d_classifier.classify, test_set)
log.info("d precision: {}".format(p))
log.info("d recall: {}".format(r))
log.info("d f1: {}".format(f1))
plot(d_classifier.classify, test_set)

p,r,f1,_ = prfs(m_classifier.classify, test_set)
log.info("m precision: {}".format(p))
log.info("m recall: {}".format(r))
log.info("m f1: {}".format(f1))
#matplot(m_classifier.classify, test_set).show()
plot(m_classifier.classify, test_set)

