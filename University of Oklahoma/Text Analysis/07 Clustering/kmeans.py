# -*- coding: utf-8 -*-


import glob
#glob.glob('*.txt')
files=glob.glob('samples/*.txt')
#print (files)

from nltk.corpus import stopwords
stop = list(stopwords.words('english'))

import nltk
#x=nltk.word_tokenize(i)

temp=[]
list_temp=[]
for i in files:
    #print(i)
    with open(i,'r', encoding='utf-8') as file:
        data=file.read()
        x=nltk.word_tokenize(data)
        temp=[i for i in x if i not in stop]
        temp_str =' '.join(temp)
        list_temp.append(temp_str)
        file.close()
        
        
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.metrics import adjusted_rand_score


from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer
from sklearn.decomposition import PCA
from sklearn.pipeline import Pipeline
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

pipeline = Pipeline([
    ('vect', CountVectorizer()),
    ('tfidf', TfidfTransformer()),
])
X = pipeline.fit_transform(list_temp).todense()


vc=TfidfVectorizer()    
vectors=vc.fit_transform(list_temp)
#import sys
arg=int(input("Enter the number of clusters : "))

if arg<=0:
    print("Enter correct values!!")
    exit
else:    
    reduced_data = PCA(n_components=2).fit_transform(vectors.toarray())
    kmeans = KMeans(init='k-means++', n_clusters=arg, n_init=10)
    kmeans.fit(reduced_data)
    
    # Step size of the mesh. Decrease to increase the quality of the VQ.
    h = .02     
    # point in the mesh [x_min, x_max]x[y_min, y_max].
    import numpy as np
    # Plot the decision boundary. For that, we will assign a color to each
    x_min, x_max = reduced_data[:, 0].min() - 1, reduced_data[:, 0].max() + 1
    y_min, y_max = reduced_data[:, 1].min() - 1, reduced_data[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    
    # Obtain labels for each point in mesh. Use last trained model.
    Z = kmeans.predict(np.c_[xx.ravel(), yy.ravel()])
    
    # Put the result into a color plot
    Z = Z.reshape(xx.shape)
    plt.figure(1)
    plt.clf()
    plt.imshow(Z, interpolation='nearest',
               extent=(xx.min(), xx.max(), yy.min(), yy.max()),
               cmap=plt.cm.Paired,
               aspect='auto', origin='lower')
    
    plt.plot(reduced_data[:, 0], reduced_data[:, 1], 'k.', markersize=2)
    # Plot the centroids as a white X
    centroids = kmeans.cluster_centers_
    plt.scatter(centroids[:, 0], centroids[:, 1],
                marker='x', s=169, linewidths=3,
                color='w', zorder=10)
    plt.title('K-means clustering on the digits dataset (PCA-reduced data)\n'
              'Centroids are marked with white cross')
    plt.xlim(x_min, x_max)
    plt.ylim(y_min, y_max)
    plt.xticks(())
    plt.yticks(())
    plt.show()