# -*- coding: utf-8 -*-
"""
Created on Thu Mar  8 02:56:46 2018

@author: Saeed
this file is a single layer RNN for Car following, could be used for leading vehicle or all surrounding vehicles
"""
import tensorflow as tf
from tensorflow.contrib import rnn 
import numpy as np
import pandas as pd
import os
import matplotlib
import matplotlib.pyplot as plt
import random
#%matplotlib inline
import shutil
import tensorflow.contrib.learn as tflearn
import tensorflow.contrib.layers as tflayers
from tensorflow.contrib.learn.python.learn import learn_runner
import tensorflow.contrib.metrics as metrics
import tensorflow.contrib.rnn as rnn
import sklearn.metrics as sm
import csv

inputs = 32           #number of inputs 
num_hidden = 400    # number of cells in the hidden layer
outputs = 1            #number of outputs
num_epochs = 200    #number of training epochs
batch_size = 133    # data batch size
learning_rate = 0.004   #Optimizer's learning rate

# Training data
# reading training CSV file
input1 = []
output1 = []
with open('train_reconstracted_2k_All_133_batch_ver3.csv', 'r') as csv_f:
    data = csv.reader (csv_f) 
    for row in data:
        input1.append (row [0:inputs])
        output1.append (row [inputs])
csv_f.close()
# String to float
input11 = []
for i in range(0, len(input1)):   
    input11.append([])
    for j in range(0, inputs):
        input11[i].append(float(input1[i][j]))
output1 = [float(x) for x in output1]
input2 = np.array(input11)
output2 = np.array(output1)

# Create inputs and outputs' Batches
x_data = input2[:(len(input2)-(len(input2) % batch_size))]
x_batches = x_data.reshape(-1, batch_size, inputs)

y_data = output2[:(len(output2)-(len(output2) % batch_size))]
y_batches = y_data.reshape(-1, batch_size, outputs)


# Testing data
# reading testing CSV file
inputt = []
outputt = []
with open('valid_reconstracted_2k_All_133_batch_var3.csv', 'r') as csv_f:
    data = csv.reader (csv_f) 
    for row in data:
        inputt.append (row [0:inputs])
        outputt.append (row [inputs])
csv_f.close()
# String to float
inputtt = []
for i in range(0, len(inputt)):  
    inputtt.append([])
    for j in range(0, inputs):
        inputtt[i].append(float(inputt[i][j]))
outputt = [float(x) for x in outputt]
inputt1 = np.array(inputtt)
output1 = np.array(outputt)

# Create inputs and outputs' Batches
X_test = inputt1[:batch_size].reshape(-1, batch_size, inputs)
Y_test = output1[-(batch_size):].reshape(-1, batch_size, outputs)


# Configure RNN network
tf.reset_default_graph()   # Reset all previous graphs
#create variables' place holder
X = tf.placeholder(tf.float32, [None, batch_size, inputs])   
y = tf.placeholder(tf.float32, [None, batch_size, outputs])
keep_prob = tf.placeholder(tf.float32)

basic_cell = tf.contrib.rnn.BasicRNNCell(num_units=num_hidden, activation=tf.nn.softsign)   #create RNN cells with softsign activation function 
rnn_output, states = tf.nn.dynamic_rnn(basic_cell, X, dtype=tf.float32)      #Create the graph with RNN cells

stacked_rnn_output = tf.reshape(rnn_output, [-1, num_hidden])           #change shape of rnn_output
stacked_outputs = tf.layers.dense(stacked_rnn_output, outputs, use_bias=True)        #Create the graph with fully connected layer

outputRNN = tf.reshape(stacked_outputs, [-1, batch_size, outputs])          #change shape of stacked_outputs
 
loss = tf.losses.mean_squared_error(outputRNN, y)    #define the MSE as the cost function which evaluates the quality of the model
optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate)          #Gradient descent optimization by Adam optimizer
training_op = optimizer.minimize(loss)          #Minimize MSE by the optimization function                                 

# Runing the model in TensorFlow
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())   #initialize all the random variables
    # Training the model
    for ep in range(num_epochs):
        sess.run(training_op, feed_dict={X: x_batches, y: y_batches, keep_prob: .5})  # Run the model by feeding batchs and 0.5 Dropout rate
        mse = loss.eval(feed_dict={X: x_batches, y: y_batches})        #Extract MSE value  
        print(ep, "\tMSE:", mse)
    # Runing the test dataset
    y_pred = sess.run(outputRNN, feed_dict={X: X_test})

# Extract Test results from Tensorflow
r1 = np.ravel(Y_test)
r2 = np.ravel(y_pred)  
# Plot test results except first 3 rows of data
plt.title("Forecast vs Actual", fontsize=14)
plt.plot(pd.Series(r1[3:batch_size]), "b", markersize=10, label="Actual")
plt.plot(pd.Series(r2[3:batch_size]), "r", markersize=10, label="Forecast")
plt.legend(loc="upper left")
plt.xlabel("Time Periods")
plt.show()
# Calculate and print MSE for test data
tt = sm.mean_squared_error(r1[3:batch_size], r2[3:batch_size])
print ('MSE of Test data', tt)