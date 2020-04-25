#!/usr/bin/python
# coding=utf-8
# ^^ because https://www.python.org/dev/peps/pep-0263/

from __future__ import division

import codecs
import csv
import json
import re
import nltk
import xmltodict

from nltk import sent_tokenize
from nltk import word_tokenize

# It is okay to include tokenization and symbols in the average word size count.
# Use the Thorn character (þ) to separate the fields
# Be sure to include coding=utf-8 to the first or second line

# All the output can be printed to the screen

# Note, when printing to a non-unicode terminal or using linux to write to a file
# http://stackoverflow.com/questions/4545661/unicodedecodeerror-when-redirecting-to-file

# You may need to download a corpus in nltk using the nltk.download() command.
# If you are having trouble completing feel free to post a message on the forum.

# Usage: PYTHONIOENCODING=UTF-8 python process-data.py > output.txt




## Question 1 ---------------------------------------------------------------------------
##---- Question 1a ----------------------------------------------------------------------
print ('\n\nAnswer to question 1a:\n')

with codecs.open("twitter.txt", encoding='utf-8') as f:
	for line in f:
		if "Twitter" in line:
			print (line)

input("Press Enter to continue...")

			
##---- Question 1b ----------------------------------------------------------------------
print ('\n\nAnswer to question 1b:\n')

with codecs.open("twitter.txt", encoding='utf-8') as f:
	for line in f:
		if "Twitter" in line:
			line_converted = line.replace("Twitter", "MyStartup")
			print (line_converted)

input("Press Enter to continue...")

		
##---- Question 1c ----------------------------------------------------------------------
print ('\n\nAnswer to question 1c:\n')

addFlag = False
with codecs.open("twitter.txt", encoding='utf-8') as f:
	for line in f:
		match = re.search(r'^\d+\s+\w+\s+\d{5}$', line)
		if match:
			print ('Address: ' + line)
			addFlag = True
		
if addFlag == False:
	print('No address was found!\n')

input("Press Enter to continue...")


##---- Question 1d ----------------------------------------------------------------------
print ('\n\nAnswer to question 1d:\n')

L4Flag = False
with codecs.open("twitter.txt", encoding='utf-8') as f:
	for line in f:
		if line.find('i.') != -1:
			L4Flag = True
			print (line)
		elif line.find('v.') != -1:
			L4Flag = True
			print (line)
			
if L4Flag == False:
	print('No address was found!\n')

input("Press Enter to continue...")


	
## Question 2 ---------------------------------------------------------------------------

print ('\n\nAnswer to question 2:\n')
words = ['Hanukkah', 'Chanukah', 'Hanukah', 'Hannukah', 'Chanuka', 'Chanukkah', 
'Hanuka', 'Channukah', 'Chanukka', 'Hanukka', 'Hannuka', 'Hannukkah', 
'Channuka', 'Xanuka', 'Hannukka', 'Channukkah', 'Channukka', 'Chanuqa']
allFlag = True;
for word in words:
	match = re.search(r'[XCH]h?ann?u[kq]k?ah?', word) 
	if not match:     
		print ('{} is not matched!'.format(word)) 
		allFlag = False

if allFlag == True:
	print ('All the words were matched!')
	


## Question 3 ---------------------------------------------------------------------------


csvFile = open('HW 1.csv', 'w', newline='', encoding='utf-8')

with codecs.open("twitter.txt", encoding='utf-8') as f:
	number = 0
	fr = f.read()
	fr = fr.replace('\n', '')
	fr = fr.replace('\r', '')	
	sents = sent_tokenize(fr)
	#sents = sents.decode("utf-8")
	for sent in sents:
		words = word_tokenize(sent)
		#print(words)
		average = sum(len(word) for word in words)/len(words)
		number += 1		
		a = csv.writer(csvFile, delimiter='þ')
		a.writerow([number, sent, average])
    # Your code here
    #pass
	
print ('\nAnswer for question 3 sent to file HW "1.csv".\n')


## Question 4 ---------------------------------------------------------------------------	
# adapted from: http://code.activestate.com/recipes/577423-convert-csv-to-xml/
	
xmlFile = 'HW 1.xml'
csvData = csv.reader(open('HW 1.csv', 'r', encoding='utf-8'), delimiter='þ')
xmlData = open(xmlFile, 'w', encoding='utf-8')
#xmlData.write('<?xml version="1.0"?>\n')
xmlData.write(' <document>\n')
xmlData.write('  <sentences>\n')

rowNum = 0

for row in csvData:
	if rowNum != 0:
		xmlData.write('   <sentence id="{}">\n'.format(row[0]))
		xmlData.write('    <text>{}</text>\n'.format(row[1]))
		xmlData.write('    <avg>{0:.2f}</avg>\n'.format(float(row[2])))
		xmlData.write('   </sentence>\n')
	rowNum +=1

xmlData.write('  </sentences>\n')
xmlData.write(' </document>\n')
xmlData.close()

print ('\nAnswer for question 4 sent to file HW "1.xml".\n')


## Question 5 ---------------------------------------------------------------------------

# Source: https://pythonadventures.wordpress.com/2014/12/29/xml-to-dict-xml-to-json/
# Source: http://stackoverflow.com/questions/191536/converting-xml-to-json-using-python

xml_file = open('HW 1.xml','r', encoding='utf-8').read()
xml_file = xml_file.replace('&', 'and')
o = xmltodict.parse(xml_file.encode('utf-8'))
json_data = json.dumps(o, indent=4)
json_file = open('HW 1.json', 'w', encoding='utf-8')
json_file.write(json_data)
json_file.close()

print ('\n\nAnswer for question 5 sent to file HW "1.json".\n')

